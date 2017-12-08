import assert from 'assert'
import debug from 'debug'
import {SEPARATOR} from 'helpr'

const dbg = debug('app:client-organization-locations:id-hook')

export default async function ({data, context}) {
  dbg('data=%o, context=%o', data, context)

  if (context._id) {
    return context._id
  }

  assert(
    data.organization._id &&
    data.address.line1 &&
    data.address.city &&
    data.address.state &&
    data.address.zip,
    `insufficient fields in data=${data}`
  )

  return [
    data.organization._id,
    data.address.line1,
    data.address.city,
    data.address.state,
    data.address.zip
  ].join(SEPARATOR)
}
