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
    inputName: constants.ORGANIZATION_LOCATIONS,
    outputName: constants.ORGANIZATIONS,
    sourceHook,
    steps: [
      unwind('$specialties'),
      unwind('$practitioners'),
      {
        $group: {
          _id: '$organization._id',
          practitioners: {$addToSet: '$practitioners'},
          specialties: {$addToSet: '$specialties'},
          locations: {
            $addToSet: {
              _id: '$_id',
              address: '$address',
              geoPoint: '$geoPoint',
              phone: '$phone',
              ratings: '$ratings'
            }
          },
          doc: {$last: '$$ROOT'}
        }
      },
      {
        $project: {
          _id: 1,
          name: '$doc.organization.name',
          id: '$doc.organization.id',
          identifiers: '$doc.organization.identifiers',
          practitioners: 1,
          specialties: 1,
          locations: 1
        }
      }
    ],
    query,
    postProcessor: upsertPostProcessor(),
    postIngestHook: inactivePostIngestHook(
      {
        query: {
          ...query,
          'id.oid': {$ne: constants.CCN.oid}
        }
      }
    )
  }
)()
