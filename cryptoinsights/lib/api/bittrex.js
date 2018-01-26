'use strict';

Object.defineProperty(exports, "__esModule", {
  value: true
});

var _http = require('./http');

var _http2 = _interopRequireDefault(_http);

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { default: obj }; }

class Bittrex extends _http2.default {
  constructor() {
    super(host);
    this.version = 'v1.1';
    const host = `https://bittrex.com/api/${this.version}`;
  }
}

exports.default = Bittrex;
const apiPaths = {
  getMarkets: 'public/getmarkets',
  getCurrencies: 'public/getcurrencies',
  getTicker: 'public/getticker', // market
  getSummaries: 'public/getmarketsummaries',
  getSummary: 'public/getmarketsummary', // market
  getMarketHistory: 'public/getmarkethistory' // market
};