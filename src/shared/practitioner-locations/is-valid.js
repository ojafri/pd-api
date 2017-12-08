import joi from 'joi'
import debug from 'debug'
import {stringify} from 'helpr'
import {joiValidator} from '../../framework/data/validation-helper'
import {
  hours,
  isInactive
} from '../validators'

const dbg = debug('app:shared:provider-locations:is-valid')

const validate = joiValidator(
  {
    schema: joi.object(
      {
        hours,
        isInactive
      }
    )
  }
)

export default async function ({data, mode}) {
  dbg('data=%o, mode=%o', stringify(data), mode)
  return validate({mode, data})
}
