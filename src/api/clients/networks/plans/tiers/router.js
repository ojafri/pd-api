import getRouter from '../../../../../framework/api/router'
import opts from '../../../../../shared/clients/networks/plans/tiers/opts'

export default getRouter(
  {
    ...opts,
    xforms: {
      clientId: 'plan.network.client._id',
      networkId: 'plan.network._id',
      planId: 'plan._id',
      tierId: '_id'
    }
  }
)
