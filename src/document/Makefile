include ../testing/make_common.mk

# XML Calabash prefers absolute paths
test_metaschema:=$(abspath ../testing/models_metaschema.xml)
output_folder:=$(abspath test_output)

.PHONY: test
test: smoke-test ## Run all tests

.PHONY: smoke-test
smoke-test: smoke-test-hugo smoke-test-standalone

.PHONY: smoke-test-hugo
smoke-test-hugo: ## Test verifies that 'write-hugo-metaschema-docs.xpl' runs without error
	$(call EXEC_CALABASH,-i source=$(test_metaschema) output-path=file://$(output_folder)/smoke/hugo/ write-hugo-metaschema-docs.xpl)

.PHONY: smoke-test-standalone
smoke-test-standalone: ## Test verifies that make-metaschema-standalone-docs.xpl runs without error
	$(call EXEC_CALABASH,-i source=$(test_metaschema) \
		output-path=file://$(output_folder)/smoke/standalone/ \
		-o INT_0_echo-input=/dev/null \
		-o INT_1_composed=/dev/null \
		-o INT_2_abstract-model-map=/dev/null \
		-o INT_3_unfolded-instance-map=/dev/null \
		-o INT_4_marked-instance-map=/dev/null \
		make-metaschema-standalone-docs.xpl)

clean: ## Remove test output
	rm -fr $(smoke-test_output)
