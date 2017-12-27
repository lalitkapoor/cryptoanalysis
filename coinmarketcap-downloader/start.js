import db from '@/lib/db'
import Worker from './worker'

process.on('uncaughtException', function (error) {
  console.log('uncaughtException')
  console.log(error)
})

process.on('unhandledRejection', function (reason, p) {
  console.log('unhandledRejection')
  console.log(reason)
})

const worker = new Worker()
worker.run()
.then(() => db.pg.end())
