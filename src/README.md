# Metaschema-XSLT `src`

An XSLT implementation of the [Metaschema](https://pages.nist.gov/metaschema) toolchain for generating schemas, converters, and model documentation.

Typically any of these operations will combine several lower-level operations in a defined sequence.

## To run

Also see the [site README](../README.md) for background information.

### `bash` scripts

A bash script located in this distribution provides a single unified interface to functionalities provided by this library. Add [../bin](../bin) to your path, or invoke the script directly for help:

```
> path/to/bin/metaschema-xslt -h
```

The help message includes a list of the supported subcommands, indicating which processes are to be run on given inputs with a particular configuration. (If provided with no arguments, the script returns an error `Error: SUBCOMMAND not specified` along with the same help.) Typically scripts use Maven and rely on it for dependency management.

See each subdirectory README for more instructions.

#### Dedicated scripts

Within any of the subdirectories in `src`, recognize the scripts by their `.sh` file suffix. The scripts follow a naming convention, with an initial segment identifying the primary executable invoked by the script (usually `mvn` for Maven); a final segment `xpl` or `xsl` indicating XPoc or XSLT entries, and intermediate segments indicating what the script produces.

For example, `mvn-xsd-schema-xsl.sh` can be run to produce an XSD schema from a metaschema, using an XSLT-based process (i.e., Saxon with an appropriate XSLT transformation), run under Maven.

Each script also requires arguments, typically the path to the metaschema source (input) file along with a name or keyword directing where to write results. Invoke the script without arguments to get help on its syntax requirements.

Scripts and stylesheets are also documented in place using readmes and in line. Since XSLTs can call, import, include or read XSLTs from elsewhere in the distribution, and sometimes do, keep the modules together: each folder on its own is *not* self-contained.

A good place to start for further research is the `src` directory with [its `readme.md`](src/README.md).

Users are also expected to call resources in this repository from their own scripts. Do this either by cloning, copying and modifying scripts here; by writing your own scripts or shells; or by adapting code into the XML/XSLT processing framework or stack of your choice.

A convention is used indicating that an XProc (`*.xpl` file) or XSLT (`*.xsl`) intended to be invoked directly (that is, not only to be used as a module or component) is given a name entirely or partly in `ALL-CAPITALS`. For example, `src/schema-gen/METASCHEMA-ALL-SCHEMAS.xpl` is such an XProc pipeline (a step definition intended to be used directly). The XSLTs that observe this convention are, additionally, higher-order transformations by virtue of using the `transform()` function; for all other resources the convention `lower-case-hyphenated` is followed.

### `make` support

Additionally, some subdirectories include `make` configurations. These are used for testing including regression testing, but may also be used to support processing.

To use `make`, confirm you have [`make`](https://www.gnu.org/software/make/), or install it. In any directory with a Makefile, including this one, test it:

```
> src/schema-gen make
```

The system returns a list of available (configured) targets, typically running tests.

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
