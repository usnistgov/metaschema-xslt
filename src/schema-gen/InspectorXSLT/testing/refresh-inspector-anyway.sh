#!/usr/bin/env bash

# This script produces an Inspector XSLT, except for a metaschema designated at runtime.
# Like refresh-computer-inspector-saxon.sh, it bypasses the XSLT-checking, so GIGO (useful for diagnostics).
# The resulting XSLT is suffixed 'X' in the file (base) name to indicate its untested status.
# Maven is required on your system PATH.

# Fail early if an error occurs
set -Eeuo pipefail

usage() {
    cat <<EOF
Usage: $(basename "${BASH_SOURCE[0]}") METASCHEMA_SOURCE [ADDITIONAL_ARGS]

Writes an InspectorXSLT for metaschema METASCHEMA_SOURCE, without testing it, in the 'current' directory

The resulting XSLT is named after the source file with suffix '-inspectorX'

Use this script to produce an XSLT from a metaschema for diagnostics

Additional arguments are provided to SaxonHE - see https://www.saxonica.com/documentation11/#!using-xsl/commandline
EOF
}


if ! [ -x "$(command -v mvn)" ]; then
  echo 'Error: Maven (mvn) is not in the PATH, is it installed?' >&2
  exit 1
fi

[[ -z "${1-}" ]] && { echo "Error: METASCHEMA_SOURCE not specified"; usage; exit 1; }
METASCHEMA_SOURCE=$1

if [ ! -f "${METASCHEMA_SOURCE}" ]; then
    echo "${METASCHEMA_SOURCE} not found."
fi

XSLT_RESULT=current/$(basename "$METASCHEMA_SOURCE" .xml)-inspectorX.xsl

ADDITIONAL_ARGS=$(shift 1; echo ${*// /\\ })

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd)"
POM_FILE="${SCRIPT_DIR}/../../../../support/pom.xml"

MAIN_CLASS="net.sf.saxon.Transform" # Saxon defined in pom.xml

if [ -e "$XSLT_RESULT" ]
then 
    echo "Deleting prior $XSLT_RESULT ..."
    rm -f ./$XSLT_RESULT
fi

mvn \
    -quiet \
    -f "$POM_FILE" \
    exec:java \
    -Dexec.mainClass="$MAIN_CLASS" \
    -Dexec.args="-xsl:${SCRIPT_DIR}/../../nist-metaschema-MAKE-INSPECTOR-XSLT.xsl -s:\"$METASCHEMA_SOURCE\" -o:\"$XSLT_RESULT\" $ADDITIONAL_ARGS"

if [ -e "$XSLT_RESULT" ]
then 
    echo "XSLT written to file $XSLT_RESULT"
fi
