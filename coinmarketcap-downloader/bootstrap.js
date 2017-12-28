require('babel-register')
require('babel-polyfill')
var Promise = require('babel-runtime/core-js/promise').default = require('bluebird')

Promise.config({
  // Enable warnings
  warnings: true,
  // Enable long stack traces
  longStackTraces: true,
  // Enable cancellation
  cancellation: true,
  // Enable monitoring
  monitoring: true
})

require('app-module-path').addPath(__dirname + '/.require-hack')

process.on('uncaughtException', function (error) {
  console.log('uncaughtException')
  console.log(error)
})

process.on('unhandledRejection', function (reason, p) {
  console.log('unhandledRejection')
  console.log(reason)
})
