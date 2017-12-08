#!sh
# stop service and cleanup
# probably only needed for testing

set -e -o pipefail
export MONGO_HOME=${MONGO_HOME:-"/e/mongo"}

# start the services (in reverse order)
./stop.sh 2
./stop.sh 1
./stop.sh 0

# and logs
_RS_CLEANUP=${RS_CLEANUP:=false}
if [ "${_RS_CLEANUP}" != false ]; then
  rm -rf ${MONGO_HOME}/log/*
  echo "removed log ..."
fi

echo ""
echo "all is done!"
echo ""
