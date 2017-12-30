import cron from 'cron'
import uuid from 'uuid'
import db from '@/lib/db'
import Worker from './worker'
import PriceMomentumLast10ConservativeStrategy from '@/strategies/price-momentum/last-10-conservative'

new cron.CronJob('0 */1 * * * *', async () => {
  const id = uuid.v4()

  //import data
  const worker = new Worker()
  console.log(new Date(), id, 'importing started')
  await worker.run()
  console.log(new Date(), id, 'importing complete')

  // run strategies
  const strategy = new PriceMomentumLast10ConservativeStrategy()
  console.log(new Date(), id, 'running strategy:', strategy.name)
  await strategy.run()
  console.log(new Date(), id, 'done running strategy:', strategy.name)
  console.log('\n\n')
}, null, true, 'America/New_York')
