# Testing the XSLT Metaschema Inspector

Produced from a metaschema, an Inspector is an XSLT transformation which produces, when applied to an XML document, error and warning messages from that document respecting its conformance to the rules dictated by that metaschema.

In other words the Inspector is a Schema Emulator, and can expect to return the same information (effectively) as schema validation.

Broadly, this presents at least three areas for testing (each of which has complexities)
- Generation of the Inspector XSLT from controlled (metaschema) sources
- Functionality of the Inspector XSLT
- Interfaces and outputs / runtime options for Inspector XSLT

Currently we focus on the *first two* of these, producing functional results in a simplified format that we can build to later - testing interface targets at that time as appropriate. An example would be producing HTML or Markdown reports: for now we test only generic reports in a format we control.

Find resources for testing the XSLT Inspector and its production in the [testing](testing) subdirectory.

## Inspector XSLT production

First, build `current/computer_inspector.xsl` from `computer_metaschema.xml` using `generate-inspector-xslt`
  - Use ../METASCHEMA-INSPECTOR-XSLT.xpl runtime or script to provide metaschema composition

This pipeline produces an XSLT which, when applied to a Computer XML document, reports the result tree annotated with error and warning reports. The results of this XSLT can be post-processed (in the testing framework or elsewhere) to show just the reports.

Unit test this production with an [inspector production XSpec](testing/produce-inspector.xspec).

## Inspector XSLT application / correctness

The functionality of `computer-inspector.xsl` can be unit tested with [its own XSpec]().

It uses both inline examples and out of line examples from the 'invalid' suite.

The XSLT `filter-for-mx.xsl` can be used as utility XSLT for post-processing results before comparison.

A couple of patterns:

- inline source (computer fragment) validation and cleanup with inline mx:results
- out of line source (XPath into 'invalid' example) validation and cleanup with inline results
  - both full/complete
  - and using XPath to target

## Standalone document-level tests

Valid instances are expected to test as valid.

Invalid instances are expected to return appropriate warnings and errors.

These are specified in XSpec examples.

## Template and function tests

Individual templates and defined functions can also be targeted and tested in XSpec.

To the extent possible, sources should call into out-of-line metaschema examples -- and those examples validated -- in order to avoid drift.
