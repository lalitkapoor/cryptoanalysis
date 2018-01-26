// @flow
import reduce from 'object-loops/reduce'

import pg from 'db/postgres'

export default class PostgresModel {
  constructor(table: string) {
    this.table = table
  }
  table: string
  static valToString(val: any) {
    return JSON.stringify(val).replace(/^"/, '\'').replace(/"$/, '\'')
  }
  static objToString(obj: {}, delimeter: string) {
    return reduce(
      obj,
      (str, val, key) => {
        return str
          ? `${key} = ${this.valToString(val)}`
          : `${str}${delimeter}${key} = ${this.valToString(val)}`
      },
      '',
    )
  }
  static conditionsToString(conditions: {}) {
    return this.objToString(conditions, '\n  AND ')
  }
  static updateToString(update: {}) {
    return this.objToString(update, '\n,  ')
  }
  async create(data: {}) {
    const keys = Object.keys(data)
    const keysStr = keys.toString()
    const valsStr = keys.map(key => JSON.stringify(data[key])).toString()
    const query = `
      INSERT INTO ${this.table}(${keysStr})
      VALUES (${valsStr})
      RETURNING *
    `
    return await pg.query(query)
  }
  async where(conditions: {}) {
    const query = `
      SELECT *
      FROM ${this.table}
      WHERE
        ${PostgresModel.conditionsToString(conditions)}
    `
    return await pg.query(query)
  }
  async update(conditions: {}, update: {}) {
    const query = `
      UPDATE ${this.table}
      SET
        ${PostgresModel.updateToString(update)}
      WHERE
        ${PostgresModel.conditionsToString(conditions)}
      RETURNING *
    `
    return await pg.query(query)
  }
  async remove() {}
}
