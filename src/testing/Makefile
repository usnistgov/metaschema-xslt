include ./make_common.mk

# TODO: Build out targets and runtimes for XML <-> JSON conversions
#         Including XSpec testing of conversion pipelines and steps
#       Extend and integrate unit tests into this Makefile
      
# See the Makefile at ../schema-gen/InspectorXSLT/Makefile for more logic to borrow

# INCLUDES:
# smoke-test - smoke testing - whether artifacts are produced as expected
# xspec - run XSpec tests in designated folder
# clean - clean up designated output folder

module_path:=$(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))
output_folder:=$(module_path)/test_output
xspec_script=$(realpath $(module_path)/../../../support/xspec-dev/mvn-saxon-xspec-batch-quiet.sh)
xspec_ci_script=$(realpath $(module_path)/../../../support/xspec-dev/mvn-saxon-xspec-batch.sh)
metaschema_validate_xsd_script=$(realpath $(module_path)/../validate/mvn-metaschema-xsd-validate-xpl.sh)
metaschema_validate_schematron_script=$(realpath $(module_path)/../validate/mvn-composition-validate-xpl.sh)

folder=.
METASCHEMA=models_metaschema.xml


.PHONY: test
test: smoke-test ## Run all tests


# .PHONY: spec-test #
# spec-test: ## Run all specification tests
# 	LOGFILE="$(output_folder)/inspector-functional-tests.log" $(xspec_ci_script) \
# 		"folder=$(module_path)/testing/tests/inspector-functional-xspec" \
# 		"report-to=$(output_folder)/inspector-functional-tests_report.html" \
# 		"junit-to=$(output_folder)/inspector-functional-tests_junit-report.xml" \
# 		"stop-on-error=yes" \
# 		"recurse=yes"


.PHONY: smoke-test ## Pre-check models_metaschema.xml
smoke-test: validate_models_metaschema ## Pre-check test inputs


.PHONY: validate_models_metaschema
validate_models_metaschema: ## Validate models_metaschema.xml with the Metaschema XSD and Schematron
	$(metaschema_validate_xsd_script) models_metaschema.xml
	$(metaschema_validate_schematron_script) models_metaschema.xml


.PHONY: metaschema-validate-xsd
metaschema-validate-xsd: ## Validate (top level or component module) metaschema with the Metaschema XSD
	$(metaschema_validate_xsd_script) METASCHEMA


.PHONY: metaschema-validate-schematron
metaschema-validate-schematron: ## Pre-check metaschema with the Metaschema Composition Checker Schematron
	$(metaschema_validate_xsd_script) METASCHEMA


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