#!/usr/bin/env bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../common/subcommand_common.bash

source "$SCRIPT_DIR/../../common/subcommand_common.bash"

usage() {
    cat <<EOF
Usage: ${BASE_COMMAND:-$(basename "${BASH_SOURCE[0]}")} JSON_FILE [ADDITIONAL_ARGS]

Applies Morgana XProc III processor to determine validity against the current 'choices' JSON Schema

EOF
}

[[ -z "${1-}" ]] && { echo "Error: XProc 3 pipeline not specified"; usage; exit 1; }
JSON_FILE=$1


ADDITIONAL_ARGS=$(shift 1; echo "${*// /\\ }")

PIPELINE3=validate-tiny-json.xp3

MORGANA_ARGS="$PIPELINE3 -input:json-in=${JSON_FILE} $ADDITIONAL_ARGS"
               
../../../support/lib/MorganaXProc-IIIse-1.3.6/Morgana.sh ${MORGANA_ARGS}
