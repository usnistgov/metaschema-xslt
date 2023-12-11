#!/usr/bin/env bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../common/subcommand_common.bash

source "$SCRIPT_DIR/../../../src/common/subcommand_common.bash"

XPROC_FILE="${SCRIPT_DIR}/xspec-test-batch.xpl"

usage() {
    cat <<EOF
Usage: ${BASE_COMMAND:-$(basename "${BASH_SOURCE[0]}")} [ADDITIONAL_ARGS]

Runs ${XPROC_FILE} echoing a summary determination of its XSpec test suites. 

Additional arguments for XML Calabash should be specified in the 'key=value' format.
EOF
}

ADDITIONAL_ARGS=$(echo "${*// /\\ }")

# dumping XSpec results and summary (ports), leaving synopsis for STDOUT

CALABASH_ARGS="-oxspec-results=/dev/null -osummary=/dev/null \
                $ADDITIONAL_ARGS \"${XPROC_FILE}\""

invoke_calabash "${CALABASH_ARGS}"
