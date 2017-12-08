import assert from 'assert'
import debug from 'debug'
import {SEPARATOR, stringify} from 'helpr'

const dbg = debug('app:shared:provider-locations:id-hook')

export default async function ({data, context}) {
  dbg('data=%o, context=%o', stringify(data), stringify(context))

  if (context._id) {
    return context._id
  }

  assert(
    data.practitioner._id &&
    data.location.organization._id &&
    data.location.address.line1 &&
    data.location.address.city &&
    data.location.address.state &&
    data.location.address.zip,
    `insufficient fields in data=${data}`
  )

  return [
    data.practitioner._id,
    data.location.organization._id,
    data.location.address.line1,
    data.location.address.city,
    data.location.address.state,
    data.location.address.zip
  ].join(SEPARATOR)
}
