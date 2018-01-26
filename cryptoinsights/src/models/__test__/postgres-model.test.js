import postgres from 'db/postgres'

import PostgresModel from 'models/postgres-model'

describe('PostgresModel', () => {
  const table = 'test'

  beforeEach(async () => {
    await postgres.query(`DROP TABLE IF EXISTS ${table}`)
    await postgres.query(`
      CREATE TABLE ${table} (
        id serial PRIMARY KEY,
        name text NOT NULL
      )
    `)
  })
  afterEach(async () => {
    await postgres.query(`DROP TABLE IF EXISTS ${table}`)
    await postgres.disconnect()
  })

  // it('should instantiate a model', () => {
  //   const model = new PostgresModel('foo')
  //   expect(model).toBeInstanceOf(PostgresModel)
  // })

  describe('instance methods', () => {
    describe('create', () => {
      it('should create a row', async () => {
        const model = new PostgresModel(table)
        const result = await model.create({ name: 'name' })
        console.log('fdsafdsafdasfadfdas', result.rows[0])
      })
    })
  })
})
