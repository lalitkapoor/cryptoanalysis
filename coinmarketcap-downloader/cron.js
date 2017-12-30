import cron from 'cron'
import uuid from 'uuid'
import db from '@/lib/db'
import Worker from './worker'
import PriceMomentumLast10ConservativeStrategy from '@/strategies/price-momentum/last-10-conservative'
import PriceMomentumLast10ModerateStrategy from '@/strategies/price-momentum/last-10-moderate'

new cron.CronJob('0 */1 * * * *', async () => {
  const id = uuid.v4()

  //import data
  const worker = new Worker()
  console.log(new Date(), id, 'importing started')
  await worker.run()
  console.log(new Date(), id, 'importing complete')

  // run strategies
  const strategies = [
    new PriceMomentumLast10ConservativeStrategy(),
    new PriceMomentumLast10ModerateStrategy()
  ]

  strategies.forEach((strategy) => {
    console.log(new Date(), id, 'running strategy:', strategy.name)
    strategy.run().catch(console.log)
    console.log(new Date(), id, 'done running strategy:', strategy.name)
    console.log('\n\n')
  })

}, null, true, 'America/New_York')
