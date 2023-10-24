#!/usr/bin/env bash

# Fail early if an error occurs
set -Eeuo pipefail

usage() {
    cat <<EOF
Usage: $(basename "${BASH_SOURCE[0]}") XML_SOURCE [ADDITIONAL_ARGS]

Invokes current/computer_inspector.xsl to issue a validation report for XML_SOURCE

Additional arguments are provided to SaxonHE - see the [Inspector readme](../readme.md).

Also see https://www.saxonica.com/documentation11/#!using-xsl/commandline
EOF
}

if ! [ -x "$(command -v mvn)" ]; then
  echo 'Error: Maven (mvn) is not in the PATH, is it installed?' >&2
  exit 1
fi

[[ -z "${1-}" ]] && { echo "Error: XML_SOURCE not specified"; usage; exit 1; }
XML_SOURCE=$1

ADDITIONAL_ARGS=$(shift 1; echo ${*// /\\ })

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd)"
POM_FILE="${SCRIPT_DIR}/../../../../support/pom.xml"

MAIN_CLASS="net.sf.saxon.Transform" # Saxon defined in pom.xml

mvn \
    -quiet \
    -f "$POM_FILE" \
    exec:java \
    -Dexec.mainClass="$MAIN_CLASS" \
    -Dexec.args="-im:html -xsl:${SCRIPT_DIR}/current/computer_inspector.xsl -s:\"$XML_SOURCE\" $ADDITIONAL_ARGS !method=html !indent=true"

echo
