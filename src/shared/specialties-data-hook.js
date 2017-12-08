import _ from 'lodash'
import debug from 'debug'
import getData from '../framework/data/data'
import specialtyOpts from '../shared/specialties/opts'

const dbg = debug('app:shared:specialties-data-hook')

const specialtyData = getData(specialtyOpts)

const specialtyCodesKey = 'specialtyCodes'

export default async function ({data, context, mode}) {
  dbg('data=%o, context=%o, mode=%o', data, context, mode)

  const specialtyCodes = data[specialtyCodesKey]

  if (specialtyCodes) {
    const specialties = await Promise.all(
      specialtyCodes.map(
        code => specialtyData.get({code})
      )
    )

    dbg('specialties=%o', specialties)

    specialties[0].isPrimary = true

    return {
      ..._.omit(data, specialtyCodesKey),
      specialties
    }
  }

  return data
}
