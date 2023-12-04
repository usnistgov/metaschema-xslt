#!/usr/bin/env bash

# Fail early if an error occurs
set -Eeuo pipefail

usage() {
    cat <<EOF
Usage: $(basename "${BASH_SOURCE[0]}") METASCHEMA_SOURCE XSLT_RESULT [ADDITIONAL_ARGS]

Produces an XSLT Transformation (Stylesheet) from a valid and well-ordered NIST (ITL/CSD)
metaschema (Metaschema instance) using Saxon invoked from Maven. When applied to an XML document,
this XSLT performs a set of tests (validations) of constraints defined by the Metaschema source.

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
[[ -z "${2-}" ]] && { echo "Error: XSLT_RESULT not specified"; usage; exit 1; }
XSLT_RESULT=$2

ADDITIONAL_ARGS=$(shift 2; echo ${*// /\\ })

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd)"
POM_FILE="${SCRIPT_DIR}/../../support/pom.xml"

MAIN_CLASS="net.sf.saxon.Transform" # Saxon defined in pom.xml

if [ -e "$XSLT_RESULT" ]
then 
    echo "Deleting prior $XSLT_RESULT ..."
    rm -f ./$XSLT_RESULT
fi

mvn \
    -f "$POM_FILE" \
    exec:java \
    -Dexec.mainClass="$MAIN_CLASS" \
    -Dexec.args="-xsl:${SCRIPT_DIR}/nist-metaschema-MAKE-INSPECTOR-XSLT.xsl -s:\"$METASCHEMA_SOURCE\" -o:\"$XSLT_RESULT\" $ADDITIONAL_ARGS"

if [ -e "$XSLT_RESULT" ]
then 
    echo "XSLT transformation written to file $XSLT_RESULT"
fi
