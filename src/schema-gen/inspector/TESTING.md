# Testing the XSLT Metaschema Inspector

Find resources for testing the XSLT Inspector and its production in the [testing](testing) subdirectory.

## Inspector functionality

Produced from a metaschema, an Inspector is an XSLT transformation which produces, when applied to an XML document, error and warning messages from that document respecting its conformance to the rules dictated by that metaschema.

In other words the Inspector is a Schema Emulator, and can expect to return the same information (effectively) as schema validation.

We unit test this in two ways. When developing keep in mind that both sets of tests may be useful, and both should always be run when available.

### Functional document-level tests

Valid instances are expected to test as valid.

Invalid instances are expected to return appropriate warnings and errors.

These are specified in XSpec examples.

Run XSpec:

- In oXygen
- (tbd) in a standalone runtime

### Template and function tests

Individual templates and defined functions can also be targeted and tested in XSpec.

To the extent possible, sources should call into out-of-line metaschema examples -- and those examples validated -- in order to avoid drift.

## Inspector production from Metaschema sources

A test 'reference' Inspector XSLT may be kept and maintained by hand as a static resource, but the point is to generate the Inspector XSLT from metaschema inputs. This pipeline can also be tested.

