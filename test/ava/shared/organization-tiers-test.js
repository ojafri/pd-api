import test from 'ava'
import {initDb} from 'mongo-test-helpr'
import debug from 'debug'
import {stringify} from 'helpr'
import {getDb} from 'mongo-helpr'
import getData from '../../../src/framework/data/data'
import constants from '../../../src/shared/constants'
import otOpts from '../../../src/shared/organization-tiers/opts'

const dbg = debug('test:shared:organization-tiers')

const otData = getData(otOpts)

test.beforeEach(async t => {
  const db = await getDb()
  await initDb(db)
  const result = await db.collection(constants.CLIENTS).save(
    {
      _id: 'c1',
      name: 'clientOne',
      networks: [
        {
          _id: 'c1:n1',
          name: 'netOne',
          plans: [
            {
              _id: 'c1:n1:p1',
              name: 'planOne',
              tiers: [
                {
                  _id: 'c1:n1:p1:t1',
                  name: 'tierOne'
                }
              ]
            }
          ]
        }
      ]
    }
  )
  t.is(result.result.ok, 1)
})

test('create', async t => {
  const db = await getDb()

  let result = await db.collection(constants.ORGANIZATIONS).save({_id: 'o1'})
  t.is(result.result.ok, 1)

  db.collection(constants.ORGANIZATION_LOCATIONS).save(
    {
      _id: 'ol1',
      organization: {_id: 'o1'}
    }
  )
  t.is(result.result.ok, 1)

  result = await otData.create(
    {
      data: {isInactive: true},
      context: {'organization._id': 'o1', 'tier._id': 'c1:n1:p1:t1'}
    }
  )
  t.is(result.result.ok, 1)

  result = await db.collection(constants.ORGANIZATIONS).find().toArray()

  // dbg('result=%s', stringify(result))

  t.deepEqual(
    result[0].tierRefs[0],
    {
      _id: 'o1:c1:n1:p1:t1',
      isInactive: true,
      tier: {
        _id: 'c1:n1:p1:t1',
        name: 'tierOne',
        plan: {
          _id: 'c1:n1:p1',
          name: 'planOne',
          network: {
            _id: 'c1:n1',
            name: 'netOne',
            client: {
              _id: 'c1',
              name: 'clientOne'
            }
          }
        }
      }
    }
  )
})

// test('update', async t => {
//   const db = await getDb()
//
//   let result = await db.collection(constants.ORGANIZATIONS).save(
//     {
//       _id: 'o1',
//       tierRefs: [
//         {
//           _id: 'o1:c1:n1:p1:t1',
//           isInactive: false,
//           other: 'stuff'
//         }
//       ]
//     }
//   )
//   t.is(result.result.ok, 1)
//
//   db.collection(constants.ORGANIZATION_LOCATIONS).save(
//     {
//       _id: 'ol1',
//       organization: {_id: 'o1'}
//     }
//   )
//   t.is(result.result.ok, 1)
//
//   const context = {'organization._id': 'o1', 'tier._id': 'c1:n1:p1:t1'}
//   result = await otData.update(
//     {
//       id: await otOpts.idHook({context}),
//       data: {isInactive: true},
//       context
//     }
//   )
//   t.is(result.result.ok, 1)
//
//   result = await db.collection(constants.ORGANIZATIONS).find().toArray()
//
//   dbg('result=%s', stringify(result))
//
//   t.deepEqual(
//     result[0].tierRefs[0],
//     {
//       _id: 'o1:c1:n1:p1:t1',
//       isInactive: true,
//       other: 'stuff'
//     }
//   )
// })
//
// test('update: parent does not exist', async t => {
//   const context = {'organization._id': 'o1', 'tier._id': 'c1:n1:p1:t1'}
//   const result = await otData.update(
//     {
//       id: await otOpts.idHook({context}),
//       data: {isInactive: true},
//       context
//     }
//   )
//   t.falsy(result)
// })
//
// test('update: target does not exist', async t => {
//   const db = await getDb()
//
//   let result = await db.collection(constants.ORGANIZATIONS).save(
//     {
//       _id: 'o1',
//       tierRefs: []
//     }
//   )
//   t.is(result.result.ok, 1)
//
//   db.collection(constants.ORGANIZATION_LOCATIONS).save(
//     {
//       _id: 'ol1',
//       organization: {_id: 'o1'}
//     }
//   )
//   t.is(result.result.ok, 1)
//
//   const context = {'organization._id': 'o1', 'tier._id': 'c1:n1:p1:t1'}
//   result = await otData.update(
//     {
//       id: await otOpts.idHook({context}),
//       data: {isInactive: true},
//       context
//     }
//   )
//   t.falsy(result)
// })

test('upsert: target does not exist', async t => {
  const db = await getDb()

  let result = await db.collection(constants.ORGANIZATIONS).save({_id: 'o1'})
  t.is(result.result.ok, 1)

  db.collection(constants.ORGANIZATION_LOCATIONS).save(
    {
      _id: 'ol1',
      organization: {_id: 'o1'}
    }
  )
  t.is(result.result.ok, 1)

  const context = {'organization._id': 'o1', 'tier._id': 'c1:n1:p1:t1'}
  result = await otData.upsert(
    {
      data: {isInactive: true},
      context
    }
  )
  t.is(result.result.ok, 1)

  result = await db.collection(constants.ORGANIZATIONS).find().toArray()

  // dbg('result=%s', stringify(result))

  t.deepEqual(
    result[0].tierRefs[0],
    {
      _id: 'o1:c1:n1:p1:t1',
      isInactive: true,
      tier: {
        _id: 'c1:n1:p1:t1',
        name: 'tierOne',
        plan: {
          _id: 'c1:n1:p1',
          name: 'planOne',
          network: {
            _id: 'c1:n1',
            name: 'netOne',
            client: {
              _id: 'c1',
              name: 'clientOne'
            }
          }
        }
      }
    }
  )
})

test('upsert: exists', async t => {
  const db = await getDb()

  let result = await db.collection(constants.ORGANIZATIONS).save(
    {
      _id: 'o1',
      tierRefs: [
        {
          _id: 'o1:c1:n1:p1:t1',
          isInactive: false
        }
      ]
    }
  )
  t.is(result.result.ok, 1)

  db.collection(constants.ORGANIZATION_LOCATIONS).save(
    {
      _id: 'ol1',
      organization: {_id: 'o1'}
    }
  )
  t.is(result.result.ok, 1)

  const context = {'organization._id': 'o1', 'tier._id': 'c1:n1:p1:t1'}
  result = await otData.upsert(
    {
      data: {isInactive: true},
      context
    }
  )
  t.is(result.result.ok, 1)

  result = await db.collection(constants.ORGANIZATIONS).find().toArray()

  dbg('result=%s', stringify(result))

  t.deepEqual(
    result[0].tierRefs[0],
    {
      _id: 'o1:c1:n1:p1:t1',
      isInactive: true,
      tier: {
        _id: 'c1:n1:p1:t1',
        name: 'tierOne',
        plan: {
          _id: 'c1:n1:p1',
          name: 'planOne',
          network: {
            _id: 'c1:n1',
            name: 'netOne',
            client: {
              _id: 'c1',
              name: 'clientOne'
            }
          }
        }
      }
    }
  )
})

test('upsert: other exists', async t => {
  const db = await getDb()

  let result = await db.collection(constants.ORGANIZATIONS).save(
    {
      _id: 'o1',
      tierRefs: [
        {
          _id: 'o1:c1:n1:p1:t2',
          isInactive: false
        }
      ]
    }
  )
  t.is(result.result.ok, 1)

  db.collection(constants.ORGANIZATION_LOCATIONS).save(
    {
      _id: 'ol1',
      organization: {_id: 'o1'}
    }
  )
  t.is(result.result.ok, 1)

  const context = {'organization._id': 'o1', 'tier._id': 'c1:n1:p1:t1'}
  result = await otData.upsert(
    {
      data: {isInactive: true},
      context
    }
  )
  t.is(result.result.ok, 1)

  result = await db.collection(constants.ORGANIZATIONS).find().toArray()

  dbg('result=%s', stringify(result))

  t.deepEqual(
    result[0].tierRefs[0],
    {
      _id: 'o1:c1:n1:p1:t2',
      isInactive: false
    }
  )

  t.deepEqual(
    result[0].tierRefs[1],
    {
      _id: 'o1:c1:n1:p1:t1',
      isInactive: true,
      tier: {
        _id: 'c1:n1:p1:t1',
        name: 'tierOne',
        plan: {
          _id: 'c1:n1:p1',
          name: 'planOne',
          network: {
            _id: 'c1:n1',
            name: 'netOne',
            client: {
              _id: 'c1',
              name: 'clientOne'
            }
          }
        }
      }
    }
  )
})
