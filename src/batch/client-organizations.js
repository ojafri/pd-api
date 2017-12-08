import assert from 'assert'
import debug from 'debug'
import {deepClean, splitAndTrim, stringify} from 'helpr'
import getData from '../framework/data/data'
import {isCreate, isUpdate} from '../framework/data/helper'
import getIngester from '../framework/batch/ingester'
import orgOpts from '../shared/organizations/opts'
import constants from './shared/constants'
import {getRequiredSource, shouldWriteIdFields, getRecordId} from './shared/helper'

const dbg = debug('app:batch:client-organizations')

const orgData = getData(orgOpts)
const delimiter = constants.DELIMITER

// think restful post/put for '/organizations'
//
export default (async function () {
  const source = await getRequiredSource()

  async function postProcessor({record, date}) {
    dbg('post-processor-hook: record=%o, date=%o', record, date)

    const _shouldWriteIdFields = shouldWriteIdFields({mode: record.action, recordId: record.recordId})

    const data = deepClean(
      {
        id: {
          authority: record.authority,
          ...(_shouldWriteIdFields && {
            oid: record.oid,
            extension: record.extension
          })
        },
        name: record.name,
        specialtyCodes: splitAndTrim(record.specialtyCodes, {delimiter}), // xformed by data-hook
        hospitals: splitAndTrim(record.hospitals, {delimiter}),
        insurances: splitAndTrim(record.insurances, {delimiter}),
        website: record.website,
        direct: record.direct,
        email: record.email,
        description: record.description,
        isInactive: record.isInactive,
        isPrivate: record.isPrivate
      }
    )

    let result

    const context = {
      ...getRecordId({source, record}),
      date,
      source
    }

    if (isCreate(record.action)) {
      result = await orgData.upsert({data, context})
    } else if (isUpdate(record.action)) {
      assert(!data.isPrivate, 'updating records to private disallowed')
      const id = context._id || {
        'id.oid': record.oid,
        'id.extension': record.extension
      }
      result = await orgData.update({id, data, context})
      assert(result, `unable to obtain organization for id=${stringify(id)}`)
    } else {
      throw new Error(`unsupported action=${record.action}`)
    }
    assert(result.result.ok, 'ok required')
    return result
  }

  return getIngester(
    {
      inputName: constants.CLIENT_ORGANIZATIONS_SOURCE,
      outputName: constants.ORGANIZATIONS,
      sourceHook: source,
      postProcessor
    }
  )()
})()
