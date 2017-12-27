import config from '@/config'
import path from 'path'
import pgUtil from 'pg-util'
import SQL from 'sql-template-strings'
import sql from 'sql'
import DatabaseCleaner from 'database-cleaner'

sql.setDialect('postgres')

let db = pgUtil(config.PG_CONN_STR, path.join(config.APP_ROOT, 'db/sql'))
const databaseCleaner = new DatabaseCleaner('postgresql', {
  postgresql: {
    strategy: 'truncation',
    skipTables: ['migrations']
  }
})

db.SQL = SQL
db.sql = sql

db.clean = async () => {
  const client = await db.getClient()
  return new Promise(function (resolve, reject) {
    databaseCleaner.clean(
      client,
      function (error) {
        client.done()
        if (error) return reject(error)
        return resolve()
      }
    )
  })
}

export default db
