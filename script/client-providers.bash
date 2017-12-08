#!/bin/bash
set -o nounset
set -o errexit

path=$(dirname $(realpath --relative-to=. $0))
. $path/helper.bash

log begin

csvFile=${clientProvidersCsvFile:-client-providers.csv}
collection=originalClientProviders
fieldFile=client-provider-fields.dat

if [ "${import:-true}" = true ]; then
  run importCsv
fi

run "npm run client-providers -- --sourceId=$sourceId"

log end
