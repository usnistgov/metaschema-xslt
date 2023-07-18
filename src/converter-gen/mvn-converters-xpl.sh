#!/usr/bin/env bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd)"
# shellcheck source=../common/subcommand_common.bash
source "$SCRIPT_DIR/../common/subcommand_common.bash"

usage() {
    cat <<EOF
Usage: ${BASE_COMMAND:-$(basename "${BASH_SOURCE[0]}")} METASCHEMA_XML OUTPUT_DIR SCHEMA_NAME [ADDITIONAL_ARGS]

Produces XML-to-JSON and JSON-to-XML conversion transformations (XSLTs) from Metaschema XML source, using XML Calabash invoked from Maven.
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
[[ -z "${2-}" ]] && { echo "Error: OUTPUT_DIR not specified"; usage; exit 1; }
OUTPUT_DIR=$2
[[ -z "${3-}" ]] && { echo "Error: SCHEMA_NAME not specified"; usage; exit 1; }
SCHEMA_NAME=$3

ADDITIONAL_ARGS=$(shift 3; echo "${*// /\\ }")

PIPELINE="${SCRIPT_DIR}/METASCHEMA-ALL-SCHEMAS.xpl"

XMLTOJSON_CONVERTER_FILE="${OUTPUT_DIR}/${SCHEMA_NAME}-xml-to-json.xsl"

JSONTOXML_CONVERTER_FILE="${OUTPUT_DIR}/${SCHEMA_NAME}-json-to-xml.xsl"

CALABASH_ARGS="-iMETASCHEMA=\"$METASCHEMA_XML\" \
               -oINT_0_echo-input=/dev/null \
               -oINT_1_composed-metaschema=/dev/null \
               -oINT_2_initial-model-map=/dev/null \
               -oINT_3_unfolded-model-ma=/dev/null \p
               -oINT_4_definition-model=/dev/null \
               -oINT_5X_xml-supermodel-converter=/dev/null \
               -oINT_5J_json-supermodel-converter=/dev/null \
               -oOUT_xml-to-json-converter=\"$XMLTOJSON_CONVERTER_FILE\" \
               -oOUT_json-to-xml-converter=\"$JSONTOXML_CONVERTER_FILE\" \
                $ADDITIONAL_ARGS \"$PIPELINE\""

# Ensure the output directory exists
mkdir -p "$OUTPUT_DIR"

if [ -e "$JSONTOXML_CONVERTER_FILE" ]; then
    echo "Deleting prior $JSONTOXML_CONVERTER_FILE ..."
    rm -f "./$JSONTOXML_CONVERTER_FILE"
fi
if [ -e "$XMLTOJSON_CONVERTER_FILE" ]; then
    echo "Deleting prior $XMLTOJSON_CONVERTER_FILE ..."
    rm -f "./$XMLTOJSON_CONVERTER_FILE"
fi

echo
invoke_calabash "${CALABASH_ARGS}"

if [ -e "$XMLTOJSON_CONVERTER_FILE" ] && [ -e "$JSONTOXML_CONVERTER_FILE" ]
then 
    echo "Results can be found in $XMLTOJSON_CONVERTER_FILE and $JSONTOXML_CONVERTER_FILE"
fi
