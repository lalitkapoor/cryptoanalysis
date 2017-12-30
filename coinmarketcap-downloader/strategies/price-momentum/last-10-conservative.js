import config from '@/config'
import db from '@/lib/db'

export default class Strategy {
  get name() { return 'price-momentum/last-10-conservative' }
  async run() {
    const results = await db.run('last-10-conservative')
    console.log(results)
    if (!results.length) return
    // save to orders
    const insertSQLs = results.map(recommendation => {
      return db.SQL`INSERT INTO orders(
        strategy,
        ticker,
        symbol,
        price_usd,
        shares
      ) SELECT
        'price-momentum/last-10-conservative',
        ${recommendation.ticker},
        ${recommendation.symbol},
        ${recommendation.price_usd},
        ${100/recommendation.price_usd}
      WHERE NOT EXISTS (
        SELECT *
        FROM orders
        WHERE
          strategy = 'price-momentum/last-10-conservative' AND
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
