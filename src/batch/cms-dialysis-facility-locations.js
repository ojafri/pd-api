import {unwind} from 'mongo-helpr'
import getIngester from '../framework/batch/ingester'
import {getAddressKeyArray} from '../framework/data/helper'
import constants from './shared/constants'
import {
  getLocationKeyArray,
  decorateWithOid,
  getRating,
  transformField,
  ratingsCleaner
} from './shared/helper'
import upsertPostProcessor from './shared/upsert-post-processor'
import inactivePostIngestHook from './shared/inactive-post-ingest-hook'
import sourceHook from './shared/source-hook'

const addressKeyArray = getAddressKeyArray(
  {
    line1: '$Address_line_1',
    city: '$City',
    state: '$STATE',
    zip: '$Zip'
  }
)

const orgKeyArray = decorateWithOid({oid: constants.CCN.oid, key: '$Provider_number'})

const locationKeyArray = getLocationKeyArray({orgKey: orgKeyArray, addressKey: addressKeyArray})

const id = {
  ...constants.CCN,
  extension: '$Provider_number'
}

const measures = {
  fiveStar: {
    _id: 'cms:df:fiveStar',
    name: 'Five Star Rating',
    scale: 5
  }
}

export default getIngester(
  {
    debugName: 'cms-dialysis-facility-locations',
    inputName: constants.CMS_DIALYSIS_FACILITY_SOURCE,
    outputName: constants.ORGANIZATION_LOCATIONS,
    sourceHook,
    steps: [
      {
        $addFields: {
          addressKey: {$concat: addressKeyArray},
          specialty: constants.DIALYSIS_FACILITY_SPECIALTY,
          fromDate: {$substr: ['$Five_star_date', 0, 10]},
          toDate: {$substr: ['$Five_star_date', 11, 10]}
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
          from: constants.SPECIALTIES,
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
            line1: '$Address_line_1',
            city: '$City',
            state: '$STATE',
            zip: '$Zip'
          },
          geoPoint: '$geocoded.geoPoint',
          organization: {
            _id: {$concat: orgKeyArray},
            id,
            name: '$Facility_name',
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
          phone: '$Phone_number',
          ratings: [
            {
              $switch: {
                branches: [
                  {
                    case: {$eq: ['$Five_star_data_availability_code', '001']},
                    then: getRating({measure: measures.fiveStar, score: '$Five_star', fromDate: '$fromDate', toDate: '$toDate'})
                  }
                ],
                default: null
              }
            }
          ]
        }
      }
    ],
    postProcessor: upsertPostProcessor({
      recordHook: record => {
        return transformField(
          {
            target: record,
            field: 'ratings',
            transformer: ratingsCleaner
          }
        )
      }
    }),
    postIngestHook: inactivePostIngestHook(
      {
        query: {
          'organization.id.oid': constants.CCN.oid,
          'specialties.code': constants.DIALYSIS_FACILITY_SPECIALTY
        }
      }
    )
  }
)()
