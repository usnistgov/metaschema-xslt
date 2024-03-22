#!/usr/bin/env bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../common/subcommand_common.bash

source "$SCRIPT_DIR/../../common/subcommand_common.bash"

usage() {
    cat <<EOF
Usage: ${BASE_COMMAND:-$(basename "${BASH_SOURCE[0]}")} [ADDITIONAL_ARGS]

Generates XSD and JSON Schema for the 'choices' test metaschema, file ./choices_metaschema.xml

Runs pipeline ../../schema-gen/METASCHEMA-ALL-SCHEMAS.xpl - qv for dependencies.

EOF
}

METASCHEMA_XML=choices_metaschema.xml

OUTPUT_DIR=current

SCHEMA_NAME=choices

ADDITIONAL_ARGS=$(echo "${*// /\\ }")

PIPELINE="${SCRIPT_DIR}/../../schema-gen/METASCHEMA-ALL-SCHEMAS.xpl"

XSD_FILE="${OUTPUT_DIR}/${SCHEMA_NAME}_schema.xsd"
JSONSCHEMA_FILE="${OUTPUT_DIR}/${SCHEMA_NAME}_schema.json"

CALABASH_ARGS="-iMETASCHEMA=\"$METASCHEMA_XML\" \
               -oINT_0_echo-input=/dev/null \
               -oINT_1_composed-metaschema=/dev/null \
               -oOUT_json-schema-xml=/dev/null \
               -oOUT_json-schema=\"$JSONSCHEMA_FILE\" \
               -oOUT_xml-schema=\"$XSD_FILE\" \
               $ADDITIONAL_ARGS \"$PIPELINE\""

# Ensure the output directory exists
mkdir -p "$OUTPUT_DIR"


## show usage if a first argument is '-h', expanding $1 to '' if not set
if [ "${1:-}" = '-h' ] || [ "${1:-}" = '--help' ];

then

  usage

else

if [ -e "$XSD_FILE" ]; then
    echo "Overwriting prior $XSD_FILE..." >&2
    rm -f "$XSD_FILE"
fi

if [ -e "$JSONSCHEMA_FILE" ]; then
    echo "Overwriting prior $JSONSCHEMA_FILE..." >&2
    rm -f "$JSONSCHEMA_FILE"
fi

invoke_calabash "${CALABASH_ARGS}"

if [ -e "$XSD_FILE" ] && [ -e "$JSONSCHEMA_FILE" ]; then
    echo "Wrote XSD to $XSD_FILE" >&2
    echo "Wrote JSON schema to $JSONSCHEMA_FILE" >&2
fi

fi
