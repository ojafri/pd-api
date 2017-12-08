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
    line1: '$ADDRESS',
    city: '$CITY',
    state: '$STATE',
    zip: '$ZIP'
  }
)

const orgKeyArray = decorateWithOid({oid: constants.CCN.oid, key: '$provnum'})

const locationKeyArray = getLocationKeyArray({orgKey: orgKeyArray, addressKey: addressKeyArray})

const id = {
  ...constants.CCN,
  extension: '$provnum'
}

const measures = {
  overall: {
    _id: 'cms:nh:overall',
    name: 'Overall Rating',
    scale: 5
  },
  survey: {
    _id: 'cms:nh:survey',
    name: 'Survey Rating',
    scale: 5
  },
  quality: {
    _id: 'cms:nh:qualtiy',
    name: 'QM Rating',
    scale: 5
  },
  staffing: {
    _id: 'cms:nh:staffing',
    name: 'Staffing Rating',
    scale: 5
  },
  rnStaffing: {
    _id: 'cms:nh:rn_staffing',
    name: 'RN Staffing Rating',
    scale: 5
  }
}

export default getIngester(
  {
    inputName: constants.CMS_NURSING_HOME_SOURCE,
    outputName: constants.ORGANIZATION_LOCATIONS,
    sourceHook,
    steps: [
      {
        $addFields: {
          addressKey: {$concat: addressKeyArray},
          specialty: constants.NURSING_HOME_SPECIALTY
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
            line1: '$ADDRESS',
            city: '$CITY',
            state: '$STATE',
            zip: '$ZIP'
          },
          geoPoint: '$geocoded.geoPoint',
          organization: {
            _id: {$concat: orgKeyArray},
            id,
            name: '$PROVNAME',
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
          phone: '$PHONE',
          ratings: [
            getRating({measure: measures.overall, score: '$overall_rating'}),
            getRating({measure: measures.survey, score: '$survey_rating'}),
            getRating({measure: measures.quality, score: '$quality_rating'}),
            getRating({measure: measures.staffing, score: '$staffing_rating'}),
            getRating({measure: measures.rnStaffing, score: '$RN_staffing_rating'})
          ]
        }
      }
    ],
    postProcessor: upsertPostProcessor(),
    postIngestHook: inactivePostIngestHook(
      {
        query: {
          'organization.id.oid': constants.CCN.oid,
          'specialties.code': constants.NURSING_HOME_SPECIALTY
        }
      }
    )
  }
)()
