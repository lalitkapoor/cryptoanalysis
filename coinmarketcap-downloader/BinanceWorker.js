import WebSocket from 'ws'
import _ from 'lodash'
import pad from 'pad'
import moment from 'moment'

export default class Worker {
  constructor () {
    this.stats = {}
    this.watch = {}
    this.buys = {}
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
    // console.log(msg)
    // return
    const data = JSON.parse(msg)
    const filtered = data.filter((ticker) => {
      return ['BTC'].includes(ticker.s.substr(-3))
    })

    // add stat for missing data to filtered (use the average for volume, last price for price)
    // const missing = _.difference(Object.keys(this.stats), filtered.map(ticker => ticker.s))
    // const fillerForMissingData = missing.map(ticker => ({
    //   s: ticker,
    //   v: this.stats[ticker].average,
    //   c: this.stats[ticker].price
    // }))
    // Array.prototype.push.apply(filtered, fillerForMissingData)

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

    // console.log(this.stats)

    Object.keys(this.stats).forEach((ticker) => {
      const stat = this.stats[ticker]
      if(stat.measures.length < 60) return // skip if we havent collected at least 60 measures of data

      const lastMeasure = stat.measures[stat.measures.length - 1]
      const percentChange = (stat.measures[stat.measures.length - 1]/stat.average - 1) * 100
      if (percentChange >= 2) {
        const watch = this.watch[ticker] = this.watch[ticker] || {
          lastMeasure: lastMeasure,
          timeout: setTimeout(() => delete this.watch[ticker], 1000 * 60 * 5)
        }

        // console.log('watching', ticker, 'for 60 seconds for increases')

        if (lastMeasure/watch.lastMeasure > 1.02) {
          this.buys =
          watch.lastMeasure = lastMeasure
          clearTimeout(this.watch[ticker].timeout)
          setTimeout(() => delete this.watch[ticker], 1000 * 60 * 5)
          this.printRow(
            moment().format(),
            ticker,
            Math.round(percentChange * 100000000) / 100000000,
            Math.round(lastMeasure * 100000000) / 100000000,
            Math.round(stat.average * 100000000) / 100000000
          )
        }
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
