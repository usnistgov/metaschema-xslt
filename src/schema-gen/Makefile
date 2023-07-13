include ../testing/make_common.mk

# XML Calabash prefers absolute paths
test_metaschema:=../testing/models_metaschema.xml
output_folder:=test_output

.PHONY: test
test: smoke-test ## Run all tests

.PHONY: smoke-test
smoke-test: ## Run all smoke-tests
	./mvn-schemas-xpl.sh "$(test_metaschema)" $(output_folder)/models_metaschema

.PHONY: clean
clean: ## Remove test output
	rm -fr $(output_folder)/*
