#!/usr/bin/env bash

set -o pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../common/subcommand_common.bash

source "$SCRIPT_DIR/../../src/common/subcommand_common.bash"

XSLT_FILE="${SCRIPT_DIR}/XSPEC-BATCH.xsl"
LOGFILE=${LOGFILE:-"xspec_$(date +"%Y%m%d%H%M").log.txt"}

usage() {
    cat <<EOF
Usage: ${BASE_COMMAND:-$(basename "${BASH_SOURCE[0]}")} [ADDITIONAL_ARGS]

Compiles and executes a set or batch of XSpecs in Saxon, together.

An aggregate summary report is delivered in plain text (to STDOUT or --output argument).

Additionally, HTML files may be written to the file system, as directed.

This script redirects STDERR to a log file: xspec-log.txt, unless adjusted.

Runtime parameters (use param=value syntax):

folder: XSpec inputs are found in the targeted folder, relative to baseURI - defaults to 'src'
         (baseURI being set by default to the repository, this gives its /src directory)

e.g. folder=src (sets folder to repository /src)

pattern: glob-like syntax for file name matching
         cf https://www.saxonica.com/html/documentation12/sourcedocs/collections/collection-directories.html '?select'
         use a single file name for a single XSpec instance
         use (file1.xspec|file2.xspec|...|fileN.xspec) for file name literals (with URI escaping for spaces etc.)
         defaults to *.xspec (all files suffixed 'xspec')  

    e.g. pattern=*-ready.xspec

recurse (yes|no): matches files in subfolders recursively - defaults to 'no'

report-to (folder or HTML filename): if not given, no report is written
         If a given value ends in '.html', a single aggregated report is written to this path relative to the selected folder.
         Otherwise, the value is taken as a folder name
         where a separate report is written for each successful XSpec, named after the XSPec.

    e.g. report-to=all-report.html
         report-to=xspec-reports

junit-to (filename with suffix): write a JUnit test report (XML) to this file
         produces a warning if provided value is not a suffixed file name and a valid URI

stop-on-error (yes|no): hard stop on any failure, or keep going - defaults to 'no'

baseURI: a URI indicating runtime context relative to which XSpecs are found
         defaults to repository root

theme=(clean|classic|toybox|uswds) defaulting to 'clean'

EOF
}

echo_on_error()

{
      echo "Error: $1"
      exit 1
}

ADDITIONAL_ARGS=$(echo "${*// /\\ }")

SAXON_ARGS="-it:go -xsl:\"${XSLT_FILE}\" -init:org.nineml.coffeesacks.RegisterCoffeeSacks \
                 stop-on-error=yes $ADDITIONAL_ARGS"

echo "XSpec testing - logging to ${LOGFILE}"

# echo  "${SAXON_ARGS}"

# set 2>/dev/null to drop all runtime messages / progress reports instead of logging
# the process should error out only if stop-on-error=yes, otherwise it will do its best to complete
invoke_saxon "${SAXON_ARGS}" 2>&1 | tee ${LOGFILE}
