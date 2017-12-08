import assert from 'assert'
import debug from 'debug'
import _ from 'lodash'
import {combine, getArg, getRequiredArg} from 'helpr'
import getData from '../framework/data/data'
import {onlyScanned} from '../framework/data/helper'
import getIngester from '../framework/batch/ingester'
import clientOpts from '../shared/clients/opts'
import networkOpts from '../shared/clients/networks/opts'
import planOpts from '../shared/clients/networks/plans/opts'
import tierOpts from '../shared/clients/networks/plans/tiers/opts'
import constants from './shared/constants'
import {getId} from './shared/helper'

const dbg = debug('app:batch:clients')

const clientId = getRequiredArg('clientId')
const isUpsertClient = getArg('isUpsertClient')
const clientName = getArg('clientName')

const clientData = getData({...clientOpts})
const networkData = getData({...networkOpts})
const planData = getData({...planOpts})
const tierData = getData({...tierOpts})

function add(a, b) {
  return a + b
}

export default (async function () {
  const client = await clientData.get(clientId.toString())
  if (!client) {
    if (isUpsertClient && clientName) {
      const result = await clientData.upsert({id: clientId, data: {name: clientName}})
      assert(result.result.ok, 'ok result required')
    } else {
      throw new Error('client does not exist, try with isUpsertClient=true and clientName')
    }
  }
  const source = {_id: clientId, name: _.get(client, 'name') || clientName}
  dbg('source=%j', source)

  async function postProcessor({record, date}) {
    dbg('post-ingest-hook: record=%o, date=%o', record, date)
    let _result = {upsertedCount: 0, modifiedCount: 0, matchedCount: 0, scannedCount: 0}

    const {
      networkId,
      networkName,
      networkDesc,
      isNetworkInactive,
      planId,
      planName,
      planDesc,
      isPlanInactive,
      tierId,
      tierName,
      isTierInactive,
      tierBenefits,
      tierRank,
      isTierInNetwork
    } = record

    assert(networkId, 'networkId required')

    const _networkId = getId({id: networkId, clientId})

    const result = await networkData.upsert(
      {
        id: _networkId,
        data: {
          name: networkName,
          ...(networkDesc && {description: networkDesc}),
          ...(_.isBoolean(isNetworkInactive) && {isInactive: isNetworkInactive})
        },
        context: {source, clientId, networkId: _networkId}
      }
    )

    if (onlyScanned(result)) {
      result.scannedCount = 1
    }
    _result = combine({target: _result, source: result, operator: add})
    dbg('network: result=%o', _result)

    if (planId) {
      const _planId = getId({id: planId, clientId})

      const result = await planData.upsert(
        {
          id: _planId,
          data: {
            name: planName,
            ...(planDesc && {description: planDesc}),
            ...(_.isBoolean(isPlanInactive) && {isInactive: isPlanInactive})
          },
          context: {source, clientId, networkId: _networkId, planId: _planId}
        }
      )

      if (onlyScanned(result)) {
        result.scannedCount = 1
      }
      _result = combine({target: _result, source: result, operator: add})
      dbg('plan: result=%o', _result)

      if (tierId) {
        const _tierId = getId({id: tierId, clientId})

        const result = await tierData.upsert(
          {
            id: _tierId,
            data: {
              name: tierName,
              ...(_.isBoolean(isTierInactive) && {isInactive: isTierInactive}),
              ...(tierBenefits && {benefits: tierBenefits}),
              rank: tierRank,
              isInNetwork: isTierInNetwork
            },
            context: {source, clientId, networkId: _networkId, planId: _planId, tierId: _tierId}
          }
        )

        if (onlyScanned(result)) {
          result.scannedCount = 1
        }
        _result = combine({target: _result, source: result, operator: add})
        dbg('tier: result=%o', _result)
      }
    }
    return _result
  }

  return getIngester(
    {
      inputName: constants.CLIENTS_SOURCE,
      outputName: constants.CLIENTS,
      sourceHook: source,
      postProcessor
    }
  )()
})()
