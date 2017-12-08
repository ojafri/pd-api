import debug from 'debug'
import joi from 'joi'
import {joiValidator} from '../../framework/data/validation-helper'
import {
  id,
  humanName,
  education,
  gender,
  languages,
  hospitals,
  insurances,
  website,
  direct,
  email,
  description,
  isInactive,
  isPrivate,
  specialtyCodes
} from '../validators'

const dbg = debug('app:shared:providers:is-valid')

const validate = joiValidator(
  {
    schema: joi.object(
      {
        id,
        name: humanName,
        education,
        gender,
        languages,
        hospitals,
        insurances,
        website,
        direct,
        email,
        description,
        isInactive,
        isPrivate,
        specialtyCodes
      }
    ),
    createModifier: schema => schema.requiredKeys(
      'id.oid',
      'id.extension',
      'id.authority',
      'name.first',
      'name.last',
      'specialtyCodes'
    )
  }
)

export default async function ({data, mode}) {
  dbg('data=%o, mode=%o', data, mode)
  return validate({mode, data})
}
