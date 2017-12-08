#!/bin/bash
set -o nounset
set -o errexit

host=${MONGO_HOST:-localhost}
port=${MONGO_PORT:-27017}
db=${MONGO_DB:-test}
qualDb=$host:$port/$db
client1=c1
client2=c2

echo "begin: processing [`date`]"
echo "target-db = $qualDb"

echo "removing clients [$client1, $client2]"
mongo $qualDb --eval "db.clients.remove({_id: \"${client1}\"})"
mongo $qualDb --eval "db.clients.remove({_id: \"${client2}\"})"
mongoimport --verbose --host $host --port $port --db $db --file fixture/clients.js --collection clients --jsonArray

mongo $qualDb --eval "db.organizationLocations.remove({'source._id': \"$client1\"})"
mongoimport --verbose --host $host --port $port --db $db --file fixture/organization-locations-06108.json --collection organizationLocations --jsonArray
mongoimport --verbose --host $host --port $port --db $db --file fixture/organization-locations-10021.json --collection organizationLocations --jsonArray

mongo $qualDb --eval "db.providerLocations.remove({'source._id': \"$client1\"})"
mongoimport --verbose --host $host --port $port --db $db --file fixture/provider-locations-06108.json --collection providerLocations --jsonArray
mongoimport --verbose --host $host --port $port --db $db --file fixture/provider-locations-10021.json --collection providerLocations --jsonArray

mongo $qualDb --eval "db.organizations.remove({'source._id': \"$client1\"})"
mongoimport --verbose --host $host --port $port --db $db --file fixture/organizations-06108.json --collection organizations --jsonArray

mongo $qualDb --eval "db.providers.remove({'source._id': \"$client1\"})"
mongoimport --verbose --host $host --port $port --db $db --file fixture/providers-06108.json --collection providers --jsonArray

echo "end: processing [`date`]"
