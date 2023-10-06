# Metaschema XSLT Inspector

'Emmex Eye' or just "Emmex" ('MX').

A standalone XSLT can be produced by applying a stylesheet to a metaschema. Using the composition pipeline, it can apply to a top-level module of a modular metaschema.
The [testing/current](testing/current) directory shows such an XSLT, which can be applied to an instance or set of instances (documents) to be tested against the rules defined by the Metaschema. This includes all rules regarding:

* Structures and content models
  * Occurrences and cardinalities of attributes and elements
  * Detection of unknown inputs
  * Detection of inputs out of place
* Lexical data type (castability) checks
* Constraints defined in the metaschema including compound/contingent, co-occurrence and key-based (referentiality) constraints

That is, it combines the effective functionality of XML schema and Schematron (XPath-based) validation.
## Feature set (for demo)

- [x] Emit reports to STDOUT
- [ ] Compact mode? summary-only
- [ ] Run in batch, write reports to file(s)
- [x] Validate structures - names and cardinalities
- [x] Validate lexical rules over datatypes
  - [ ] more testing 
- [ ] Validate constraints
- [x] Write reports to file (HTML, Markdown)
- [x] Emit copy of source annotated with validation messages
- [ ] Run in browser / SaxonJS

## Design goals and principles

The tool should be both easy to use and verifiably correct.

No need to quit after first error; take advantage of the 'pull' process (random access to tree) to give a complete picture.

The aims of the reporting are clarity/ease of use; to be unambiguous; to be traceable. To be terse and economical is a secondary goal.

Reporting can be parsimonious - no need to be exhaustive.

At the same time, errors anywhere are of interest (see 'no need to quit'). Some amount of redundancy is okay if not too noisy.

## Interfaces - how to use

The tool is designed to be used standalone in an XSLT 3.0-capable processing environment, or to be embedded. For testing, we use a command-line XSLT engine such as Saxon (v10 or later). The following assumes that Saxon is set up to run from a command `saxon`.

In the testing directory are example scripts that run Saxon inside Maven to (a) produce an Inspector XSLT from a metaschema, then subsequently (b) apply this XSLT to an XML document to report issues detected in it, to delivering this report in HTML or Markdown format:

- `testing/mvn-refresh-computer-inspector.sh` refreshes "computer metaschema" example XSLT
- `testing/mvn-inspect-computer-md.sh` applies this XSLT to a 'computer' XML document returning Markdown
- `testing/mvn-inspect-computer-html.sh` applies this XSLT to a 'computer' XML document returning HTML

These scripts demonstrate one way to invoke Saxon but there are many others suited to different operational contexts and systems, including other deployments of Saxon (Saxon-C or SaxonJS, just to name two). 

### To use generated XSLT

Having produced the XSLT `computer-inspector.xsl` for inspecting `computer` XML documents: to validate a file `invalid10.xml` ...

```bash
saxon -xslt:computer-inspector.xsl -s:invalid10.xml
```

Bring back a copy of the input annotated with MX (XML) results to STDOUT.

```bash
saxon -it:mx -xslt:computer-inspector.xsl -s:invalid10.xml
```

Bring the messages only. `-it:mx-report` does the same. `-it` designates an initial template. For convenience the Inspector XSLT also supports `-im` (designating an initial mode) with the same values and effects. If both are given the processor uses `-it`.

```bash
saxon -it:mx -xslt:computer-inspector.xsl -s:invalid10.xml -o:results.xml
```

Write MX (XML) results (only) to file `results.xml`:


```bash
saxon -it:html -xslt:computer-inspector.xsl -s:invalid10.xml -o:results.html
```

Write HTML results to file `results.html`. Use `!method:html !html-version:5.0` to get HTML 5 output instead of XML. (Or `!method:xhtml` if preferred.) Use `!indent:true` if you don't want a code brick.

Note that HTML and Markdown results presuppose the MX filtering step.

To write Markdown results to STDOUT. (Note lack of `-o` argument.) This is the same as `-it:markdown`:

```bash
saxon -it:md -xslt:computer-inspector.xsl -s:invalid10.xml
```

To run over files in `invalid` and produce result (files) in a new folder, `v-invalid`:


```bash
saxon -xslt:computer-inspector.xsl -s:invalid -o:v-invalid
```

### To do: further work on scripting

Instrument to run from the CL:

```
inspectorXSLT data.xml results.html
inspectorXSLT data.xml results.md
inspectorXSLT data.xml results.xml

inspectorXSLT -md data.xml (writes results to STDOUT)
inspectorXSLT -mx data.xml (writes results to STDOUT)
inspectorXSLT -html data.xml (writes results to STDOUT)
```

Also - batch process folders or globbed files?

### To generate the XSLT

Best/easiest to use the XProc pipeline or the XSLT that emulates this pipeline.

- ../METASCHEMA-INSPECTOR-XSLT.xpl
- ../nist-metaschema-MAKE-INSPECTOR-XSLT.xsl

In this sequence of transformations the target (result) XSLT is assembled dynamically, by combining templates produced from a metaschema source with static boilerplate and infrastructure. This XSLT can be applied directly (for testing) or written out for distribution.
An example script that generates such an XSLT is given as [testing/mvn-refresh-computer-inspector.sh](testing/mvn-refresh-computer-inspector.sh).

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
