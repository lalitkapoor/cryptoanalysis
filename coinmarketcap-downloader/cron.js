import cron from 'cron'
import uuid from 'uuid'
import db from '@/lib/db'
import Worker from './worker'

const worker = new Worker()

new cron.CronJob('0 */1 * * * *', () => {
  const id = uuid.v4()
  console.log(id, 'importing started: ', new Date())
  worker.run().then(() => console.log(id, 'importing complete:', new Date()))
}, null, true, 'America/New_York')
