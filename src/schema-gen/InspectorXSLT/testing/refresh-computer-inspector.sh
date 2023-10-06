#!/usr/bin/env bash

# Fail early if an error occurs
set -Eeuo pipefail

usage() {
    cat <<EOF
Usage: $(basename "${BASH_SOURCE[0]}") [ADDITIONAL_ARGS]

Refreshes current/computer_inspector.xsl

Additional arguments are provided to SaxonHE - see https://www.saxonica.com/documentation11/#!using-xsl/commandline
EOF
}

if ! [ -x "$(command -v mvn)" ]; then
  echo 'Error: Maven (mvn) is not in the PATH, is it installed?' >&2
  exit 1
fi

METASCHEMA_SOURCE=computer_metaschema.xml

XSLT_RESULT=current/computer_inspector.xsl

ADDITIONAL_ARGS=$(echo ${*// /\\ })

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
