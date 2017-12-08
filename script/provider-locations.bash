#!/bin/bash
set -o nounset
set -o errexit

path=$(dirname $(realpath --relative-to=. $0))
. $path/helper.bash

csvFile=${physicianCompareCsvFile:-Physician_Compare_National_Downloadable_File.csv}
fieldFile=physician-compare-fields.dat
collection=cmsOriginalProviderLocations

log begin
if [ "${import:-true}" = true ]; then
  run importCsv
fi
if [ "${geocode:-true}" = true ]; then
  run "npm run geocoder -- --inputCollection=${collection}"
fi
run "npm run provider-locations"
log end
