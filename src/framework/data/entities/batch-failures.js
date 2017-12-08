import getEmbedHooks from '../mongo-embed-helper'
import {mongoIdHook} from '../helper'
import constants from '../constants'

const {createHook} = getEmbedHooks(
  {
    contextPath: [
      {key: 'batchId', path: '_id', isGuid: true},
      {key: 'failureId', path: 'failures._id', isGuid: true}
    ]
  }
)

export default {
  name: constants.BATCH_FAILURES,
  collectionName: constants.BATCHES,
  steps: [
    {$unwind: '$failures'},
    {
      $project: {
        _id: '$failures._id',
        record: '$failures.record',
        error: '$failures.error',
        batch: {
          _id: '$_id'
        }
      }
    }
  ],
  useStepsForGet: true,
  idHook: mongoIdHook,
  createHook
}
