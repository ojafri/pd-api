import debug from 'debug'
import express from 'express'
import getRouter from '../../framework/api/router'
import {dbgreq, forward} from '../../framework/api/express-helper'
import opts from '../../shared/clients/opts'
import networksRouter from './networks/router'
import plansRouter from './networks/plans/router'
import tiersRouter from './networks/plans/tiers/router'

const dbg = debug('app:clients:router')

const router = express.Router()

router.all('/:clientId/networks', (req, res, next) => {
  dbgreq(dbg, req)
  forward({req, res, next, router: networksRouter})
})

router.all('/:clientId/networks/:networkId', (req, res, next) => {
  dbgreq(dbg, req)
  forward({req, res, next, router: networksRouter, id: req.params.networkId})
})

router.all('/:clientId/networks/:networkId/plans', (req, res, next) => {
  dbgreq(dbg, req)
  forward({req, res, next, router: plansRouter})
})

router.all('/:clientId/networks/:networkId/plans/:planId', (req, res, next) => {
  dbgreq(dbg, req)
  forward({req, res, next, router: plansRouter, id: req.params.planId})
})

router.all('/:clientId/networks/:networkId/plans/:planId/tiers', (req, res, next) => {
  dbgreq(dbg, req)
  forward({req, res, next, router: tiersRouter})
})

router.all('/:clientId/networks/:networkId/plans/:planId/tiers/:tierId', (req, res, next) => {
  dbgreq(dbg, req)
  forward({req, res, next, router: tiersRouter, id: req.params.tierId})
})

export default getRouter(
  {
    ...opts,
    router
  }
)
