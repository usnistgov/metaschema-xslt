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

## Standalone document-level tests

Question: *Can test samples including nominally-valid and invalid test cases be known to be valid or invalid, as described?*


Within `testing`, `valid` contains instances expected to test as valid.

Examples within `invalid` are expected to return appropriate warnings and errors. They may be commented with notes indicating their lapses.

Results in the `mx` i.e. `Q{http://csrc.nist.gov/ns/csd/metaschema-xslt}` namespace are specified in XSpec examples, while other schema processors should effectively produce the same results.


[An XSD schema ](testing/computer_metaschema-xmlschema.xsd) can be used to provide external assurance of 'valid' and 'invalid' at the document level.

Any other metaschema-based validator that supports XML can also be used.

tbd: provide automation for this

## Template and function tests

Individual templates and defined functions can also be targeted and tested in XSpec.

To the extent possible, sources should call into out-of-line metaschema examples -- and those examples validated -- in order to avoid drift.

## Testing Inspector XSLT production

Question: *Is the XSLT produced from a metaschema instance produced correctly to its definition?*

First, build `current/computer_inspector.xsl` from `computer_metaschema.xml` using `generate-inspector-xslt`
  - Use ../METASCHEMA-INSPECTOR-XSLT.xpl runtime or script to provide metaschema composition before applying the stylesheet

This pipeline produces an XSLT which, when applied to a Computer XML document, reports the result tree annotated with error and warning reports. The results of this XSLT can be post-processed (in the testing framework or elsewhere) to show just the reports.

Unit test this production with an [inspector production XSpec](testing/produce-inspector.xspec).
