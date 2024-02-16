#!/usr/bin/env bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../common/subcommand_common.bash

source "$SCRIPT_DIR/../../../common/subcommand_common.bash"

# XProc produces Inspector XSLT with a fail-safe check by compiling and running it
XPROC_FILE="${SCRIPT_DIR}/XSD-VALIDATE-COMPUTER-SAMPLES.xpl"

usage() {
    cat <<EOF
Usage: ${BASE_COMMAND:-$(basename "${BASH_SOURCE[0]}")} [ADDITIONAL_ARGS]

Produces a validation report for a file set designated in the pipeline \"${XPROC_FILE}\" 
EOF
}

ADDITIONAL_ARGS=$(echo "${*// /\\ }")

CALABASH_ARGS="-osurvey=/dev/null $ADDITIONAL_ARGS \"${XPROC_FILE}\""

# echo "${CALABASH_ARGS}"

invoke_calabash "${CALABASH_ARGS}"

echo GAMBARIMASU!