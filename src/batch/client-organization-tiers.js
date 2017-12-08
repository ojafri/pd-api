import assert from 'assert'
import debug from 'debug'
import {stringify} from 'helpr'
import getData from '../framework/data/data'
import {isCreate, isDelete} from '../framework/data/helper'
import getIngester from '../framework/batch/ingester'
import tierOpts from '../shared/clients/networks/plans/tiers/opts'
import orgOpts from '../shared/organizations/opts'
import orgTierOpts from '../shared/organization-tiers/opts'
import getTierRefHooks from '../shared/tier-ref-hooks'
import constants from './shared/constants'
import {getRequiredSource} from './shared/helper'

const dbg = debug('app:batch:client-organization-tiers')

const tierData = getData(tierOpts)
const orgData = getData(orgOpts)
const orgTierData = getData(orgTierOpts)

export default (async function () {
  const source = await getRequiredSource()

  async function postProcessor({record, date}) {
    dbg('post-processor-hook: record=%o, date=%o', record, date)

    const tier = await tierData.get(record.tierId)
    dbg('tier-id=%o, tier=%o', record.tierId, stringify(tier))
    assert(tier, `unable to obtain tier for id=${record.tierId}`)
    assert(tier.plan.network.client._id === source._id, 'tier client required to match ingesting client')

    let result

    const orgFilter = {
      'id.oid': record.oid,
      'id.extension': record.extension
    }

    const org = await orgData.get(orgFilter)

    assert(org, `unabled to obtain org reference with filter=${stringify(orgFilter)}`)

    const data = {
      tier: {_id: record.tierId}
    }

    const context = {
      'tier._id': record.tierId,
      'organization._id': org._id
    }

    const tierRefHooks = getTierRefHooks({target: 'organization'})
    const tierRefId = await tierRefHooks.id({context})
    dbg('tierRefId=%o', tierRefId)

    if (isCreate(record.action)) {
      result = await orgTierData.upsert({id: tierRefId, data, context})
    } else if (isDelete(record.action)) {
      result = await orgTierData.delete({id: tierRefId, context})
      assert(result, `unable to obtain org-tier for id=${tierRefId}`)
    } else {
      throw new Error(`unsupported action=${record.action}`)
    }
    assert(result.result.ok, 'ok required')

    return result
  }

  return getIngester(
    {
      inputName: constants.CLIENT_ORGANIZATION_TIERS_SOURCE,
      outputName: constants.ORGANIZATIONS,
      sourceHook: source,
      postProcessor
    }
  )()
})()
