#!sh
set -e -o pipefail

# name of replica set which mongo instanaces below will join
export RS_NAME=${RS_NAME:-"rs0"}

#############################################################################
# initialize the replication
# run this on only one instance !
#############################################################################

# get ip
IP=$(ipconfig | grep IPv4 | cut -f2 -d':'| tr -d '[:space:]')
echo "my IP is ${IP}"

echo ""
echo "These are the instances in your replica set ${RS_NAME}"
cat hosts.txt
echo ""

file=( $(cat "hosts.txt") )
members=""
for i in "${!file[@]}"
do
  # this ugly mess will strip windows cr in host string
  member="{_id:"${i}", host:\"$(echo ${file[$i]} | tr -d '\r')\"}"
  members="${members}${member},"
done

# remove trailing , -> ${members%?}
echo "rs.initiate({_id:\"${RS_NAME}\", members: [${members%?}]});" > rs-init.js

# initialize the replication
"C:\Program Files\MongoDB\Server\3.4\bin\mongo" rs-init.js

echo "ok"
