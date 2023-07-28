#!/usr/bin/env bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../common/subcommand_common.bash
source "$SCRIPT_DIR/../common/subcommand_common.bash"

usage() {
    cat <<EOF
Usage: ${BASE_COMMAND:-$(basename "${BASH_SOURCE[0]}")} METASCHEMA_XML [ADDITIONAL_ARGS]

Produces 'all is well' messages, or errors out.

Errors result
  if the metaschema input fails to produce a valid XSD (as XSD using the XSD schema)
  if the metaschema input fails to produce a functional XSD (validating a stub)

Additional arguments for XML Calabash should be specified in the 'key=value' format.
EOF
}

[[ -z "${1-}" ]] && { echo "Error: METASCHEMA_XML not specified"; usage; exit 1; }
METASCHEMA_XML=$1

ADDITIONAL_ARGS=$(shift 1; echo "${*// /\\ }")


CALABASH_ARGS0="-iMETASCHEMA=\"$METASCHEMA_XML\" -oOUT_XSD=/dev/null \
                 $ADDITIONAL_ARGS \"${SCRIPT_DIR}/METASCHEMA-XSD-VALIDATE.xpl\""
CALABASH_ARGS1="-iMETASCHEMA=\"$METASCHEMA_XML\" -oOUT_XSD=/dev/null \
                $ADDITIONAL_ARGS \"${SCRIPT_DIR}/METASCHEMA-XSD-TEST.xpl\""

invoke_calabash "${CALABASH_ARGS0}"
invoke_calabash "${CALABASH_ARGS1}"
