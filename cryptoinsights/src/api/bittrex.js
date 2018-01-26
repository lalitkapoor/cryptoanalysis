import HttpClient from './http'

export default class Bittrex extends HttpClient {
  constructor() {
    super(host)
    this.version = 'v1.1'
    const host = `https://bittrex.com/api/${this.version}`
  }
}

const apiPaths = {
  getMarkets: 'public/getmarkets',
  getCurrencies: 'public/getcurrencies',
  getTicker: 'public/getticker', // market
  getSummaries: 'public/getmarketsummaries',
  getSummary: 'public/getmarketsummary', // market
  getMarketHistory: 'public/getmarkethistory', // market
}
