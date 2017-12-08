import getEmbedHooks from '../../../../../framework/data/mongo-embed-helper'
import {markedIdHook} from '../../../../../framework/data/helper'
import updateEventHook from '../../../../../framework/data/update-event-hook'
import constants from '../../../../constants'
import createdDataHook from '../../../../created-data-hook'
import changesPostUpdateHook from '../../../../changes-post-update-hook'
import nptConstants from '../../../constants'
import isValid from './is-valid'

const {networkPath, planPath, tierPath} = nptConstants

const {createHook, updateHook} = getEmbedHooks(
  {
    contextPath: [
      {key: 'clientId', path: '_id', isGuid: true},
      {key: 'networkId', path: `${networkPath}._id`, isGuid: true},
      {key: 'planId', path: `${planPath}._id`, isGuid: true},
      {key: 'tierId', path: `${tierPath}._id`, isGuid: true}
    ]
  }
)

export default {
  name: constants.TIERS,
  collectionName: constants.CLIENTS,
  steps: [
    {
      $unwind: `$${networkPath}`
    },
    {
      $unwind: `$${planPath}`
    },
    {
      $unwind: `$${tierPath}`
    },
    {
      $project: {
        _id: `$${tierPath}._id`,
        name: `$${tierPath}.name`,
        benefits: `$${tierPath}.benefits`,
        rank: `$${tierPath}.rank`,
        isInNetwork: `$${tierPath}.isInNetwork`,
        isInactive: `$${tierPath}.isInactive`,
        plan: {
          _id: `$${planPath}._id`,
          name: `$${planPath}.name`,
          // product: `$${planPath}.product`,
          network: {
            _id: `$${networkPath}._id`,
            name: `$${networkPath}.name`,
            client: {
              _id: '$_id',
              name: '$name'
            }
          }
        },
        updated: `$${tierPath}.updated`
      }
    }
  ],
  useStepsForGet: true,
  idHook: markedIdHook(`${tierPath}._id`),
  isValid,
  createHook,
  updateHook,
  dataHook: createdDataHook({omitSource: true}),
  postUpdateHook: changesPostUpdateHook({omitSource: true}),
  updateEventHook: [
    updateEventHook({target: constants.ORGANIZATIONS, path: 'tierRefs.$.tier'}),
    updateEventHook({target: constants.PROVIDER_LOCATIONS, path: 'tierRefs.$.tier'}),
    updateEventHook({target: constants.ORGANIZATION_LOCATIONS, path: 'tierRefs.$.tier'}),
    updateEventHook({target: constants.PROVIDERS, path: 'organizationRefs.$.tierRefs.$.tier'})
  ]
}
