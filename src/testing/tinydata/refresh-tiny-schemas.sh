#!/usr/bin/env bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../common/subcommand_common.bash

source "$SCRIPT_DIR/../../common/subcommand_common.bash"

usage() {
    cat <<EOF
Usage: ${BASE_COMMAND:-$(basename "${BASH_SOURCE[0]}")} [ADDITIONAL_ARGS]

Generates XSD and JSON Schema for the 'choices' test metaschema, file ./choices_metaschema.xml

Runs pipeline ../../schema-gen/METASCHEMA-ALL-VALIDATORS.xpl - qv for dependencies.

EOF
}

METASCHEMA_XML=tiny_metaschema.xml

OUTPUT_DIR=current

SCHEMA_NAME=tiny

ADDITIONAL_ARGS=$(echo "${*// /\\ }")

PIPELINE="${SCRIPT_DIR}/../../schema-gen/METASCHEMA-ALL-VALIDATORS.xpl"

COMPOSED_METASCHEMA="${OUTPUT_DIR}/${SCHEMA_NAME}_COMPOSED.xml"
XSD_FILE="${OUTPUT_DIR}/${SCHEMA_NAME}_schema.xsd"
JSONSCHEMA_FILE="${OUTPUT_DIR}/${SCHEMA_NAME}_schema.json"
JSONSCHEMA_XMLFILE="${OUTPUT_DIR}/${SCHEMA_NAME}_json-schema.xml"
INSPECTORXSLT_FILE="${OUTPUT_DIR}/${SCHEMA_NAME}_inspector.xsl"

CALABASH_ARGS="-iMETASCHEMA=\"$METASCHEMA_XML\" \
               -oINT_0_echo-input=/dev/null \
               -oINT_1_composed-metaschema=\"$COMPOSED_METASCHEMA\" \
               -oOUT_json-schema-xml=\"$JSONSCHEMA_XMLFILE\" \
               -oOUT_json-schema=\"$JSONSCHEMA_FILE\" \
               -oOUT_xml-schema=\"$XSD_FILE\" \
               -oOUT_inspector-xsl=\"$INSPECTORXSLT_FILE\" \
               $ADDITIONAL_ARGS \"$PIPELINE\""

# Ensure the output directory exists
mkdir -p "$OUTPUT_DIR"


## show usage if a first argument is '-h', expanding $1 to '' if not set
if [ "${1:-}" = '-h' ] || [ "${1:-}" = '--help' ];

then

  usage

else

if [ -e "$COMPOSED_METASCHEMA" ]; then
    echo "Overwriting prior $COMPOSED_METASCHEMA..." >&2
    rm -f "$COMPOSED_METASCHEMA"
fi

if [ -e "$XSD_FILE" ]; then
    echo "Overwriting prior $XSD_FILE..." >&2
    rm -f "$XSD_FILE"
fi

if [ -e "$JSONSCHEMA_FILE" ]; then
    echo "Overwriting prior $JSONSCHEMA_FILE..." >&2
    rm -f "$JSONSCHEMA_FILE"
fi

if [ -e "$JSONSCHEMA_XMLFILE" ]; then
    echo "Overwriting prior $JSONSCHEMA_XMLFILE..." >&2
    rm -f "$JSONSCHEMA_XMLFILE"
fi

if [ -e "$INSPECTORXSLT_FILE" ]; then
    echo "Overwriting prior $INSPECTORXSLT_FILE..." >&2
    rm -f "$INSPECTORXSLT_FILE"
fi


# echo  "${CALABASH_ARGS}"
 
invoke_calabash "${CALABASH_ARGS}"

if [ -e "$XSD_FILE" ] && [ -e "$JSONSCHEMA_FILE" ] && [ -e "$INSPECTORXSLT_FILE" ]; then
    echo "Wrote composed metaschema (de-referenced input) to $COMPOSED_METASCHEMA" >&2
    echo "Wrote XSD to $XSD_FILE" >&2
    echo "Wrote JSON schema to $JSONSCHEMA_FILE" >&2
    echo "Wrote JSON schema (XML notation) to $JSONSCHEMA_XMLFILE" >&2
    echo "Wrote Inspector XSLT to $INSPECTORXSLT_FILE" >&2
fi

fi
