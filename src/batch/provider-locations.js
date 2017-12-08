// import debug from 'debug'
import {unwind, ifNull} from 'mongo-helpr'
import getIngester from '../framework/batch/ingester'
import {getAddressKeyArray} from '../framework/data/helper'
import {
  getLocationKeyArray,
  getProviderLocationKeyArray,
  decorateWithOid,
  getSourceQuery
} from './shared/helper'
import constants from './shared/constants'
import upsertPostProcessor from './shared/upsert-post-processor'
import inactivePostIngestHook from './shared/inactive-post-ingest-hook'
import sourceHook from './shared/source-hook'

// const dbg = debug('app:provider-locations')

const query = getSourceQuery()

export default (async function () {
  const addressKey = getAddressKeyArray(
    {
      line1: '$doc.addressLine1',
      city: '$doc.city',
      state: '$doc.state',
      zip: '$doc.zip'
    }
  )
  const providerKey = decorateWithOid({oid: constants.NPI.oid, key: '$doc.npi'})
  const orgKey = decorateWithOid({oid: constants.PAC.oid, key: '$doc.groupPac'})
  const locationKey = getLocationKeyArray({orgKey, addressKey})
  const npiOrgLocationKey = getLocationKeyArray({orgKey: providerKey, addressKey})
  const providerLocationKey = getProviderLocationKeyArray({providerKey, locationKey})
  const npiOrgProviderLocationKey = getProviderLocationKeyArray({providerKey, locationKey: npiOrgLocationKey})

  const _orgKey = ifNull({test: '$doc.groupPac', is: {$concat: providerKey}, not: {$concat: orgKey}})
  const _locationKey = ifNull({test: '$doc.groupPac', is: {$concat: npiOrgLocationKey}, not: {$concat: locationKey}})
  const _providerLocationKey = ifNull({test: '$doc.groupPac', is: {$concat: npiOrgProviderLocationKey}, not: {$concat: providerLocationKey}})

  const providerId = {
    ...constants.NPI,
    extension: '$doc.npi'
  }

  const orgId = ifNull(
    {
      test: '$doc.groupPac',
      is: providerId,
      not: {
        ...constants.PAC,
        extension: '$doc.groupPac'
      }
    }
  )

  return getIngester(
    {
      inputName: constants.CMS_PROVIDER_SOURCE,
      outputName: constants.PROVIDER_LOCATIONS,
      sourceHook,
      steps: [
        {
          $lookup: {
            from: constants.NPI_PROVIDERS,
            localField: 'npi',
            foreignField: 'npi',
            as: 'provider'
          }
        },
        unwind('$provider'),
        unwind('$provider.specialties'),
        {
          $lookup: {
            from: constants.SPECIALTIES,
            localField: 'provider.specialties.code',
            foreignField: 'code',
            as: 'taxonomy'
          }
        },
        unwind('$taxonomy'),
        {
          $group: {
            _id: '$_id',
            doc: {$last: '$$ROOT'},
            specialties: {
              $push: {
                code: '$provider.specialties.code',
                classification: '$taxonomy.classification',
                specialization: '$taxonomy.specialization',
                system: '$taxonomy.system',
                isPrimary: '$provider.specialties.isPrimary'
              }
            }
          }
        },
        {$addFields: {addressKey: {$concat: addressKey}}},
        {
          $lookup: {
            from: constants.GEO_ADDRESSES,
            localField: 'addressKey',
            foreignField: 'addressKey',
            as: 'geocoded'
          }
        },
        unwind('$geocoded'),
        {
          $sort: {
            'doc.addressLine1': 1,
            'doc.city': 1,
            'doc.state': 1,
            'doc.zip': 1,
            'doc.addressLine2': 1
          }
        },
        {
          $group: {
            _id: {
              providerId,
              orgId,
              addressLine1: '$doc.addressLine1',
              city: '$doc.city',
              state: '$doc.state',
              zip: '$doc.zip'
            },
            doc: {$last: '$doc'},
            specialties: {$last: '$specialties'},
            geocoded: {$last: '$geocoded'}
          }
        },
        {
          $project: {
            _id: _providerLocationKey,
            practitioner: {
              _id: {$concat: providerKey},
              id: providerId,
              name: {
                first: '$doc.firstName',
                middle: '$doc.middleName',
                last: '$doc.lastName',
                suffix: '$doc.suffix'
              },
              specialties: '$specialties',
              identifiers: [providerId]
            },
            location: {
              _id: _locationKey,
              organization: {
                _id: _orgKey,
                id: orgId,
                name: {
                  $ifNull: [
                    '$doc.orgName',
                    {
                      $concat: [
                        '$doc.lastName',
                        ', ',
                        '$doc.firstName',
                        ifNull(
                          {
                            test: '$doc.middleName',
                            is: {$literal: ''},
                            not: {$concat: [' ', '$doc.middleName']}
                          }
                        )
                      ]
                    }
                  ]
                },
                identifiers: [orgId]
              },
              address: {
                line1: '$doc.addressLine1',
                line2: '$doc.addressLine2',
                city: '$doc.city',
                state: '$doc.state',
                zip: '$doc.zip'
              },
              geoPoint: '$geocoded.geoPoint',
              phone: '$doc.phone'
            }
          }
        }
      ],
      postProcessor: upsertPostProcessor(),
      postIngestHook: inactivePostIngestHook({query})
    }
  )()
})()
