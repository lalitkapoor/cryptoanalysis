import db from '@/lib/db'
import axios from 'axios'

const BASE_URL = 'https://api.coinmarketcap.com/v1'

export default class Worker {
  async run() {
    const data = await getCurrentMarketData()
    const result = await saveDataToDB(data)
  }
}

const getCurrentMarketData = async () => {
  const response = await axios.get(`${BASE_URL}/ticker`, {
    params: {
      limit: 100000
    }
  })

  return response.data
}

const saveDataToDB = async (data) => {
  const query = db.SQL`INSERT INTO cmc_market_data (ticker,
    name,
    symbol,
    rank,
    price_usd,
    price_btc,
    volume_24h_usd,
    market_cap_usd,
    available_supply,
    total_supply,
    max_supply,
    percent_change_1h,
    percent_change_24h,
    percent_change_7d,
    last_updated) VALUES `

  const values = data.map(ticker => db.SQL`(${ticker.id},
    ${ticker.name},
    ${ticker.symbol},
    ${ticker.rank},
    ${ticker.price_usd},
    ${ticker.price_btc},
    ${ticker['24h_volume_usd']},
    ${ticker.market_cap_usd},
    ${ticker.available_supply},
    ${ticker.total_supply},
    ${ticker.max_supply},
    ${ticker.percent_change_1h},
    ${ticker.percent_change_24h},
    ${ticker.percent_change_7d},
    to_timestamp(${ticker.last_updated}))`
  ).reduce((prev, curr) => prev.append(', ').append(curr))

  query.append(values)
  query.append(' ON CONFLICT DO NOTHING')

  return await db.one(query)
}
