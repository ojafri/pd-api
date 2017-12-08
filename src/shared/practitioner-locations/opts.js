import constants from '../constants'
import sourceQueryHook from '../source-query-hook'
import tierUnwindingHooks from '../tier-unwinding-hooks'
import createdDataHook from '../created-data-hook'
import changesPostUpdateHook from '../changes-post-update-hook'
import {addToOrganizations, addToOrganizationLocations} from './create-event-hook'
import isValid from './is-valid'
import dataHook from './data-hook'
import idHook from './id-hook'

export default {
  collectionName: constants.PROVIDER_LOCATIONS,
  distanceField: 'location.distance',
  queryHook: [
    sourceQueryHook,
    tierUnwindingHooks.queryHook
  ],
  postStepsHook: tierUnwindingHooks.postStepsHook,
  isValid,
  idHook,
  dataHook: [
    dataHook,
    createdDataHook()
  ],
  postUpdateHook: changesPostUpdateHook(),
  createEventHook: [
    addToOrganizations,
    addToOrganizationLocations
  ]
}
