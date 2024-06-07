# Metaschema XSLT

## License

See the [project license](LICENSE.md) in this repository.

This project is placed into the worldwide public domain.

## Software description

Metaschema-XSLT is an XSLT-based implementation of the NIST (ITL/CSD) [Metaschema Information Modeling Framework](https://github.com/usnistgov/metaschema).

NIST Metaschema defines how to describe sets of data objects -- serialized information sets, considered abstractly -- *across* and *between* implementations of processing systems that are coded to manipulate and process such objects. These descriptions are provided by means of a formal *language* developed for this purpose.

In support of metaschemas defined using this language, this software can be used to generate utilities and software artifacts including XML Schema (XSD) and JSON Schema, data conversion scripts, and model documentation.

Such utilities can in turn provide the basis for ecosystems of tools supporting data models and data sets expressed in the supported formats. ***Make-your-own Schema Kit*** except your schema comes with many extras, including not only documentation, but also the ability to cast your data between formats and maintain formal format-agnosticism.

### Statement of purpose

NIST ITL/CSD Metaschema is a data modeling technology, which works by providing formal and validable descriptions of data models such that instances (data sets) conforming to these models can be cast and rewritten in various alternative syntaxes, i.e. optimized at the level of format, while permitting lossless conversion of defined-as-equal information sets across format boundaries.

In addition to neutralizing the "XML vs JSON" or more broadly "Markup language vs object notation" issue, this technology also offers other capabilities such as external specification and validation of application-oriented semantics ("business rules") defined over models appropriate to specialized knowledge domains.

The current effort seeks to implement, demonstrate and enable the capabilities of a NIST Metaschema system, with respect to functionalities including schema generation, data conversion or pipelining, stylesheet generation or a host of other potential uses of Metaschema and metaschemas considered broadly. In addition, we aspire to do so sustainably, not in the sense that the software will meet all requirements for all time, but that it will be reliable, validable, traceable, extensible -- and replaceable.

Considering data traceability and process transparency as primary goals will also serve secondary goals, such as the creation and demonstration of use cases (for this and compatible software) and the codification and maturation of relevant standards, including standards supported by Metaschema such as OSCAL.

Stress is therefore on:

- Transparency, testability and maintainability of processing on an open-source stack
- Conformance in support of Metaschema-based data interchange / interop
- Generality of support of Metaschema features

Additionally, we care about, but do not prioritize:

- Performance
- Portability beyond the XML/XSLT dependency stack (instead relying on other Metaschema initiatives)
- Specific use cases

### Origins

Formerly housed in the [Metaschema repository](https://github.com/usnistgov/metaschema), this code base traces the history of development of the Metaschema concept in the context of the OSCAL project. It was originally conceived as a demonstration and proof of concept, providing a bridge enabling JSON- and XML-based development in parallel over common problem sets and common data. Success in this effort led to a determination that multiple implementations of a platform-independent specification were needed, at which point this implementation was carved out into its own repository.

### Maturity and project sunset

Software in this repository remains 'experimental' in status until it can be demonstrated with public conformance testing, which in turn depends on the maturity of the Metaschema initiative.

The NIST team has no long-term plan to maintain this project outside the context of the initiatives it supports, [OSCAL](https://pages.nist.gov/OSCAL) and [Metaschema](https://pages.nist.gov/metaschema), while we reserve the right to change and adapt to community needs in alignment with NIST's mission. A project goal is to enable the stabilization and socialization of the Metaschema technology, as evidenced by the use and support of *other* Metaschema implementations.

The best way to ensure long-term access to the code base is to clone or fork the git repository and archive a copy for study or use.

## Repository contents

`bin` includes utility scripting and might be useful to have on your system path.

`src` includes XSLT source code, with supporting infrastructure including ad-hoc testing.

`support` includes dependent submodules with other static resources.

## Installation and operation

These utilities are designed for integration in a range of environments, and core functionalities are implemented in XSLT 3, which is supported across platforms including Java, Node.js and C. Please deconstruct and reverse engineer. (Consider proposing improvements as [contributions](CONTRIBUTING.md).)

The software is designed to be used in a range of ways:

- Directly, in development of metaschemas and Metaschema-based software and tools
- Within Metaschema-based builds, including under CI/CD, to generate artifacts or productions from metaschema source under controlled conditions

The following generalized services are provided by the tools in this repository, separately or in combination

- XSD and JSON schema generation - [`src/schema-gen` folder](src/schema-gen)
- Converter XSLTs for metaschema-supported data - [`src/converter-gen` folder](src/converter-gen)
- Metaschema documentation production - [`src/document` folder](src/document).
- (*Forthcoming*) Schematron generation and more

### Using `make` utility

Currently we are supporting "smoke testing" and regression testing via `make`. See more details in [src/README.md](src/README.md).

**Work in progress. Please work with us.**

[`make`](https://www.gnu.org/software/make/) is helpful for providing a clean and versatile interface on the command line, with features supporting build management and process dispatching (parallelization). `make` comes pre-installed in many Linux distributions.

We recommend running `make` from a bash command line under Linux or WSL, and using `make help` for discovery of its features (from any subdirectory in the project):

```bash
$ make help
```

Note that depending on the subdirectory, the help offered will be different.

Run directly from script for more transparency, and see the next section for more details on available processes.

### Directly from script

The same scripts used by `make` can also be used directly for a more dynamic and versatile interface, for example for developers of new Metaschema instances who wish to generate artifacts or documentation for their metaschemas.

[bin/metaschema-xslt](bin/metaschema-xslt) is a top-level `bash` script that dispatches to lower-level scripts for the processes. With the `bin` directory on your path invoke it directly for more help:

```
> bin/metaschema-xslt -h
```

#### Dedicated scripts

See more details in the [src/README](src/README.md). Using the scripts directly provides more fine-grained access to the logic (for example, if only a single kind of schema output is wanted), while not always offering the same efficiencies.

### Dependencies

Within the Maven architecture, the software depends on two libraries:

- [**XML Calabash**](https://xmlcalabash.com/) XProc processor, by Norman Walsh
- **Saxon** XSLT processor from [Saxonica](https://saxonica.com/welcome/welcome.xml)

Note however that the underlying XSLT-conformant code should in principle run in any processor implementing the language (version 3.0).

The [POM file](support/pom.xml) for Java/Maven configuration indicates the current tested version of Saxon. At time of writing, Saxon versions 10 and 11 are known to work with this codebase. When reporting bugs please include the version of your processor.

Some processes are also configured to run using XProc, the XML Pipelining Language, for greater runtime efficiency and transparency (debuggability). XProc is supported by XML Calabash, which also includes Saxon as a dependency.

Developers interested in demonstrating the viability of these processes in different processors and environments are eagerly invited to participate in development of this tool or related tools.

Additional dependencies for some functionalities (XSLT libraries) are included as submodule repositories, in the [support](support) subdirectory.

### Git Client Setup

See more on git setup on the page on the [Contributing](CONTRIBUTING) page.

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

As this initiative spins off from and supports the ITL/CSD [Metaschema](https://pages.nist.gov/metaschema) Project, originally and currently being developed in support of OSCAL, the [Open Security Controls Assessment Language](https://pages.nist.gov/OSCAL), feedback on this project will be gratefully received in those forums.

For OSCAL-related discussions see the [OSCAL Site](https://pages.nist.gov/OSCAL/contribute).

## Cite this work

Piez, Wendell (2023), Metaschema-XSLT. US National Institute of Standards and Technology (NIST). https://github.com/usnistgov/metaschema-xslt.

## Related projects

See the [Metaschema Repository](https://github.com/usnistgov/metaschema) and its [Pages Site](https://pages.nist.gov/metaschema/) for a description and specification of the technology this software is designed to support. Those pages also contain links to other projects.

See the Project [Wiki](https://github.com/usnistgov/metaschema-xslt/wiki) for documentation maintained on this site.

## Acknowledgements

This work and especially work on testing XSLT represented by this project would have been impossible without examples and leadership provided by persons including AG; AJS; DW; NW.

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
   and additional license language if needed, *e.g.* BSD,
   GPL, or MIT

