import getRouter from '../../../../framework/api/router'
import opts from '../../../../shared/clients/networks/plans/opts'

export default getRouter(
  {
    ...opts,
    xforms: {
      clientId: 'network.client._id',
      networkId: 'network._id',
      planId: '_id'
    }
  }
)
