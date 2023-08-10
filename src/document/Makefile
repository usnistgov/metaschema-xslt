include ../testing/make_common.mk

# XML Calabash prefers absolute paths
test_metaschema:=$(abspath ../testing/models_metaschema.xml)
output_folder:=$(abspath test_output)

.PHONY: test
test: smoke-test ## Run all tests

.PHONY: smoke-test
smoke-test: smoke-test-hugo smoke-test-testsite ## Run all smoke-tests

.PHONY: smoke-test-hugo
smoke-test-hugo: ## Test verifies that 'METASCHEMA-DOCS-DIVS-write.xpl' runs without error
	$(call EXEC_CALABASH,-iMETASCHEMA=$(test_metaschema) METASCHEMA-DOCS-DIVS-write.xpl output-path=file://$(output_folder)/smoke/hugo/ metaschema-id=models_metaschema)

.PHONY: smoke-test-testsite
smoke-test-testsite: ## Test verifies that METASCHEMA-DOCS-TESTSITE-write.xpl runs without error
	./mvn-schemadocs-testsite-xpl.sh "$(test_metaschema)" test_output/smoke/testsite models_metaschema

#	$(call EXEC_CALABASH,-iMETASCHEMA=$(test_metaschema) \
#		METASCHEMA-DOCS-TESTSITE-write.xpl \
#		output-path=file://$(output_folder)/smoke/testsite/ \
#		metaschema-id=models_metaschema)

clean: ## Remove test output
	rm -fr $(output_folder)
