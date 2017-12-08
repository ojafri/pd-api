import test from 'ava'
import {initFixture} from 'mongo-test-helpr'
import {getDb, requireOne} from 'mongo-helpr'
import getIngester from '../../../src/framework/batch/ingester'
import upsertPostProcessor from '../../../src/batch/shared/upsert-post-processor'
import inactivePostIngestHook from '../../../src/batch/shared/inactive-post-ingest-hook'

const inputName = 'test-input'
const outputName = 'test-output'
const ingester = getIngester(
  {
    inputName,
    outputName,
    sourceHook: {_id: 1},
    postProcessor: upsertPostProcessor(),
    postIngestHook: inactivePostIngestHook()
  }
)
const docs = [
  {
    fieldOne: 'f1-1',
    fieldTwo: 'f2-1'
  },
  {
    fieldOne: 'f1-2',
    fieldTwo: 'f2-2'
  }
]

test.beforeEach(async () => {
  const db = await getDb()

  await initFixture(
    {
      db,
      collectionName: inputName,
      docs
    }
  )
})

test('ingest: basic', async t => {
  const metrics = await ingester()
  t.deepEqual(metrics, {inserted: docs.length, updated: 0, scanned: 0, failed: 0})
  const db = await getDb()
  const result = await db.collection(outputName).find().toArray()
  t.is(result.length, docs.length)
  result.map(elt => {
    t.truthy(elt.created.date)
    return t.falsy(elt.scanned)
  })
})

test('ingest: multiple no change', async t => {
  await ingester()
  const metrics = await ingester()
  t.deepEqual(metrics, {inserted: 0, updated: 0, scanned: docs.length, failed: 0})
  const db = await getDb()
  const result = await db.collection(outputName).find().toArray()
  t.is(result.length, docs.length)
  result.map(elt => {
    t.truthy(elt.created.date)
    return t.truthy(elt.scanned.date)
  })
})

test('ingest: multiple with change', async t => {
  await ingester()
  const db = await getDb()
  const query = {fieldOne: 'f1-1'}
  const fieldOne = 'foo'
  const record = await requireOne({db, query, collectionName: outputName})
  t.truthy(record.created.date)
  const result = await db.collection(inputName).updateOne(query, {$set: {fieldOne}})
  t.is(result.modifiedCount, 1)
  const metrics = await ingester()
  t.deepEqual(metrics, {inserted: 0, updated: 1, scanned: docs.length - 1, failed: 0})
  const _record = await requireOne({query: {_id: record._id}, collectionName: outputName})
  t.is(_record.fieldOne, fieldOne)
  t.truthy(_record.updated.date)
  t.truthy(_record.created.date)
  t.falsy(_record.scanned)
  t.not(_record.updated.date, record.created.date)
})

test('ingest: multiple with inactive', async t => {
  await ingester()
  const db = await getDb()
  const query = {fieldOne: 'f1-1'}
  const result = await db.collection(inputName).remove(query)
  t.is(result.result.n, 1)
  const metrics = await ingester()
  t.deepEqual(metrics, {inserted: 0, updated: 0, scanned: docs.length - 1, failed: 0, postIngest: {updated: 1}})
  const record = await requireOne({query, collectionName: outputName})
  t.truthy(record.isInactive)
})
