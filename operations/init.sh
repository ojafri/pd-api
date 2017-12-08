#!sh
set -e -o pipefail

# name of replica set which mongo instanaces below will join
export RS_NAME=${RS_NAME:-"rs0"}

# start each instance. this should be an odd number
# configuration and data location are automatically configured
# start the services
./start.sh 0
# if instance topology is on instance per host, you only need to start the '0' instance
# on each host
# if you are running multiple instances on each host, then start remainder

_RS_MULTI=${RS_MULTI:=false}
if [ "${_RS_MULTI}" != false ]; then
  ./start.sh 1
  ./start.sh 2
fi


echo "**********************************************************"
echo ""
echo "Next steps"
echo ""
echo "run the './initialize.sh' on ONE of the instances to complete the setup"
echo ""
echo "**********************************************************"
