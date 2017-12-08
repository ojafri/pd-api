#!sh
set -e -o pipefail
export MONGO_HOME=${MONGO_HOME:-"/e/mongo"}
export MONGOD='C:\Program Files\MongoDB\Server\3.4\bin\mongod.exe'

SVC="rs$1"

# loop

# stop the service
net stop "MongoDB-${SVC}"
echo "stopped ${SVC} ..."

# remove the service
"${MONGOD}" --remove \
            --serviceName "MongoDB-${SVC}"

echo "removed service ${SVC}..."

# cleanup data
_RS_CLEANUP=${RS_CLEANUP:=false}
if [ "${_RS_CLEANUP}" != false ]; then
  echo "removing old data ${SVC} ..."
  rm -rf ${MONGO_HOME}/data/${SVC}
  echo "removed data ${SVC} ...."
fi
