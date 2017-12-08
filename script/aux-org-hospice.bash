#!/bin/bash
set -o nounset
set -o errexit

path=$(dirname $(realpath --relative-to=. $0))
. $path/helper.bash

orgType=cms-hospice-agency
oid=2.16.840.1.113883.4.336
specialtyCode=251G00000X

csvFile=${hospiceCsvFile:-Hospice_Agencies.csv}
fieldFile=hospice-fields.dat
collection=cmsOriginalHospiceAgencies

log begin
run auxOrg
log end
