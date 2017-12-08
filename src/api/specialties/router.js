import getRouter from '../../framework/api/router'
import {orMatcher} from '../../framework/api/mongo-xform-query'
import opts from '../../shared/specialties/opts'

export default getRouter(
  {
    ...opts,
    matchers: [
      orMatcher
    ]
  }
)
