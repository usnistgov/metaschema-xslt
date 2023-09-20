# Metaschema XSLT Inspector

A standalone XSLT can be produced by applying a stylesheet pipeline to a metaschema source.

The testing directory shows an XSLT that can be applied to an instance or set of instances (documents) to be tested against the rules defined by the Metaschema. This includes all rules regarding:

* Structures and content models
  * Occurrences and cardinalities of attributes and elements
  * Detection of unknown inputs
  * Detection of inputs out of place
* Lexical data type (castability) checks
* Constraints defined in the metaschema including compound/contingent, co-occurrence and key-based (referentiality) constraints

That is, it combines the effective functionality of XML schema and Schematron (XPath-based) validation.

## Plans

XProc 1.0 (and 3.0) pipeline to generate standalone XSLT.

This XSLT when applied to an instance produces errors and warnings.

### Under Java/Maven

This XSLT can be scripted and run from the command line
  - delivering HTML results
  - or Markdown

### Under NodeJS

It could also be compiled into SEF for SaxonJS and delivered as a NodeJS command line application or library

### In the browser

Another SEF with interface and SVRL rendering templates could provide this functionality under SaxonJS in the browser.

### XSLT 1.0?

We know that we can't do everything under XSLT 1.0 (such as regular expressions for lexical type checking) but we might be able to provide a significant subset, as a "sine qua non" first-cut validator.

## Punchlist

- [x] stand up apply-validator to run a 'null validation' in no-mode
- [x] inject as boilerplate into input doc for XSLT generator
  - [ ] any more static code to consolidate in boilerplate?
- [ ] provide and test datatype validation
- [ ] deliver as XSLT with optional post-processes applied
  - embedded report (annotated tree)
  - report only - summary/detail HTML
  - report only - summary/detail Markdown
  - offer the same, only XProc?
- [ ] constraints!
