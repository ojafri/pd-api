import debug from 'debug'
import {stringify} from 'helpr'
import {isCreate} from '../framework/data/helper'
import {getChanged} from './helper'

const dbg = debug('app:shared:created-data-hook')

export default function ({omitSource} = {}) {
  return async function ({data, context, mode}) {
    dbg('data=%o, context=%o, mode=%o', stringify(data), context, mode)

    if (isCreate(mode)) {
      const created = await getChanged({context, omitSource})
      return {
        ...data,
        created,
        updated: created
      }
    }
    return data
  }
}
