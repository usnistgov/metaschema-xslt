include ../testing/make_common.mk

# Note that Makefile definitions in other subdirectories use scripts defined in this one


# XML Calabash prefers absolute paths
test_metaschema:=../testing/models_metaschema.xml

.PHONY: test
test: pre-checks smoke-test ## Run all tests

# As a pre-check we validate the test metaschema first;
# if this succeeds we check its composition

.PHONY: pre-checks ## Validate test inputs (model metaschema)
	./mvn-metaschema-xsd-validate-xpl.sh "$(test_metaschema)"
	./mvn-composition-validate-xpl.sh "$(test_metaschema)"


.PHONY: smoke-test
smoke-test: ## Run all smoke-tests

