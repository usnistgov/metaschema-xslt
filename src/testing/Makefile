include ./make_common.mk

# TODO: Build out targets and runtimes for XML <-> JSON conversions
#       Including XSpec testing of conversion pipelines and steps
#       Extend and integrate unit tests into this Makefile

# See the Makefile at ../schema-gen/InspectorXSLT/Makefile for more logic to borrow

# INCLUDES:
# smoke-test - smoke testing - for this directory, pre-checks models_metaschema.xml
# xspec - run XSpec tests in designated folder
# clean - clean up designated output folder

module_path:=$(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))
output_folder:=$(module_path)/test_output
xspec_script=$(realpath $(module_path)/../../../support/xslt3-functions/xspec-dev/mvn-saxon-xspec-batch-quiet.sh)
xspec_ci_script=$(realpath $(module_path)/../../../support/xslt3-functions/xspec-dev/mvn-saxon-xspec-batch.sh)
metaschema_validate_xsd_script=$(realpath $(module_path)/../validate/mvn-metaschema-xsd-validate-xpl.sh)
metaschema_validate_schematron_script=$(realpath $(module_path)/../validate/mvn-composition-validate-xpl.sh)

folder=.
test_metaschema=models_metaschema.xml


.PHONY: test
test: smoke-test spec-test ## Run all tests

# .PHONY: spec-test #
# spec-test: ## Run all specification tests
# 	LOGFILE="$(output_folder)/inspector-functional-tests.log" $(xspec_ci_script) \
# 		"folder=$(module_path)/testing/tests/inspector-functional-xspec" \
# 		"report-to=$(output_folder)/inspector-functional-tests_report.html" \
# 		"junit-to=$(output_folder)/inspector-functional-tests_junit-report.xml" \
# 		"stop-on-error=yes" \
# 		"recurse=yes"


.PHONY: smoke-test
smoke-test: pre-checks ## For this directory, run pre-checks for other processes


.PHONY: pre-checks
pre-checks: ## Validate and check models_metaschema.xml
	$(metaschema_validate_xsd_script) models_metaschema.xml
	$(metaschema_validate_schematron_script) models_metaschema.xml


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

