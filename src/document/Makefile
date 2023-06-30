SHELL:=/usr/bin/env bash

test: smoke-test

pom_path:=../../support/pom.xml
entry_xproc:=write-hugo-metaschema-docs.xpl

smoke-test_output:=test_output/smoke/

.PHONY: smoke-test
smoke-test:
	mvn --quiet -f "${pom_path}" exec:java \
    	-Dexec.mainClass="com.xmlcalabash.drivers.Main" \
		-Dexec.args="-i source=file://$$(pwd)/../testing/models_metaschema.xml output-path=file://$$(pwd)/${smoke-test_output} ${entry_xproc}"
