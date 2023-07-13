#!/usr/bin/env bash


# This is the two-way converter generator script - it produces two converters

# Fail early if an error occurs
set -Eeuo pipefail

usage() {
    cat <<EOF
Usage: $(basename "${BASH_SOURCE[0]}") METASCHEMA_SOURCE SCHEMA_NAME [ADDITIONAL_ARGS]

Writes two XSLTs (stylesheets) from a valid and well-ordered NIST (ITL/CSD) metaschema (Metaschema instance) using Saxon invoked from Maven.
One XSLT is capable of converting JSON valid to metaschema-defined models into equivalent XML valid to the same model,
while the other does the opposite.
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
[[ -z "${2-}" ]] && { echo "Error: SCHEMA_NAME not specified"; usage; exit 1; }
SCHEMA_NAME=$2

ADDITIONAL_ARGS=$(shift 2; echo ${*// /\\ })

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd)"
POM_FILE="${SCRIPT_DIR}/../../support/pom.xml"

MAIN_CLASS="net.sf.saxon.Transform" # Saxon defined in pom.xml

# Making XML-to-JSON converter first

XMLTOJSON_CONVERTER_FILE="${SCHEMA_NAME}-xml-to-json.xsl"

if [ -e "$XMLTOJSON_CONVERTER_FILE" ]
then 
    echo "Deleting prior $XMLTOJSON_CONVERTER_FILE ..."
    rm -f ./$XMLTOJSON_CONVERTER_FILE
fi

mvn \
    -f "$POM_FILE" \
    exec:java \
    -Dexec.mainClass="$MAIN_CLASS" \
    -Dexec.args="-xsl:${SCRIPT_DIR}/nist-metaschema-MAKE-XML-TO-JSON-CONVERTER.xsl -s:\"$METASCHEMA_SOURCE\" -o:\"$XMLTOJSON_CONVERTER_FILE\" $ADDITIONAL_ARGS"

if [ -e "$XMLTOJSON_CONVERTER_FILE" ]
then 
    echo "$SCHEMA_NAME XML to JSON syntax converter XSLT written to $XMLTOJSON_CONVERTER_FILE"
fi

# Making XML-to-JSON-to-XML converter the same way

JSONTOXML_CONVERTER_FILE="${SCHEMA_NAME}-json-to-xml.xsl"

if [ -e "$JSONTOXML_CONVERTER_FILE" ]
then 
    echo "Deleting prior $JSONTOXML_CONVERTER_FILE ..."
    rm -f ./$JSONTOXML_CONVERTER_FILE
fi

mvn \
    -f "$POM_FILE" \
    exec:java \
    -Dexec.mainClass="$MAIN_CLASS" \
    -Dexec.args="-xsl:${SCRIPT_DIR}/nist-metaschema-MAKE-JSON-TO-XML-CONVERTER.xsl -s:\"$METASCHEMA_SOURCE\" -o:\"$JSONTOXML_CONVERTER_FILE\" $ADDITIONAL_ARGS"

if [ -e "$JSONTOXML_CONVERTER_FILE" ]
then 
    echo "$SCHEMA_NAME JSON to XML syntax converter XSLT written to $JSONTOXML_CONVERTER_FILE"
fi

# Done making two XSLTs

