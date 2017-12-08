import _ from 'lodash'
import {pushOrs} from 'mongo-helpr'
import {getClientId} from './helper'
import constants from './constants'

export default async function ({query, context}) {
  const clientId = await getClientId({query, context})

  // important: if source._id is not set, only return public data
  if (clientId) {
    if (query[constants.ONLY_CLIENT_CREATED]) {
      query['created.source._id'] = clientId
    } else {
      query = pushOrs({query, ors: [{isPrivate: {$ne: true}}, {'created.source._id': clientId}]})
    }
  } else {
    query.isPrivate = {$ne: true}
  }
  // pull these as mongo doesn't know about them
  return _.omit(query, [constants.ONLY_CLIENT_CREATED, constants.QUERY_CLIENT_ID])
}
