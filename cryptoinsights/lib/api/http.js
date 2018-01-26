'use strict';

Object.defineProperty(exports, "__esModule", {
  value: true
});

var _path = require('path');

var _path2 = _interopRequireDefault(_path);

var _r = require('r2');

var _r2 = _interopRequireDefault(_r);

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { default: obj }; }

class BaseClient {
  constructor(host) {
    this.host = host;
  }
}

exports.default = BaseClient;
const methods = ['get', 'post', 'put', 'head', 'patch', 'delete'];
Object.assign(BaseClient.prototype, methods.reduce(method => {
  return async (...args) => {
    const [urlpath, ...rest] = args;
    const url = `${host}${_path2.default.join('/', urlpath)}`;
    return _r2.default[method](url, ...rest);
  };
}));