#!/bin/bash
set -o nounset
set -o errexit

path=$(dirname $(realpath --relative-to=. $0))
. $path/helper.bash

log begin

sourceHost=${sourceHost:-$MONGO_HOST}
sourcePort=${sourcePort:-$MONGO_PORT}
collection=geocodedAddresses
qualifiedDb=$(qualifiedDb)
count=$(mongo --quiet $qualifiedDb --eval "db.$collection.count()")

if (( $count == 0 )); then
  echo "found no records in db=$qualifiedDb, collection=$collection, continuing..."
  run "mongodump --db $sourceDb --host $sourceHost:$sourcePort --collection geocodedAddresses --archive | mongorestore --host $MONGO_HOST:$MONGO_PORT --archive --nsFrom=$sourceDb.geocodedAddresses --nsTo=$MONGO_DB.geocodedAddresses"
else
  echo "encountered $count records in db=$qualifiedDb, collection=$collection, bypassing..."
fi

log end
