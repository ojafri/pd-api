#!/bin/bash
set -o nounset
set -o errexit

path=$(dirname $(realpath --relative-to=. $0))
. $path/helper.bash

orgType=cms-hospital
oid=2.16.840.1.113883.4.336
specialtyCode=282N00000X

csvFile=${hospitalCsvFile:-Hospital-General-Information.csv}
fieldFile=hospital-compare-fields.dat
collection=cmsOriginalHospitalLocations

log begin
run auxOrg
log end
