#!/usr/bin/env bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../common/subcommand_common.bash
source "$SCRIPT_DIR/../common/subcommand_common.bash"

usage() {
    cat <<EOF
Usage: ${BASE_COMMAND:-$(basename "${BASH_SOURCE[0]}")} METASCHEMA_XML [ADDITIONAL_ARGS]

Validates a metaschema document instance (top-level or component module) by validating against the Metaschema XSD

EOF
}

[[ -z "${1-}" ]] && { echo "Error: METASCHEMA_XML not specified"; usage; exit 1; }
METASCHEMA_XML=$1

ADDITIONAL_ARGS=$(shift 1; echo "${*// /\\ }")

PIPELINE="${SCRIPT_DIR}/METASCHEMA-XSD-VALIDATE.xpl"

CALABASH_ARGS="-iMETASCHEMA=\"$METASCHEMA_XML\" \
               $ADDITIONAL_ARGS \"$PIPELINE\""

invoke_calabash "${CALABASH_ARGS}"
