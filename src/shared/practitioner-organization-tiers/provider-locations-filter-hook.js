import assert from 'assert'
import debug from 'debug'
import {stringify} from 'helpr'
import getData from '../../framework/data/data'
import providerOrgOpts from '../practitioner-organizations/opts'

const dbg = debug('app:shared:provider-organization-tiers:provider-locations-filter-hook')
const providerOrgKey = 'practitionerOrganization._id'
const providerOrgData = getData(providerOrgOpts)

export default async function ({context}) {
  dbg('context=%o', stringify(context))

  const targetId = context[providerOrgKey]
  assert(targetId, `${providerOrgKey} required in context`)

  const target = await providerOrgData.get(targetId)
  assert(target, `provider-organization for id=${targetId} required`)

  return {
    'practitioner._id': target.practitioner._id,
    'location.organization._id': target.organization._id
  }
}
