import assert from 'assert'
import debug from 'debug'
import {stringify, getArg, getJsonArg} from 'helpr'

const dbg = debug('app:shared:inactive-post-ingest-hook')

export default function ({query} = {}) {
  return async function ({output, date}) {
    if (getArg('skip') || getArg('limit')) {
      dbg('incompatible with skip/limit arguments=%o, bypassing...', process.argv.slice(2))
      return
    }

    const queryArg = getArg('query')
    if (queryArg && !getArg('inactiveHookVerify')) {
      dbg('query argument=%o must be accompanied by the inactiveHookVerify argument, bypassing...', queryArg)
      return
    }

    assert(output, 'output required')
    assert(date, 'date required')

    const _query = {
      ...getJsonArg('inactiveQuery', {dflt: query}),
      'scanned.date': {$ne: date},
      'updated.date': {$ne: date}
    }

    const result = await output.updateMany(
      _query,
      {
        $set: {
          isInactive: true
        }
      }
    )

    dbg('query=%o, modified-count=%o', stringify(_query), result.modifiedCount)
    return result
  }
}
