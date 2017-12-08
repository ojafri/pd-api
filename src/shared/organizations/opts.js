import updateEventHook from '../../framework/data/update-event-hook'
import constants from '../constants'
import queryHook from '../source-query-hook'
import identifiersDataHook from '../identifiers-data-hook'
import specialtiesDataHook from '../specialties-data-hook'
import createdDataHook from '../created-data-hook'
import changesPostUpdateHook from '../changes-post-update-hook'
import idHook from '../id-hook'
import isValid from './is-valid'

export default {
  collectionName: constants.ORGANIZATIONS,
  idHook,
  isValid,
  dataHook: [
    identifiersDataHook,
    specialtiesDataHook,
    createdDataHook()
  ],
  queryHook,
  postUpdateHook: changesPostUpdateHook(),
  updateEventHook: [
    updateEventHook(
      {
        target: constants.ORGANIZATION_LOCATIONS,
        path: 'organization',
        fields: ['name']
      }
    ),
    updateEventHook(
      {
        target: constants.PROVIDERS,
        path: 'organizationRefs.$.organization',
        fields: ['name']
      }
    ),
    updateEventHook(
      {
        target: constants.PROVIDER_LOCATIONS,
        path: 'location.organization',
        fields: ['name']
      }
    )
  ]
}
