import test from 'ava'
import {initDb} from 'mongo-test-helpr'
// import debug from 'debug'
// import {stringify} from 'helpr'
import {getDb} from 'mongo-helpr'
import {isLike} from 'helpr'
import constants from '../../../src/shared/constants'
import getData from '../../../src/framework/data/data'
import potOpts from '../../../src/shared/practitioner-organization-tiers/opts'

// const dbg = debug('test:shared:provider-organization-tiers')

const potData = getData(potOpts)

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
                },
                {
                  _id: 'c1:n1:p1:t2',
                  name: 'tierTwo'
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

  let result = await db.collection(constants.PROVIDERS).save(
    {
      _id: 'p1',
      organizationRefs: [
        {
          _id: 'or1',
          organization: {
            _id: 'o1'
          }
        }
      ]
    }
  )
  t.is(result.result.ok, 1)

  db.collection(constants.PROVIDER_LOCATIONS).save(
    {
      _id: 'pl1',
      practitioner: {
        _id: 'p1'
      },
      location: {
        organization: {
          _id: 'o1'
        }
      }
    }
  )
  t.is(result.result.ok, 1)

  result = await potData.create(
    {
      data: {isInactive: true},
      context: {'practitionerOrganization._id': 'or1', 'tier._id': 'c1:n1:p1:t1'}
    }
  )
  t.is(result.result.ok, 1)

  result = await db.collection(constants.PROVIDERS).find().toArray()

  // dbg('result=%s', stringify(result))

  t.truthy(
    isLike(
      {
        actual: result[0],
        expected: {
          _id: 'p1',
          organizationRefs: [
            {
              _id: 'or1',
              organization: {
                _id: 'o1'
              },
              tierRefs: [
                {
                  tier: {
                    _id: 'c1:n1:p1:t1'
                  }
                }
              ]
            }
          ]
        }
      }
    )
  )
})

test('update', async t => {
  const db = await getDb()

  let result = await db.collection(constants.PROVIDERS).save(
    {
      _id: 'p1',
      organizationRefs: [
        {
          _id: 'or1',
          organization: {
            _id: 'o1'
          },
          tierRefs: [
            {
              _id: 'or1:c1:n1:p1:t1',
              tier: {
                _id: 'c1:n1:p1:t1'
              },
              isInactive: false,
              other: 'stuff'
            }
          ]
        }
      ]

    }
  )
  t.is(result.result.ok, 1)

  db.collection(constants.PROVIDER_LOCATIONS).save(
    {
      _id: 'pl1',
      practitioner: {
        _id: 'p1'
      },
      location: {
        organization: {
          _id: 'o1'
        }
      }
    }
  )
  t.is(result.result.ok, 1)

  const context = {'practitionerOrganization._id': 'or1', 'tier._id': 'c1:n1:p1:t1'}

  result = await potData.update(
    {
      id: await potOpts.idHook({context}),
      data: {isInactive: true},
      context
    }
  )
  t.is(result.result.ok, 1)

  result = await db.collection(constants.PROVIDERS).find().toArray()

  // dbg('result=%s', stringify(result))
  t.truthy(
    isLike(
      {
        actual: result[0],
        expected: {
          _id: 'p1',
          organizationRefs: [
            {
              _id: 'or1',
              organization: {
                _id: 'o1'
              },
              tierRefs: [
                {
                  _id: 'or1:c1:n1:p1:t1',
                  tier: {
                    _id: 'c1:n1:p1:t1'
                  },
                  isInactive: true,
                  other: 'stuff'
                }
              ]
            }
          ]
        }
      }
    )
  )
})

test('update: parent does not exist', async t => {
  const context = {'practitionerOrganization._id': 'or1', 'tier._id': 'c1:n1:p1:t1'}
  const result = await potData.update(
    {
      id: await potOpts.idHook({context}),
      data: {isInactive: true},
      context
    }
  )
  t.falsy(result)
})

test('update: target does not exist', async t => {
  const db = await getDb()

  let result = await db.collection(constants.PROVIDERS).save(
    {
      _id: 'p1',
      organizationRefs: []
    }
  )
  t.is(result.result.ok, 1)

  const context = {'practitionerOrganization._id': 'or1', 'tier._id': 'c1:n1:p1:t1'}
  result = await potData.update(
    {
      id: await potOpts.idHook({context}),
      data: {isInactive: true},
      context
    }
  )
  t.falsy(result)
})

test('upsert: target does not exist', async t => {
  const db = await getDb()

  let result = await db.collection(constants.PROVIDERS).save(
    {
      _id: 'p1',
      organizationRefs: [
        {
          _id: 'or1',
          organization: {
            _id: 'o1'
          }
        }
      ]
    }
  )
  t.is(result.result.ok, 1)

  db.collection(constants.PROVIDER_LOCATIONS).save(
    {
      _id: 'pl1',
      practitioner: {
        _id: 'p1'
      },
      location: {
        organization: {
          _id: 'o1'
        }
      }
    }
  )
  t.is(result.result.ok, 1)

  const context = {'practitionerOrganization._id': 'or1', 'tier._id': 'c1:n1:p1:t1'}

  result = await potData.upsert(
    {
      id: await potOpts.idHook({context}),
      data: {isInactive: true, other: 'stuff'},
      context
    }
  )
  t.is(result.result.ok, 1)

  result = await db.collection(constants.PROVIDERS).find().toArray()

  // dbg('result=%s', stringify(result))
  t.truthy(
    isLike(
      {
        actual: result[0],
        expected: {
          _id: 'p1',
          organizationRefs: [
            {
              _id: 'or1',
              organization: {
                _id: 'o1'
              },
              tierRefs: [
                {
                  _id: 'or1:c1:n1:p1:t1',
                  tier: {
                    _id: 'c1:n1:p1:t1'
                  },
                  isInactive: true,
                  other: 'stuff'
                }
              ]
            }
          ]
        }
      }
    )
  )
})

test('upsert: exists', async t => {
  const db = await getDb()

  let result = await db.collection(constants.PROVIDERS).save(
    {
      _id: 'p1',
      organizationRefs: [
        {
          _id: 'or1',
          organization: {
            _id: 'o1'
          },
          tierRefs: [
            {
              _id: 'or1:c1:n1:p1:t1',
              isInactive: false,
              other: 'stuff',
              tier: {
                _id: 'c1:n1:p1:t1'
              }
            }
          ]
        }
      ]
    }
  )
  t.is(result.result.ok, 1)

  const context = {'practitionerOrganization._id': 'or1', 'tier._id': 'c1:n1:p1:t1'}
  result = await potData.upsert(
    {
      id: await potOpts.idHook({context}),
      data: {isInactive: true},
      context
    }
  )
  t.is(result.result.ok, 1)

  result = await db.collection(constants.PROVIDERS).find().toArray()

  // dbg('result=%s', stringify(result))

  t.truthy(
    isLike(
      {
        actual: result[0],
        expected: {
          _id: 'p1',
          organizationRefs: [
            {
              _id: 'or1',
              organization: {
                _id: 'o1'
              },
              tierRefs: [
                {
                  _id: 'or1:c1:n1:p1:t1',
                  tier: {
                    _id: 'c1:n1:p1:t1'
                  },
                  isInactive: true,
                  other: 'stuff'
                }
              ]
            }
          ]
        }
      }
    )
  )
})

test('upsert: other exists', async t => {
  const db = await getDb()

  let result = await db.collection(constants.PROVIDERS).save(
    {
      _id: 'p1',
      organizationRefs: [
        {
          _id: 'or1',
          organization: {
            _id: 'o1'
          },
          tierRefs: [
            {
              _id: 'or1:c1:n1:p1:t1',
              isInactive: false,
              other: 'stuff',
              tier: {
                _id: 'c1:n1:p1:t1'
              }
            }
          ]
        }
      ]
    }
  )
  t.is(result.result.ok, 1)

  db.collection(constants.PROVIDER_LOCATIONS).save(
    {
      _id: 'pl1',
      practitioner: {
        _id: 'p1'
      },
      location: {
        organization: {
          _id: 'o1'
        }
      }
    }
  )
  t.is(result.result.ok, 1)

  const context = {'practitionerOrganization._id': 'or1', 'tier._id': 'c1:n1:p1:t2'}
  result = await potData.upsert(
    {
      id: await potOpts.idHook({context}),
      data: {isInactive: true, other: 'nonsense'},
      context
    }
  )
  t.is(result.result.ok, 1)

  result = await db.collection(constants.PROVIDERS).find().toArray()

  // dbg('result=%s', stringify(result))

  t.truthy(
    isLike(
      {
        actual: result[0],
        expected: {
          _id: 'p1',
          organizationRefs: [
            {
              _id: 'or1',
              organization: {
                _id: 'o1'
              },
              tierRefs: [
                {
                  _id: 'or1:c1:n1:p1:t1',
                  tier: {
                    _id: 'c1:n1:p1:t1'
                  },
                  isInactive: false,
                  other: 'stuff'
                },
                {
                  _id: 'or1:c1:n1:p1:t2',
                  tier: {
                    _id: 'c1:n1:p1:t2'
                  },
                  isInactive: true,
                  other: 'nonsense'
                }
              ]
            }
          ]
        }
      }
    )
  )
})
