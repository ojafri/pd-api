import assert from 'assert'
import debug from 'debug'
import {findOne, getDb} from 'mongo-helpr'
import geocode, {geocodio} from 'geocodr'
import constants from './constants'
import {getAddressKey} from './helper'

const dbg = debug('app:shared:caching-geocoder')

export default async function ({street, city, state, zip}) {
  dbg('street=%o, city=%o, state=%o, zip=%o', street, city, state, zip)

  const addressKey = getAddressKey({street, city, state, zip})

  const address = await findOne({query: {addressKey}, collectionName: constants.GEO_ADDRESSES})

  if (address) {
    dbg('cache hit for address=%o', arguments[0])
    return address.geoPoint.coordinates
  }

  const coordinates = await geocode(`${street}, ${city}, ${state} ${zip}`, geocodio)

  if (coordinates) {
    dbg('obtained coordinates=%o for address=%o, saving back to cache', coordinates, arguments[0])
    const db = await getDb()
    const result = await db.collection(constants.GEO_ADDRESSES).insertOne(
      {
        geoPoint: {
          type: 'Point',
          coordinates,
          addressLine1: street,
          city,
          state,
          zip
        },
        addressKey
      }
    )
    assert(result.result.ok, 'ok result required')
  } else {
    dbg('unable to obtain coordinates for address=%o', arguments[0])
  }

  return coordinates
}
