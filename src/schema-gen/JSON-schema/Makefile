include ../../testing/make_common.mk

# INCLUDES:
# unit-test - unit testing - XSLT production templates for InspectorXSLT
# spec-test - specification conformance testing - functional runtime tests of the generated XSLT
# xspec - run XSpec tests in designated folder
# clean - clean up designated output folder

# for smoke testing see ../Makefile

# tbd - 'field testing' applying result JSON Schema to known 'working and broken' instances

module_path:=$(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))
output_folder:=$(module_path)/test_output
xspec_script=$(realpath $(module_path)/../../../support/xslt3-functions/xspec-dev/mvn-saxon-xspec-batch-quiet.sh)
xspec_ci_script=$(realpath $(module_path)/../../../support/xslt3-functions/xspec-dev/mvn-saxon-xspec-batch.sh)
folder=.

.PHONY: test
test: unit-test spec-test ## Run all tests


.PHONY: spec-test
spec-test: ## Run all specification tests
	LOGFILE="$(output_folder)/jsonschemagen-mapping.log" $(xspec_ci_script) \
		"folder=$(module_path)/testing/tests/jsonschemagen-mapping-xspec/" \
		"report-to=$(output_folder)/jsonschemagen-mapping_report.html" \
		"junit-to=$(output_folder)/jsonschemagen-mapping_junit-report.xml" \
		"stop-on-error=yes" \
		"recurse=yes"

.PHONY: unit-test
unit-test: ## Run all unit tests
	LOGFILE="$(output_folder)/jsonschemagen-runtime.log" $(xspec_ci_script) \
		"folder=$(module_path)/testing/tests/jsonschemagen-runtime-xspec" \
		"report-to=$(output_folder)/jsonschemagen-runtime_report.html" \
		"junit-to=$(output_folder)/jsonschemagen-runtime_junit-report.xml" \
		"stop-on-error=yes" \
		"recurse=yes"

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