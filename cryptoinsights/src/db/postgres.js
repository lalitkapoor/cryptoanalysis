// @flow
import Pg from 'pg'
import PgError from 'pg-error'
import { Client, Pool } from 'pg'

Pg.Connection.prototype.parseE = PgError.parse
Pg.Connection.prototype.parseN = PgError.parse

const Error = global.Error || window.Error

type PgErrorType = {
  message: ?string,
  severity: ?string,
  code: ?string,
  condition: ?string,
  detail: ?string,
  hint: ?string,
  position: ?string,
  internalPosition: ?string,
  internalQuery: ?string,
  where: ?string,
  schema: ?string,
  table: ?string,
  column: ?string,
  dataType: ?string,
  constraint: ?string,
  file: ?string,
  line: ?string,
  routine: ?string,
}

export class PostgresError extends Error {
  constructor(pgerr: PgErrorType) {
    super(pgerr.message)
    const keys = [
      'message',
      'severity',
      'code',
      'condition',
      'detail',
      'hint',
      'position',
      'internalPosition',
      'internalQuery',
      'where',
      'schema',
      'table',
      'column',
      'dataType',
      'constraint',
      'file',
      'line',
      'routine',
    ]
    keys.forEach(key => {
      let val
      if (key in pgerr) {
        this[key] = pgerr[key]
      }
    })
  }
  message: ?string
  severity: ?string
  code: ?string
  condition: ?string
  detail: ?string
  hint: ?string
  position: ?string
  internalPosition: ?string
  internalQuery: ?string
  where: ?string
  schema: ?string
  table: ?string
  column: ?string
  dataType: ?string
  constraint: ?string
  file: ?string
  line: ?string
  routine: ?string
}

export class PostgresClient {
  pool: Pool
  async connect(): Promise<Client> {
    if (!this.pool) {
      this.pool = new Pool({
        database: process.env.PGDATABASE,
        host: process.env.PGHOST,
        port: process.env.PGPORT,
        user: process.env.PGUSER,
        password: process.env.PGPASSWORD,
      })
    }
    const client = await this.pool.connect()
    client.release()
    return this.pool
  }
  async disconnect(): Promise<void> {
    if (!this.pool) return
    const pool = this.pool
    delete this.pool
    await pool.end()
  }
  async query(query: string): Promise<any> {
    query = trim(query)
    let result
    try {
      const pool = await this.connect()
      result = await pool.query(query)
    } catch (err) {
      console.log(err)
      console.log(err)
      console.log(err)
      console.log(err)
      throw new PostgresError(err)
    }
    console.log('POSTGRES QUERY:\n%s', query)
    console.log('POSTGRES RESUL:\n%o', result)
    return result
  }
}

export default new PostgresClient()

function trim(str: string): string {
  const match = /\n([ ]*)/.exec(str)
  const pad = match && match[1]
  str = str.trim()
  if (pad) {
    str = str.replace(new RegExp(`(\n)${pad}`, 'g'), '$1')
  }
  return str
}
