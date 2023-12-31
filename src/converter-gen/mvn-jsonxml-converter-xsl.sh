#!/usr/bin/env bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd)"
# shellcheck source=../common/subcommand_common.bash
source "$SCRIPT_DIR/../common/subcommand_common.bash"

usage() {
    cat <<EOF
Usage: $(basename "${BASH_SOURCE[0]}") METASCHEMA_SOURCE XSL_RESULT [ADDITIONAL_ARGS]

Produces an XSLT (stylesheet) from a valid and well-ordered NIST (ITL/CSD) metaschema (Metaschema instance) using Saxon invoked from Maven.
The resulting XSLT is capable of converting JSON valid to metaschema-defined models into equivalent XML valid to the same model.
Please install Maven first.

Additional arguments are provided to SaxonHE - see https://www.saxonica.com/documentation11/#!using-xsl/commandline
EOF
}

if ! [ -x "$(command -v mvn)" ]; then
  echo 'Error: Maven (mvn) is not in the PATH, is it installed?' >&2
  exit 1
fi

[[ -z "${1-}" ]] && { echo "Error: METASCHEMA_SOURCE not specified"; usage; exit 1; }
METASCHEMA_SOURCE=$1
[[ -z "${2-}" ]] && { echo "Error: XSL_RESULT not specified"; usage; exit 1; }
XSL_RESULT=$2

ADDITIONAL_ARGS=$(shift 2; echo "${*// /\\ }")

if [ -e "$XSL_RESULT" ]
then 
    echo "Deleting prior $XSL_RESULT ..."
    rm -f ./$XSL_RESULT
fi

invoke_saxon "-xsl:${SCRIPT_DIR}/nist-metaschema-MAKE-JSON-TO-XML-CONVERTER.xsl -s:\"$METASCHEMA_SOURCE\" -o:\"$XSL_RESULT\" $ADDITIONAL_ARGS"

if [ -e "$XSL_RESULT" ]
then 
    echo "XSLT instance written to file $XSL_RESULT"
fi
