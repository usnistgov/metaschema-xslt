# Metaschema XSLT Inspector

'Emmex Eye' or just "Emmex" ('MX').

A standalone XSLT can be produced by applying a stylesheet to a metaschema. Using the composition pipeline, it can apply to a top-level module of a modular metaschema.

The [testing/current](testing/current) directory shows such an XSLT, which can be applied to an instance or set of instances (documents) to be tested against the rules defined by its Metaschema - in this case the Computer Model metaschema example provided. This includes all rules regarding:

* Structures and content models
  * Occurrences and cardinalities of attributes and elements
  * Detection of unknown inputs
  * Detection of inputs out of place
* Lexical data type (castability) checks
* Constraints defined in the metaschema including compound/contingent, co-occurrence and key-based (referentiality) constraints

That is, it combines the effective functionality of XML schema and Schematron (XPath-based) validation.

## Feature set (for demo)

- [x] Emit reports to STDOUT
- [x] Write reports to file system (lower ASCII, escaped HTML for emoji)
- [x] Emit reports in native (MX) format, HTML or Markdown
- [x] Compact mode returns a one-line answer
- [x] Silent-if-valid mode returns validations only for files found invalid
- [x] Run in batch, write reports to file(s)
  - [x] Using Saxon feature
  - [ ] Using XProc 
  - [ ] make post-process XSLT digesting a sequence of MX results
- [x] Validate structures - names and cardinalities
- [x] Validate lexical rules over datatypes
  - [ ] more testing 
- [ ] Validate constraints
- [x] Write reports to file (HTML, Markdown)
- [x] Emit copy of source annotated with validation messages
- [ ] Run in browser / SaxonJS
- [ ] other ideas below

## Design goals and principles

The tool should be both easy to use and verifiably correct.

("Easy to use" being relative, possibly the goal is "easy to make easy to use", with one or two easy-to-use ways to use it.)

No need to quit after first error; take advantage of the 'pull' process (random access to tree) to give a complete picture of a document's state vis-a-vis validation requirements.

The aims of the reporting are clarity/ease of use; to be unambiguous; to be traceable. To be concise and economical is a secondary goal.

Reporting can be parsimonious - no need to be exhaustive.

At the same time, errors anywhere are of interest (see 'no need to quit'). Some amount of redundancy is okay if not too noisy.

## Interfaces - how to use

The tool is designed to be used standalone in an XSLT 3.0-capable processing environment, or to be embedded. For testing, we use a command-line XSLT engine such as Saxon (v10 or later).

For convenience, in the testing directory are example scripts that run Saxon inside Maven to (a) produce an Inspector XSLT from a metaschema, then subsequently (b) apply this XSLT to an XML document to report issues detected in it, to delivering this report in HTML or Markdown format:

- `testing/refresh-computer-inspector.sh` refreshes "computer metaschema" example XSLT
- `testing/inspect-computer-md.sh` applies this XSLT to a 'computer' XML document returning Markdown
- `testing/inspect-computer-html.sh` applies this XSLT to a 'computer' XML document returning HTML

These scripts demonstrate one way to invoke Saxon but there are many others suited to different operational contexts and systems, including other deployments of Saxon (Saxon-C or SaxonJS, just to name two). 

The scripts also pass through arguments provided them to the receiving application, so that the flags and switches described below will also work, unless a script sets the same configuration itself.

### To use generated XSLT directly

If a script is not well-suited or easily adaptable, or for testing/experiment, Saxon can also be used directly. The following assumes that Saxon is set up to run from a command `saxon`. Arguments and command-line flags support functionalities beyond what is scripted, and can also be frequently be used *in combination* with the scripts. 

#### Summary

Command line flags and options for using the InspectorXSLT with Saxon - note use of `:` and `=` and an ordering requirement, that all parameters (`param=`) be placed after all flags (`-flag:`), but the order of parameters or flags does not matter.

- `-s` required flag indicates the source file or directory - if a directory, `-o` is also required
- `-o` optional flag indicates where to write a report file; if omitted the report comes back to STDOUT; required when `-s` is a directory
- `-it:markdown`, `-it:md`, `-im:markdown` and `-im:md` all produce Markdown
- `-it:html` and `-im:html` produce (the same) HTML
- `-it:mx-report`, `-it:mx`, `-im:mx-report`, and `-im:mx` all produce (the same) report in an MX XML format, suitable for further processing
- Leaving out `-it` or `-im`, you should expect a copy of the document with its MX reports embedded close to the validation errors they report
- `-it` is short for `-initial-template` while `-im` is short for `-initial-mode`
- If both `-it` and `-im` are given, expect `-it` to prevail
- Parameter `mode` further affects the results:
  - `mode=concise` writes only one-line summaries - most useful for Markdown output
  - `mode=silent-when-valid` suppresses reports from valid instances\*
  - `mode=noisy` provides extra progress reports to STDOUT - useful for tracing when writing outputs to files
  
TBD, to be considered:

  - `mode=compressed` could have the effect of removing double-newlines from Markdown
  - filters to remove messages by level, code or matched node (XPath)

\* The setting `mode=silent-when-valid` is most useful when the results come to the console, not a file. Unfortunately, since Saxon directed with `-o` is obliged to write some kind of file output, 0-byte file entities are still produced even for "empty" outputs created when reports of validity are suppressed. These files can be removed with `$ find dir -type f -empty -print -delete` (Linux CL) or equivalent, where `dir` is the directory (path).

#### Tweaking result file names

Saxon supports the excellent feature of processing an entire directory of inputs at a time, with the limitation that result files (validation reports in this application) are named after the source files from which they are produced.

Especially when Markdown or HTML results are produced in batch with names matching the names of XML inputs, it can be useful to follow a directory-level operation with a global renaming of `.xml` to `-report.html` (or `-report.md` etc.). The many ways to do this including (in Linux systems) a bash script invoked inside a subshell:

```
(cd reports && for f in $(ls *.xml); do mv $f ${f%.*}-report.html; done)?
```

`reports` being the path to the directory where the misnamed files can be found.

Of course this also not the only way to automate the validation and reporting processes for efficiency over many inputs in one run.

#### Scenarios calling Saxon
---

Having produced the XSLT `computer-inspector.xsl` for inspecting `computer` XML documents: **to validate a file** `invalid10.xml` ...


---

**Bring back a copy of the input annotated** with MX (XML) results to STDOUT.

```bash
saxon -xslt:computer-inspector.xsl -s:invalid10.xml
```

---

**Bring the messages only.** `-it:mx-report` does the same. `-it` designates an initial template. For convenience the Inspector XSLT also supports `-im` (designating an initial mode) with the same values and effects. If both are given the processor uses `-it`.


```bash
saxon -it:mx -xslt:computer-inspector.xsl -s:invalid10.xml
```

---

**Write MX (XML) results (only) to a file** `results.xml`:


```bash
saxon -it:mx -xslt:computer-inspector.xsl -s:invalid10.xml -o:results.xml
```

This can be useful to capture MX reports for further processing.

---

**Write HTML results to a file** `results.html`. Use `!method:html !html-version:5.0` to get HTML 5 output instead of XML. (Or `!method:xhtml` if preferred.) Use `!indent:true` if you don't want a code brick.


```bash
saxon -it:html -xslt:computer-inspector.xsl -s:invalid10.xml -o:results.html
```


Note that HTML and Markdown results presuppose the MX filtering step - they do not present a copy of the document being validated.

---

To **write Markdown results to STDOUT**. (Note lack of `-o` argument.) This is the same as `-it:markdown`:

```bash
saxon -it:md -xslt:computer-inspector.xsl -s:invalid10.xml
```

---

To write **Markdown results to STDOUT except emit *one line only***. This uses the `mode` parameter.:

```bash
saxon -it:md -xslt:computer-inspector.xsl -s:invalid10.xml mode=concise
```

---

And to **silence results entirely when a file is found to be valid**:

```bash
saxon -it:md -xslt:computer-inspector.xsl -s:invalid10.xml mode=silent-when-valid
```

(This also works with `-it:html` for HTML reports.)

---

To **run over a set of files** in a folder named `to-validate` and produce result (files) in a new folder, `reports`:

```bash
saxon -xslt:computer-inspector.xsl -s:to-validate -o:reports
```

Note - results are written for all files, valid and invalid, irrespective of findings. So even when `mode=silent-if-valid`, empty files is produced for a valid instances. See above for hints.

---

To **report as files are found to be valid or invalid** to STDOUT, *additional* to producing reports.

Use `mode=noisy` if you wish to see progress in the console even when directing results to file outputs. It will announce findings of both valid and invalid files, one line per file; so it is similar to `mode=concise` except it supplements instead of replaces the production of complete reports - so progress can be monitored as well as results can be written out. This mode cannot be used with `silent-if-valid` or `concise`.

This feature is designed to be used when validating in batch and writing results to files. When validating a single file or not producing static results, consider using `mode=concise` instead (for example, to produce and see Markdown in the console).

```bash
saxon -it:html -xslt:computer-inspector.xsl -s:invalid10.xml -o:invalid10-report.html mode=noisy
```

---

There is much else that can be done to produce **batched and grouped reports** including analytical summaries, etc., by aggregating and post-processing MX, HTML or Markdown outputs. 

### To do: further work on scripting

Instrument to run from the CL, inferring the mode from the result filename and hard wiring the `computer-inspector.xsl` stylesheet:

```
computerInspectorXSLT data.xml results.html
computerInspectorXSLT data.xml results.md
computerInspectorXSLT data.xml results.xml

computerInspectorXSLT -md data.xml (writes results to STDOUT)
computerInspectorXSLT -mx data.xml (writes results to STDOUT)
computerInspectorXSLT -html data.xml (writes results to STDOUT)
computerInspectorXSLT -md data.xml mode=concise
```

This all ought to be doable in `make`, no?

Alternatively, note that *these scripts as well* might be generated from Metaschema source as they are mostly boilerplate. So to the extent they can be produced on the basis of  `/METASCHEMA/short-name` etc. we should consider doing that.

### To generate the XSLT

A fresh and complete Inspector XSLT for any metaschema (any valid and workable instance of [Metaschema](https://pages.nist.gov/metaschema/)) can be produced using an XProc pipeline or an XSLT that emulates this pipeline.

- ../METASCHEMA-INSPECTOR-XSLT.xpl
- ../nist-metaschema-MAKE-INSPECTOR-XSLT.xsl

In this sequence of transformations the target (result) XSLT is assembled dynamically, by combining templates produced from a metaschema source with static boilerplate and infrastructure.

An example script calling the XSLT pipeline (thus requiring only Saxon, not XML Calabash) is given as [testing/mvn-refresh-computer-inspector.sh](testing/refresh-computer-inspector.sh).

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

### XSLT 1.0?

We know that we can't do everything under XSLT 1.0 (such as regular expressions for lexical type checking) but we might be able to provide a significant subset, as a "sine qua non" first-cut validator.
