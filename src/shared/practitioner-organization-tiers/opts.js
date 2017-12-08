import createEventHook from '../../framework/data/create-event-hook'
import updateEventHook from '../../framework/data/update-event-hook'
import pullEventHook from '../../framework/data/pull-event-hook'
import getEmbedHooks from '../../framework/data/mongo-embed-helper'
import {startsWithMatcherStepsHook} from '../../framework/data/helper'
import sourceQueryHook from '../source-query-hook'
import tierQueryHook from '../tier-query-hook'
import getTierRefHooks from '../tier-ref-hooks'
import constants from '../constants'
import postDeleteHook from '../post-delete-hook'
import providerLocationsFilterHook from './provider-locations-filter-hook'

const providerOrgKey = 'practitionerOrganization'
const providerKey = 'practitioner'
const orgKey = 'organization'
const orgRefsKey = 'organizationRefs'
const tierRefsKey = 'tierRefs'
const tierKey = 'tier'

export const PROVIDER_ORGANIZATION = 'practitionerOrganization'

const tierRefHooks = getTierRefHooks({target: PROVIDER_ORGANIZATION})
const {createHook, updateHook, deleteHook} = getEmbedHooks(
  {
    contextPath: [
      {key: `${PROVIDER_ORGANIZATION}._id`, path: `${orgRefsKey}._id`, isGuid: true},
      {useId: true, path: `${orgRefsKey}.${tierRefsKey}._id`, isGuid: true}
    ],
    isAssociative: true
  }
)

export default {
  name: constants.PROVIDER_ORGANIZATION_TIERS,
  collectionName: constants.PROVIDERS,
  queryHook: [
    tierQueryHook,
    sourceQueryHook
  ],
  steps: [
    {$unwind: `$${orgRefsKey}`},
    {$unwind: `$${orgRefsKey}.${tierRefsKey}`},
    {
      $project: {
        _id: `$${orgRefsKey}.${tierRefsKey}._id`,
        [providerOrgKey]: {
          _id: `$${orgRefsKey}._id`,
          [providerKey]: {
            _id: '$_id',
            id: '$id',
            name: '$name',
            identifiers: '$identifiers',
            specialties: '$specialties'
          },
          [orgKey]: `$${orgRefsKey}.${orgKey}`
        },
        [tierKey]: `$${orgRefsKey}.${tierRefsKey}.${tierKey}`,
        updated: '$updated',
        source: '$source'
      }
    }
  ],
  useStepsForGet: true,
  stepsHook: startsWithMatcherStepsHook(
    [
      {before: `${providerOrgKey}.${providerKey}`},
      {before: `${providerOrgKey}.${orgKey}`, after: `${orgRefsKey}.${orgKey}`},
      {before: providerOrgKey, after: orgRefsKey},
      {before: tierKey, after: `${orgRefsKey}.${tierRefsKey}.${tierKey}`},
      {after: `${orgRefsKey}.${tierRefsKey}`}
    ]
  ),
  idHook: tierRefHooks.id,
  dataHook: tierRefHooks.data,
  createHook,
  updateHook,
  deleteHook,
  postDeleteHook,
  createEventHook: [
    createEventHook(
      {
        target: constants.PROVIDER_LOCATIONS,
        path: 'tierRefs',
        filterHook: providerLocationsFilterHook
      }
    )
  ],
  updateEventHook: [
    updateEventHook({target: constants.PROVIDER_LOCATIONS, path: 'tierRefs.$'})
  ],
  deleteEventHook: [
    pullEventHook({collectionName: constants.PROVIDER_LOCATIONS, field: 'tierRefs'})
  ]
}
