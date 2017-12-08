import {unwind} from 'mongo-helpr'
import getIngester from '../framework/batch/ingester'
import {getAddressKeyArray} from '../framework/data/helper'
import constants from './shared/constants'
import {
  getLocationKeyArray,
  decorateWithOid
} from './shared/helper'
import upsertPostProcessor from './shared/upsert-post-processor'
import inactivePostIngestHook from './shared/inactive-post-ingest-hook'
import sourceHook from './shared/source-hook'

const addressKeyArray = getAddressKeyArray(
  {
    line1: '$Address_Street',
    city: '$Address_City',
    state: '$State_Abbreviation',
    zip: '$Address_Zip_Code'
  }
)

const orgKeyArray = decorateWithOid({oid: constants.CCN.oid, key: '$CCN'})

const locationKeyArray = getLocationKeyArray({orgKey: orgKeyArray, addressKey: addressKeyArray})

const id = {
  ...constants.CCN,
  extension: '$CCN'
}

export default getIngester(
  {
    inputName: constants.CMS_HOSPICE_AGENCY_SOURCE,
    outputName: constants.ORGANIZATION_LOCATIONS,
    sourceHook,
    steps: [
      {
        $addFields: {
          addressKey: {$concat: addressKeyArray},
          specialty: constants.HOSPICE_SPECIALTY
        }
      },
      {
        $lookup: {
          from: constants.GEO_ADDRESSES,
          localField: 'addressKey',
          foreignField: 'addressKey',
          as: 'geocoded'
        }
      },
      {
        $lookup: {
          from: 'specialties',
          localField: 'specialty',
          foreignField: 'code',
          as: 'taxonomy'
        }
      },
      unwind('$geocoded'),
      unwind('$taxonomy'),
      {
        $project: {
          _id: {$concat: locationKeyArray},
          address: {
            line1: '$Address_Street',
            city: '$Address_City',
            state: '$State_Abbreviation',
            zip: '$Address_Zip_Code'
          },
          geoPoint: '$geocoded.geoPoint',
          organization: {
            _id: {$concat: orgKeyArray},
            id,
            name: '$Facility_Name',
            identifiers: [id]
          },
          specialties: [
            {
              code: '$taxonomy.code',
              grouping: '$taxonomy.grouping',
              classification: '$taxonomy.classification',
              specialization: '$taxonomy.specialization',
              system: '$taxonomy.system',
              isPrimary: true
            }
          ],
          phone: '$Telephone_Number'
        }
      }
    ],
    postProcessor: upsertPostProcessor(),
    postIngestHook: inactivePostIngestHook(
      {
        query: {
          'organization.id.oid': constants.CCN.oid,
          'specialties.code': constants.HOSPICE_SPECIALTY
        }
      }
    )
  }
)()
