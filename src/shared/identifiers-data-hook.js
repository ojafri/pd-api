import debug from 'debug'
import {deepClean} from 'helpr'

const dbg = debug('app:shared:identifiers-data-hook')

export default async function ({data, context, mode}) {
  dbg('data=%o, context=%o, mode=%o', data, context, mode)

  return {
    ...data,
    ...deepClean(
      {
        identifiers: [data.id]
      }
    )
  }
}
