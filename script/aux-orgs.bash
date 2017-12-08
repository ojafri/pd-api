#!/bin/bash
set -o nounset
set -o errexit

path=$(dirname $(realpath --relative-to=. $0))
. $path/helper.bash

log begin
run $path/aux-org-dialysis.bash
run $path/aux-org-hospice.bash
run $path/aux-org-hospital.bash
run $path/aux-org-nursing-home.bash
run $path/aux-org-home-health.bash
log end
