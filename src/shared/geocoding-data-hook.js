import assert from 'assert'
import debug from 'debug'
import _ from 'lodash'
import {stringify, join} from 'helpr'
import geocoder from '../framework/data/caching-geocoder'

const dbg = debug('app:shared:geocoding-data-hook')

export default function ({addressPath} = {}) {
  dbg('address-path=%o', addressPath)
  return async function ({data, context, mode}) {
    dbg('data=%o, context=%o, mode=%o', stringify(data), context, mode)

    const _addressPath = join([addressPath, 'address'])
    const {line1, city, state, zip} = _.get(data, _addressPath, {})

    if (line1 || city || state || zip) {
      assert(line1 && city && state && zip, 'primary address fields required')

      const coordinates = await geocoder({street: line1, city, state, zip})
      assert(coordinates, `unable to obtain coordinates for address=${_addressPath}`)

      const geoPoint = {type: 'Point', coordinates}

      return _.set({...data}, join([addressPath, 'geoPoint']), geoPoint)
    }

    return data
  }
}
