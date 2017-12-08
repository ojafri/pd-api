#!/bin/bash
set -o nounset
set -o errexit

path=$(dirname $(realpath --relative-to=. $0))
. $path/helper.bash

log begin

npm run indexer
$path/preliminary-ingest.bash
$path/primary-ingest.bash
$path/aux-orgs.bash
$path/apply-fixtures.bash
$path/apply-qa-fixtures.bash

log end
