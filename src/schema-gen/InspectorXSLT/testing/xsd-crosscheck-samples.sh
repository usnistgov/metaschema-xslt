#!/usr/bin/env bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../common/subcommand_common.bash

source "$SCRIPT_DIR/../../../common/subcommand_common.bash"

# XProc produces Inspector XSLT with a fail-safe check by compiling and running it
XPROC_FILE="${SCRIPT_DIR}/XSD-VALIDATE-COMPUTER-SAMPLES.xpl"

usage() {
    cat <<EOF
Usage: ${BASE_COMMAND:-$(basename "${BASH_SOURCE[0]}")} [ADDITIONAL_ARGS]

Produces a validation report for a file set designated in the pipeline XSD-VALIDATE-COMPUTER-SAMPLES.xpl

Get this message with first argument '--help' or '-h'

Otherwise arguments are passed to XML Calabash, so take care (YMMV)

EOF
}

ADDITIONAL_ARGS=$(echo "${*// /\\ }")

CALABASH_ARGS="-osurvey=/dev/null $ADDITIONAL_ARGS \"${XPROC_FILE}\""

# echo "${CALABASH_ARGS}"

## show usage if a first argument is '-h', expanding $1 to '' if not set
if [ "${1:-}" = '-h' ] || [ "${1:-}" = '--help' ];

then

  usage

else

  invoke_calabash "${CALABASH_ARGS}"

fi

echo GAMBARIMASU!