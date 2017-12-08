import assert from 'assert'
import debug from 'debug'
import _ from 'lodash'
import {requireOne} from 'mongo-helpr'
import {stringify, getKey} from 'helpr'
import constants from '../shared/constants'

const dbg = debug('app:shared:tier-ref-hooks')

export default function ({target}) {
  async function dataHook({data, db, context, mode, opts}) {
    dbg('data-hook: target=%o, data=%o, context=%o', target, stringify(data), context)

    if (mode === constants.MODES.update && !opts.isUpsert) {
      dbg('data-hook: strict update, returning original data')
      return data
    }

    const tierId = context['tier._id']
    assert(tierId, 'context.tierId required')

    const client = await requireOne(
      {db, query: {'networks.plans.tiers._id': tierId}, collectionName: constants.CLIENTS}
    )
    dbg('client=%o', stringify(client))
    let tier
    let plan
    const network = _.find(
      client.networks,
      _network => {
        return plan = _.find( // eslint-disable-line no-return-assign
          _network.plans,
          _plan => {
            return tier = _.find( // eslint-disable-line no-return-assign
              _plan.tiers,
              _tier => {
                return _tier._id === tierId
              }
            )
          }
        )
      }
    )

    assert(plan, `unable to locate plan for tier.id=${tierId} in client.id=${client.id}`)
    assert(network, `unable to locate network for plan.id=${plan.id} in client.id=${client.id}`)

    const _data = {
      ...data,
      tier: {
        ...tier,
        plan: {
          ..._.omit(plan, 'tiers'),
          // product: _.get(plan, 'product.name'),
          network: {
            ..._.omit(network, 'plans'),
            client: {
              ..._.omit(client, 'networks')
            }
          }
        }
      }
    }

    return _data
  }

  async function idHook({context}) {
    dbg('id-hook: target=%o, context=%o', target, context)
    const tierId = context['tier._id']
    assert(tierId, 'context[tier._id] required')

    const targetId = context[`${target}._id`]
    assert(targetId, `context[${target}._id] required`)

    return getKey(targetId, tierId)
  }

  return {
    id: idHook,
    data: dataHook
  }
}
