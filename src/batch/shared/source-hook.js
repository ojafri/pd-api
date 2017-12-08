import {getArg} from 'helpr'
import {requireOne} from 'mongo-helpr'
import constants from './constants'

export default async function () {
  const sourceId = getArg('sourceId')

  if (sourceId) {
    const record = await requireOne(
      {
        collectionName: constants.CLIENTS,
        query: {_id: sourceId}
      }
    )
    return {
      _id: record._id,
      name: record.name
    }
  }

  return constants.CMS
}
