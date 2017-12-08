#!/bin/bash
set -o nounset
set -o errexit

path=$(dirname $(realpath --relative-to=. $0))
. $path/helper.bash

log begin

csvFile=${nuccTaxonomyCsvFile:-nucc_taxonomy_161.csv}
collection=originalSpecialties
fieldFile=nucc-fields.dat

if [ "${import:-true}" = true ]; then
  run importCsv
fi

run "npm run specialties"

log end
