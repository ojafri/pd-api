import getIngester from '../framework/batch/ingester'
import {getProviderOrganizationKeyArray, getSourceQuery} from './shared/helper'
import constants from './shared/constants'
import upsertPostProcessor from './shared/upsert-post-processor'
import inactivePostIngestHook from './shared/inactive-post-ingest-hook'
import sourceHook from './shared/source-hook'

const query = getSourceQuery()

export default getIngester(
  {
    inputName: constants.PROVIDER_LOCATIONS,
    outputName: constants.PROVIDERS,
    sourceHook,
    steps: [
      {
        $group: {
          _id: {
            practitioner: '$practitioner._id',
            organization: '$location.organization._id'
          },
          locations: {
            $push: {
              _id: '$location._id',
              address: '$location.address',
              geoPoint: '$location.geoPoint',
              phone: '$location.phone'
            }
          },
          doc: {$last: '$$ROOT'}
        }
      },
      {
        $group: {
          _id: '$doc.practitioner._id',
          organizationRefs: {
            $push: {
              _id: {
                $concat: getProviderOrganizationKeyArray(
                  {
                    providerKey: '$doc.practitioner._id',
                    organizationKey: '$doc.location.organization._id'
                  }
                )
              },
              organization: {
                _id: '$doc.location.organization._id',
                name: '$doc.location.organization.name',
                locations: '$locations'
              }
            }
          },
          doc: {$last: '$doc'}
        }
      },
      {
        $project: {
          _id: '$doc.practitioner._id',
          name: '$doc.practitioner.name',
          id: '$doc.practitioner.id',
          identifiers: '$doc.practitioner.identifiers',
          specialties: '$doc.practitioner.specialties',
          organizationRefs: 1
        }
      }
    ],
    query,
    postProcessor: upsertPostProcessor(),
    postIngestHook: inactivePostIngestHook({query})
  }
)()
