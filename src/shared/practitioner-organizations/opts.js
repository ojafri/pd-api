import constants from '../constants'
import {startsWithMatcherStepsHook} from '../../framework/data/helper'
import sourceQueryHook from '../source-query-hook'

const providerKey = 'practitioner'
const organizationKey = 'organization'
const organizationRefsKey = 'organizationRefs'
const tierRefsKey = 'tierRefs'

export default {
  name: constants.PROVIDER_ORGANIZATIONS,
  collectionName: constants.PROVIDERS,
  queryHook: sourceQueryHook,
  steps: [
    {$unwind: `$${organizationRefsKey}`},
    {
      $project: {
        _id: `$${organizationRefsKey}._id`,
        [providerKey]: {
          _id: '$_id',
          id: '$id',
          name: '$name',
          identifiers: '$identifiers',
          specialties: '$specialties'
        },
        [organizationKey]: `$${organizationRefsKey}.${organizationKey}`,
        [tierRefsKey]: `$${organizationRefsKey}.${tierRefsKey}`,
        updated: 1,
        created: 1,
        isPrivate: 1
      }
    }
  ],
  useStepsForGet: true,
  stepsHook: startsWithMatcherStepsHook(
    [
      {before: providerKey},
      {before: organizationKey, after: `${organizationRefsKey}.${organizationKey}`},
      {before: tierRefsKey, after: `${organizationRefsKey}.${tierRefsKey}`},
      {after: organizationRefsKey}
    ]
  )
}
