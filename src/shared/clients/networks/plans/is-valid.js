import assert from 'assert'
import joi from 'joi'
import {assertNone} from 'mongo-helpr'
import {joiValidator} from '../../../../framework/data/validation-helper'
import {isUpdate, isUpsert} from '../../../../framework/data/helper'
import {
  name,
  description,
  isInactive
} from '../../../validators'

const validate = joiValidator(
  {
    schema: joi.object(
      {
        name,
        description,
        isInactive
      }
    ),
    createModifier: schema => schema.requiredKeys(
      'name'
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
          name: 'peaOne'
        },
        {
          _id: 'c1:n1:p2',
          name: 'peaOne' <-- invalid
        }
      ]
    },
    {
      _id: 'c1:n2',
      plans: [
        {
          _id: 'c1:n2:p1',
          name: 'peaOne' <-- ok
        }
      ]
    }
  ]
}
*/

export default async function ({collectionName, steps, data, context, mode}) {
  validate({mode, data})
  assert(context.networkId, 'network id required')
  const query = {'network._id': context.networkId, name: data.name}
  if (isUpdate(mode) || isUpsert(mode)) {
    assert(context.planId, 'plan id required')
    query._id = {$ne: context.planId}
  }
  return assertNone({collectionName, steps, query})
}
