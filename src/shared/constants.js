import constants from '../framework/data/constants'

const CMS_SOURCE_ID = '-1'

const user = 'user'

export default {
  ...constants,
  CLIENTS: 'clients',
  NETWORKS: 'networks',
  PLANS: 'plans',
  TIERS: 'tiers',
  ORGANIZATIONS: 'organizations',
  ORGANIZATION_LOCATIONS: 'organizationLocations',
  PROVIDERS: 'providers',
  PROVIDER_LOCATIONS: 'providerLocations',
  SPECIALTIES: 'specialties',
  ORGANIZATION_TIERS: 'organizationTiers',
  PROVIDER_ORGANIZATIONS: 'providerOrganizations',
  PROVIDER_ORGANIZATION_TIERS: 'providerOrganizationTiers',
  CMS_SOURCE_ID,
  PUBLIC_SOURCE_IDS: [CMS_SOURCE_ID],
  QUERY_CLIENT_ID: 'source._id',
  CONTEXT_CLIENT_ID: `${user}.clientId`,
  CONTEXT_USER_NAME: `${user}.userName`,
  CONTEXT_USER_ID: `${user}.userId`,
  ONLY_CLIENT_CREATED: 'onlyClientCreated'
}
