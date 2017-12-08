#!/bin/bash
set -o nounset
set -o errexit

export dataRoot=fixture/qa

path=$(dirname $(realpath --relative-to=. $0))
. $path/helper.bash

log begin

export clientId=qac1
export sourceId=$clientId
export isUpsertClient=true
export clientName=qaCeeOne

$path/clients.bash
$path/client-organizations.bash
$path/client-organization-locations.bash
$path/client-providers.bash
$path/client-provider-locations.bash

log end
