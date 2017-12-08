import assert from 'assert'
import _ from 'lodash'
import debug from 'debug'
import {stringify, deepClean} from 'helpr'
import getData from '../../framework/data/data'
import {isCreate, isUpsert} from '../../framework/data/helper'
import practitionerOpts from '../../shared/practitioners/opts'
import orgLocOpts from '../../shared/organization-locations/opts'

const dbg = debug('app:shared:provider-locations:data-hook')

const practitionerData = getData(practitionerOpts)
const orgLocData = getData(orgLocOpts)

export default async function ({data, context, mode}) {
  dbg('data=%o, context=%o, mode=%o', stringify(data), stringify(context), mode)

  if (isCreate(mode) || isUpsert(mode)) {
    assert(context.providerId, 'context.providerId required')
    const practitioner = await practitionerData.get(context.providerId)
    assert(practitioner, `unable to obtain practitioner for id=${stringify(context.providerId)}`)

    assert(context.organizationLocId, 'context.organizationLocId required')
    const orgLoc = await orgLocData.get(context.organizationLocId)
    assert(orgLoc, `unable to obtain organization-location for id=${stringify(context.organizationLocId)}`)

    return {
      ...data,
      practitioner: _.pick(practitioner, ['_id', 'id', 'name', 'specialties', 'identifiers']),
      location: _.pick(orgLoc, ['_id', 'organization', 'address', 'geoPoint', 'phone']),
      isPrivate: practitioner.isPrivate
    }
  }

  if (deepClean(context.providerId)) {
    dbg('updates to provider disallowed, ignoring context.providerId=%o', context.providerId)
  }

  if (deepClean(context.organizationLocId)) {
    dbg('updates to organization-location disallowed, ignoring context.organizationLocId=%o', context.organizationLocId)
  }

  return data
}
