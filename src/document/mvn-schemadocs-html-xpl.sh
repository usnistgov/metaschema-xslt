#!/usr/bin/env bash

# Fail early if an error occurs
set -Eeuo pipefail

usage() {
    cat <<EOF
Usage: $(basename "${BASH_SOURCE[0]}") METASCHEMA_XML SCHEMA_NAME OUTPUT_DIR [ADDITIONAL_ARGS]

Produces HTML documentation from Metaschema XML source, using XML Calabash invoked from Maven.
Please install Maven first.

Additional arguments for XML Calabash should be specified in the `key=value` format.
EOF
}

if ! [ -x "$(command -v mvn)" ]; then
  echo 'Error: Maven (mvn) is not in the PATH, is it installed?' >&2
  exit 1
fi

[[ -z "${1-}" ]] && { echo "Error: METASCHEMA_XML not specified"; usage; exit 1; }
METASCHEMA_XML=$1
[[ -z "${2-}" ]] && { echo "Error: SCHEMA_NAME not specified"; usage; exit 1; }
SCHEMA_NAME=$2
[[ -z "${3-}" ]] && { echo "Error: OUTPUT_DIR not specified"; usage; exit 1; }
OUTPUT_DIR=$3

ADDITIONAL_ARGS=$(shift 3; echo ${*// /\\ })

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd)"
POM_FILE="${SCRIPT_DIR}/../../support/pom.xml"

MAIN_CLASS="com.xmlcalabash.drivers.Main" # XML Calabash

PIPELINE="${SCRIPT_DIR}/METASCHEMA-HTML-DOCS.xpl"

CALABASH_ARGS="-iMETASCHEMA=\"$METASCHEMA_XML\" $ADDITIONAL_ARGS \"$PIPELINE\" output-path=file:///${PWD}/$OUTPUT_DIR/ metaschema-id=$SCHEMA_NAME"

mvn \
    -f "$POM_FILE" \
    exec:java \
    -Dexec.mainClass="$MAIN_CLASS" \
    -Dexec.args="${CALABASH_ARGS}"

if [ -d "$OUTPUT_DIR" ]
then 
    echo "Results can be found in $OUTPUT_DIR"
fi
