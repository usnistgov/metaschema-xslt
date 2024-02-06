# Planning


## Feature set (for demo)

- [x] Emit copy of source annotated with validation messages
- [x] Emit reports to STDOUT
- [x] Write reports to file system (lower ASCII, escaped HTML for emoji)
- [x] Emit reports in native (MX) format, HTML, Markdown or plain text (compacted Markdown)
- [x] Supports full, summary or one-line results per instance
- [x] Can echo progress as it writes
- [x] Run in batch
  - [x] Using Saxon feature (writing files)
  - [x] Using shell
  - [ ] Using XProc 
  - [ ] make post-process XSLT digesting a sequence of MX results
- [x] Validate structures - names and cardinalities
- [x] Validate lexical rules over datatypes
  - [ ] more testing 
- [x] Validate constraints
- [ ] Run in browser / SaxonJS
- [ ] MX->SVRL filter postprocess
- [ ] other ideas below


### To do: further work on scripting

Instrument to run from the CL, inferring the mode from the result filename and hard wiring the `computer-inspector.xsl` stylesheet:

```
computerInspectorXSLT data.xml results.html
computerInspectorXSLT data.xml results.md
computerInspectorXSLT data.xml results.xml

computerInspectorXSLT -md data.xml (writes results to STDOUT)
computerInspectorXSLT -mx data.xml (writes results to STDOUT)
computerInspectorXSLT -html data.xml (writes results to STDOUT)
computerInspectorXSLT -md data.xml mode=one-liner
```

This all ought to be doable in `make`, no?

Alternatively, note that *these scripts as well* might be generated from Metaschema source as they are mostly boilerplate. So to the extent they can be produced on the basis of  `/METASCHEMA/short-name` etc. we should consider doing that.

## Plans

### Functional enhancements

- Filters to sort, sift?
- HTML aggregation layer? over collections
- CSS customization (CSS-based filtering?)
- or all this could be done dynamically (CSX)

### Under NodeJS

It could also be compiled into SEF for SaxonJS and delivered as a NodeJS command line application or library

### In the browser - CSX (client-side XSLT)

Another SEF with interface and SVRL rendering templates could provide this functionality under SaxonJS in the browser.

See https://pages.nist.gov/oscal-tools/demos/csx/validator/ for prior work/PoC.

### XProc / XML Calabash

For batching and post-processing validations using an XSLT, the sky is the limit.

### Python runtime?

How hard can it be?

### OSCAL application

Should go into oscal-xslt repository

### JSON support?

One approach could be to produce templates not to match XML (that is or is not conformant to expectations) but JSON (that is or is not conformant to the metaschema-analogous expectations).

JSON could first be cast into an XDM map, so this operation conceivably could mean an XSLT generator whose output XSLT would match not nodes but objects (properties) in this map - checking to see whether they resolve to maps, arrays and values as planned - and whose templates indeed would perform a 'map traversal'.

### Line numbers

Alas, can't get line numbers in Saxon-HE. We could provide optional line number echoing potentially in a version requiring licensed Saxon.

### XSLT 1.0?

We know that we can't do everything under XSLT 1.0 (such as regular expressions for lexical type checking) but we might be able to provide a significant subset, as a "sine qua non" first-cut validator.

---

notes - combinatorial allowed-values implementation

inspector XSLT carries a template cascade
- it reports back both values and IDs
- the cascade overloads priority="100" for competing `allowed-values`
  mode has on-multiple-match="use-last" so that they can be made (purposefully) to compete (last wins)
  - these must all be identical so an effective no-op when redundant
  - any/each of which (only one of them being used under use-last) pulls the entire collection of values/IDs matching this node


