#!/usr/bin/env bash

# Fail early if an error occurs
set -Eeuo pipefail

usage() {
    cat <<EOF
Usage: $(basename "${BASH_SOURCE[0]}") XML_SOURCE [ADDITIONAL_ARGS]

Invokes current/computer_inspector.xsl to issue a validation report for XML_SOURCE

For the consuming application (Saxo), flags (-f: syntax) must be given before parameters (name=val syntax).

Use flag -o:aFileName to direct main results to file aFileName. Suppress the results with -o:/dev/null.
If XML_SOURCE is a directory, all XML files (i.e. all files that can be parsed) in the directory will be processed, -o must also indicate an existing directory for result reports, and file names will be mirrored.

Use -im:html      to produce HTML. -im indicates initial mode. -it (initial template) is a functional alias.
    -im:md        to produce Markdown.
    -im:plaintext to produce a compressed near-Markdown.
    -im:mx        to produce a standalone report in Metaschema XSLT XML format (MX).

Additional arguments are also provided to SaxonHE - see the [Inspector readme](../readme.md):

Use form=one-line for one-line report. form=summary for summary only (no reports).

Use echo settings to direct information to the console/STDERR, useful especially when directing results to files.
echo=(none|invalid-docs|docs|info|warnings|all) (falls back to 'none')

Example: ./inspect-computer.sh computers/mycomputerXML.xml -im:plaintext
Validates the file computers/mycomputerXML.xml and brings a plaintext report back to the console.

Another example: ./inspect-computer.sh mycomputerXML.xml -im:md -o:validationReport.md echo=warnings
Applying the XSLT to mycomputerXML.xml, writes a validation report in Markdown to a file validationReport.md while reporting on any warnings or info to the console.

Another example: ./inspect-computer.sh myFiles -im:html -o:validationReports echo=invalid-only
Produces a pile of validation resports in directory validationReports, in HTML format, also announcing to the console which ones are not valid.

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
    -Dexec.args="-xsl:${SCRIPT_DIR}/current/computer_inspector.xsl -s:\"$XML_SOURCE\" $ADDITIONAL_ARGS"

echo
