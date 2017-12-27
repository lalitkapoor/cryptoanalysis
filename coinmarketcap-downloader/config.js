import path from 'path'
import dotenv from 'dotenv'
import appRoot from 'app-root-path'

dotenv.load({
  silent: true,
  path: path.resolve(__dirname + '/../.env')
})

let config = {
  ENV: process.env.NODE_ENV || 'development',
  APP_ROOT: appRoot.path,

  PROTOCOL: process.env.PROTOCOL || 'http',
  DOMAIN: process.env.DOMAIN || 'localhost',
  PORT: process.env.PORT || 3000,
}

config.URL = `${config.PROTOCOL}://${config.DOMAIN}:${config.PORT}`

config.PG_CONN_STR = process.env.PG_CONN_STR || process.env.DATABASE_URL
if (config.ENV === 'test') config.PG_CONN_STR += '_test'

export default config

