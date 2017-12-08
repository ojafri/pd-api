#!/bin/bash
set -o nounset
set -o errexit

path=$(dirname $(realpath --relative-to=. $0))
. $path/helper.bash

log begin

csvFile=${clientOrganizationLocationsCsvFile:-client-organization-locations.csv}
collection=originalClientOrganizationLocations
fieldFile=client-organization-location-fields.dat

if [ "${import:-true}" = true ]; then
  run importCsv
fi

run "npm run client-organization-locations -- --sourceId=$sourceId"

log end
