import assert from 'assert'
// import debug from 'debug'
import _ from 'lodash'
import {stringify} from 'helpr'
import {isPublicSource} from '../../shared/helper'
import {getSyntheticResult, captureDataChange} from '../../framework/data/helper'

// const dbg = debug('app:batch:shared:upsert-post-processor')

export default function ({queryHook, recordHook} = {}) {
  return async function ({output, record, source, date}) {
    const _record = recordHook ? recordHook(record) : record
    let query

    if (queryHook) {
      query = queryHook(record)
    } else {
      assert(record._id, `record _id required, record=${record}`)
      query = {_id: record._id}
    }

    // if this record exists and has been updated by a private client
    // this will not match, an upsert will be attempted and should fail per unique index.
    //
    // the intent is to disallow updates to records that have been updated by private clients
    // from a public source
    //
    if (isPublicSource(source)) {
      query['updated.source._id'] = source._id
    }

    const $set = _record._id ? _.omit(_record, ['_id']) : _record

    // dbg('query=%j, $set=%j', query, $set)

    let result = await output.findOneAndUpdate(
      query,
      {
        $set,
        $setOnInsert: {
          created: {source, date},
          updated: {source, date},
          ...(_record._id && {_id: _record._id})
        }
      },
      {upsert: true}
    )

    result = getSyntheticResult({result, data: $set})
    // dbg('synthetic-result=%j', result)

    if (!result.upsertedCount) {
      let set
      if (result.modifiedCount) {
        // calling update again to modify updated date isn't that great
        // keep an eye on this for a better way: https://jira.mongodb.org/browse/SERVER-13578
        //
        set = {
          $set: {updated: {source, date}},
          $unset: {
            isInactive: null,
            scanned: null
          } // in case of re-activation
        }

        const _result = await captureDataChange(
          {
            target: output.s.name,
            source,
            date,
            data: result.original,
            update: $set
          }
        )
        assert(_result.result.ok, 'ok result required')
      } else {
        // assume record was unchanged by operation
        // mark as scanned, but not updated such that we can spot "inactive" records
        set = {$set: {scanned: {date}}}
      }

      const _result = await output.updateOne(query, set)
      assert(
        _result.modifiedCount === 1,
        `unexpected result=${_result} attempting to modify with set=${stringify(set)}`
      )
    }

    return result
  }
}
