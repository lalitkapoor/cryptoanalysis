'use strict';

Object.defineProperty(exports, "__esModule", {
  value: true
});
exports.PostgresClient = exports.PostgresError = undefined;

var _pg = require('pg');

var _pg2 = _interopRequireDefault(_pg);

var _pgError = require('pg-error');

var _pgError2 = _interopRequireDefault(_pgError);

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { default: obj }; }

_pg2.default.Connection.prototype.parseE = _pgError2.default.parse;

_pg2.default.Connection.prototype.parseN = _pgError2.default.parse;

const Error = global.Error || window.Error;

class PostgresError extends Error {
  constructor(pgerr) {
    super(pgerr.message);
    const keys = ['message', 'severity', 'code', 'condition', 'detail', 'hint', 'position', 'internalPosition', 'internalQuery', 'where', 'schema', 'table', 'column', 'dataType', 'constraint', 'file', 'line', 'routine'];
    keys.forEach(key => {
      let val;
      if (key in pgerr) {
        this[key] = pgerr[key];
      }
    });
  }
}

exports.PostgresError = PostgresError;
class PostgresClient {
  async connect() {
    if (!this.pool) {
      this.pool = new _pg.Pool({
        database: process.env.PGDATABASE,
        host: process.env.PGHOST,
        port: process.env.PGPORT,
        user: process.env.PGUSER,
        password: process.env.PGPASSWORD
      });
    }
    const client = await this.pool.connect();
    client.release();
    return this.pool;
  }
  async disconnect() {
    if (!this.pool) return;
    const pool = this.pool;
    delete this.pool;
    await pool.end();
  }
  async query(query) {
    query = trim(query);
    let result;
    try {
      const pool = await this.connect();
      result = await pool.query(query);
    } catch (err) {
      console.log(err);
      console.log(err);
      console.log(err);
      console.log(err);
      throw new PostgresError(err);
    }
    console.log('POSTGRES QUERY:\n%s', query);
    console.log('POSTGRES RESUL:\n%o', result);
    return result;
  }
}

exports.PostgresClient = PostgresClient;
exports.default = new PostgresClient();


function trim(str) {
  const match = /\n([ ]*)/.exec(str);
  const pad = match && match[1];
  str = str.trim();
  if (pad) {
    str = str.replace(new RegExp(`(\n)${pad}`, 'g'), '$1');
  }
  return str;
}