include testing/make_common.mk

# Each subdirectory that has a makefile
dirs:=$(dir $(wildcard ./*/Makefile))

.PHONY: test
test: ## Run all tests
	$(call FOREACH_MAKE,$@,$(dirs))

.PHONY: smoke-test
smoke-test: ## Run all "smoke tests", establishing a baseline of sanity across the project
	$(call FOREACH_MAKE_OPTIONAL,$@,$(dirs))

.PHONY: spec-test
spec-test: ## Run all "specification tests", validating this implementation against the Metaschema spec
	$(call FOREACH_MAKE_OPTIONAL,$@,$(dirs))

.PHONY: unit-test
unit-test: ## Run all unit tests
	$(call FOREACH_MAKE_OPTIONAL,$@,$(dirs))

.PHONY: clean
clean: ## Remove any generated test or build artifacts
	$(call FOREACH_MAKE_OPTIONAL,$@,$(dirs))
