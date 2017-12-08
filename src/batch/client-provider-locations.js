import assert from 'assert'
import debug from 'debug'
import {deepClean, stringify} from 'helpr'
import getData from '../framework/data/data'
import {isCreate, isUpdate} from '../framework/data/helper'
import getIngester from '../framework/batch/ingester'
import practitionerLocOpts from '../shared/practitioner-locations/opts'
import constants from './shared/constants'
import {getRequiredSource, getRecordId} from './shared/helper'

const dbg = debug('app:batch:client-practitioner-locations')

const practitionerLocData = getData(practitionerLocOpts)

export default (async function () {
  const source = await getRequiredSource()

  async function postProcessor({record, date}) {
    dbg('post-processor-hook: record=%o, date=%o', record, date)

    const data = deepClean(
      {
        hours: record.hours,
        isInactive: record.isInactive
      }
    )

    let result

    const context = {
      ...(getRecordId({source, record})),
      providerId: {
        'id.oid': record.providerOid,
        'id.extension': record.providerExtension
      },
      organizationLocId: {
        'organization.id.oid': record.orgOid,
        'organization.id.extension': record.orgExtension,
        'address.line1': record.addressLine1,
        'address.city': record.city,
        'address.state': record.state,
        'address.zip': record.zip
      },
      date,
      source
    }

    if (isCreate(record.action)) {
      result = await practitionerLocData.upsert({data, context})
    } else if (isUpdate(record.action)) {
      const id = context._id || {
        'practitioner.id.oid': record.providerOid,
        'practitioner.id.extension': record.providerExtension,
        'location.organization.id.oid': record.orgOid,
        'location.organization.id.extension': record.orgExtension,
        'location.address.line1': record.addressLine1,
        'location.address.city': record.city,
        'location.address.state': record.state,
        'location.address.zip': record.zip
      }
      result = await practitionerLocData.update({id, data, context})
      assert(result, `unable to obtain provider-location for record=${stringify(id)}`)
    } else {
      throw new Error(`unsupported action=${record.action}`)
    }
    assert(result.result.ok, 'ok required')

    return result
  }

  return getIngester(
    {
      inputName: constants.CLIENT_PROVIDER_LOCATIONS_SOURCE,
      outputName: constants.PROVIDER_LOCATIONS,
      sourceHook: source,
      postProcessor
    }
  )()
})()
