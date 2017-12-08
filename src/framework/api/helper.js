import debug from 'debug'
import {getDb} from 'mongo-helpr'
import constants from '../data/constants'

const dbg = debug('app:api:helper')

export async function getZipCoordinates(zip) {
  const db = await getDb()
  const result = await db.collection(constants.GEO_ZIPS).find({zip}).toArray()
  dbg('get-zip-coordinates: result=%o', result)
  if (result.length > 1) {
    throw new Error(`unexpected result count=[${result.length}] for zip=[${zip}]`)
  } else if (result.length === 0) {
    return null
  } else {
    return [result[0].longitude, result[0].latitude]
  }
}
