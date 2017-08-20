#!/bin/bash

export SCRIPT_SRC="$(dirname "$(readlink -f "$0")")"

pushd "$SCRIPT_SRC/.."

rm -rf "./rules-generated/*"
mkdir -p "./rules-generated"
rm -rf "./weapons-generated/*"
mkdir -p "./weapons-generated"

$SCRIPT_SRC/lib/header.sh             > ./rules-generated/resource.yaml
$SCRIPT_SRC/lib/resources-rules.sh   >> ./rules-generated/resource.yaml
$SCRIPT_SRC/lib/header.sh             > ./weapons-generated/resource.yaml
$SCRIPT_SRC/lib/resources-weapons.sh >> ./weapons-generated/resource.yaml

popd