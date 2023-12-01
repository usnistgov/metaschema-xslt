# Testing Metaschema XSLT Inspector XSLT

See the [Testing](../Testing.md) docs for Inspector XSLT for explanation of how these resources can be used.

## Apologies to the XML-averse (for now)

Keep in mind when considering testing that Inspector XSLT currently only supports XML-based formats defined by a metaschema. Your JSON can be inspected only if you convert it to XML first - a conversion that is dependable only if the data was already valid to begin with.

(Running a metaschema-configured conversion, comparing results, and running a conversion again - even apart from applying the Inspector - is however quite a good way in general of determining metaschema-validity of non-XML formats based on Metaschema.)

## If you have a metaschema that you wish to use

Any valid and correct Metaschema module can be used to produce an Inspector for the XML format defined by that metaschema. Use the included script to produce your Inspector XSLT, or run the generator pipeline directly, not skipping composition, (Even a self-containted schema module in one file needs to be composed to link up definitions with their uses.)

See the top-level [readme](../readme.md) for more information. Please consider reporting what you learn.

## Working with the trial (model) metaschemas

`computer_metaschema.xml` has been provided with some outlandish rules and constraints, enabling it as a testbed for the application of constraints to arbitrary metaschema-defined data (specifically XML for this application).

Some [known-valid](valid/) and [known-invalid](invalid/) instances are also provided, serving as examples and out-of-line tests.

Additionally, `tiny_metaschema.xml` is a small metaschema made specifically for trying and testing the markup datatypes.

### XSpec demonstrating correctness of the Inspector

An Inspector can be generated from a metaschema such as `computer_model.xml` and tested against known inputs to demonstrate that the tests performed by the Inspector bring the correct results.

Exercising these tests, a number of XSpec files in this folder calling `current/computer_inspector.xsl` should all complete successfully and report "all green" -- no warnings, no errors, no unexpected 'pending' sections.

See the [Testing](../Testing.md) docs for more information.
