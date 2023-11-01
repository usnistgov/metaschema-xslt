#!/usr/bin/env bash

# Fail early if an error occurs
set -Eeuo pipefail

usage() {
    cat <<EOF
Usage: $(basename "${BASH_SOURCE[0]}") XML_SOURCE [-o:RESULT] [ADDITIONAL_ARGS]

Invokes current/computer_inspector.xsl to issue a validation report for XML_SOURCE.

For the application being invoked (Saxon), flags (-f: syntax) must be given before parameters (name=val syntax).

The -s: flag is provided to your XML_SOURCE by the script. XML_SOURCE is required for this purpose.

If XML_SOURCE is a directory, all XML files (i.e. all files that can be parsed) in the directory will be processed, -o must also indicate an existing directory for result reports, and file names will be mirrored.

Use flag -o:aFileName.txt directly after XML_SOURCE to direct main results to file aFileName.txt. If the -o flag is not given the results are on STDOUT, and should appear (unless otherwise redirected) in the command window. Suppress these results entirely with -o:/dev/null.

Using parameter syntax (param=value), additional arguments are also provided to SaxonHE - see the Inspector readme.md.

Use the format parameter to override the script's setting for initial mode ('plaintext') and the default behavior of the XSLT ('reflect'):

 format=html      to produce an HTML validation report
 format=md        to produce Markdown
 format=plaintext to produce a compressed near-Markdown (confirms the default for this script)
 format=mx        to produce a standalone report in Metaschema XSLT XML format (MX)
 format=reflect   to produce a copy of the input with reports embedded

Invoking the script without specifying a format results in the plaintext output, as it sets -im:plaintext.

In addition to format, parameters 'form' and 'echo' can further affect the outputs.

Use form=one-line for a one-line report (useful for scanning or aggregating).

Use form=summary for summary only (no incidence reports, just a finding and a count).

Use echo settings to direct information to the console/STDERR, useful especially when writing the reports to files.

echo=(none|invalid-only|docs|info|warnings|all) (falls back to 'none')

Ranging from 'none' being quietest (silent) through to 'all', the noisiest (announce all findings). This parameter cannot be used `format=inspected` since in order to summarize the findings of inspection, it must run to the end first.

Example: ./inspect-computer.sh computers/mycomputerXML.xml format=plaintext
- Validates the file computers/mycomputerXML.xml and brings a plaintext report back to the console.

Another example: ./inspect-computer.sh mycomputerXML.xml -o:validationReport.md format=md echo=warnings
- Applying the XSLT to mycomputerXML.xml, writes a validation report in Markdown to a file validationReport.md, and additionally reports any warnings or info messages to the console.

Another example: ./inspect-computer.sh myFiles -o:validationReports format=html echo=invalid-only
- Produces a pile of validation reports in directory validationReports, in HTML format, also announcing to the console which ones fail the validation.

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
    -Dexec.args="-im:plaintext -xsl:${SCRIPT_DIR}/current/computer_inspector.xsl -s:\"$XML_SOURCE\" $ADDITIONAL_ARGS"

echo
