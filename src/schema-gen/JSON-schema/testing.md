# Testing Metaschema-XSLT JSON Schema production

**Currently only JSON Schema v7 is supported.**

At a future date we aim to support other forms.

## Smoke testing

A JSON Schema, with other schemas, is produced by a pipeline in the parent directory, ../METASCHEMA-ALL-SCHEMAS.xpl, which is also run as a smoke test.

(from that directory)

```
make smoke-test
```

The smoke test outputs including a JSON Schema are found in the `test_output` folder (until/unless cleaned out). If a JSON instance cannot be produced, the process will fail.
The smoke test does *not* currently

- test that the JSON functions as a JSON Schema
- test that it conforms to an idea of a JSON Schema ('the standard')

It does, however, confirm that the process terminated successfully with a file output in the expected location.

This implies near-term and long-term goals:

## Near term goals

Even without running the JSON Schema (a 'field-test' to demonstrate its adequacy for the purpose, i.e. validation), we can test a great deal since we know what that JSON Schema should look like.

I.e., we can test the mapping of Metaschema semantics into JSON by sketching the transformation from Metaschema source to the JSON Schema in its XML precursor format.

- [ ] XSpec the XSLT
  - [ ] `make-json-schema-metamap.xsl` for unit testing
  - [ ] `../nist-metaschema-MAKE-JSON-SCHEMA-as-xml.xsl` with @external='true' for end to end
- [ ] Flesh out with micro-examples of special cases
- [ ] Deal with `choice` https://github.com/usnistgov/metaschema-xslt/issues/105

cf https://github.com/usnistgov/OSCAL/issues/1989

This will give us something to show that we can generate correct outputs, for given inputs, in the general case.

Note that in this repo, the OSCAL models will *not* be used.

(But it can be used in parallel work in the oscal-xslt repository.)

## Longer term goals

"Field test" script able to distinguish between expected-valid and expected-invalid JSON, and report findings.

Something that could be reused in oscal-xslt over OSCAL inputs, for example.

## Punchlist

- [ ] XSpec to test metamap XSLT
- [x] Makefile to run this XSpec using xspec-dev script cf ../InspectorXSLT/Makefile
- [ ] Show tests with proposed solution(s) via PR