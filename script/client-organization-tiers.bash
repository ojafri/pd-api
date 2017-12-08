#!/bin/bash
set -o nounset
set -o errexit

path=$(dirname $(realpath --relative-to=. $0))
. $path/helper.bash

log begin

csvFile=${clientOrganizationTiersCsvFile:-client-organization-tiers.csv}
collection=originalClientOrganizationTiers
fieldFile=client-organization-tier-fields.dat

if [ "${import:-true}" = true ]; then
  run importCsv
fi

run "npm run client-organization-tiers -- --sourceId=$sourceId"

log end
