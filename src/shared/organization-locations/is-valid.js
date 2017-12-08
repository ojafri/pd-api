import joi from 'joi'
import debug from 'debug'
import {stringify} from 'helpr'
import {joiValidator} from '../../framework/data/validation-helper'
import {
  address,
  phone,
  fax,
  county,
  hours,
  isInactive
} from '../validators'

const dbg = debug('app:shared:organization-locations:is-valid')

const validate = joiValidator(
  {
    schema: joi.object(
      {
        address,
        phone,
        fax,
        county,
        hours,
        isInactive
      }
    ),
    createModifier: schema => schema.requiredKeys(
      'address'
    )
  }
)

export default async function ({data, mode}) {
  dbg('data=%o, mode=%o', stringify(data), mode)
  return validate({mode, data})
}
