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
import isValid from './is-valid'

const tierRefHooks = getTierRefHooks({target: 'organization'})

const {createHook, updateHook, deleteHook} = getEmbedHooks(
  {
    contextPath: [
      {key: 'organization._id', path: '_id', isGuid: true},
      {useId: true, path: 'tierRefs._id', isGuid: true}
    ],
    isAssociative: true
  }
)

export default {
  name: constants.ORGANIZATION_TIERS,
  collectionName: constants.ORGANIZATIONS,
  queryHook: [
    tierQueryHook,
    sourceQueryHook
  ],
  steps: [
    {$unwind: '$tierRefs'},
    {
      $project: {
        _id: '$tierRefs._id',
        organization: {
          _id: '$_id',
          id: '$id',
          identifiers: '$identifiers',
          name: '$name'
        },
        tier: '$tierRefs.tier',
        created: 1,
        updated: 1,
        isPrivate: 1
      }
    }
  ],
  useStepsForGet: true,
  idHook: tierRefHooks.id,
  dataHook: tierRefHooks.data,
  isValid,
  createHook,
  updateHook,
  deleteHook,
  postDeleteHook,
  createEventHook: [
    createEventHook(
      {
        target: constants.ORGANIZATION_LOCATIONS,
        path: 'tierRefs',
        filterHook: ({context}) => ({'organization._id': context['organization._id']})
      }
    )
  ],
  deleteEventHook: [
    pullEventHook({collectionName: constants.ORGANIZATION_LOCATIONS, field: 'tierRefs'})
  ],
  updateEventHook: [
    updateEventHook({target: constants.ORGANIZATION_LOCATIONS, path: 'tierRefs.$'})
  ],
  stepsHook: startsWithMatcherStepsHook(
    [
      {before: 'tier', after: 'tierRefs.tier'},
      {before: 'organization'},
      {after: 'tierRefs'}
    ]
  )
}
