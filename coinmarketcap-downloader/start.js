import db from '@/lib/db'
import Worker from './worker'

const worker = new Worker()
worker.run()
.then(() => db.pg.end())
