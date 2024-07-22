include ../../testing/make_common.mk

module_path:=$(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))
metaschema_validate_xsd_script=$(realpath $(module_path)/../../validate/mvn-metaschema-xsd-validate-xpl.sh)
metaschema_validate_schematron_script=$(realpath $(module_path)/../../validate/mvn-composition-validate-xpl.sh)
pom_path:=../../../support/pom.xml

# Logic for TinyData testing

# Validate tiny_metaschema.xml


.PHONY: test
test: pre-checks ## Run pre-checks

# .PHONY: smoke-test
# smoke-test: pre-checks ## For this directory, run pre-checks for other processes


.PHONY: pre-checks
pre-checks: ## Validate tiny_metaschema.xml against Metaschema XSD and Schematron
	$(metaschema_validate_xsd_script) tiny_metaschema.xml
	$(metaschema_validate_schematron_script) tiny_metaschema.xml

.PHONY: refresh-tiny
refresh-tiny: refresh-tiny-schemas refresh-tiny-converters ## Refresh TinyData schemas and converter scripts

.PHONY: refresh-tiny-schemas
refresh-tiny-schemas: ## Refresh XSD and JSON Schemas for TinyData, in 'current'
	$(realpath $(module_path)/refresh-tiny-schemas.sh)


.PHONY: refresh-tiny-converters
refresh-tiny-converters: ## Refresh XML-JSON converter XSLTs for TinyData, in 'current'
	$(realpath $(module_path)/refresh-tiny-converters.sh)

  
# Generate schemas (call refresh-tiny-schemas.sh)
#   including Composed metaschema, XSD, JSON Schema and InspectorXSLT
#   place current/* into .gitignore
# Generate converters (call refresh-tiny-converters.sh)

.PHONY: tiny-css
tiny-css: ## Create boilerplate CSS for Tiny metaschema - also in 'current'
	$(call EXEC_SAXON,-xsl:../../util/make-plain-CSS.xsl -s:tiny_metaschema.xml -o:current/tiny-boilerplate.css)


# Batch validation
#  XSD, JSON Schema, Inspector

# Batch conversion - tiny-xsd-validate-set.sh

# Round trip conversion test
#  Batch convert valid samples using current/*-converter.xsl
#  XSpec this

# Which of all this go under CI/CD? allocate to smoke-test, unit-test etc.

