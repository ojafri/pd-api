# scripts

this folder contains a series of scripts to assist in the ingestion process.

the scripts are hierarchical in nature in that parents will run children, but children can be run separately as well.

1. [full-ingest.bash](full-ingest.bash) (~2h)
  1. [preliminary-ingest.bash](preliminary-ingest.bash)
    1. [npi-providers.bash](npi-providers.bash)
      - import ~4M records (~10m) and ingest (~15m)
    1. [specialties.bash](specialties.bash)
      - specialty codes and descriptions
    1. [geozip.bash](geozip.bash)
      - zip-to-geocode lookups
  1. [primary-ingest.bash](primary-ingest.bash)
    1. [provider-locations.bash](provider-locations.bash)
      - import, geocode and ingest (~40m/~1.5M records)
    1. npm run organization-locations (~10m/~400K records)
    1. npm run organizations (~10m/~300K records)
    1. npm run providers (~20m/~1M records)
    1. npm run provider-organizations (~20m/~1M records)
  1. [aux-orgs.bash](aux-orgs.bash) (~3m)
    1. [aux-org-dialysis.bash](aux-org-dialysis.bash)
    1. [aux-org-hospice.bash](aux-org-hospice.bash)
    1. [aux-org-hospital.bash](aux-org-hospital.bash)
    1. [aux-org-nursing-home.bash](aux-org-nursing-home.bash)
    1. [aux-org-home-health.bash](aux-org-home-health.bash)

> duration wise, these steps can range from a few seconds to over an hour, for slower ones (more than a few minutes), we provide benchmark times on a fast laptop (vm's will be slower)

## environment variables

| variable | default | description |
| :---: | :---: | --- |
| MONGO_HOST | localhost | mongo host |
| MONGO_PORT | 27017 | mongo port |
| MONGO_DB | test | mongo database |
| import | true | run `mongoimport` step where applicable |
| geocode | true | run geocode step where applicable |
| dataRoot | data | folder containing csv files |
| nppesCsvFile | npidata.csv | npi to specialties mapping |
| geozipCsvFile | zipcode.csv | zip to lat-lon mapping |
| nuccTaxonomyCsvFile | nucc_taxonomy_161.csv | specialty code descriptions |
| physicianCompareCsvFile | Physician_Compare_National_Downloadable_File.csv | primary data file |
| dialysisCsvFile | DFC_SOCRATA_FAC_DATA.csv | dialysis |
| homeHealthCsvFile | HHC_SOCRATA_PRVDR.csv | home health |
| hospiceCsvFile | Hospice_Agencies.csv | hospice |
| hospitalCsvFile | Hospital-General-Information.csv | hospital |
| nursingHomeCsvFile | ProviderInfo_Download.csv | nursing home |

## test fixtures

[apply-fixtures.bash](apply-fixtures.bash) can currently be used in non-prod environments to setup [these fixtures](../fixture)

## geocoding

geocoding is a time consuming task that we pay a geocoding provider for, so it makes sense to avoid doing repetitive bulk geocoding of the same addresses by copying over geocoding data to new environments.

to accomplish this, use the [copy-geocoded.bash](copy-geocoded.bash) script
