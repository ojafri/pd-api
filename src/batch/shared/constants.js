import constants from '../../shared/constants'

export default {
  ...constants,
  // note: public source _id should be < 0 as positive integers will be used by clients
  CMS: {
    _id: constants.CMS_SOURCE_ID,
    name: 'cms'
  },
  CMS_PROVIDER_SOURCE: 'cmsOriginalProviderLocations',
  NPPES_PROVIDER_SOURCE: 'npiOriginalProviderLocations',
  CMS_SOURCE: 'cmsOriginalProviderLocations',
  NPI_SOURCE: 'npiOriginalProviderLocations',
  SPECIALTIES_SOURCE: 'originalSpecialties',
  NPI_PROVIDERS: 'npiProviders',
  NPI: {
    authority: 'npi',
    oid: '2.16.840.1.113883.4.6'
  },
  PAC: {
    authority: 'pac',
    oid: 'pac'
  },
  CCN: {
    authority: 'ccn',
    oid: '2.16.840.1.113883.4.336'
  },
  SPECIALTIES_SYSTEM: '2.16.840.1.113883.6.101',
  CMS_NURSING_HOME_SOURCE: 'cmsOriginalNursingHomes',
  NURSING_HOME_SPECIALTY: '313M00000X',
  CMS_HHA_SOURCE: 'cmsOriginalHHAgencies',
  HOME_HEALTH_SPECIALTY: '251E00000X',
  CMS_DIALYSIS_FACILITY_SOURCE: 'cmsOriginalDialysisFacilities',
  DIALYSIS_FACILITY_SPECIALTY: '2472R0900X',
  CMS_HOSPICE_AGENCY_SOURCE: 'cmsOriginalHospiceAgencies',
  HOSPICE_SPECIALTY: '251G00000X',
  NPI_OID: '2.16.840.1.113883.4.6',
  NPI_AUTH: 'npi',
  PAC_AUTH: 'pac',
  HOSPITAL_SPECIALTY: '282N00000X',
  CMS_HOSPITAL_SOURCE: 'cmsOriginalHospitalLocations',
  CLIENTS_SOURCE: 'originalClients',
  CLIENT_ORGANIZATIONS_SOURCE: 'originalClientOrganizations',
  CLIENT_ORGANIZATION_LOCATIONS_SOURCE: 'originalClientOrganizationLocations',
  CLIENT_PROVIDER_ORGANIZATION_TIERS_SOURCE: 'originalClientProviderOrganizationTiers',
  CLIENT_PROVIDERS_SOURCE: 'originalClientProviders',
  CLIENT_ORGANIZATION_TIERS_SOURCE: 'originalClientOrganizationTiers',
  DELIMITER: '|',
  CLIENT_PROVIDER_LOCATIONS_SOURCE: 'originalClientProviderLocations'
}
