# Testing Metaschema XSLT Inspector XSLT

See the [TESTING](../TESTING.md) docs for Inspector XSLT for explanation of how to test the application using these resources.

*Plus* - to see quickly what utilities for testing and development are supported using `make`, open a command line interface to the [InspectorXSLT directory[(..) and use

```
> make help
```

## Apologies to the XML-averse (for now)

Keep in mind when considering testing that Inspector XSLT currently only supports XML-based formats defined by a metaschema. Your JSON can be inspected only if you convert it to XML first - a conversion that is dependable only if the data was already valid to begin with.

(Running a metaschema-configured conversion, comparing results, and running a conversion again - even apart from applying the Inspector - is however quite a good way in general of determining metaschema-validity of non-XML formats based on Metaschema.)

## If you have a metaschema that you wish to use

Any valid and correct Metaschema module can be used to produce an Inspector for the XML format defined by that metaschema. Use the included script to produce your Inspector XSLT, or run the generator pipeline directly, not skipping composition, (Even a self-containted schema module in one file needs to be composed to link up definitions with their uses.)

In this subdirectory, two models (at time of writing) are used in harnesses for testing Metaschema-based XSLT generation (transpiling): `computer_metaschema.xml` and `tiny_metaschema.xml`. Together these are able to represent a broad range (ultimateley, the broadest range possible) of metaschema-based declarative functionality in modeling and constraint definition. At present they are also useful examples of small metaschema-based applications.

This means the developer of any metaschema should be able to copy handling found here, especially for `computer_metaschema.xml`, such as scripts for [refreshing an InspectorXSLT for testing](refresh-computer-inspector.sh), or [simply to apply an InspectorXSLT](inspect-computer.sh) to an XML document nominated at the command line.

See the [InspectorXSLT readme](../readme.md) for more information. Additionally, please consider reporting what you learn and letting project developers know of your needs as a Metaschema consumer and implementor.

## Working with the trial (model) metaschemas

`computer_metaschema.xml` has been provided with some outlandish rules and constraints, enabling it as a testbed for the application of constraints to arbitrary metaschema-defined data (specifically XML for this application).

Some [known-valid](valid/) and [known-invalid](invalid/) instances are also provided, serving as examples and out-of-line tests.

Additionally, `tiny_metaschema.xml` is a small metaschema made specifically for trying and testing the markup datatypes.

### XSD validations of computer samples

This can be done with a script in batch, respecting the organization of examples that should be found valid or invalid, as indicated by their file location.

The script is `xsd-crosscheck-samples.sh`, which invokes XProc pipeline `XSD-VALIDATE-COMPUTER-SAMPLES.xpl`.

See [InpspectorXSLT/TESTING.md](../TESTING.md) for more information.

### XSpec demonstrating correctness of the Inspector

An Inspector can be generated from a metaschema such as `computer_model.xml` and tested against known inputs to demonstrate that the tests performed by the Inspector bring the correct results.

Exercising these tests, a number of XSpec files in this folder calling `current/computer_metaschema-inspector.xsl` should all complete successfully and report "all green" -- no warnings, no errors, no unexpected 'pending' sections.

Again, see the [TESTING](../TESTING.md) docs for more information.
