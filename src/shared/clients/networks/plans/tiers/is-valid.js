import assert from 'assert'
import joi from 'joi'
import {assertNone} from 'mongo-helpr'
import {joiValidator} from '../../../../../framework/data/validation-helper'
import {isCreate} from '../../../../../framework/data/helper'
import {
  name,
  benefits,
  rank,
  isInNetwork,
  isInactive
} from '../../../../validators'

const validate = joiValidator(
  {
    schema: joi.object(
      {
        name,
        benefits,
        rank,
        isInNetwork,
        isInactive
      }
    ),
    createModifier: schema => schema.requiredKeys(
      'name',
      'rank',
      'isInNetwork'
    )
  }
)

/*
{
  _id: 'c1',
  networks: [
    {
      _id: 'c1:n1',
      plans: [
        {
          _id: 'c1:n1:p1',
          tiers: [
            {
              _id: 'c1:n1:p1:t1',
              rank: 1
            },
            {
              _id: 'c1:n1:p1:t2',
              rank: 1 <-- invalid
            }
          ]
        }
      ]
    }
  ]
}
*/

export default async function ({collectionName, steps, data, context, mode}) {
  validate({mode, data})
  const query = {
    $or: [{'plan._id': context.planId, name: data.name}]
  }

  // relax rank uniqueness for updates to facilitate swizzling by client...
  //
  if (isCreate(mode)) {
    query.$or.push({'plan._id': context.planId, rank: data.rank})
  } else {
    // update...
    assert(context.tierId, 'tier id required')
    query._id = {$ne: context.tierId}
  }
  return assertNone({collectionName, steps, query})
}
