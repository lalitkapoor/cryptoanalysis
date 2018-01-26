'use strict';

var _postgres = require('../../db/postgres');

var _postgres2 = _interopRequireDefault(_postgres);

var _postgresModel = require('../postgres-model');

var _postgresModel2 = _interopRequireDefault(_postgresModel);

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { default: obj }; }

describe('PostgresModel', () => {
  const table = 'test';

  beforeEach(async () => {
    await _postgres2.default.query(`DROP TABLE IF EXISTS ${table}`);
    await _postgres2.default.query(`
      CREATE TABLE ${table} (
        id serial PRIMARY KEY,
        name text NOT NULL
      )
    `);
  });
  afterEach(async () => {
    await _postgres2.default.query(`DROP TABLE IF EXISTS ${table}`);
    await _postgres2.default.disconnect();
  });

  // it('should instantiate a model', () => {
  //   const model = new PostgresModel('foo')
  //   expect(model).toBeInstanceOf(PostgresModel)
  // })

  describe('instance methods', () => {
    describe('create', () => {
      it('should create a row', async () => {
        const model = new _postgresModel2.default(table);
        const result = await model.create({ name: 'name' });
        console.log('fdsafdsafdasfadfdas', result.rows[0]);
      });
    });
  });
});