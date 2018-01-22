import db from '@/lib/db'
import CoinMarketCapWorker from './CoinMarketCapWorker'
import BinanceWorker from './BinanceWorker'

// const cmcWorker = new CoinMarketCapWorker()
// cmcWorker.run().then(() => db.pg.end())

const binanceWorker = new BinanceWorker()
binanceWorker.run()
