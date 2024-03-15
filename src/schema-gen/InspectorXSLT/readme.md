# Metaschema XSLT Inspector

Check your XML with an XSLT to see if it is valid to the rules defined in a metaschema.

Developers are urged to review this file in outline before reading it in detail. For experienced XSLT developers, it explains the interfaces. For beginners, it should tell you what you need to know. Any sections not of immediate interest can be skipped for later.

## Project status

This tool is now at a nominal version **0.8**, with plans for these milestones:

**v0.9** - will support all Metaschema features used in [OSCAL](http://pages.nist.gov/OSCAL/), the Open Security Controls Assessment Language, with conformance demonstrated with tests

**v1.0** - Supports all features specified for [Metaschema](http://pages.nist.gov/metaschema/) v1.0 as applied to XML, also with tests demonstrating conformance.

Metaschema is a NIST project in the Information Technology Lab (ITL) supporting the abstract description of data models expressible in either XML or JSON syntax (or other syntaxes), designed to enable and facilitate standards-based data exchange of information related to systems security.

As of early 2024, Metaschema is not yet finalized at version 1.0. As noted below, providing its definitions with validation in the form of a (second) conformant implementation is a driving motive for this project.

## How this works

A standalone XSLT ("stylesheet" or transformation specification) can be produced by applying a stylesheet (an XSLT) to a metaschema. Using the metaschema-xslt [composition pipeline](../../compose/), it can apply to a top-level module of a modular metaschema.

The XSLT that is created this way can be used to test XML instances for errors in view of the rules defined by the metaschema definitions.

* Element and attribute types, structures and content models
  * Occurrences and cardinalities of attributes and elements
  * Detection of unrecognized tagging
  * Detection of tagging out of place
* Lexical data type (castability) checks
* Constraints defined in the metaschema including compound and contingent constraints, co-occurrence, and key-based (referentiality) constraints

That is, it combines the effective functionality of XML schema and Schematron (XPath-based) validation.

## Limitations

Aiming at a complete and conformant implementation for XML of the [Metaschema](https://pages.nist.gov/metaschema) language version 1.0, there are a few known gaps, with a testing framework and protocols now being established both for filling those gaps and for demonstrating the tool's full functionality. Please use the processor with this in mind, that developers and sponsors need your feedback and contributions to enable us to complete the work.

Currently we plan to support only XML-based formats as defined by Metaschema, not their semantically-equivalent JSON or YAML 'cousins'.

Users of Metaschema-defined JSON can try reformatting their data as XML using automated means such as scripts produced by the  [Metaschema XSLT Converter Generators](../../converter-gen). Successful conversion will be valid on the other side. But failures will be indicated not typically be invalid results, and instead results missing those parts of the invalid that went unrecognized by the converter because they are invalid.

## Demonstrations

The [testing/current](testing/current) directory shows such an XSLT, which can be applied to an instance or set of instances (documents) to be tested against the rules defined by its metaschema - in this case the Computer Model metaschema example provided.

Alternatively, follow the directions to build an XSLT reflecting the rules of any other metaschema, with which XML conforming to those rule sets may be validated.

See the [Metaschema project site](https://pages.nist.gov/metaschema) for more information.

## Note for OSCAL users

While the intent of this project is to support OSCAL\* formats fully, and OSCAL will be an important testbed for these applications, the OSCAL Metaschema modules given in the current version (1.1.1) do *not* process flawlessly (as of the beta-version Inspector Generator) to produce a viable InspectorXSLT rules checker, without patching.

See [the tracking issue](https://github.com/usnistgov/metaschema-xslt/issues/91) for any updates, with possible mitigations for those interested.

\* OSCAL is the [Open Security Controls Assessment Language](https://pages.nist.gov/OSCAL/), a family of schemas describing documentary formats in Systems Security - Catalogs, Profiles (baselines or overlays), System Security Plans (SSP), Security Assessment Plans (SAP) and Reports (SAR), and others.

## Project purposes

While this project offers a tool that may be useful (for data validation) its ultimate focus is not the data validation as such, but to demonstrate principles of verifiable and trustworthy data validation.

A primary goal of this project is to serve as a complete and correct implementation of the [NIST Metaschema Modeling Framework](https://pages.nist.gov/metaschema), in demonstration of its features, with the objective of helping to confirm, by testing, its approach to data modeling and governance.

A secondary goal is to be fully transparent and traceable in operation and documented and tested fully, so as to serve as a resource and template for future developers of Metaschema, XML/XSLT and other technologies.

Neither *scalability* nor *performance* are primary goals, although considered valuable and worth working for.

Given these considerations on balance, *correctness* comes first in order of priority, while *usability* and *testability* come second and third.

### Who are you? some possible use scenarios

- New, occasional, or intermittent users of a Metaschema-based tech, who need to validate data
- Regular users of a metaschema or Metaschema-based tech
  - who need to validate data
  - who need to confirm the correctness of others' validations
- Developers of Metaschema-based applications
  - who wish to use or deploy an easy validation service
  - who prefer to focus on implementing semantics, not on modeling and validating to models - but who need to provide for data validation and support others in doing so
- Developers of Metaschema
  - who want more tools,
  - who need and expect diversity in a healthy standards ecosystem
  - and who wish to compare implementation strategies and approaches
- XSLT/XSpec students and developers
  - since the codebase aims to be transparent and traceable as well as useful in operation

### Aims

For new, regular and occasional users and developers of Metaschema-based technologies

* InspectorXSLT and MX\* aim to be easy to use and start using
* Correct and trustworthy in what it attempts to do
* And compatible with workflows using other conformant tools

For developers and maintainers of Metaschema-based data modeling and processing stacks, this tool (and all tools in the repo) aspires

* To be lightweight, easy to deploy, easy to adapt and useful,
* To be versatile (given its scope of application, namely validation)
* And to serve as a complement to other Metaschema tools and applications\*

For XML- and XSLT-focused developers of Metaschema and Metaschema-based technology

* MX is open, in the public domain, and standards-based
* And aims to be fully and openly tested

\* Applications to consider using along with InspectorXSLT include the schema and converter-stylesheet generators in this repository as well as tools from other developers. MX can even check against itself by validating documents with both the Inspector and its XSD - the same issues should be reported over invalid data (insofar as the XSD is able to express them) using either tool.

### Use cases we have not catered to

- Developers who wish to build their own metaschema-aware applications
  - This application is intended to be operated as a black box: while at core this is a code generator, it is not designed to be easily extensible as such or produce a 'library', so you might prefer to reverse engineer it than to extend it
  - I.e., while it should be easy enough to generate, deploy and use an InspectorXSLT for a metaschema you find or build, for building your own XSLT transpiler, you are welcome to borrow but you are on your own.
- Robots or 'lights out' automated processes (untested)
  - The interfaces are designed to be flexible for interfacing but YMMV as to scale/throughput - experience will tell
  - Our expectation is that performance will be good under normal loads but metaschemas will also vary considerably 

## Feature set (for demo)

- Emit copy of source annotated with validation messages
- Emit reports to STDOUT
- Write reports to file system (lower ASCII, escaped HTML for emoji)
- Emit reports in native (MX) format, HTML, Markdown or plain text (compacted Markdown)
- Supports full, summary or one-line results per instance
- Can echo progress as it writes
- Run in batch
  - Using Saxon feature (writing files)
  - Using shell
  - (tbd) Using XProc 
  - (tbd) make post-process XSLT digesting a sequence of MX results
- Validate structures - names and cardinalities
- Validate lexical rules over datatypes
- Validate constraints as defined by Metaschema
  - allowed values; string matching; referential integrity; arbitrary queries (assertions)
## Interfaces - how to use

### Schematron harness

InspectorXSLT was engineered to be used as a standalone XSLT, for maximum usability. Of course this means it can be also be embedded. And since Schematron is commonly deployed as an XSLT application, a full-fledged Schematron-based implementation is feasible as a possible follow-on application.

A simple <q>wrapper</q> Schematron that calls the InspectorXSLT for you and delivers its messages in a Schematron process, is even easier to engineer, and [one has been included](testing/computer-testing.sch) here in the [`testing`](testing/) folder.

### Shell scripts

The tool is designed to be used standalone in an XSLT 3.0-capable processing environment, or to be embedded. For testing, we use a command-line XSLT engine such as Saxon (v10 or later). We test with Saxon-HE in order to ensure this execution dependency remains available.

For convenience, in the testing directory are example scripts that run Saxon inside Maven to (a) produce an Inspector XSLT from a metaschema, then subsequently (b) apply this XSLT to an XML document to report issues detected in it, to delivering this report in HTML or Markdown format:

- `testing/refresh-computer-inspector.sh` refreshes "computer metaschema" example XSLT
- `testing/inspect-computer.sh aComputerXML.xml format=md` applies this XSLT to a 'computer' XML document returning Markdown
- `testing/inspect-computer.sh aComputerXML.xml -o:report.html format=html` applies this XSLT to a 'computer' XML document, and writes an HTML report to a file called `report.html`
- with many more options - see script help or more info below

These scripts demonstrate one way to invoke Saxon but there are many others suited to different operational contexts and systems, including other deployments of Saxon (Saxon-C or SaxonJS, just to name two). 

The scripts also pass through arguments provided them to the receiving application, so that the flags and switches described below will also work.

### Command-line XSLT execution

If a script is not well-suited or easily adaptable, or for testing/experiment, Saxon can also be used directly, using the same syntax (which the scripts mainly pass through).

#### Summary

Command line flags and options for using the InspectorXSLT with Saxon - note use of `:` and `=` and an ordering requirement, that all parameters (`param=`) be placed after all flags (`-flag:`), while the order of parameters or flags otherwise does not matter.

##### Flags for source, output, alternative entry points

- `-s` required flag indicates the source file or directory - if a directory, `-o` is also required
- `-o` optional flag indicates where to write a report file; if omitted the report comes back to STDOUT; required when `-s` is a directory
- `-it` (or `--initial-template`) settings are supported as aliases of the `format` parameter (see below). If `format` is not given, a template can be called by name to initiate the same behavior. This is mainly useful for debugging or to configure a different fallback behavior from the core default in deployment.

##### Parameters

Runtime parameters dictate the behavior of the transformation engine and the transformation results

- `format=markdown` and `format=md` produce Markdown
- `format=plaintext` drops double line-feeds from the Markdown producing a plain text format (or `format=plain` or `format=text`)
- `format=html` produces HTML (or `webpage` in case you are guessing)
- `format=mx-report` or `format=mx` produce (the same) report in an MX XML format, suitable for further processing
-  `format=inspected` returns a copy of the input with metadata regarding the validation and validation reports embedded

The fallback behavior, if no format is indicated via `format` (or an initial template), is `inspected`, producing an annotated copy. This is also the simplest operation, which makes it easiest to debug.

The `form` parameter provides for adjustments to be made to outputs (HTML, Markdown or plaintext):

  - `form=summary` suppresses all details and presents only a summary
  - `form=one-line` suppresses everything but a single summary line
  - Otherwise a form value `full` is inferred and the full results included

The `echo` parameter can be used to supplement output reports with messages to the console. This feature is *complementary* to the basic reporting and is expected to be used along with it, especially when reports are written to files.

  - `echo=none` or no `echo` parameter provides no echo
  - `echo=docs` reports an instance found valid or invalid
  - `echo=invalid-only` reports an instance found invalid
  - `echo=info` reports the valid/invalid finding plus info messages
  - `echo=warnings` reports the valid/invalid finding plus warnings and info messages
  - `echo=all` (or any `echo` other than `none`) reports the finding plus all errors, warnings and info messages

When producing HTML reports, a file name reference to an out-of-line CSS resource can be provided. It will drop from HTML outputs the inlined CSS, and instead provide a link to the named resource. Provide a CSS file with that name to control all the styling of the reports.

  - `css=cssfile.css` replaces CSS in your HTML header with `<link rel="stylesheet" href="cssfile.css">`.

TBD, to be considered (let us know):

  - filters to remove messages by level, code or matched node (XPath)

#### Tweaking result file names

Saxon supports the excellent feature of processing an entire directory of inputs at a time, with the limitation that result files (validation reports in this application) are named after the source files from which they are produced.

Especially when Markdown or HTML results are produced in batch with names matching the names of XML inputs, it can be useful to follow a directory-level operation with a global renaming of `.xml` to `-report.html` (or `-report.md` etc.). The many ways to do this include (in \*nix systems) a bash script invoked inside a subshell:

```
(cd reports && for f in $(ls *.xml); do mv $f ${f%.*}-report.html; done)
```

`reports` being the path to the directory where the misnamed files can be found.

It is possible to use this technique with a script as well:

```
(cd ready && for f in $(ls *.xml); do ./inspect-computer.sh -im:md -s:$f form=one-line; done)
```

In this case, `*.xml` files in the `ready` folder are run through the Inspector with a one-line Markdown report offered back.

Of course this also not the only way to automate the validation and reporting processes for efficiency over many inputs in one run.

#### Example scenarios calling Saxon

Various different command-line options can modify operations, either using Saxon and runtime parameters directly, or through scripting.

The XSLT initial template feature, XSLT runtime parameters, and redirecting processing results together provide a range of capabilities.

In the examples below, syntax for many of these is shown. This assumes `saxon` is available as an executable, such as a script that calls Saxon in Java or Maven: adjust as needed.

Having produced the XSLT `computer-inspector.xsl` for inspecting `computer` XML documents: **to validate a file** `invalid10.xml` ...

---

**Bring back a copy of the input annotated** with MX (XML) results to STDOUT.

```bash
saxon -xslt:computer-inspector.xsl -s:invalid10.xml
```

---

**Bring the messages only.** `-it:mx-report` does the same. `-it` designates an initial template. For convenience the Inspector XSLT also supports `-im` (designating an initial mode) with the same values and effects. If both are given the processor uses `-it`.


```bash
saxon -xslt:computer-inspector.xsl -s:invalid10.xml format=mx
```

---

**Write MX (XML) results (only) to a file** `results.xml`:


```bash
saxon -xslt:computer-inspector.xsl -s:invalid10.xml -o:results.xml format=mx
```

This can be useful to capture MX reports for further processing.

---

**Write HTML results to a file** `results.html`. Use `!method:html !html-version:5.0` to get HTML 5 output instead of XML. (Or `!method:xhtml` if preferred.) Use `!indent:true` if you don't want a code brick.


```bash
saxon -xslt:computer-inspector.xsl -s:invalid10.xml -o:results.html format=html
```


Note that HTML and Markdown results presuppose the MX filtering step - they do not present a copy of the document being validated.

---

To **write Markdown results to STDOUT**. (Note lack of `-o` argument.) This is the same as `-it:markdown`:

```bash
saxon -xslt:computer-inspector.xsl -s:invalid10.xml format=md
```

---

To write **Markdown results to STDOUT except emit *one line only***. This uses the `form` parameter.:

```bash
saxon -xslt:computer-inspector.xsl -s:invalid10.xml form=one-line format=md
```

---

And to **silence results entirely when a file is found to be valid**:

```bash
saxon -xslt:computer-inspector.xsl -s:invalid10.xml -o:/dev/null echo=invalid-only
```

---

Or instead to **echo warnings and info** (only) to the console but otherwise silence results:

```bash
saxon -xslt:computer-inspector.xsl -s:invalid10.xml -o:/dev/null echo=warnings
```

Why would you want to do this? Because you know of errors already but want an update regarding any warnings.

---

To **run over a set of files** in a folder named `to-validate` and produce result (files) in a new folder, `reports` (with Markdown reports):

```bash
saxon -xslt:computer-inspector.xsl -s:to-validate -o:reports format=md
```

Note - results are written for all files, valid and invalid, irrespective of findings. Extra empty files can be fairly easily removed with a utility.

---

To **report as files are found to be valid or invalid** to STDOUT, *additional* to producing reports.

The `echo` feature is useful when using the `-o` argument to direct outputs (complete or summaries) to file or device. Additional to the primary outputs, `echo` produces a record and summary view to a secondary output, generally STDERR (via `xsl:message`).

This can be helpful when validating inputs in batches and writing results to files. Often an operator prefers to have some runtime notification of what is happening, even when the main interest is in 'side effects' such as files written to the system.

Use `echo` if you wish to see progress in the console even when directing results to file outputs. It will announce findings of both valid and invalid files, one line per file, in addition to other messages; so it can be similar to `form=one-line` except it supplements instead of replaces the production of complete reports (i.e., the primary result) - so progress can be monitored in the same run as results are written out.

`echo` and `form` can be used at the same time - `form` affecting how results look, and `echo` affecting what gets reported via messaging along with that production.

---

Alternatively, to **use bash to loop over one file at a time, collecting the outputs coming to STDOUT** to a file.

With `form=one-line` and Markdown or plaintext results, we get one line per file.

```bash
(for f in $(ls collectionls /*.xml); do saxon -xslt:computer-inspector.xsl -s:$f format=md form=one-line; done) 1> validated.txt
```

---

Or running without `form=one-line` to **create a single Markdown report** (note result file name) - `echo` settings are available:


```bash
(for f in $(ls collection/*.xml); do saxon -xslt:computer-inspector.xsl -s:$f format=md echo=all; done) 1> validation-report.md
```

This time, all results are written in Markdown into the file `validation-report.md`, while `echo=all` provides progress indicators echoed to the console. Use other `echo` settings for less noise.

---

There is much else that can be done to produce **batched and grouped reports** including analytical summaries, etc., by aggregating and post-processing MX, HTML or Markdown outputs. 

### To generate an Inspector XSLT

A fresh and complete Inspector XSLT for any metaschema (any valid and workable instance of [Metaschema](https://pages.nist.gov/metaschema/)) can be produced using an XProc pipeline or an XSLT that emulates this pipeline.

- ../METASCHEMA-INSPECTOR-XSLT.xpl
- ../nist-metaschema-MAKE-INSPECTOR-XSLT.xsl

In this sequence of transformations the target (result) XSLT is assembled dynamically, by combining templates produced from a metaschema source with static boilerplate and infrastructure.

An example script calling the XSLT pipeline (thus requiring only Saxon, not XML Calabash) is given as [testing/mvn-refresh-computer-inspector.sh](testing/refresh-computer-inspector.sh).

## Design goals and principles

The tool should be both easy to use and verifiably correct.

("Easy to use" being relative, possibly the goal is "easy to make easy to use", with one or two easy-to-use ways to use it.)

No need to quit after first error; take advantage of the 'pull' process (random access to tree) to give a complete picture of a document's state vis-a-vis validation requirements.

The aims of the reporting are clarity/ease of use; to be unambiguous; to be traceable. To be concise and economical is a secondary goal.

Reporting can be parsimonious - sometimes there is no need to be exhaustive.

At the same time, errors anywhere are of interest (see 'no need to quit'). Some amount of redundancy is okay if not too noisy.

### Theoretical considerations

XSLT as validation language.

This is a very different model of validation from what is usually (yet) practiced over data sets in exchange, even XML data except in some specialized circumstances. (There are noteworthy exceptions such as the NISO JATS, PMC and JATS4R technology cluster, or within DITA.) In considering the strengths, weaknesses and feature set of the tool, it may help to keep these differences in mind. What may be interesting is that this model - here called the <q>pull</q> model of validation - while very different from the usual historic model (for which we are using the shorthand <q>push</q>), is also very complementary to it. A mature and capable system can have uses for both models in combination.

Setting aside the question of what should be meant by the pull model and why call it  <q>pull</q> - this is *somewhat* analogous to push and pull parsing, two different techniques for building interpreters for character streams aka text processing - suffice it to say here that one aspect of pull is that conceptually, the data set under examination has already been parsed and is already available for inspection. This is not paradoxical if the <q>push</q> model is also in place, as long as a document can be read well enough to push into memory once, where it can be pulled. Fortunately, the syntactic rules of XML well-formedness are sufficiently well-defined that this is feasible.

So in the field we work first by determining that an artifact purportedly and apparently XML is in fact XML - which we do, typically, with a neutral parse or 'well-formedness check'. (Indeed every day XML tools are doing this for their operators without their direct awareness.) While a low threshhold for interpretability - XML syntax assures nothing about an artifact other than its *potential* use *as XML* - this is significantly more than zero. Indeed this small bit of information is both critical (it means much more than it seems to on the surface), and *actionable* - it is consequential knowledge the enables further steps.

Traditional push-based validation such as XSD validation is defined in such a way that it can be conducted as a document is parsed for the first time - that is, without reference to any prior representation of anything in the document after the reading position. It is as if a human reader of a novel were required never to go back in the book, or skip ahead, and more importantly never read again a book with any prior knowledge acquired in a first reading. (All books must only be read once through for the first time.) A <q>read-once</q> parse is a powerful and enabling capability - helping to manage, among other things, the complexity of memory requirements for the parse relative to document size - yet this comes at a steep cost for expressibility.  Pull parsing assumes that once the book is available, reading and rereading are both natural and cheap. And in operation it proves indeed this is a tenable assemption as long as information sets do not grow too large and corpora too complex. (At that point other measures become necessary as well.)

To validate truly arbitrary constraints up to and including so-called 'business rules', in which complexity of rules explodes and far-removed components within the document-space may be related, more or less requires that we do more. That is, any rules we wish to assert over documents that require or imply *random access* to document contents (both before and after the point under examination or enforcement), cannot be provided for by a bare grammar (which is what push parsers often depend on) without the fuller capabilities of a transformation language capable of querying, binding variables, caching and the rest.

Interestingly, this different perspective on the rule set leads to different strengths and weaknesses in deployment between this application and standard approaches to document validation including XSD, RNG and DTD -- strengths and weaknesses that being opposite from the currently most common approach, also complement it. Indeed the successful use of Schematron, as another XSLT-transpiler, already shows this.

If any of this is true, the application will show.

### Advantages of this approach

- Open-endedness with respect to arbitrariness of rules including contingent and co-occurrent rules
- Ease of post processing for presentation
- Flexible deployment, adaptable to different uses and workflows
- Complementarity with other approaches (since two opinions are better than one and more than double when they're the same)
- OSS platform (Saxon-HE) on Java, NodeJS, C/.NET/Python
- Tested and testable

### Disadvantages

- Doesn't do JSON - yet
- Limits on input sizes - very large inputs must still be chunked
- Potential performance tradeoffs for some kinds of rules
- Does not instantiate metaschema-based objects but only examines their representation (lexical form as a serialization) - so it is not as easily extensible as an application framework

---
