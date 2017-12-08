#!/bin/bash
set -o nounset
set -o errexit

path=$(dirname $(realpath --relative-to=. $0))
. $path/helper.bash

log begin

csvFile=${clientProviderLocationsCsvFile:-client-provider-locations.csv}
collection=originalClientProviderLocations
fieldFile=client-provider-location-fields.dat

if [ "${import:-true}" = true ]; then
  run importCsv
fi

run "npm run client-provider-locations -- --sourceId=$sourceId"

log end
