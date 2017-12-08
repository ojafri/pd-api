#!/bin/bash
set -o nounset
set -o errexit

path=$(dirname $(realpath --relative-to=. $0))
. $path/helper.bash

csvFile=${nppesCsvFile:-npidata.csv}
fieldFile=npi-fields.dat
collection=npiOriginalProviderLocations

log begin
if [ "${import:-true}" = true ]; then
  run importCsv
fi
run "npm run npi-providers"
log end
