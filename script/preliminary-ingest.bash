#!/bin/bash
set -o nounset
set -o errexit

path=$(dirname $(realpath --relative-to=. $0))
. $path/helper.bash

log begin

$path/npi-providers.bash
$path/specialties.bash
$path/geozip.bash

log end
