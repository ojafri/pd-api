#!/bin/bash
set -o nounset
set -o errexit

path=$(dirname $(realpath --relative-to=. $0))
. $path/helper.bash

log begin

csvFile=${clientOrganizationsCsvFile:-client-organizations.csv}
collection=originalClientOrganizations
fieldFile=client-organization-fields.dat

if [ "${import:-true}" = true ]; then
  run importCsv
fi

run "npm run client-organizations -- --sourceId=$sourceId"

log end
