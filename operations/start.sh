#!sh
set -e -o pipefail

# configuration, data and logs live here !
export MONGO_HOME=${MONGO_HOME:-"/e/mongo"}
export MONGOD='C:\Program Files\MongoDB\Server\3.4.2\bin\mongod.exe'

export LOG_HOME=${LOG_HOME:-${MONGO_HOME}}
export DATA_HOME=${DATA_HOME:-${MONGO_HOME}}
export CONF_HOME=${CONF_HOME:-${MONGO_HOME}}

# make log folder if it doesn't exist
mkdir -p ${LOG_HOME}/log
mkdir -p ${CONF_HOME}/conf
mkdir -p ${DATA_HOME}/data

# oplogSizeMB
MONGO_OPLOGSZ=${MONGO_OPLOGSZ:-100}
# convert the path for windows niceness
LOG_WIN_HOME=$(cygpath -m ${LOG_HOME})
DATA_WIN_HOME=$(cygpath -m ${DATA_HOME})

# replicaset name
RS_NAME=${RS_NAME:-"rs0"}

# loop
RS_INDEX=$1   # $1 eg, ./m0 0 , ./m0 1 , etc
SVC="rs${RS_INDEX}"

# make a data folder
mkdir -p ${DATA_HOME}/data/${SVC}
# and set port

MONGO_PORT=$((27017+$RS_INDEX))

# build the configuration
cat <<_EOF_ > ${CONF_HOME}/conf/${SVC}.conf
systemLog:
   destination: file
   path: "${LOG_WIN_HOME}/log/mongod-${SVC}.log"
   logRotate: rename
   logAppend: true
storage:
   dbPath: "${DATA_WIN_HOME}/data/${SVC}"
   journal:
      enabled: true
net:
   port: ${MONGO_PORT}
setParameter:
   enableLocalhostAuthBypass: true
replication:
   oplogSizeMB: ${MONGO_OPLOGSZ}
   replSetName: "${RS_NAME}"
_EOF_

# install the service
# to see installed
# sc queryex type= service state= all | grep -i "MON"
#
"${MONGOD}" --config "${CONF_HOME}/conf/${SVC}.conf" \
          --install \
          --serviceName "MongoDB-${SVC}" \
          --serviceDisplayName "MongoDB-${SVC}"

echo "service ${SVC} installed ..."

# start the service
net start "MongoDB-${SVC}"
echo "service ${SVC} started ...."
