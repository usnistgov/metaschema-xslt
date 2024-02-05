include ../../testing/make_common.mk

module_path:=$(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))
output_folder:=$(module_path)/test_output
xspec_script=$(realpath $(module_path)/../../../support/xspec-dev/mvn-saxon-xspec-batch.sh)

.PHONY: test
test: unit-test smoke-test ## Run all tests

.PHONY: unit-test
spec-test: ## Run all specification-tests
	LOGFILE="$(output_folder)/unit-tests.log" $(xspec_script) \
		"baseURI=file:$(xspec_script)" \
		"folder=$(module_path)/testing/tests/inspector-functional-xspec" \
		"report-to=$(output_folder)/unit-tests_report.html" \
		"recurse=yes"

.PHONY: smoke-test
smoke-test: ## Run all smoke-tests
	LOGFILE="$(output_folder)/integration-tests.log" $(xspec_script) \
		"baseURI=file:$(xspec_script)" \
		"folder=$(module_path)/testing/tests/inspector-generation-xspec" \
		"report-to=$(output_folder)/integration-tests_report.html" \
		"recurse=yes"

.PHONY: clean
clean: ## Remove test output
	rm -fr $(output_folder)/*