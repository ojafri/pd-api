#!/bin/bash
set -o nounset
set -o errexit

path=$(dirname $(realpath --relative-to=. $0))
. $path/helper.bash

orgType=cms-dialysis-facility
oid=2.16.840.1.113883.4.336
specialtyCode=2472R0900X

csvFile=${dialysisCsvFile:-DFC_SOCRATA_FAC_DATA.csv}
fieldFile=dialysis-fields.dat
collection=cmsOriginalDialysisFacilities

log begin
run auxOrg
log end
