include ../testing/make_common.mk

# XML Calabash prefers absolute paths
test_metaschema:=../testing/models_metaschema.xml

.PHONY: test
test: smoke-test ## Run all tests

.PHONY: smoke-test
smoke-test: ## Run all smoke-tests
	./mvn-composition-validate-xpl.sh "$(test_metaschema)"
