import assert from 'assert'
import debug from 'debug'
import {stringify} from 'helpr'
import {assertNone} from 'mongo-helpr'
import {isCreate, isUpsert} from '../../framework/data/helper'

const dbg = debug('app:shared:organization-tiers:is-valid')

export default async function ({collectionName, data, context, mode}) {
  dbg('data=%o, context=%o', stringify(data), stringify(context))
  assert(isCreate(mode) || isUpsert(mode), `unsupported mode=${mode}`)
  assert(context['tier._id'] && context['organization._id'], `insufficient data in context=${context}`)
  return assertNone(
    {
      collectionName,
      query: {
        _id: context['organization._id'],
        'tierRefs.tier._id': context['tier._id']
      }
    }
  )
}
