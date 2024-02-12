#!/usr/bin/env bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../common/subcommand_common.bash

source "$SCRIPT_DIR/../../../common/subcommand_common.bash"

# XProc produces Inspector XSLT with a fail-safe check by compiling and running it
XPROC_FILE="file:${SCRIPT_DIR}/CURRENT-TEST-MODELS-REFRESH.xpl"

usage() {
    cat <<EOF
Usage: ${BASE_COMMAND:-$(basename "${BASH_SOURCE[0]}")} [ADDITIONAL_ARGS]

Refreshes InspectorXSLT and XSD for test models, placing them in 'current'.

The process fails if either an XSLT or an XSD cannot be produced.

See pipeline CURRENT-TEST-MODELS-REFRESH.xpl for dependencies.

EOF
}

ADDITIONAL_ARGS=$(echo "${*// /\\ }")

# -iMETASCHEMA=computer_metaschema.xml  -iMETASCHEMA=tiny_metaschema.xml
CALABASH_ARGS="$ADDITIONAL_ARGS \"${XPROC_FILE}\""

# echo  "${CALABASH_ARGS}"
invoke_calabash "${CALABASH_ARGS}"
# invoke_calabash "-iMETASCHEMA=computer_metaschema.xml -iMETASCHEMA=tiny_metaschema.xml "${CALABASH_ARGS}"

echo Current test models refreshed - InspectorXSLT and XSD - check 'current'
