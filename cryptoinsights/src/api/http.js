import path from 'path'

import r2 from 'r2'

export default class BaseClient {
  constructor(host) {
    this.host = host
  }
}

const methods = ['get', 'post', 'put', 'head', 'patch', 'delete']
Object.assign(
  BaseClient.prototype,
  methods.reduce(method => {
    return async (...args) => {
      const [urlpath, ...rest] = args
      const url = `${host}${path.join('/', urlpath)}`
      return r2[method](url, ...rest)
    }
  })
)
