#!/usr/bin/env bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../common/subcommand_common.bash
source "$SCRIPT_DIR/../common/subcommand_common.bash"

usage() {
    cat <<EOF
Usage: ${BASE_COMMAND:-$(basename "${BASH_SOURCE[0]}")} METASCHEMA_XML OUTPUT_DIR SCHEMA_NAME [ADDITIONAL_ARGS]

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
[[ -z "${2-}" ]] && { echo "Error: OUTPUT_DIR not specified"; usage; exit 1; }
OUTPUT_DIR=$2
[[ -z "${3-}" ]] && { echo "Error: SCHEMA_NAME not specified"; usage; exit 1; }
SCHEMA_NAME=$3

ADDITIONAL_ARGS=$(shift 3; echo ${*// /\\ })

PIPELINE="${SCRIPT_DIR}/METASCHEMA-DOCS-TESTSITE-write.xpl"

CALABASH_ARGS="-iMETASCHEMA=\"$METASCHEMA_XML\" $ADDITIONAL_ARGS \"$PIPELINE\" output-path=file:///${PWD}/$OUTPUT_DIR/ metaschema-id=$SCHEMA_NAME"

# Possible enhancement to script: create/cleanup $OUTPUT_DIR before writing to it.


invoke_calabash "${CALABASH_ARGS}"

if [ -d "$OUTPUT_DIR" ]
then 
    echo "Results can be found in $OUTPUT_DIR"
fi
