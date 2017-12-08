#!/bin/bash
set -o nounset
set -o errexit

MONGO_HOST=${MONGO_HOST:-localhost}
MONGO_PORT=${MONGO_PORT:-27017}
MONGO_DB=${MONGO_DB:-test}

function qualifiedDb(){
  echo "$MONGO_HOST:$MONGO_PORT/$MONGO_DB"
}
function getDate() {
  #echo $(date +%Y-%m-%d' '%H:%M:%S)
  echo $(date +%F' '%T)
}

function log() {
  echo "[$(getDate)]: $(basename $0): $@ [${SECONDS}s]"
}

function run() {
  start=$SECONDS
  log "starting [$@]"
  eval $@
  elapsed=$(($SECONDS - $start))
  log "finished [$@] [${elapsed}s]"
}

function importCsv() {
  path=$(dirname $(realpath --relative-to=. $0))
  dataRoot=${dataRoot:-$path/../data}
  fieldRoot=${fieldRoot:-$path/../data}

  if [ ! -z "${fieldFile-}" ]; then
    fieldArgs="--columnsHaveTypes --fieldFile $fieldRoot/$fieldFile"
    catClause="tail -n +2"
  else
    fieldArgs="--headerline"
    catClause=cat
  fi
  #run "tail -n +2 $dataRoot/$csvFile | mongoimport --host ${MONGO_HOST} --port ${MONGO_PORT} --db ${MONGO_DB} --collection $collection --verbose --ignoreBlanks --type csv  --drop --stopOnError --parseGrace=autoCast $fieldArgs"
  run "$catClause $dataRoot/$csvFile | mongoimport --host ${MONGO_HOST} --port ${MONGO_PORT} --db ${MONGO_DB} --collection $collection --verbose --ignoreBlanks --type csv  --drop --stopOnError --parseGrace=autoCast $fieldArgs"
}

function auxOrg() {
  if [ "${import:-true}" = true ]; then
    run importCsv
  fi
  if [ "${geocode:-true}" = true ]; then
    run "npm run geocode-${orgType}-locations"
  fi
  run "npm run ${orgType}-locations"
  query="{\"organization.id.oid\": \"${oid}\", \"specialties.code\": \"${specialtyCode}\"}"
  inactiveQuery="{\"id.oid\": \"${oid}\", \"specialties.code\": \"${specialtyCode}\"}"
  run "npm run organizations -- --query='$query' --inactiveQuery='$inactiveQuery' --inactiveHookVerify=true"
}

function relPath() {
  echo $(dirname $(realpath --relative-to=. $0))
}
