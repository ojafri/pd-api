import joi from 'joi'
import {joiValidator} from '../../framework/data/validation-helper'
import {
  name,
  description,
  isInactive
} from '../validators'

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

export default async function ({data, mode}) {
  return validate({mode, data})
}
