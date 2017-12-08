import test from 'ava'
import axios from 'axios'
import debug from 'debug'
import _ from 'lodash'
import config from 'config'
import {initFixture} from 'mongo-test-helpr'
import {getUrl} from 'test-helpr'
import {isLike} from 'helpr'
import {getDb, requireOne} from 'mongo-helpr'
import constants from '../../../src/shared/constants'

const dbg = debug('test:api:tiers')
const collectionName = constants.CLIENTS
const port = _.get(config, 'listener.port', 3000)

test.before(() => {
  dbg('before')
  // eslint-disable-next-line no-unused-expressions
  require('../../../src/api').default
})

test.beforeEach(async () => {
  const db = await getDb()
  dbg('before-each')
  await initFixture(
    {
      db,
      collectionName,
      docs: [
        {
          _id: 'c1',
          networks: [
            {
              _id: 'c1:n1',
              plans: [
                {
                  _id: 'c1:n1:p1',
                  tiers: [
                    {_id: 'c1:n1:p1:t1', isActive: false},
                    {_id: 'c1:n1:p1:t2', isActive: true}
                  ]
                }
              ]
            }
          ]
        },
        {
          _id: 'c2',
          networks: [
            {
              _id: 'c2:n1',
              plans: [
                {
                  _id: 'c2:n1:p1'
                }
              ]
            }
          ]
        }
      ]
    }
  )
})

test('create auto-id tier for plan', async t => {
  dbg('create-auto-id...')
  const response = await axios.post(
    getUrl('/clients/c2/networks/c2:n1/plans/c2:n1:p1/tiers', {port}),
    {name: 'tier one', rank: 1, isInNetwork: true}
  )
  t.is(response.status, 201)
  const actual = await requireOne({collectionName, query: {_id: 'c2'}})
  const expected = {
    _id: 'c2',
    networks: [
      {
        _id: 'c2:n1',
        plans: [
          {
            _id: 'c2:n1:p1',
            tiers: [
              {
                name: 'tier one'
              }
            ]
          }
        ]
      }
    ]
  }
  t.truthy(isLike({expected, actual}))
})
