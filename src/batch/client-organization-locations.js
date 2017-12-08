import assert from 'assert'
import debug from 'debug'
import {deepClean, stringify} from 'helpr'
import getData from '../framework/data/data'
import {isCreate, isUpdate} from '../framework/data/helper'
import getIngester from '../framework/batch/ingester'
import orgLocOpts from '../shared/organization-locations/opts'
import constants from './shared/constants'
import {getRequiredSource, shouldWriteIdFields, getRecordId} from './shared/helper'

const dbg = debug('app:batch:client-organization-locations')

const orgLocData = getData(orgLocOpts)

// think restful post/put for '/organizations/:orgId/locations'
//
export default (async function () {
  const source = await getRequiredSource()

  async function postProcessor({record, date}) {
    dbg('post-processor-hook: record=%o, date=%o', record, date)
    const _shouldWriteIdFields = shouldWriteIdFields({mode: record.action, recordId: record.recordId})

    const data = deepClean(
      {
        address: {
          line2: record.addressLine2,
          ...(_shouldWriteIdFields && {
            line1: record.addressLine1,
            city: record.city,
            state: record.state,
            zip: record.zip
          })
        },
        phone: record.phone,
        fax: record.fax,
        county: record.county,
        hours: record.hours,
        isInactive: record.isInactive
      }
    )

    let result

    const context = {
      ...(getRecordId({source, record})),
      organizationId: {
        'id.oid': record.oid,
        'id.extension': record.extension
      },
      date
    }

    if (isCreate(record.action)) {
      result = await orgLocData.upsert({data, context})
    } else if (isUpdate(record.action)) {
      const id = context._id || {
        'organization.id.oid': record.oid,
        'organization.id.extension': record.extension,
        'address.line1': record.addressLine1,
        'address.city': record.city,
        'address.state': record.state,
        'address.zip': record.zip
      }
      result = await orgLocData.update({id, data, context})
      assert(result, `unable to obtain organization-location for record=${stringify(id)}`)
    } else {
      throw new Error(`unsupported action=${record.action}`)
    }
    assert(result.result.ok, 'ok required')

    return result
  }

  return getIngester(
    {
      inputName: constants.CLIENT_ORGANIZATION_LOCATIONS_SOURCE,
      outputName: constants.ORGANIZATION_LOCATIONS,
      sourceHook: source,
      postProcessor
    }
  )()
})()
