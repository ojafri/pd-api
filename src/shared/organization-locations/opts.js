import updateEventHook from '../../framework/data/update-event-hook'
import createEventHook from '../../framework/data/create-event-hook'
import constants from '../constants'
import sourceQueryHook from '../source-query-hook'
import tierUnwindingHooks from '../tier-unwinding-hooks'
import geocodingDataHook from '../geocoding-data-hook'
import createdDataHook from '../created-data-hook'
import changesPostUpdateHook from '../changes-post-update-hook'
import isValid from './is-valid'
import dataHook from './data-hook'
import idHook from './id-hook'

export default {
  collectionName: constants.ORGANIZATION_LOCATIONS,
  queryHook: [
    sourceQueryHook,
    tierUnwindingHooks.queryHook
  ],
  postStepsHook: tierUnwindingHooks.postStepsHook,
  dataHook: [
    dataHook,
    geocodingDataHook(),
    createdDataHook()
  ],
  isValid,
  idHook,
  postUpdateHook: changesPostUpdateHook(),
  createEventHook: [
    createEventHook(
      {
        target: constants.PROVIDERS,
        path: 'organizationRefs.$.organization.locations',
        fields: ['address', 'geoPoint', 'phone'],
        filterHook: createFilterHook
      }
    ),
    createEventHook(
      {
        target: constants.ORGANIZATIONS,
        path: 'locations',
        fields: ['address', 'geoPoint', 'phone'],
        filterHook: createFilterHook
      }
    )
  ],
  updateEventHook: [
    updateEventHook(
      {
        target: constants.ORGANIZATIONS,
        path: 'locations.$',
        fields: ['address', 'geoPoint', 'phone']
      }
    ),
    updateEventHook(
      {
        target: constants.PROVIDERS,
        path: 'organizationRefs.$.organization.locations.$',
        fields: ['address', 'geoPoint', 'phone']
      }
    ),
    updateEventHook(
      {
        target: constants.PROVIDER_LOCATIONS,
        path: 'location',
        fields: ['address', 'geoPoint', 'phone']
      }
    )
  ]
}

function createFilterHook({defaultFilterIdPath, data}) {
  return {[defaultFilterIdPath]: data.organization._id}
}
