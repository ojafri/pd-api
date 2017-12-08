import constants from '../constants'

const {NETWORKS, PLANS, TIERS} = constants
const networkPath = NETWORKS
const planPath = `${NETWORKS}.${PLANS}`
const tierPath = `${planPath}.${TIERS}`

export default {
  networkPath,
  planPath,
  tierPath
}
