# Testing Resources

See the [TESTING](../TESTING.md) docs for info on testing.

This directory contains misc testing resources that do not have a home elsewhere, or have not yet been moved to their proper homes.

## Warning: taking care editing resources

The files and utilities in this subdirectory are used as inputs in testing across the repository. When editing them, be sure that dependent operations are still running.

Don't edit and amend these resources without performing due diligence to align processes and tests that depend on them.

## In this directory


Dynamic testing of Metaschema-based data conversions, XML to JSON and back.

- models-testdata.xml
- models_metaschema.xml
- test-json-conversions.xpl
- test-xml-conversions.xpl
- test-xml-json-roundtrip.xpl

Don't change any of these files without keeping the schema generation testing in place as it depends on them.

## Tinydata model

See the [tinydata](./tinydata) folder for a fully worked example, made to a different set of design requirements than models_metaschema.xml.

It has its own tests and build scripts.

The 'models' metaschema aims to present all assembly, field and flag model configurations and definitions in a 'lab-only' tag set.

Tinydata, in contrast, is designed to be actually useful for some range of use cases, for example glossaries, data sheets or spreadsheet dumps.

## Schema generation testing overhaul planning Summer 2024

- [ ] **Phase I** plan out, test and code solution to Issue 105 - JSON schema `choice` fail
  - [x] use tinydata example to unit test this in schema-gen/JSON-schema
  - [ ] demonstrate with some go/no-go testing in tinydata that this works
  - [ ] make a new OSCAL catalog JSON Schema available for field testing in oscal-xproc3
  - [ ] clean up and push to address #105
- [ ] **Phase II** build out XSpecs for schema generation - at least minimally (foothold)
  - [ ] XSD and JSON Schema in detail
  - [ ] both models_metaschema and tinydata
- [ ] **Phase III** Inspector XSLT generation
  - [ ] free all schema generators from `metaschema` module runtime dependency
  - [ ] make all schema generation available as runtimes in XSLT, XProc 1/3
