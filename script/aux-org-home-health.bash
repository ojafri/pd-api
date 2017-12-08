#!/bin/bash
set -o nounset
set -o errexit

path=$(dirname $(realpath --relative-to=. $0))
. $path/helper.bash

orgType=cms-home-health-agency
oid=2.16.840.1.113883.4.336
specialtyCode=251E00000X

csvFile=${homeHealthCsvFile:-HHC_SOCRATA_PRVDR.csv}
fieldFile=home-health-agency-fields.dat
collection=cmsOriginalHHAgencies

log begin
run auxOrg
log end
