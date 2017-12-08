import assert from 'assert'
import debug from 'debug'
import {SEPARATOR} from 'helpr'
import {compressOid} from './helper'

const dbg = debug('app:shared:id-hook')

export default async function ({data, context}) {
  dbg('data=%o, context=%o', data, context)

  if (context._id) {
    return context._id
  }

  assert(data.id.oid && data.id.extension, `insufficient fields in data=${data}`)

  return [
    compressOid(data.id.oid),
    data.id.extension
  ].join(SEPARATOR)
}
