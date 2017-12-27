import worker from './worker'

process.on('uncaughtException', function (error) {
  console.log('uncaughtException')
  console.log(error)
})

process.on('unhandledRejection', function (reason, p) {
  console.log('unhandledRejection')
  console.log(reason)
})

worker.run()
