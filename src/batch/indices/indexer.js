#!/usr/bin/env node
import debug from 'debug'
import {getArg, splitAndTrim} from 'helpr'
import {createIndices, getDb, closeDb} from 'mongo-helpr'
import clients from './clients'
import npiProviders from './npi-providers'
import organizationLocations from './organization-locations'
import organizations from './organizations'
import providerLocations from './provider-locations'
import providers from './providers'
import specialties from './specialties'

const dbg = debug('app:indexer')

const indexMap = {
  clients,
  npiProviders,
  organizationLocations,
  organizations,
  providerLocations,
  providers,
  specialties
}

const targets = splitAndTrim(getArg('targets'))
targets && dbg('targets=%o', targets)

export default (async function () {
  try {
    const db = await getDb()
    for (const collectionName in indexMap) {
      if (targets && !targets.includes(collectionName)) {
        dbg('skipping collection=%o because it is absent from targets', collectionName)
        continue
      }
      dbg('dropping and creating indices for collection=%o', collectionName)
      // eslint-disable-next-line no-await-in-loop
      await createIndices({db, collectionName, indices: indexMap[collectionName], drop: true})
    }
    await closeDb()
  } catch (err) {
    dbg('caught error=%o, exiting...', err)
    throw err
  }
})()
