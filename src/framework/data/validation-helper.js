import joi from 'joi'
import debug from 'debug'
import {stringify} from 'helpr'
import constants from './constants'

const {create, upsert} = constants.MODES
const dbg = debug('app:data:validation-helper')

export function joiAssert({data, schema}) {
  const result = joi.validate(data, schema)
  if (result.error) {
    throw result.error
  }
  return true
}

export function joiValidator({schema, createModifier} = {}) {
  return function ({mode, data}) {
    dbg('joi-validator: mode=%o, data=%o', mode, stringify(data))
    return [create, upsert].includes(mode) ?
    joiAssert({data, schema: createModifier ? createModifier(schema) : schema}) :
    joiAssert({data, schema})
  }
}
