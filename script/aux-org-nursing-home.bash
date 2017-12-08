#!/bin/bash
set -o nounset
set -o errexit

path=$(dirname $(realpath --relative-to=. $0))
. $path/helper.bash

orgType=cms-nursing-home
oid=2.16.840.1.113883.4.336
specialtyCode=313M00000X

csvFile=${nursingHomeCsvFile:-ProviderInfo_Download.csv}
fieldFile=nursing-home-fields.dat
collection=cmsOriginalNursingHomes

log begin
run auxOrg
log end
