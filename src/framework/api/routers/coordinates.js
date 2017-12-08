import assert from 'assert'
import express from 'express'
import debug from 'debug'
import geocode from 'geocodr'
import {getProvider} from '../geo-provider'
import {dbgreq} from '../express-helper'

const dbg = debug('app:api:routers:coordinates')
const router = express.Router()

function _getProvider(req) {
  return getProvider(req.query.provider)
}

router.get('/', async (req, res, next) => {
  try {
    dbgreq(dbg, req)
    assert(req.query.address)

    const coordinates = await geocode(req.query.address, _getProvider(req))
    res.send(coordinates)
  } catch (err) {
    next(err)
  }
})

router.get('/:address', async (req, res, next) => {
  try {
    dbgreq(dbg, req)
    assert(req.params.address)

    const coordinates = await geocode(req.params.address, _getProvider(req))
    res.send(coordinates)
  } catch (err) {
    next(err)
  }
})

export default router
