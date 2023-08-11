# Metaschema-XSLT `src`

An XSLT implementation of the [Metaschema](https://pages.nist.gov/metaschema) toolchain for generating schemas, converters, and model documentation.

Typically any of these operations will combine several lower-level operations in a defined sequence.

## To run

See each subdirectory README for more instructions, and see the top-level [README](../README.md) for general description of the entry points available, including not only the scripts in each folder but also a global `make` configuration available to any client.

### `make` quick setup

This distribution includes [a `make` configuration (script)](bin/metaschema-xslt) enabling access to its runtimes with a simple command line interface. It is not intended as the only means to invoke these processes, but it can be convenient.

Confirm you have [`make`](https://www.gnu.org/software/make/), or install it. Add the [bin](../bin)`../bin` directory in this repository (distribution) to your system path.

From a command line, test `make`:

```
> path/to/metaschema-xslt/bin/metaschema-xslt
```

On the console the system will report `Error: SUBCOMMAND not specified`, followed by a list of subcommands you can give.

## Subdirectories

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
