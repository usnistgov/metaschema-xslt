include ../testing/make_common.mk

# XML Calabash prefers absolute paths
test_metaschema:=../testing/models_metaschema.xml
module_path:=$(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))
output_folder:=$(module_path)/test_output

xspec_script=$(realpath $(module_path)/../../support/xslt3-functions/xspec-dev/mvn-saxon-xspec-batch-quiet.sh)
xspec_ci_script=$(realpath $(module_path)/../../support/xslt3-functions/xspec-dev/mvn-saxon-xspec-batch.sh)
folder=.

.PHONY: test
test: smoke-test ## Run all tests

.PHONY: smoke-test
smoke-test: ## Apply generators to test metaschema
	./mvn-converters-xpl.sh "$(test_metaschema)" $(output_folder) models_metaschema

.PHONY: spec-test
spec-test: ## Run all XSpec in testing folder
	LOGFILE="$(output_folder)/converter-gen-xspec.log" $(xspec_ci_script) \
		"folder=$(module_path)/testing/" \
		"report-to=$(output_folder)/converter-gen_report.html" \
		"junit-to=$(output_folder)/converter-gen_junit-report.xml" \
		"stop-on-error=yes" \
		"recurse=yes"

.PHONY: clean
clean: ## Remove test output
	rm -fr $(output_folder)/*
