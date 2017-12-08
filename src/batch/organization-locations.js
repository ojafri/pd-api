import {unwind} from 'mongo-helpr'
import getIngester from '../framework/batch/ingester'
import {getSourceQuery} from './shared/helper'
import constants from './shared/constants'
import upsertPostProcessor from './shared/upsert-post-processor'
import inactivePostIngestHook from './shared/inactive-post-ingest-hook'
import sourceHook from './shared/source-hook'

const query = getSourceQuery()

export default getIngester(
  {
    inputName: constants.PROVIDER_LOCATIONS,
    outputName: constants.ORGANIZATION_LOCATIONS,
    sourceHook,
    steps: [
      unwind('$practitioner.specialties'),
      {
        $group: {
          _id: '$location._id',
          practitioners: {
            $addToSet: {
              _id: '$practitioner._id',
              id: '$practitioner.id',
              name: '$practitioner.name'
            }
          },
          specialties: {$addToSet: '$practitioner.specialties'},
          doc: {$last: '$$ROOT'}
        }
      },
      {
        $project: {
          _id: 1,
          organization: '$doc.location.organization',
          address: '$doc.location.address',
          geoPoint: '$doc.location.geoPoint',
          phone: '$doc.location.phone',
          practitioners: 1,
          specialties: 1
        }
      }
    ],
    query,
    postProcessor: upsertPostProcessor(),
    postIngestHook: inactivePostIngestHook(
      {
        query: {
          ...query,
          'organization.id.oid': {$ne: constants.CCN.oid}
        }
      }
    )
  }
)()
