import assert from 'assert'
import {getClientId} from './helper'
//
// remove all but specified clients tiers
//
export default function ({query, context}) {
  const clientId = getClientId({query, context})
  assert(clientId, 'clientId required')
  query['tier.plan.network.client._id'] = clientId
  return query
}
