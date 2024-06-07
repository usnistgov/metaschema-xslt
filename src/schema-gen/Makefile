include ../testing/make_common.mk

# XML Calabash prefers absolute paths
test_metaschema:=../testing/models_metaschema.xml
output_folder:=test_output


.PHONY: test
test: smoke-test unit-test ## Run all tests


.PHONY: smoke-test
smoke-test: ## Generate schemas from ../testing/models_metaschema.xml
	./mvn-schemas-xpl.sh "$(test_metaschema)" $(output_folder) models_metaschema


.PHONY: unit-test
unit-test: xsd-proof-test ## Generate, validate and test run an XSD for ../testing/models_metaschema.xml


.PHONY: xsd-proof-test
xsd-proof-test: ## Proof test XSD schema for ../testing/models_metaschema.xml
	./mvn-xsd-proofcheck-xpl.sh "$(test_metaschema)"

.PHONY: clean
clean: ## Remove test output
	rm -fr $(output_folder)/*
