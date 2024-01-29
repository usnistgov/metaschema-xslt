#!/usr/bin/env bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../common/subcommand_common.bash

source "$SCRIPT_DIR/../../src/common/subcommand_common.bash"

XSLT_FILE="${SCRIPT_DIR}/XSPEC-BATCH.xsl"

usage() {
    cat <<EOF
Usage: ${BASE_COMMAND:-$(basename "${BASH_SOURCE[0]}")} [ADDITIONAL_ARGS]

Compiles and executes a set or batch of XSpecs in Saxon together.

An aggregate summary report is delivered in plain text (to STDOUT or --output argument).

Additionally, HTML files may be written to the file system, as directed.

Runtime parameters:

folder: the targeted folder, relative to baseURI - defaults to '.' (current folder, i.e. baseURI)
         (baseURI being set by default to repo /src directory)
pattern: glob-like syntax for file name matching
         cf https://www.saxonica.com/html/documentation12/sourcedocs/collections/collection-directories.html '?select'
         use a single file name for a single XSpec instance
         use (file1.xspec|file2.xspec|...|fileN.xspec) for file name literals (with URI escaping for spaces etc.)
         defaults to *.xspec (all files suffixed xspec)  

recurse (yes|no): matches files in subfolders recursively - defaults to 'yes'

report-to (folder or HTML filename): if not given, no report is written
         If given, and ends in '.html', a single aggregated report is written to this path relative to baseURI.
         Otherwise, the value is taken as a folder name, where a separate report is written for each successful XSpec, named after the XSPec.

stop-on-error (yes|no): hard stop on any failure, or keep going - defaults to 'no'

baseURI: a URI indicating runtime context relative to which XSpecs are found
         defaults to 'src' in repository
         but this could be anywhere

theme=(clean|classic|toybox|uswds) defaulting to 'clean'

To silence progress messages and show only final results, use 2>/dev/null to redirect STDERR
(a successful run will show test results while a runtime failure emits nothing)

EOF
}

crash_and_burn()

{
      echo "Error: $1"
      exit 1
}

ADDITIONAL_ARGS=$(echo "${*// /\\ }")

SAXON_ARGS="-it:go -xsl:\"${XSLT_FILE}\" -init:org.nineml.coffeesacks.RegisterCoffeeSacks \
                 stop-on-error=yes $ADDITIONAL_ARGS"

# echo  "${SAXON_ARGS}"

# set 2>/dev/null to drop all runtime messages / progress reports instead of logging
# the process should error out only if stop-on-error=yes, otherwise it will do its best to complete
invoke_saxon "${SAXON_ARGS}" 2>xspec.log.txt || crash_and_burn "Errors encountered running XSpec - check xspec.log.txt"
