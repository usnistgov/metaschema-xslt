#!/usr/bin/env bash

# Fail early if an error occurs
set -Eeuo pipefail

usage() {
    cat <<EOF
Usage: $(basename "${BASH_SOURCE[0]}") METASCHEMA_XML SCHEMA_NAME OUTPUT_DIR [ADDITIONAL_ARGS]

Produces schema documentation from Metaschema XML source, using XML Calabash invoked from Maven.
This script uses the 'traceable' XProc for configurability.
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

PIPELINE="${SCRIPT_DIR}/METASCHEMA-DOCS-TRACE.xpl"

CALABASH_ARGS="-iMETASCHEMA=\"$METASCHEMA_XML\" \
               -oINT_0_echo-input=/dev/null \
               -oINT_1_composed=/dev/null \
               -oINT_2_abstract-model-map=/dev/null \
               -oINT_3_unfolded-instance-map=/dev/null \
               -oINT_4_marked-instance-map=/dev/null \
               -oJSON-object-tree-xml=/dev/null \
               -oJSON-object-map-html=$OUTPUT_DIR/$SCHEMA_NAME-json-outline.html \
               -oJSON-object-reference-html=$OUTPUT_DIR/$SCHEMA_NAME-json-reference.html \
               -oJSON-object-index-html=$OUTPUT_DIR/$SCHEMA_NAME-json-index.html \
               -oJSON-definitions-html=$OUTPUT_DIR/$SCHEMA_NAME-json-definitions.html \
               -oXML-element-tree-xml=/dev/null \
               -oXML-element-map-html=$OUTPUT_DIR/$SCHEMA_NAME-xml-outline.html \
               -oXML-element-reference-html=$OUTPUT_DIR/$SCHEMA_NAME-xml-reference.html \
               -oXML-element-index-html=$OUTPUT_DIR/$SCHEMA_NAME-xml-index.html \
               -oXML-definitions-html=$OUTPUT_DIR/$SCHEMA_NAME-xml-definitions.html \
               $ADDITIONAL_ARGS \"$PIPELINE\" \
               output-path=$OUTPUT_DIR \
               metaschema-id=$SCHEMA_NAME"

mvn \
    -f "$POM_FILE" \
    exec:java \
    -Dexec.mainClass="$MAIN_CLASS" \
    -Dexec.args="${CALABASH_ARGS}"

if [ -d "$OUTPUT_DIR" ]
then 
    echo "Results can be found in $OUTPUT_DIR"
fi
