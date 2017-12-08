import debug from 'debug'
import * as adapters from 'geocodr'
import _ from 'lodash'
import config from 'config'

const dbg = debug('app:api:geo-provider')

const configuredProviderName = config.get('geocoder.provider')
const _configuredProvider = adapters[configuredProviderName]

export const configuredProvider = {
  ..._configuredProvider,
  params: {
    ..._configuredProvider.params,
    ..._.get(config, 'geocoder.params')
  }
}

dbg('configured=%o', configuredProviderName)

export function getProvider(providerName = configuredProviderName) {
  return (providerName === configuredProviderName) ? configuredProvider : adapters[providerName]
}
