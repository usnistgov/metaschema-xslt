include ../../testing/make_common.mk

# INCLUDES:
# unit-test - unit testing - XSLT production templates for InspectorXSLT
# smoke-test - smoke testing - whether an XSLT is produced and compiles in a run
# spec-test - specification conformance testing - functional runtime tests of the generated XSLT
# refresh-testing - update InspectorXSLT and XSD for test metaschemas
# xspec - run XSpec tests in designated folder
# clean - clean up designated output folder

module_path:=$(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))
output_folder:=$(module_path)/test_output
xspec_script=$(realpath $(module_path)/../../../support/xslt3-functions/xspec-dev/mvn-saxon-xspec-batch-quiet.sh)
xspec_ci_script=$(realpath $(module_path)/../../../support/xslt3-functions/xspec-dev/mvn-saxon-xspec-batch.sh)
smoketest_script=$(realpath $(module_path)/testing/smoketest-computer-inspector.sh)
testing-refresh_script=$(realpath $(module_path)/testing/refresh-test-inspectors.sh)
folder=.

.PHONY: test
test: smoke-test unit-test spec-test ## Run all tests


.PHONY: spec-test
spec-test: ## Run all specification tests
	LOGFILE="$(output_folder)/inspector-functional-tests.log" $(xspec_ci_script) \
		"folder=$(module_path)/testing/tests/inspector-functional-xspec" \
		"report-to=$(output_folder)/inspector-functional-tests_report.html" \
		"junit-to=$(output_folder)/inspector-functional-tests_junit-report.xml" \
		"stop-on-error=yes" \
		"recurse=yes"

.PHONY: unit-test
unit-test: ## Run all unit tests
	LOGFILE="$(output_folder)/inspector-generation-tests.log" $(xspec_ci_script) \
		"folder=$(module_path)/testing/tests/inspector-generation-xspec" \
		"report-to=$(output_folder)/inspector-generation_report.html" \
		"junit-to=$(output_folder)/inspector-generation_junit-report.xml" \
		"stop-on-error=yes" \
		"recurse=yes"


.PHONY: smoke-test
smoke-test: ## Run InspectorXSLT production smoke test
	$(smoketest_script)


.PHONY: refresh-testing
refresh-testing: ## Update InspectorXSLT and XSD for test metaschemas (doesn't run tests)
	$(testing-refresh_script)


.PHONY: xspec
xspec: ## Run all *.xspec in a designated folder, quietly - use folder=[folder]
	LOGFILE="$(output_folder)/$(folder)-xspec-tests.log" $(xspec_script) \
		"baseURI=file:$(module_path)/" \
		"folder=$(folder)" \
		"report-to=$(output_folder)/inspector-$(folder)-tests_report.html" \
		"stop-on-error=no" \
		"recurse=yes"


.PHONY: clean
clean: ## Remove test output
	rm -fr $(output_folder)/*