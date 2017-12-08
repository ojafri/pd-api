import getEmbedHooks from '../../../../framework/data/mongo-embed-helper'
import {markedIdHook} from '../../../../framework/data/helper'
import updateEventHook from '../../../../framework/data/update-event-hook'
import constants from '../../../constants'
import createdDataHook from '../../../created-data-hook'
import changesPostUpdateHook from '../../../changes-post-update-hook'
import nptConstants from '../../constants'
import isValid from './is-valid'

const {networkPath, planPath, tierPath} = nptConstants

const {createHook, updateHook} = getEmbedHooks(
  {
    contextPath: [
      {key: 'clientId', path: '_id', isGuid: true},
      {key: 'networkId', path: `${networkPath}._id`, isGuid: true},
      {key: 'planId', path: `${planPath}._id`, isGuid: true}
    ]
  }
)

export default {
  name: constants.PLANS,
  collectionName: constants.CLIENTS,
  steps: [
    {
      $unwind: `$${networkPath}`
    },
    {
      $unwind: `$${planPath}`
    },
    {
      $project: {
        _id: `$${planPath}._id`,
        name: `$${planPath}.name`,
        description: `$${planPath}.description`,
        isInactive: `$${planPath}.isInactive`,
        // product: `$${planPath}.product`,
        [constants.TIERS]: `$${tierPath}`,
        network: {
          _id: `$${networkPath}._id`,
          name: `$${networkPath}.name`,
          client: {
            _id: '$_id',
            name: '$name'
          }
        },
        updated: `$${planPath}.updated`
      }
    }
  ],
  useStepsForGet: true,
  idHook: markedIdHook(`${planPath}._id`),
  isValid,
  createHook,
  updateHook,
  dataHook: createdDataHook({omitSource: true}),
  postUpdateHook: changesPostUpdateHook({omitSource: true}),
  updateEventHook: [
    updateEventHook({target: constants.PROVIDERS, path: 'organizationRefs.$.tierRefs.$.tier.plan'}),
    updateEventHook({target: constants.ORGANIZATIONS, path: 'tierRefs.$.tier.plan'}),
    updateEventHook({target: constants.PROVIDER_LOCATIONS, path: 'tierRefs.$.tier.plan'}),
    updateEventHook({target: constants.ORGANIZATION_LOCATIONS, path: 'tierRefs.$.tier.plan'})
  ]
}
