import assert from 'assert'
import _ from 'lodash'
import debug from 'debug'
import {join} from 'helpr'
import {getName, captureDataChange} from '../framework/data/helper'
import {getChanged, getContextDate, getContextSource, getContextUser} from './helper'

const dbg = debug('app:shared:changes-post-update-hook')

export default function ({omitSource} = {}) {
  return async function ({result, filter, context, opts, db, update}) {
    dbg(
      'target=%o, filter=%o, result=%o, context=%o',
      getName(opts),
      filter,
      _.pick(
        result,
        [
          'matchedCount',
          'upsertedCount',
          'modifiedCount',
          'path',
          'filter'
        ]
      ),
      context
    )

    const _filter = filter || result.filter
    assert(_filter, 'filter required')
    const $set = {}

    if (result.upsertedCount || result.modifiedCount) {
      const {path} = result
      const changed = await getChanged({context, omitSource})

      if (result.upsertedCount) {
        $set[join([path, 'created'])] = changed
      }

      $set[join([path, 'updated'])] = changed

      dbg('filter=%j, $set=%j', _filter, $set)

      let _result = await db.collection(opts.collectionName).updateOne(_filter, {$set})

      assert(
        _result.result.nModified,
        `modification to collection=${opts.collectionName} with filter=${filter} expected`
      )

      if (result.modifiedCount) {
        _result = await captureDataChange(
          {
            target: opts.collectionName,
            source: await getContextSource(context),
            user: await getContextUser(context),
            date: getContextDate(context),
            data: result.original,
            update: update || result.update
          }
        )
        assert(_result.result.ok, 'ok result required')
      }
    }
  }
}
