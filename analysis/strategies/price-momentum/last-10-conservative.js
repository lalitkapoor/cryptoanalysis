import config from '@/config'
import db from '@/lib/db'

export default class Strategy {
  get name() { return 'price-momentum/last-10-conservative' }

  async run() {
    const results = await db.run('strategies/price-momentum/last-10-conservative')
    if (!results.length) return
    // save to orders
    const insertSQLs = results.map(recommendation => {
      console.log('name', this.name)
      return db.SQL`INSERT INTO orders(
        strategy,
        ticker,
        symbol,
        price_usd,
        shares
      ) SELECT
        ${this.name},
        ${recommendation.ticker},
        ${recommendation.symbol},
        ${recommendation.price_usd},
        ${100/recommendation.price_usd}
      WHERE NOT EXISTS (
        SELECT *
        FROM orders
        WHERE
          strategy = ${this.name} AND
          ticker = ${recommendation.ticker} AND
          symbol = ${recommendation.symbol} AND
          sell_at IS NULL
      )`
    })

    return await Promise.map(insertSQLs, (sql) => {
      return db.one(sql)
    })
  }
}
