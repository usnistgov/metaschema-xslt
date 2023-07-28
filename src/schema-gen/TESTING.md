# Schema generation testing

Currently we are producing two schema language variant expressions of metaschema constraints, and planning a third:

- XSD
- JSON Schema, v7
- (planned) Schematron

## Smoke tests

Test if both generators produce outputs

## Correctness tests

Does each artifact function properly?
Test this by validating stub test instances and checking what comes back

\<xsi:stub/> shouldn't validate against *anything*

## Unit tests

Validating against instances showing known good/bad validation states

Use models_metaschema.xml

XProc to generate a schema dynamically and then validate a set of documents?

