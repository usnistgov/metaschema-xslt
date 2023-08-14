# Metaschema-XSLT `src`

An XSLT implementation of the [Metaschema](https://pages.nist.gov/metaschema) toolchain for generating schemas, converters, and model documentation.

Typically any of these operations will combine several lower-level operations in a defined sequence.

## To run

Also see the [site README](../README.md) for background information.

Runtime support and dependency management are provided with [Apache Maven](https://maven.apache.org/). The included stylesheets (XSLT) and pipeline configurations (XProc) should also be portable to other environments and runtimes.

Please install Maven, configure its system paths, and test before proceeding.

### `bash` scripts

A bash script located in this distribution provides a single unified interface to functionalities provided by this library. Add [../bin](../bin) to your path, or invoke the script directly, using `-h` for help:

```
> path/to/bin/metaschema-xslt -h
```

The help message includes a list of the supported subcommands, indicating which processes are to be run on given inputs with a particular configuration. (If provided with no arguments, the script returns an error `Error: SUBCOMMAND not specified` along with the same help.) Typically scripts use Maven and rely on it for dependency management.

See each subdirectory README for more instructions.

### common

XSLT and logic used as common modules by other utilities.

Moving or removing this directory will often break things.

### compose

Implements a metaschema composition pipeline - producing a unified single metaschema from a metaschema top-level module, by performing imports and linking references.

This subroutine is a dependency for most other metaschema processes, so like `common` this directory should be kept in place.

### converter-gen

Logic to generate converter transformations (XSLT) capable of producing JSON from XML or XML from JSON, according to mappings defined by appropriate metaschema definitions, defining schemas to which the respective data sets are valid.

### document

Logic to create HTML-based web-ready documentation of XML and JSON schemas based on a metaschema.

### metapath

Provides support for parsing and mapping Metapath, the metaschema path language.

This directory is a dependency for logic in converter generation, which uses it to match JSON in conversion into XML, and schema generation, which uses it to implement path traversal in constraints definition and implementation. 

### schema-gen

Logic to provide schemas for validating XML or JSON according to definitions provided in a metaschema.

Generators for XSD and JSON Schema v7 are provided.

Additionally, a partial implementation of Metaschema constraints via a Schematron cast is offered, as a basis for future work.

### testing

Some testing artifacts.

Also find testing within each subdirectory, appropriate to its functionalities.

### util

Miscellaneous utilities. Due for cleanup.

### validate

Provides support for *extra-schema validation* of Metaschema instances against constraints implicit in Metaschema semantics.

Note that validation provided here via Schematron applies *additionally* to regular structural schema validation of a metaschema, using its XSD.

[end]
