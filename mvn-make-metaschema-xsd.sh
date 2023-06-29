#!/usr/bin/env bash

# Fail early if an error occurs
set -Eeuo pipefail

usage() {
    cat <<EOF
Usage: $(basename "${BASH_SOURCE[0]}") METASCHEMA_SOURCE XSD_RESULT [ADDITIONAL_ARGS]

Produces an XSD (XML Schema Definition) from a valid and well-ordered NIST (ITL/CSD) metaschema (Metaschema instance) using Saxon invoked from Maven.
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
[[ -z "${2-}" ]] && { echo "Error: XSD_RESULT not specified"; usage; exit 1; }
XSD_RESULT=$2

ADDITIONAL_ARGS=$(shift 2; echo ${*// /\\ })

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd)"
POM_FILE="${SCRIPT_DIR}/support/pom.xml"

MAIN_CLASS="net.sf.saxon.Transform" # Saxon defined in pom.xml

if [ -e "$XSD_RESULT" ]
then 
    echo "Deleting prior $XSD_RESULT ..."
    rm -f ./$XSD_RESULT
fi

# mvn  -f ../pom.xml exec:java -Dexec.mainClass="com.xmlcalabash.drivers.Main"  -Dexec.args="-oHTML=test.html -oFO=/dev/null render-oscal-catalog.xpl
mvn \
    -f "$POM_FILE" \
    exec:java \
    -Dexec.mainClass="$MAIN_CLASS" \
    -Dexec.args="-xsl:src/nist-metaschema-MAKE-XSD.xsl -s:\"$METASCHEMA_SOURCE\" -o:\"$XSD_RESULT\" $ADDITIONAL_ARGS"

if [ -e "$XSD_RESULT" ]
then 
    echo "XSD schema written to file $XSD_RESULT"
fi
