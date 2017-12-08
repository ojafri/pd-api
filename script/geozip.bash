#!/bin/bash
set -o nounset
set -o errexit

path=$(dirname $(realpath --relative-to=. $0))
. $path/helper.bash

log begin

csvFile=${geozipCsvFile:-zipcode.csv}
fieldFile=geozip-fields.dat
collection=geozip

if [ "${import:-true}" = true ]; then
  run importCsv
fi

mongo $(qualifiedDb) --eval 'db.geozip.createIndex({zip: 1}, {unique: true})'

log end
