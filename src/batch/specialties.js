import getIngester from '../framework/batch/ingester'
import constants from './shared/constants'
import sourceHook from './shared/source-hook'

export default getIngester(
  {
    inputName: constants.SPECIALTIES_SOURCE,
    outputName: constants.SPECIALTIES,
    sourceHook,
    steps: [
      {
        $project: {
          code: '$Code',
          grouping: {$toUpper: '$Grouping'},
          classification: {$toUpper: '$Classification'},
          specialization: {$toUpper: '$Specialization'},
          system: constants.SPECIALTIES_SYSTEM
        }
      }
    ],
    isReplace: true
  }
)()
