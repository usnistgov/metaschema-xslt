#!/usr/bin/env bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../common/subcommand_common.bash

source "$SCRIPT_DIR/../../../src/common/subcommand_common.bash"

XPROC_FILE="${SCRIPT_DIR}/xspec-test-batch.xpl"

usage() {
    cat <<EOF
Usage: ${BASE_COMMAND:-$(basename "${BASH_SOURCE[0]}")}

Runs $( echo ${XPROC_FILE##*/} ), returning a one-line summary evaluation of its XSpec test set inputs.
EOF
}

# dumping XSpec results and summary (ports), leaving port `determination` for STDOUT

CALABASH_ARGS="-oxspec-results=/dev/null -osummary=/dev/null \"${XPROC_FILE}\""

if [ $# -ne 0 ] ; then
  usage
else
  invoke_calabash "${CALABASH_ARGS}"
fi
