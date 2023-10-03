# Metaschema XSLT Inspector

'Emmex Eye' or just "Emmex" ('MX').

A standalone XSLT can be produced by applying a stylesheet to a metaschema. Using the composition pipeline, it can apply to a top-level module of a modular metaschema.

The testing directory shows such an XSLT, which can be applied to an instance or set of instances (documents) to be tested against the rules defined by the Metaschema. This includes all rules regarding:

* Structures and content models
  * Occurrences and cardinalities of attributes and elements
  * Detection of unknown inputs
  * Detection of inputs out of place
* Lexical data type (castability) checks
* Constraints defined in the metaschema including compound/contingent, co-occurrence and key-based (referentiality) constraints

That is, it combines the effective functionality of XML schema and Schematron (XPath-based) validation.

## Principles

The tool should be both easy to use and verifiably correct.

No need to quit after first error; take advantage of 'pull' process (random access to tree).

The aims of the reporting are clarity/ease of use; to be unambiguous; to be traceable.

Reporting can be parsimonious - no need to be exhaustive.

At the same time, errors anywhere are of interest (see 'no need to quit'). Some formal redundancy is okay as long as it is not too noisy.

## Interfaces

### To use generated XSLT

Having produced the XSLT `computer-inspector.xsl` for inspecting `computer` XML documents: to validate a file `invalid10.xml` ...

```bash
saxon -xslt:computer-inspector.xsl -s:invalid10.xml
```

brings back a copy of the input annotated with MX (XML) results to STDOUT.

```bash
saxon -it:mx -xslt:computer-inspector.xsl -s:invalid10.xml
```

brings the messages only. `-it:mx-report` does the same.


```bash
saxon -it:mx -xslt:computer-inspector.xsl -s:invalid10.xml -o:results.xml
```

writes MX (XML) results (only) to file `results.xml`.


```bash
saxon -it:html -xslt:computer-inspector.xsl -s:invalid10.xml -o:results.html
```

writes HTML results to file `results.html`. Use `!method:html !html-version:5.0` to get HTML 5 output instead of XML. (Or `!method:xhtml` if preferred.) Use `!indent:true` if you don't want a code brick.

Note that HTML and Markdown results presuppose the MX filtering step.

```bash
saxon -it:md -xslt:computer-inspector.xsl -s:invalid10.xml
```

writes Markdown results to STDOUT. This is the same as `-it:markdown`.

Use `!method=text` to clear unwanted XML cruft when writing Markdown.

There is no plain text option apart from Markdown, as of yet.
 
TBD: wrapper logic for all this under `make` or Maven?

```
inspectorXSLT data.xml results.html
inspectorXSLT data.xml results.md

inspectorXSLT -md data.xml (writes results to STDOUT)
inspectorXSLT -html data.xml (writes results to STDOUT)
```


### To generate the XSLT

Use the XProc pipeline. It assembles the XSLT dynamically, combining templates produced from a metaschema source with static boilerplate and infrastructure. This XSLT can be applied directly or written out for distribution.

TBD: a script to generate a standalone XSLT, using Maven, wrapping the XML Calabash call.

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
