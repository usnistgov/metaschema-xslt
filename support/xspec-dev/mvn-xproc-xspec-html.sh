#!/usr/bin/env bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../common/subcommand_common.bash

source "$SCRIPT_DIR/../../src/common/subcommand_common.bash"

XPROC_FILE="${SCRIPT_DIR}/xspec-single-report.xpl"

usage() {
    cat <<EOF
Usage: ${BASE_COMMAND:-$(basename "${BASH_SOURCE[0]}")} XSPEC_FILE [ADDITIONAL_ARGS]

Applies XSpec Xproc to XSpec file and produces an HTML report of the test results.

Additional arguments for XML Calabash should be specified in the 'key=value' format,
EOF
}

[[ -z "${1-}" ]] && { echo "Error: XSPEC_FILE not specified"; usage; exit 1; }
XSPEC_FILE=$1

ADDITIONAL_ARGS=$(shift 1; echo "${*// /\\ }")

RESULT_FILE="xspec/$( echo $(basename "${XSPEC_FILE%.*}") ).html"

CALABASH_ARGS="-ixspec=\"$XSPEC_FILE\" -oxspec-result=/dev/null -ohtml-report=\"${RESULT_FILE}\" \
                $ADDITIONAL_ARGS \"${XPROC_FILE}\""

mkdir -p xspec

invoke_calabash "${CALABASH_ARGS}"
