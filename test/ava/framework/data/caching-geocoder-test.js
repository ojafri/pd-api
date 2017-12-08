import test from 'ava'
import _ from 'lodash'
import debug from 'debug'
import {getDb, findOne} from 'mongo-helpr'
import {initFixture, initDb} from 'mongo-test-helpr'
import constants from '../../../../src/framework/data/constants'
import geocoder from '../../../../src/framework/data/caching-geocoder'

const dbg = debug('test:data:caching-geocoder')

const collectionName = constants.GEO_ADDRESSES
dbg('collection-name=%o', collectionName)

test('geocoder: local', async t => {
  const db = await getDb()
  await initFixture(
    {
      db,
      collectionName,
      docs: [
        {
          geoPoint: {
            type: 'Point',
            coordinates: [0.111, 0.222]
          },
          addressKey: 'street-1:city-1:state-1:zip-1'
        }
      ]
    }
  )
  const coordinates = await geocoder({street: 'street-1', city: 'city-1', state: 'state-1', zip: 'zip-1'})
  t.deepEqual(coordinates, [0.111, 0.222])
})

test('geocoder: remote', async t => {
  const db = await getDb()
  await initDb(db)
  const coordinates = await geocoder(
    {
      street: '151 Farmington Ave',
      city: 'Hartford',
      state: 'CT',
      zip: '06108'
    }
  )
  const expected = [-72.69, 41.77]

  t.deepEqual(round(coordinates), expected)

  const result = await findOne(
    {
      db,
      collectionName,
      query: {
        addressKey: '151 Farmington Ave:Hartford:CT:06108'
      }
    }
  )

  t.truthy(result)

  t.deepEqual(round(result.geoPoint.coordinates), expected)
})

function round(array) {
  return _.map(array, elt => _.round(elt, 2))
}
