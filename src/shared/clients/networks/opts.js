import getEmbedHooks from '../../../framework/data/mongo-embed-helper'
import {markedIdHook} from '../../../framework/data/helper'
import updateEventHook from '../../../framework/data/update-event-hook'
import constants from '../../constants'
import createdDataHook from '../../created-data-hook'
import changesPostUpdateHook from '../../changes-post-update-hook'
import nptConstants from '../constants'
import isValid from './is-valid'

const {networkPath, planPath} = nptConstants

const {createHook, updateHook} = getEmbedHooks(
  {
    contextPath: [
      {key: 'clientId', path: '_id', isGuid: true},
      {key: 'networkId', path: `${networkPath}._id`, isGuid: true}
    ]
  }
)

export default {
  name: constants.NETWORKS,
  collectionName: constants.CLIENTS,
  steps: [
    {
      $unwind: `$${networkPath}`
    },
    {
      $project: {
        _id: `$${networkPath}._id`,
        name: `$${networkPath}.name`,
        description: `$${networkPath}.description`,
        isInactive: `$${networkPath}.isInactive`,
        client: {
          _id: '$_id',
          name: '$name'
        },
        // products: '$networks.products',
        [constants.PLANS]: `$${planPath}`,
        updated: `$${networkPath}.updated`
      }
    }
  ],
  useStepsForGet: true,
  idHook: markedIdHook(`${networkPath}._id`),
  isValid,
  dataHook: createdDataHook({omitSource: true}),
  postUpdateHook: changesPostUpdateHook({omitSource: true}),
  createHook,
  updateHook,
  updateEventHook: [
    updateEventHook({target: constants.ORGANIZATIONS, path: 'tierRefs.$.tier.plan.network'}),
    updateEventHook({target: constants.ORGANIZATION_LOCATIONS, path: 'tierRefs.$.tier.plan.network'}),
    updateEventHook({target: constants.PROVIDER_LOCATIONS, path: 'tierRefs.$.tier.plan.network'}),
    updateEventHook({target: constants.PROVIDERS, path: 'organizationRefs.$.tierRefs.$.tier.plan.network'})
  ]
}
