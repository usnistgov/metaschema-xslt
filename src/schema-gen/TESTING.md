# Schema generation testing

One application of Metaschema is to generate schema instances in multiple languages.

Both the mappings from Metaschema syntax into a schema syntax, and the function of any schema so produced (in detecting errors and validating instances), can be unit tested.

The specific languages currently include XSD (for XML) and JSON Schema, v7 (for JSON, YAML and isomorphic object notations). More schema languages for these and other data notations are under development.

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

