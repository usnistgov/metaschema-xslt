# Testing Resources

See the [TESTING](../TESTING.md) docs for info on testing.

This directory contains misc testing resources that do not have a home elsewhere, or have not yet been moved to their proper homes.

## Illustrative Model Metaschema

Dynamic testing of Metaschema-based data conversions, XML to JSON and back.

- models-testdata.xml
- models_metaschema.xml
- test-json-conversions.xpl
- test-xml-conversions.xpl
- test-xml-json-roundtrip.xpl

## Demo JSON Serialization Debug XSpec

The converters when targeting JSON depend on a serialization step found to be buggy in an OSCAL issue. The files `issue_235_regression.xspec` and `issue_235_regression-metaschema.xml` support testing for this solution as well as (if maintained) regression testing going forward.

## Towards CI/CD

Try `make` to use utilities installed for CI/CD:

```
> make smoke-test
```

Currently, smoke testing includes XSD and Schematron validation of the `models_metaschema.xml` test metaschema, using the XSD and "Composition Check" Schematron.

```
> make validate_models_metaschema
```

Does this as well, only without any other smoke testing added since this page was written.

See `make help` from a `bash` command line for more on Make targets available in this folder.

