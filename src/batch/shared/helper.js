import assert from 'assert'
import _ from 'lodash'
import {getKeyArray, getArg, getRequiredArg, SEPARATOR} from 'helpr'
import {requireOne, ifNull} from 'mongo-helpr'
import {getMarkedKey, isCreate, isUpdate, isUpsert} from '../../framework/data/helper'
import {compressOid} from '../../shared/helper'
import constants from './constants'

export function getLocationKeyArray({orgKey, addressKey}) {
  return getKeyArray([orgKey, addressKey])
}

export function getProviderLocationKeyArray({providerKey, locationKey}) {
  return getKeyArray([providerKey, locationKey])
}

export function getProviderOrganizationKeyArray({providerKey, organizationKey}) {
  return getKeyArray([providerKey, organizationKey])
}

export function decorateWithSource({source, key}) {
  return getKeyArray([source._id, key])
}

export function decorateWithOid({oid, key}) {
  assert(key, 'key required')
  return getKeyArray([compressOid(oid), key])
}

export function getSource(source) {
  return {
    _id: source._id,
    name: source.name
  }
}

export async function getSourceArg() {
  const sourceId = getArg('sourceId')

  if (sourceId) {
    const record = await requireOne(
      {
        collectionName: constants.CLIENTS,
        query: {_id: sourceId}
      }
    )
    return {
      _id: record._id,
      name: record.name
    }
  }

  return constants.CMS
}

export async function getRequiredClient(id) {
  const record = await requireOne(
    {
      collectionName: constants.CLIENTS,
      query: {_id: id}
    }
  )
  return {
    _id: record._id,
    name: record.name
  }
}

export async function getRequiredSource() {
  const sourceId = getRequiredArg('sourceId')
  return getRequiredClient(sourceId)
}

export function getSourceQuery() {
  const sourceId = getArg('sourceId', {dflt: constants.CMS._id})
  return {'created.source._id': sourceId}
}

export function getRating({measure, score, fromDate, toDate}) {
  return {
    score,
    measure,
    ...(fromDate && {fromDate}),
    ...(toDate && {toDate})
  }
}

export function getRatingNullCheck({measure, score, fromDate, toDate}) {
  return ifNull({
    test: score,
    is: null,
    not: getRating({measure, score, fromDate, toDate})
  })
}

export function transformField({target, field, transformer}) {
  assert(transformer, 'transformer required')
  const value = transformer(_.get(target, field))
  return (!value || _.isEmpty(value)) ? _.omit(target, field) : _.set(target, field, value)
}

export function ratingsCleaner(ratings) {
  return _.filter(ratings, rating => rating && (rating.score !== 'Not Available'))
}

export function getId({id, clientId}) {
  assert(id, 'id required')
  const key = getMarkedKey(clientId)
  return id.startsWith(key) ? id : `${key}${id}`
}

export function ifDefined({key, value}) {
  return value && {[key]: value}
}

export function shouldWriteIdFields({mode, recordId}) {
  return isCreate(mode) || isUpsert(mode) || (isUpdate(mode) && recordId)
}

export function buildKey({head, tail}) {
  assert(head && tail, `head and tail required, arguments=${arguments[0]}`)
  return [head, tail].join(SEPARATOR)
}

export function getRecordId({source, record}) {
  return record.recordId && {_id: buildKey({head: source._id, tail: record.recordId})}
}
