# metaschema-xslt

## punchlist

- [x] `CODEMETA`
- [x] `CONTRIBUTING.md`
- [x] `CODEOWNERS`
- [x] `LICENSE.md`
- [x] `CODE_OF_CONDUCT.md`
- [x] this file (see outline/requirements at end)

## License

See the [project license](LICENSE.md) in this repository.

This project is placed into the worldwide public domain.

## Software description

Metaschema-XSLT is an XSLT-based implementation of the NIST (ITL/CSD) [Metaschema data modeling framework](https://github.com/usnistgov/metaschema).

NIST Metaschema defines how to describe sets of data objects -- serialized information sets, considered abstractly -- *across* and *between* implementations of processing systems that are coded to manipulate and process such objects.

These descriptions are provided by means of a formal *language* developed for this purpose. In support of metaschemas defined using this language, this software can be used to generate utilities and software artifacts including XML Schema (XSD) and JSON Schema, data conversion scripts, and model documentation.

Such utilities can in turn provide the basis for ecosystems of tools supporting data models and data sets expressed in the supported formats. ***Make-your-own Schema Kit*** except you get more than a schema, you also get many things with it, including the ability to cast to other formats and maintain formal format-agnosticism.

### Statement of purpose

NIST ITL/CSD Metaschema is a data modeling technology, which works by providing formal and validable descriptions of data models such that instances (data sets) conforming to these models can be cast and rewritten in various alternative syntaxes, i.e. optimized at the level of format, while permitting lossless conversion of defined-as-equal information sets across format boundaries.

In addition to neutralizing the "XML vs JSON" or more broadly "Markup language vs object notation" issue, this technology also offers other capabilities such as external specification and validation of application-oriented semantics ("business rules") defined over models appropriate to specialized knowledge domains.

The current effort seeks to implement, demonstrate and enable the capabilities of a NIST Metaschema system, with respect to functionalities including schema generation, data conversion or pipelining, stylesheet generation or a host of other potential uses of Metaschema and metaschemas considered broadly. In addition, we aspire to do so sustainably, not in the sense that the software will meet all requirements for all time, but that it will be reliable, validable, traceable, extensible -- and replaceable.

Considering data traceability and process transparency as primary goals will also serve secondary goals, such as the creation and demonstration of use cases (for this and compatible software) and the codification and maturation of relevant standards, including standards supported by Metaschema such as OSCAL.

Stress is therefore on:

- Transparency, testability and maintainability of processing on an open-source stack
- Conformance in support of Metaschema-based data interchange / interop
- Generality of support of Metaschema features

What we do not emphasize:

- Performance
- Portability beyond the XML/XSLT dependency stack (instead relying on other Metaschema initiatives)
- Use cases in isolation

### Origins

Formerly housed in the Metaschema repository, this code base traces the history of development of the Metaschema concept in the context of the OSCAL project. It was originally conceived as a demonstration and proof of concept, providing a bridge enabling JSON- and XML-based development in parallel over common problem sets and common data. Success in this effort led to a determination that multiple implementations of a platform-independent specification were needed, at which point this implementation was carved out into its own repository.

### Project sunset

Currently there is no plan to continue maintaining this project beyond the retirement of its lead researcher. A project goal is to enable the stabilization and socialization of the Metaschema technology, as evidenced by the use and support of *other* Metaschema implementations.

The best way to ensure long-term access to the code base is to clone or fork the git repository and archive a copy for study or use.

## Repository contents

`src` includes XSLT source code, with supporting infrastructure including ad-hoc testing

`support` includes dependent submodules with other static resources for configuration

## Installation and use

The software is designed to be used in a range of ways:

- Directly, in development of metaschemas and Metaschema-based software and tools
- Within Metaschema-based builds, including under CI/CD, to generate artifacts or productions from metaschema source under controlled conditions

Accordingly (as is not uncommon with XML/XSLT-based libraries), there will generally be multiple points of entry or invocation methods for any process, with the software dependencies maintained as appropriate for different use cases.

This being the case, since the applications are written in XSLT 3.0, the latest stable version of the [Saxon](https://saxonica.com/documentation11/documentation.xml) processor is regarded as the primary dependency.

At one extreme, an XML IDE such as oXygen XML (or extended VS Code), integrating Saxon, can be used to run processes and tests in diagnostic mode, using its runtime and interfaces for XSLT (`*.xsl`) or XProc (`*.xproc`).

At the other, command-line scripts or makefiles can be used to automate processes to run externally to produce outputs. The repository includes examples of these.

In particular, a convenient way to manage dependencies is to use Maven to manage a Java-based stack deploying SaxonHE and/or XML Calabash, as open-source XML processors. Scripts are provided for running under Maven.

### To run

With `bash` and Maven installed, run any script given at the top level. Use `--help` for help.

Additionally, scripts and stylesheets will be documented *in situ* using readmes and in line.

For testing, all XSpec scenarios (`*.xspec`) can be run in place to generate local test reports.

Users are also expected to call resources in this repository from their own scripts. Do this either by cloning, copying and modifying scripts here; by writing your own; or by adapting code into the XML/XSLT processing framework or stack of your choice.

### Dependencies

As noted, the Saxon XSLT engine can be regarded as a *de facto* dependency - while this XSLT-conformant code should in principle run in *any* processor implementing the language. SaxonHE can be bundled using Maven or another Java packaging technology.

The [POM file](support/pom.xml) for Java/Maven configuration indicates the current tested version of Saxon. At time of writing, Saxon versions 10 and 11 are known to work with this codebase. When reporting bugs please include the version of your processor.

Developers interested in demonstrating the viability of these processes in different processors and environments are eagerly invited to participate in development of this tool or [related tools](#Related_projects).

### Git Client Setup

See more on git setup on the page on [Contributing](CONTRIBUTING).

Clone the project:

```
git clone --recurse-submodules https://github.com/usnistgov/metaschema-xslt.git
```

Or to clone with submodule initialization:

```
git clone --recurse-submodules https://github.com/usnistgov/metaschema-xslt.git
```

### Initializing Git submodules

This GitHub repository makes use of Git submodules to mount other repositories as subdirectories. When cloning this repo for the first time, you need to initialize these.

```
git submodule update --init
```

Or do this in one step using `clone --recurse-submodules` as noted.

### Updating submodules

Submodule contents will be periodically updated. To ensure you have the latest commits for a configured submodule:

```
git submodule update --init --recursive
```

## Contact information

Principal Investigator: Wendell Piez, NIST (US National Institute of Standards and Technology) ITL/CSD (Information Technology Laboratory, Computer Security Division).

Email w e n d e l l (dot) p i e z (at) n i s t (dot) g o v.

This initiative spins off from and supports the ITL/CSD [Metaschema](https://pages.nist.gov/metaschema) Project, originally and currently being developed in support of OSCAL, the [Open Security Controls Assessment Language](https://pages.nist.gov/OSCAL).

For OSCAL-related discussions see the [OSCAL Site](https://pages.nist.gov/OSCAL/contribute).

## Cite this work

Piez, Wendell (2023), Metaschema-XSLT. US National Institute of Standards and Technology (NIST). https://github.com/usnistgov/metaschema-xslt.

## Related projects

See the [Metaschema Repository](https://github.com/usnistgov/metaschema) and its [Pages Site](https://pages.nist.gov/metaschema/) for a description and specification of the technology this software is designed to support.

See the Project [Wiki](https://github.com/usnistgov/metaschema-xslt/wiki)  for documentation maintained on this site.

Projects in support of NIST Metaschema (at time of writing)

- https://github.com/usnistgov/metaschema-java
- https://github.com/usnistgov/metaschema-node
- https://github.com/usnistgov/nmetaschema

Projects currently known to be using NIST Metaschema

- [OSCAL: the Open Security Controls Assessment Language](https://pages.nist.gov/OSCAL/)

## Required outline

This page includes all the following, as described by guidelines at https://raw.githubusercontent.com/usnistgov/opensource-repo/main/README.md

1. Software or Data description
   - Statements of purpose and maturity
   - Description of the repository contents
   - Technical installation instructions, including operating
     system or software dependencies
1. Contact information
   - PI name, NIST OU, Division, and Group names
   - Contact email address at NIST
   - Details of mailing lists, chatrooms, and discussion forums,
     where applicable
1. Related Material
   - URL for associated project on the NIST website or other Department
     of Commerce page, if available
   - References to user guides if stored outside of GitHub
1. Directions on appropriate citation with example text
1. References to any included non-public domain software modules,
   and additional license language if needed, *e.g.* [BSD][li-bsd],
   [GPL][li-gpl], or [MIT][li-mit]

