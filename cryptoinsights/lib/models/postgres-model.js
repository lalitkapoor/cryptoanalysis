'use strict';

Object.defineProperty(exports, "__esModule", {
  value: true
});

var _reduce = require('object-loops/reduce');

var _reduce2 = _interopRequireDefault(_reduce);

var _postgres = require('../db/postgres');

var _postgres2 = _interopRequireDefault(_postgres);

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { default: obj }; }

class PostgresModel {
  constructor(table) {
    this.table = table;
  }

  static valToString(val) {
    return JSON.stringify(val).replace(/^"/, '\'').replace(/"$/, '\'');
  }
  static objToString(obj, delimeter) {
    return (0, _reduce2.default)(obj, (str, val, key) => {
      return str ? `${key} = ${this.valToString(val)}` : `${str}${delimeter}${key} = ${this.valToString(val)}`;
    }, '');
  }
  static conditionsToString(conditions) {
    return this.objToString(conditions, '\n  AND ');
  }
  static updateToString(update) {
    return this.objToString(update, '\n,  ');
  }
  async create(data) {
    const keys = Object.keys(data);
    const keysStr = keys.toString();
    const valsStr = keys.map(key => JSON.stringify(data[key])).toString();
    const query = `
      INSERT INTO ${this.table}(${keysStr})
      VALUES (${valsStr})
      RETURNING *
    `;
    return await _postgres2.default.query(query);
  }
  async where(conditions) {
    const query = `
      SELECT *
      FROM ${this.table}
      WHERE
        ${PostgresModel.conditionsToString(conditions)}
    `;
    return await _postgres2.default.query(query);
  }
  async update(conditions, update) {
    const query = `
      UPDATE ${this.table}
      SET
        ${PostgresModel.updateToString(update)}
      WHERE
        ${PostgresModel.conditionsToString(conditions)}
      RETURNING *
    `;
    return await _postgres2.default.query(query);
  }
  async remove() {}
}
exports.default = PostgresModel;