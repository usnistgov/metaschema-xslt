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

## XSD Schemas

XSD Schema production was not originally developed using test-driven-development practices. We are now catching up.

Work to be done includes comprehensive XSpecs for XSD production. A dependency for this is a specification for how to represent Metaschema in XSD, either established by Metaschema itself, or for this application. The current XSD generated provides a place to start.

## JSON Schemas

The pipelines generating JSON Schema have some ad-hoc unit testing developed to support bug fixing, buts await comprehensive unit tests.

A separate work item is to update this generation to support more recent versions of JSON Schema - while that too demands unit tests.

## InspectorXSLT

The InspectorXSLT application produces an XSLT representing the constraints defined by a Metaschema, both model-based constraints (thereby in emulation of grammar-based validators such as XML DTD, W3C XSD and ISO RelaxNG) and constraints based on arbitrary assertions.

It thus combines in one the functional properties of Schematron with XSD used as a validation application.

Its testing is also the most advanced in this repository at time of writing, including smoke tests, unit tests and specification testing, and growing. See documentation in the folder including [readme](InspectorXSLT/readme.md) and [testing](InspectorXSLT/TESTING.md) documentation.
