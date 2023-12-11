#!/usr/bin/env bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../common/subcommand_common.bash

source "$SCRIPT_DIR/../../src/common/subcommand_common.bash"

XSPEC_DIR="${SCRIPT_DIR}/../xspec/src"
XPROC_HARNESS="${XSPEC_DIR}/harnesses/saxon/saxon-xslt-harness.xproc"

usage() {
    cat <<EOF
Usage: ${BASE_COMMAND:-$(basename "${BASH_SOURCE[0]}")} XSPEC_FILE [ADDITIONAL_ARGS]

Applies XSpec Xproc to XSpec file and delivers HTML result

Additional arguments for XML Calabash should be specified in the 'key=value' format.
EOF
}

[[ -z "${1-}" ]] && { echo "Error: XSPEC_FILE not specified"; usage; exit 1; }
XSPEC_FILE=$1

ADDITIONAL_ARGS=$(shift 1; echo "${*// /\\ }")

RESULT_FILE="xspec/$( echo $(basename "${XSPEC_FILE%.*}") ).html"

# -pxspec-home addresses https://github.com/xspec/xspec/issues/1832
CALABASH_ARGS="-isource=\"$XSPEC_FILE\" -oresult=\"${RESULT_FILE}\" -pxspec-home=\"file://${XSPEC_DIR}\" \
                $ADDITIONAL_ARGS \"${XPROC_HARNESS}\""

mkdir -p xspec

invoke_calabash "${CALABASH_ARGS}"
