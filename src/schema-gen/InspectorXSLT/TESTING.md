# Testing the XSLT Metaschema Inspector

Produced from a metaschema, an Inspector is an XSLT transformation which produces, when applied to an XML document, error and warning messages from that document respecting its conformance to the rules dictated by that metaschema.

In other words the Inspector is a Schema Emulator, as it aims to return (or expose) effectively the same information  as schema validation.

Broadly, this presents at least three areas for testing (each of which has complexities)

- Generation of the Inspector XSLT from controlled (metaschema) sources
- Functionality of the Inspector XSLT
- Interfaces and outputs / runtime options for Inspector XSLT

Currently we focus on the *first two* of these, producing functional results in a simplified format that we can build to later - testing interface targets at that time as appropriate. An example would be producing HTML or Markdown reports: for now we test only generic reports in a format we control.

Find resources for testing the XSLT Inspector and its production in the [testing](testing) subdirectory.


## Testing under `make`

Documented in the Makefile -

Use

```
> make help
```

to see the available make targets, supporting smoke testing, unit testing of XSLT production and others.

Some utilities described on this page are also available using scripts, which will function in place despite not being accessible via `make`.
 expressions.

Note this is work in progress and may change over time especially as we bring more tests in.

## Model metaschemas for testing

### `current` resource cache

The testing/current directory contains copies of resources produced by the Inspector generator and related tools for testing, including:

- Current-best Inspector implementation for any metaschemas, as generated
- Current-best XSD expressing (a subset of) the same rules as the corresponding Inspector, for a metaschema module, for testing
- Current-best 'composed' metaschema instance for each testing metaschema. i.e. a fully assembled and linked metaschema module, useful for debugging

Within these artifacts, initial comments should give information regarding date of creation.

### "Computer Model" metaschema

This suite uses an extended variant of the 'computer metaschema' model by AJ Stein and team for testing, maintained here as [testing/computer_metaschema.xml](testing/computer_metaschema.xml).

The Inspector XSLT feature set can be tested by generating XSLT and schemas and creating instances (e.g. `valid` and `invalid` instances) from this metaschema, which exercise its feature set.

See the original in [the specification's repository](https://github.com/usnistgov/metaschema/blob/develop/examples/).

#### Refresh the 'computer model' XSD

Use a script such as [../mvn-xsd-schema-xsl.sh](../mvn-xsd-schema-xsl.sh) or the XSLT [../nist-metaschema-MAKE-XSD.xsl](../nist-metaschema-MAKE-XSD.xsl) to produce an XSD file for the [testing/computer_metaschema.xml](testing/computer_metaschema.xml).

This XSD should validate the same set of rules as the Inspector (excluding Metaschema query constraints) and can be used to cross check functionality. Note that this XSD is also dynamically generated and might itself have bugs or issues. (If only in principle. In reality, the schema generators are also tested both in the lab and the field.) Irrespective of this question, the requirements are that both processes (schema validation and Inspector-XSLT validation) are effectively congruent, compatible and "the same" inasmuch as they detect all the same problems in data.

A copy of the current-best schema is also here, to be refreshed as necessary): [testing/current/computer_metaschema-xmlschema.xsd](testing/current/computer_metaschema-xmlschema.xsd)

#### XSD Validate the Samples

A bash script `testing/xsd-crosscheck-samples.sh` executes an XProc pipeline that performs batch 'go/no-go' validation of XML sources expected to be either valid, or invalid, to the computer_metaschema model, as found in the `testing` folder.

It will report on the command line whether any files expected to be valid (based on their placement in the `computer-valid` folder) are not valid, or any files expected not to be valid (because in the `computer-invalid` folder) are found actually to be valid.

The validating parser used is the Java built-in parser, Xerces, as instrumented in XML Calabash (using `p:validate-with-xml-schema`).

### Refresh the 'computer model' Inspector XSLT

Before testing the Computer Inspector XSLT, the copy kept for testing must be refreshed.

First, build `current/computer_inspector.xsl` from `computer_metaschema.xml` using `generate-inspector-xslt`

  - Use ../METASCHEMA-INSPECTOR-XSLT.xpl runtime or script to provide metaschema composition, then apply the 'generator' stylesheet to produce the Inspector XSLT
  - The top-level ../nist-metaschema-MAKE-INSPECTOR-XSLT.xsl applies the same XSLT pipeline
  - Either test metaschema, or any correctly tagged metaschema, can be refreshed this way

### Tiny Data mini-model

An additional small metaschema is provided specifically for the purpose of isolating markup-based datatypes (`markup-line` and `markup-multiline`) in their various configurations and testing the correctness of validations of this markup (passing valid markup and reporting invalid markup).

Use it and test with it the same way as the Computer metaschema.

"Tiny data" supports term bases (controlled vocabularies) and documents using controlled terminology, using a very few tags. With a little creative extension-by-restriction it can be used for glossaries and arbitrary structured prose in a lightweight XML format supportive of further improvement, enhancement, and conversion.

## Testing the Inspector XSLT

Question: *Is the XSLT produced from a metaschema instance capable of addressing its functional requirements?*

To address this question, functional requirements can be isolated and illustrated both in standalone complete documents, and in document fragments maintained as XSpec test suites.

### Standalone document-level tests

Question: *Can test samples including nominally-valid and invalid test cases be known to be valid or invalid, as described?*

Within `testing`, `computers-valid` contains Computer Model instances expected to test as valid.

Examples within `computers-invalid` when tested by the Computer MOdel Inspector (or any validator) are expected to return appropriate warnings and errors. They may be commented with notes indicating their lapses.

For testing the InspectorXSLT transformation, the XSpec file [testing/validations-in-batch.xspec](testing/validations-in-batch.xspec) runs both valid and invalid sets through the Inspector and ensures results are correct - reports for the invalid cases, no reports for the valid cases.

[An XSD schema ](testing/computer_metaschema-xmlschema.xsd) can also be used to confirm validity or failure to validate for sets of examples, as given. Any other metaschema-based validator, or a metaschema-derived validation that supports XML, can also be used, such as a validator produced using [metaschema-java](https://github.com/usnistgov/metaschema-java).

Also, examples within `tinydata` may be valid or invalid to the Tiny metaschema, as indicated.

### Templates and functions

Question: *How do I know a specific report is being produced correctly by Inspector XSLT for a given error condition in 'computer XML' data?*

Individual templates and defined functions can also be targeted and tested in XSpec.

XSpec testing breaking out these cases, both 'go' and 'no-go', are located in [the inspector-functional testing directory](testing/tests/inspector-functional/)

## Testing Inspector XSLT production

Question: *Is the XSLT produced from a metaschema instance correct not only respect to its capabilities (addressing functional requirements) but also other requirements such as legibility, exception handling or post-processing features?*

To the extent that 'correctly' is currently defined, it is in reference to functionality (see above) and relevant Metaschema specifications, not to an abstract design.

However, a target for this transformation - generation of XSLT from correct Metaschema source data - can be defined and codified as a 'canonical form' of Inspector XSLT. To the extent this has been done, XSpec demonstrating conformance to the expressed requirements is given in [the inspector-generation testing directory](testing/tests/inspector-generation/)

The [Inspector XSLT Generator Pipeline](../METASCHEMA-INSPECTOR-XSLT.xpl) includes a step that applies the generated XSLT and reports a finding of `OKAY` or `ERROR` as a pipeline result (on output port `OUT_xslt-prooftest`), as a convenience.

## Testing the <q>costuming</q> post-processing pipelines

Inspector XSLT first produces MX outputs. These are further processed, first by being filtered, then into HTML and Markdown results.

These transformations can be tested. An HTML-to-Markdown XSpec could also be useful elsewhere.

If these are not already to be found among the tests it remains a TODO item.
