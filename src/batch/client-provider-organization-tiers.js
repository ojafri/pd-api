import assert from 'assert'
import debug from 'debug'
import {stringify} from 'helpr'
import getData from '../framework/data/data'
import tierOpts from '../shared/clients/networks/plans/tiers/opts'
import providerOrgOpts from '../shared/practitioner-organizations/opts'
import providerOrgTierOpts, {PROVIDER_ORGANIZATION} from '../shared/practitioner-organization-tiers/opts'
import getTierRefHooks from '../shared/tier-ref-hooks'
import {isCreate, isDelete} from '../framework/data/helper'
import getIngester from '../framework/batch/ingester'
import constants from './shared/constants'
import {getRequiredSource} from './shared/helper'

const dbg = debug('app:batch:client-provider-organization-tiers')

const tierData = getData(tierOpts)
const providerOrgData = getData(providerOrgOpts)
const providerOrgTierData = getData(providerOrgTierOpts)
const tierRefHooks = getTierRefHooks({target: PROVIDER_ORGANIZATION})

export default (async function () {
  const source = await getRequiredSource()

  async function postProcessor({record, date}) {
    dbg('post-processor-hook: record=%o, date=%o', stringify(record), date)

    const tier = await tierData.get(record.tierId)
    dbg('tier-id=%o, tier=%o', record.tierId, stringify(tier))
    assert(tier, `unable to obtain tier for id=${record.tierId}`)
    assert(tier.plan.network.client._id === source._id, 'tier client required to match ingesting client')

    const providerOrgIdFilter = {
      'practitioner.id.oid': record.providerOid,
      'practitioner.id.extension': record.providerExtension,
      'organization.id.oid': record.organizationOid,
      'organization.id.extension': record.organizationExtension
    }

    const providerOrg = await providerOrgData.get(providerOrgIdFilter)
    dbg('providerOrg=%o', providerOrg)
    assert(providerOrg, `invalid providerOrg reference. id=${stringify(providerOrgIdFilter)}`)

    const data = {
      tier: {_id: record.tierId}
    }

    const context = {
      'tier._id': record.tierId,
      [`${PROVIDER_ORGANIZATION}._id`]: providerOrg._id
    }

    const tierRefId = await tierRefHooks.id({context})
    dbg('tierRefId=%o', tierRefId)

    let result
    if (isCreate(record.action)) {
      result = await providerOrgTierData.upsert({id: tierRefId, data, context})
    } else if (isDelete(record.action)) {
      result = await providerOrgTierData.delete({id: tierRefId, context})
      assert(result, `provider-org-tier for id=${tierRefId} not found to delete`)
    } else {
      throw new Error(`unsupported action=${record.action}`)
    }
    dbg('result=%o', result)
    assert(result.result.ok, 'ok required')

    return result
  }

  return getIngester(
    {
      inputName: constants.CLIENT_PROVIDER_ORGANIZATION_TIERS_SOURCE,
      outputName: constants.PROVIDERS,
      postProcessor
    }
  )()
})()
