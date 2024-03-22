#!/usr/bin/env bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../common/subcommand_common.bash

# source "$SCRIPT_DIR/../common/subcommand_common.bash"

# XProc produces Inspector XSLT with a fail-safe check by compiling and running it
XPROC_FILE="${SCRIPT_DIR}/XSD-VALIDATE-OSCAL-SAMPLES.xpl"

usage() {
    cat <<EOF
Usage: ${BASE_COMMAND:-$(basename "${BASH_SOURCE[0]}")} [ADDITIONAL_ARGS]

Produces a validation report for a JSON file set designated in the pipeline JSON-VALIDATE-CHOICES.xp3

Get this message with first argument '--help' or '-h'

Otherwise arguments are passed to XML Calabash, so take care (YMMV)

EOF
}

ADDITIONAL_ARGS=$(echo "${*// /\\ }")

CALL_MORGANA=../../../support/lib/MorganaXProc-IIIse-1.3.6/Morgana.sh

PIPELINE3=JSON-VALIDATE-CHOICES.xp3

MORGANA_ARGS="$PIPELINE3 -xslt-connector=saxon12-3 $ADDITIONAL_ARGS"

## show usage if a first argument is '-h', expanding $1 to '' if not set
if [ "${1:-}" = '-h' ] || [ "${1:-}" = '--help' ];

then

  usage

else

  echo \[INITIATING JSON Schema cross-checking\]
  ${CALL_MORGANA} ${MORGANA_ARGS}

fi

# echo \"The future is here, but unevenly distributed\" \(paraphrasing William Gibson\)
echo \[COMPLETED JSON Schema cross-checking\]