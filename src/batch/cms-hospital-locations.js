import {unwind} from 'mongo-helpr'
import getIngester from '../framework/batch/ingester'
import {getAddressKeyArray} from '../framework/data/helper'
import constants from './shared/constants'
import {
  getLocationKeyArray,
  decorateWithOid,
  getRating
} from './shared/helper'
import upsertPostProcessor from './shared/upsert-post-processor'
import inactivePostIngestHook from './shared/inactive-post-ingest-hook'
import sourceHook from './shared/source-hook'

const addressKeyArray = getAddressKeyArray(
  {
    line1: '$Address',
    city: '$City',
    state: '$State',
    zip: '$ZIP_Code'
  }
)

// Refer here for Oid info https://www.cms.gov/Regulations-and-Guidance/Guidance/Transmittals/downloads/R29SOMA.pdf
const id = {
  ...constants.CCN,
  extension: '$Provider_ID'
}

const orgKeyArray = decorateWithOid({oid: constants.CCN.oid, key: '$Provider_ID'})

const locationKeyArray = getLocationKeyArray({orgKey: orgKeyArray, addressKey: addressKeyArray})

const measures = {
  overall: {
    _id: 'cms:hpl:overall',
    name: 'Overall Rating',
    scale: 5
  }
}

export default getIngester(
  {
    inputName: constants.CMS_HOSPITAL_SOURCE,
    outputName: constants.ORGANIZATION_LOCATIONS,
    sourceHook,
    steps: [
      {
        $addFields: {
          addressKey: {$concat: addressKeyArray},
          specialty: constants.HOSPITAL_SPECIALTY
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
            line1: '$Address',
            city: '$City',
            state: '$State',
            zip: '$ZIP_Code'
          },
          geoPoint: '$geocoded.geoPoint',
          organization: {
            _id: {$concat: orgKeyArray},
            id,
            name: '$Hospital_Name',
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
          phone: '$Phone_Number',
          ratings: [
            getRating({measure: measures.overall, score: '$Hospital_overall_rating'})
          ]
        }
      }
    ],
    postProcessor: upsertPostProcessor(),
    postIngestHook: inactivePostIngestHook(
      {
        query: {
          'organization.id.oid': constants.CCN.oid,
          'specialties.code': constants.HOSPITAL_SPECIALTY
        }
      }
    )
  }
)()
