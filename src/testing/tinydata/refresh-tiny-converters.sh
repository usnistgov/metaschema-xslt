#!/usr/bin/env bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../common/subcommand_common.bash

source "$SCRIPT_DIR/../../common/subcommand_common.bash"

usage() {
    cat <<EOF
Usage: ${BASE_COMMAND:-$(basename "${BASH_SOURCE[0]}")} [ADDITIONAL_ARGS]

Produces converter XSLTS for XML/JSON conversion from metaschema ./choices_metaschema.xml

Runs pipeline ../../converter-gen/METASCHEMA-ALL-CONVERTERS.xpl - qv for dependencies.

EOF
}

METASCHEMA_XML=tiny_metaschema.xml

OUTPUT_DIR=current

SCHEMA_NAME=tiny

ADDITIONAL_ARGS=$(echo "${*// /\\ }")

PIPELINE="${SCRIPT_DIR}/../../converter-gen/METASCHEMA-ALL-CONVERTERS.xpl"

XJ_CONVERTER="${OUTPUT_DIR}/${SCHEMA_NAME}_xml-to-json.xsl"
JX_CONVERTER="${OUTPUT_DIR}/${SCHEMA_NAME}_json-to-xml.xsl"

CALABASH_ARGS="-iMETASCHEMA=\"$METASCHEMA_XML\" \
               -oINT_0_echo-input=/dev/null \
               -oINT_1_composed-metaschema=/dev/null \
               -oINT_2_initial-model-map=/dev/null \
               -oINT_3_unfolded-model-map=/dev/null \
               -oINT_4_definition-model=/dev/null \
               -oINT_5X_xml-supermodel-converter=/dev/null \
               -oINT_5J_json-supermodel-converter=/dev/null \
               -oOUT_xml-to-json-converter=\"$XJ_CONVERTER\" \
               -oOUT_json-to-xml-converter=\"$JX_CONVERTER\" \
               $ADDITIONAL_ARGS \"$PIPELINE\""

# Ensure the output directory exists
mkdir -p "$OUTPUT_DIR"


## show usage if a first argument is '-h', expanding $1 to '' if not set
if [ "${1:-}" = '-h' ] || [ "${1:-}" = '--help' ];

then

  usage

else

if [ -e "$XJ_CONVERTER" ]; then
    echo "Overwriting prior $XJ_CONVERTER..." >&2
    rm -f "$XJ_CONVERTER"
fi

if [ -e "$JX_CONVERTER" ]; then
    echo "Overwriting prior $JX_CONVERTER..." >&2
    rm -f "$JX_CONVERTER"
fi

invoke_calabash "${CALABASH_ARGS}"

if [ -e "$XJ_CONVERTER" ] && [ -e "$JX_CONVERTER" ]; then
    echo "Wrote fresh XML/JSON conversion XSLTs into ${OUTPUT_DIR}" >&2
fi

fi
