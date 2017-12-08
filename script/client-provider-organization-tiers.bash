#!/bin/bash
set -o nounset
set -o errexit

path=$(dirname $(realpath --relative-to=. $0))
. $path/helper.bash

log begin

csvFile=${clientProviderOrganizationTiersCsvFile:-client-provider-organization-tiers.csv}
collection=originalClientProviderOrganizationTiers
fieldFile=client-provider-organization-tier-fields.dat

if [ "${import:-true}" = true ]; then
  run importCsv
fi

run "npm run client-provider-organization-tiers -- --sourceId=$sourceId"

log end
