include ../../testing/make_common.mk

# TODO (sort out):
# unit testing - XSLT production templates
# smoke testing - whether an XSLT is produced and compiles in a run
#   trying on available samples?
#   use testing/TEST-INSPECTOR-RUNTIME.xpl
# spec testing - functional runtime tests of the generated XSLT

# refresh-inspector - run XSLT production for test metaschemas writing to current (and smoke test)

module_path:=$(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))
output_folder:=$(module_path)/test_output
xspec_script=$(realpath $(module_path)/../../../support/xspec-dev/mvn-saxon-xspec-batch.sh)
smoketest_script=$(realpath $(module_path)/testing/smoketest-computer-inspector.sh)

.PHONY: test
test: unit-test spec-test smoke-test ## Run all tests

.PHONY: spec-test
spec-test: ## Run all specification tests
	LOGFILE="$(output_folder)/inspector-functional-tests.log" $(xspec_script) \
		"folder=$(module_path)/testing/tests/inspector-functional-xspec" \
		"report-to=$(output_folder)/inspector-functional-tests_report.html" \
		"junit-to=$(output_folder)/inspector-functional-tests_junit-report.xml" \
		"stop-on-error=yes" \
		"recurse=yes"

.PHONY: unit-test
unit-test: ## Run all unit tests
	LOGFILE="$(output_folder)/integration-tests.log" $(xspec_script) \
		"folder=$(module_path)/testing/tests/inspector-generation-xspec" \
		"report-to=$(output_folder)/integration-tests_report.html" \
		"junit-to=$(output_folder)/integration-tests_junit-report.xml" \
		"stop-on-error=yes" \
		"recurse=yes"

.PHONY: smoke-test
smoke-test: ## Run smoke test
	$(smoketest_script) -oINSPECTOR-XSLT=/dev/null

.PHONY: clean
clean: ## Remove test output
	rm -fr $(output_folder)/*