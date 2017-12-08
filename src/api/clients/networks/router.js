import getRouter from '../../../framework/api/router'
import opts from '../../../shared/clients/networks/opts'

export default getRouter(
  {
    ...opts,
    xforms: {
      clientId: 'client._id',
      networkId: 'networks._id'
    }
  }
)
