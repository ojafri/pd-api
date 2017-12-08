import assert from 'assert'
import _ from 'lodash'
import debug from 'debug'
import {getName, captureDataChange} from '../framework/data/helper'
import constants from '../framework/data/constants'
import {getContextDate, getContextSource, getContextUser} from './helper'

const dbg = debug('app:shared:post-delete-hook')

export default async function ({result, context, opts}) {
  dbg(
    'target=%o, result=%o, context=%o',
    getName(opts),
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

  if (result.result.n) {
    const _result = await captureDataChange(
      {
        target: opts.collectionName,
        mode: constants.MODES.delete,
        source: await getContextSource(context),
        user: await getContextUser(context),
        date: getContextDate(context),
        data: result.original,
        update: result.update
      }
    )
    assert(_result.result.ok, 'ok result required')
  }
}
