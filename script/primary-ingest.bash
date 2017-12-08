#!/bin/bash
set -o nounset
set -o errexit

path=$(dirname $(realpath --relative-to=. $0))
. $path/helper.bash

log begin

$path/provider-locations.bash
run "npm run organization-locations"
run "npm run organizations"
run "npm run providers"

log end
