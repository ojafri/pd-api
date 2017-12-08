import assert from 'assert'
import _ from 'lodash'
import debug from 'debug'
import {stringify, deepClean} from 'helpr'
import getData from '../../framework/data/data'
import {isCreate, isUpsert} from '../../framework/data/helper'
import orgOpts from '../../shared/organizations/opts'

const dbg = debug('app:shared:organization-locations:data-hook')

const orgData = getData(orgOpts)

export default async function ({data, context, mode}) {
  dbg('data=%o, context=%o, mode=%o', data, context, mode)

  if (isCreate(mode) || isUpsert(mode)) {
    assert(context.organizationId, 'context.organizationId required')
    const org = await orgData.get(context.organizationId)
    assert(org, `unable to obtain organization for id=${stringify(context.organizationId)}`)

    return {
      ...data,
      organization: _.pick(org, ['_id', 'id', 'name', 'identifiers']),
      specialties: org.specialties,
      isPrivate: org.isPrivate
    }
  } else if (deepClean(context.organizationId)) {
    dbg('updates to organization disallowed, ignoring context.organizationId=%o', context.organizationId)
  }

  return data
}
