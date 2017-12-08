import assert from 'assert'
import _ from 'lodash'
import debug from 'debug'
import {deepClean} from 'helpr'
import getData from '../framework/data/data'
import clientOpts from './clients/opts'
import constants from './constants'

const dbg = debug('app:shared:helper')

let _clientData

export const HL7_OID = '2.16.840.1.113883'

// eslint-disable-next-line import/prefer-default-export
export function compressOid(oid) {
  assert(oid, 'oid required')
  // only compress HL7 oids, otherwise qualify as "External"
  // see: https://www.hl7.org/oid/index.cfm
  return _.startsWith(oid, HL7_OID) ? oid.slice(HL7_OID.length + 1) : `e:${oid}`
}

export function getClientId({query, context}) {
  dbg('get-client-id: query=%o, context=%o', query, context)
  return _.get(context, constants.CONTEXT_CLIENT_ID) || _.get(query, constants.QUERY_CLIENT_ID)
}

export function getContextUser(context) {
  dbg('get-context-user: context=%o', context)
  return {
    _id: _.get(context, constants.CONTEXT_USER_ID),
    name: _.get(context, constants.CONTEXT_USER_NAME)
  }
}

export async function getContextSource(context) {
  dbg('get-context-source: context=%o', context)

  let {source} = context

  if (source) {
    return source
  }

  const clientId = _.get(context, constants.CONTEXT_CLIENT_ID)

  source = clientId && await getClientData().get(clientId)

  return source && {_id: source._id, name: source.name}
}

export function getContextDate(context) {
  return context.date || new Date()
}

export async function getChanged({context, omitSource}) {
  const source = !omitSource && await getContextSource(context)
  return deepClean({
    date: getContextDate(context),
    user: getContextUser(context),
    source
  })
}

function getClientData() {
  // singleton pattern to skirt weird race-condition in tests
  if (!_clientData) {
    assert(clientOpts, 'clientOps required')
    _clientData = getData(clientOpts)
  }
  return _clientData
}

export function isPublicSource(source) {
  assert(source, 'source required')
  return _.toInteger(source._id) < 0
}
