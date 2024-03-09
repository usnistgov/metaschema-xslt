#!/usr/bin/env bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../common/subcommand_common.bash
source "$SCRIPT_DIR/../common/subcommand_common.bash"

usage() {
    cat <<EOF
Usage: ${BASE_COMMAND:-$(basename "${BASH_SOURCE[0]}")} METASCHEMA_XML OUTPUT_DIR SCHEMA_NAME [ADDITIONAL_ARGS]

Produces XML Schema (XSD) and JSON Schema from Metaschema XML source, using XML Calabash invoked from Maven.

SCHEMA_NAME specifies the prefix output files will be written to, for example:
    a-metaschema -> a-metaschema_schema.xsd, a-metaschema_schema.json

Additional arguments for XML Calabash should be specified in the 'key=value' format.
EOF
}

[[ -z "${1-}" ]] && { echo "Error: METASCHEMA_XML not specified"; usage; exit 1; }
METASCHEMA_XML=$1
[[ -z "${2-}" ]] && { echo "Error: OUTPUT_DIR not specified"; usage; exit 1; }
OUTPUT_DIR=$2
[[ -z "${3-}" ]] && { echo "Error: SCHEMA_NAME not specified"; usage; exit 1; }
SCHEMA_NAME=$3

ADDITIONAL_ARGS=$(shift 3; echo "${*// /\\ }")

PIPELINE="${SCRIPT_DIR}/METASCHEMA-ALL-SCHEMAS.xpl"

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

if [ -e "$XSD_FILE" ]; then
    echo "Overwriting prior $XSD_FILE..." >&2
    rm -f "$XSD_FILE"
fi

if [ -e "$JSONSCHEMA_FILE" ]; then
    echo "Overwriting prior $JSONSCHEMA_FILE..." >&2
    rm -f "$JSONSCHEMA_FILE"
fi

invoke_calabash "${CALABASH_ARGS}"


# Check if npm is installed
if ! command -v npm &> /dev/null; then
    echo "npm is not installed. Please install Node.js and npm."
    exit 1
else
    echo "npm is installed."
fi
# Check if ajv-formats is installed
if ! npm list -g ajv-formats &> /dev/null; then
    echo "ajv-formats is not installed. Installing..."
    npm install -g ajv-formats
else
    echo "ajv-formats is installed."
fi

# Check if ajv-cli is installed
if ! npm list -g ajv-cli &> /dev/null; then
    echo "ajv-cli is not installed. Installing..."
    npm install -g ajv-cli
else
    echo "ajv-cli is installed."
fi

if [ -e "$XSD_FILE" ] && [ -e "$JSONSCHEMA_FILE" ]; then
    echo "Wrote XSD to $XSD_FILE" >&2
    echo "Wrote JSON schema to $JSONSCHEMA_FILE" >&2
    if [ -e "$JSONSCHEMA_FILE" ]; then
        ajv compile -s "$JSONSCHEMA_FILE" -c ajv-formats
        if [ $? -eq 0 ]; then
            echo "JSON schema is valid."
        else
            echo "JSON schema is invalid."
            exit 1
        fi
    else
        echo "JSON schema file $JSONSCHEMA_FILE does not exist."
        exit 1
    fi
fi
