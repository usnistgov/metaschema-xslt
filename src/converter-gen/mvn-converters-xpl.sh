#!/usr/bin/env bash

# Fail early if an error occurs
set -Eeuo pipefail

usage() {
    cat <<EOF
Usage: $(basename "${BASH_SOURCE[0]}") METASCHEMA_XML SCHEMA_NAME [ADDITIONAL_ARGS]

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
[[ -z "${2-}" ]] && { echo "Error: SCHEMA_NAME not specified"; usage; exit 1; }
SCHEMA_NAME=$2

ADDITIONAL_ARGS=$(shift 2; echo ${*// /\\ })

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd)"
POM_FILE="${SCRIPT_DIR}/../../support/pom.xml"

MAIN_CLASS="com.xmlcalabash.drivers.Main" # XML Calabash

PIPELINE="${SCRIPT_DIR}/METASCHEMA-ALL-SCHEMAS.xpl"


XMLTOJSON_CONVERTER_FILE="${SCHEMA_NAME}-xml-to-json.xsl"

JSONTOXML_CONVERTER_FILE="${SCHEMA_NAME}-json-to-xml.xsl"

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
               -oOUT_json-schema-xml=/dev/null \
               -oOUT_json-schema=\"$JSONSCHEMA_FILE\" \
               -oOUT_xml-schema=\"$XSD_FILE\" \
                $ADDITIONAL_ARGS \"$PIPELINE\""

if [ -e "$XSD_FILE" ]
then 
    echo "Deleting prior $XSD_FILE ..."
    rm -f ./$XSD_FILE
fi
if [ -e "$JSONSCHEMA_FILE" ]
then 
    echo "Deleting prior $JSONSCHEMA_FILE ..."
    rm -f ./$JSONSCHEMA_FILE
fi

mvn \
    -f "$POM_FILE" \
    exec:java \
    -Dexec.mainClass="$MAIN_CLASS" \
    -Dexec.args="${CALABASH_ARGS}"

if [ -e "$XSD_FILE" -a -e "$JSONSCHEMA_FILE" ]
then 
    echo "Results can be found in $XSD_FILE and $JSONSCHEMA_FILE"
fi
