import assert from 'assert'
import joi from 'joi'
import {assertNone} from 'mongo-helpr'
import {joiValidator} from '../../../framework/data/validation-helper'
import {isUpdate, isUpsert} from '../../../framework/data/helper'
import {
  name,
  description,
  isInactive
} from '../../validators'

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
      name: 'enOne'
    },
    {
      _id: 'c1:n2',
      name: 'enOne' <-- invalid
    }
  ]
}
*/

export default async function ({collectionName, steps, data, context, mode}) {
  validate({mode, data})
  assert(context.clientId, 'client id required')
  const query = {'client._id': context.clientId, name: data.name}
  if (isUpdate(mode) || isUpsert(mode)) {
    assert(context.networkId, 'network id required')
    query._id = {$ne: context.networkId}
  }
  return assertNone({collectionName, steps, query})
}
