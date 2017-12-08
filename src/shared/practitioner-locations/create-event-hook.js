import assert from 'assert'
import _ from 'lodash'
import {stringify} from 'helpr'
import debug from 'debug'
import constants from '../constants'

const dbg = debug('app:shared:provider-locations:create-event-hook')

const orgIdPath = 'location.organization._id'
const locIdPath = 'location._id'

export async function addToOrganizations({data, db}) {
  dbg('add-to-organizations: data=%j', data)

  const _id = _.get(data, orgIdPath)
  assert(_id, `unable to obtain id at ${orgIdPath} from data=${stringify(data)}`)
  const result = await db.collection(constants.ORGANIZATIONS).updateOne(
    {_id},
    {$push: {practitioners: getProviderData(data)}}
  )
  assert(result.result.ok, 'ok result required')
}

export async function addToOrganizationLocations({data, db}) {
  dbg('add-to-organization-locations: data=%j', data)

  const _id = _.get(data, locIdPath)
  assert(_id, `unable to obtain id at ${locIdPath} from data=${stringify(data)}`)
  const result = await db.collection(constants.ORGANIZATION_LOCATIONS).updateOne(
    {_id},
    {$push: {practitioners: getProviderData(data)}}
  )
  assert(result.result.ok, 'ok result required')
}

function getProviderData(data) {
  const {_id, id, name} = data.practitioner
  assert(_id && id && name, `insufficient fields found in data=${data.practitioner}`)
  return {_id, id, name}
}
