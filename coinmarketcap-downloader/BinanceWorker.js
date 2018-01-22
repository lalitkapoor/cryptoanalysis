import WebSocket from 'ws'
import _ from 'lodash'
import pad from 'pad'
import moment from 'moment'

export default class Worker {
  constructor () {
    this.stats = {}
    this.watch = {}
    this.buys = {}
    this.sold = []
    this.availableMoney = 1000
    this.investPerTrade = 250
    this._rowsPrinted = 0
  }
  async run() {
    const ws = new WebSocket('wss://stream.binance.com:9443/ws/!ticker@arr');

    ws.on('open', ::this.handleOpen);
    ws.on('message', ::this.handleMessage);
  }

  handleOpen() {
    console.log('connected to binance')
  }

  handleMessage(msg) {
    const data = JSON.parse(msg)
    const filtered = data.filter((ticker) => {
      return ['BTC'].includes(ticker.s.substr(-3))
    })

    // calculate moving average in a window
    filtered.map((ticker) => {
      const WINDOW_SIZE = 60 * 60 * 3 // 3 hours worth of measures
      const symbol = ticker.s
      const measure = parseFloat(ticker.c)
      const stat = this.stats[symbol] = this.stats[symbol] || {average: 0, measures: []}

      if (stat.measures.length === WINDOW_SIZE) {
        const firstMeasure = stat.measures.shift()
        stat.average = ((stat.average * WINDOW_SIZE) - firstMeasure + measure) / (WINDOW_SIZE)
      } else {
        stat.average = ((stat.average * stat.measures.length) + measure) / (stat.measures.length + 1)
      }

      stat.measures.push(measure)
    })


    let report = false
    // sell things and report on it
    Object.keys(this.buys).forEach((ticker) => {
      const buy = this.buys[ticker]
      const stat = this.stats[ticker]
      const lastMeasure = stat.measures[stat.measures.length - 1]
      if (lastMeasure >= buy.profitAt) {
        this.sold.push({ticker: ticker, buyAt: buy.price, soldAt: buy.profitAt, profit: (buy.profitAt/buy.price - 1) * 100})
        this.availableMoney += this.investPerTrade * (buy.profitAt/buy.price)
        console.log(ticker, 'met', buy.price, buy.profitAt, (buy.profitAt/buy.price - 1) * 100, this.availableMoney)
        delete this.buys[ticker]
        report = true
      } else if (lastMeasure <= buy.lossAt) {
        this.sold.push({ticker: ticker, buyAt: buy.price, soldAt: buy.lossAt, profit: (buy.lossAt/buy.price - 1) * 100})
        this.availableMoney += this.investPerTrade * (buy.lossAt/buy.price)
        console.log(ticker, 'loss', buy.price, buy.profitAt, (buy.profitAt/buy.price - 1) * 100, this.availableMoney)
        delete this.buys[ticker]
        report = true
      } else if (moment() > buy.expiration) {
        this.sold.push({ticker: ticker, buyAt: buy.price, soldAt: lastMeasure, profit: (lastMeasure/buy.price - 1) * 100})
        this.availableMoney += this.investPerTrade * (lastMeasure/buy.price)
        console.log(ticker, 'expired', buy.price, lastMeasure, (lastMeasure/buy.price - 1) * 100, this.availableMoney)
        delete this.buys[ticker]
        report = true
      }
    })

    if (report === true) console.log('total profit:', this.sold.reduce((sum, item) => {return sum + item.profit}, 0)/this.sold.length)


    Object.keys(this.stats).forEach((ticker) => {
      const stat = this.stats[ticker]
      if(stat.measures.length < 60) return // skip if we havent collected at least 60 measures of data

      const lastMeasure = stat.measures[stat.measures.length - 1]
      const percentChange = (stat.measures[stat.measures.length - 1]/stat.average - 1) * 100
      let watch = this.watch[ticker]
      let bought = this.buys[ticker]

      if (percentChange >= 2 && percentChange <= 10) {
        watch = this.watch[ticker] = this.watch[ticker] || {
          lastMeasure: lastMeasure,
          timeout: setTimeout(() => delete this.watch[ticker], 1000 * 60 * 5)
        }
      }

      if (watch && !bought && lastMeasure/watch.lastMeasure > 1.02 && lastMeasure/watch.lastMeasure < 1.08 && this.availableMoney > 100) {
        watch.lastMeasure = lastMeasure
        clearTimeout(this.watch[ticker].timeout)
        delete this.watch[ticker]
        this.availableMoney -= this.investPerTrade
        this.buys[ticker] = {price: lastMeasure, timestamp: moment(), expiration: moment().add(30, 'm'), profitAt: lastMeasure * 1.10, lossAt: lastMeasure * 0.90}
        this.printRow(
          moment().format(),
          ticker,
          Math.round(percentChange * 100000000) / 100000000,
          Math.round(lastMeasure * 100000000) / 100000000,
          Math.round(stat.average * 100000000) / 100000000
        )
      }
    })
  }

  printHeaders() {
    console.log(
      pad("timestamp", 30),
      pad("ticker", 10),
      pad("percent change", 20),
      pad("latest price", 20),
      pad("average price", 20)
    )
  }

  printRow(timestamp, ticker, percentChange, lastMeasure, average) {
    if (this._rowsPrinted % 10 === 0) this.printHeaders()
    console.log(
      pad(""+timestamp, 30),
      pad(""+ticker, 10),
      pad(""+percentChange, 20),
      pad(""+lastMeasure, 20),
      pad(""+average, 20)
    )

    this._rowsPrinted++
  }
}
