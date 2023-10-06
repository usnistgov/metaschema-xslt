# Testing the XSLT Metaschema Inspector

Produced from a metaschema, an Inspector is an XSLT transformation which produces, when applied to an XML document, error and warning messages from that document respecting its conformance to the rules dictated by that metaschema.

In other words the Inspector is a Schema Emulator, and can expect to return the same information (effectively) as schema validation.

Broadly, this presents at least three areas for testing (each of which has complexities)
- Generation of the Inspector XSLT from controlled (metaschema) sources
- Functionality of the Inspector XSLT
- Interfaces and outputs / runtime options for Inspector XSLT

Currently we focus on the *first two* of these, producing functional results in a simplified format that we can build to later - testing interface targets at that time as appropriate. An example would be producing HTML or Markdown reports: for now we test only generic reports in a format we control.

Find resources for testing the XSLT Inspector and its production in the [testing](testing) subdirectory.

## Testing Inspector XSLT application

Question: *Is the XSLT produced from a metaschema instance defined correctly to address its functional requirements?*

The functionality of `computer-inspector.xsl` can be unit tested with [its own XSpec]().

It uses both inline examples and out of line examples from the 'invalid' suite.

Failing tests (including 'successes' when 'failure' is expected) indicate that the XSLT is defined incorrectly: it does not meet its functional requirements.

Note that next to "current best", handmade XSLTs can also run these tests for prototype logic.

A couple of patterns:

- inline source (invalid fragment) transform and cleanup with inline mx:results
- out of line source ('invalid' example) transform and cleanup with inline results
  - both full/complete
  - and using XPath to target
  - the XSLT `filter-for-mx.xsl` can be used as utility XSLT for post-processing results for comparison

## Model metaschema for testing

This suite uses an extension of AJ Stein's 'computer metaschema' model for testing, maintained here as [testing/computer_metaschema.xml](testing/computer_metaschema.xml).

The Inspector XSLT feature set can be tested by generating XSLT and schemas and creating instances (e.g. `valid` and `invalid` instances) from this metaschema, which exercise its feature set.

### Refresh the XSD

Use a script such as [../mvn-xsd-schema-xsl.sh](../mvn-xsd-schema-xsl.sh) or the XSLT [../nist-metaschema-MAKE-XSD.xsl](../nist-metaschema-MAKE-XSD.xsl) to produce an XSD file for the [testing/computer_metaschema.xml](testing/computer_metaschema.xml).

This XSD should validate the same set of rules as the Inspector (excluding Metaschema query constraints) and can be used to cross check functionality.

A copy of the current-best schema is also here, to be refreshed as necessary): [testing/current/computer_metaschema-xmlschema.xsd](testing/current/computer_metaschema-xmlschema.xsd)

### Refresh the Computer Inspector XSLT

Before testing the Computer Inspector XSLT, the copy kept for testing must be refreshed.

First, build `current/computer_inspector.xsl` from `computer_metaschema.xml` using `generate-inspector-xslt`

  - Use ../METASCHEMA-INSPECTOR-XSLT.xpl runtime or script to provide metaschema composition before applying the stylesheet  
  - The top-level ../nist-metaschema-MAKE-INSPECTOR-XSLT.xsl applies the same XSLT pipeline

## 'Computer Inspector' Functionality

### Standalone document-level tests

Question: *Can test samples including nominally-valid and invalid test cases be known to be valid or invalid, as described?*

Within `testing`, `valid` contains instances expected to test as valid.

Examples within `invalid` are expected to return appropriate warnings and errors. They may be commented with notes indicating their lapses.

These can be tested in batch with XSD validation and/or Inspector XSLT, producing the same results.

The XSpec file [testing/validations-in-batch.xspec](testing/validations-in-batch.xspec) runs both Valid and Invalid sets through the Inspector and ensures results are correct - reports for the invalid cases, no reports for the valid cases.

[An XSD schema ](testing/computer_metaschema-xmlschema.xsd) can be used to confirm validity or failure to validate for sets of examples, as given. Any other metaschema-based validator, or a metaschema-derived validation that supports XML, can also be used, such as a validator produced using [metaschema-java](https://github.com/usnistgov/metaschema-java).

### Templates and functions

Individual templates and defined functions can also be targeted and tested in XSpec.

Tests for the core transformation operating to detect errors in inputs (as defined by rules in the computer_metaschema.xml source) can be found in [testing/validation-reports.xspec](testing/validation-reports.xspec).

Examples of testing for demonstration (patterns that can be followed) are also given in [testing/xspec-patterns.xspec](testing/xspec-patterns.xspec). 

## Testing Inspector XSLT production

Question: *Is the XSLT produced from a metaschema instance produced correctly to its definition?*


This pipeline produces an XSLT which, when applied to a Computer XML document, reports the result tree annotated with error and warning reports. The results of this XSLT can be post-processed (in the testing framework or elsewhere) to show just the reports.

Unit test this production with an [inspector production XSpec](testing/produce-inspector.xspec).
