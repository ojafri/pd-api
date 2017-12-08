import express from 'express'
import debug from 'debug'
import {requireOne} from 'mongo-helpr'
import constants from '../../data/constants'
/* eslint-disable import/extensions */
import {version} from '../../../../package.json'
import {sha} from '../../../../git.json'

const dbg = debug('app:api:routers:healthz')
const router = express.Router()

const response = {version, sha}

export default router.get('/', async (req, res, next) => {
  try {
    await requireOne({query: {zip: '90210'}, collectionName: constants.GEO_ZIPS})
    res.status(response.status = 200)
    res.header('Cache-Control', 'no-cache, no-store, must-revalidate')
    res.header('Pragma', 'no-cache')
    res.header('Expires', 0)
    res.send(response)
    dbg('response=%o', response)
  } catch (err) {
    next(err)
  }
})
