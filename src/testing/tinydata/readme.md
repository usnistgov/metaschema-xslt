# Tiny Data Example Metaschema

Purpose: An illustrative metaschema for testing

Meant to be complementary to other testing Metaschemas for example the 'Everything' or 'computer model' metaschemas.

Aims:

- Be lightweight, tractable and intelligible
- Be actually albeit hypothetically useful i.e. be plausible & 'realistic' - more than a toy
- Illustrate basic (but not advanced) Metaschema functionality
- Illustrate core concepts including
  - Recursive assemblies
  - Mixing prose with structure
    - both `markup-line` and `markup-multiline` datatypes
  - Key-based text expansion (**insert/@ref-id**)
  - Data dumps
  - Layered constraints?

## Basic model

TinyData provides a simple model suitable for glossaries, dictionaries and similar structured prose, supplemented with a general-purpose "grid" or data-dump model.

It is suitable for high-level structured documentation. But also for what might be CSV, JSON, or HTML tables. Also suitable for documents with islands of structure, or structures with islands of documentation.

Functional semantics provided for include indexing and reasonably decent formatting for reuse, as HTML and Markdown among other formats.

But the entire markup language has no more than ten or fifteen tags (depending on how you count).

Meanwhile we get XSD, JSON Schemas, converters and other utilities (InspectorXSLT) to play with.

Since it is straightforward to map a [Metaschema-based](https://github.com/usnistgov/metaschema) format into another Metaschema-based format, producing OSCAL (for example) from TinyData ought to be an instructive if elementary exercise.

## dev punchlist

Addressing https://github.com/usnistgov/metaschema-xslt/issues/105

But also leaving this resource intact for later use

- Copy scripting over from ../issue105/
- Refresh validators: XSD, JSON Schema and InspectorXSLT
  - leave XProc in place for later use
- Validate `choice` use case
  - field test this against samples (good vs broken)
  - demonstrate XSD, JSON Schema *and InspectorXSLT*
  - XSpec JSON Schema correction in ../../src/schema-gen/JSON-schema/
- Assess issue with datatype handling
  - are markup-line and markup-multiline adequately handled
  - https://github.com/usnistgov/OSCAL/issues/2007
  - also sketch this out in XSpec
- Build out solution
  -  using ../../src/schema-gen/JSON-schema/choice-split.xsl

- Makefile - `run tests` should include
  - XSpecs over in ../../src
  - field testing JSON and XSD validations of TinyData? (maybe not)
- Utilities?
  - XSLT for TinyData making HTML
  - Markdown?
  - CSS for editor or browser

Further: build out TinyData examples