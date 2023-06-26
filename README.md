# metaschema-xslt

## Software description

Metaschema-XSLT is an XSLT-based implementation of the NIST [Metaschema document modeling framework](https://github.com/usnistgov/metaschema).

NIST Metaschema defines how to describe sets of data objects -- serialized information sets, considered abstractly -- *across* and *between* implementations of processing systems that are coded to manipulate and process such objects.

These descriptions are provided by means of a formal *language* developed for this purpose. An instance of this language is called a <q>metaschema</q>, while the language is named <q>Metaschema</q>. A metaschema proposes or stipulates, by description, a model or set of models, which can be followed by data instances in data processing systems using standard formats and notations, such as XML, JSON and YAML. (This particular implementation supports XML- and JSON-based notations.) Because the Metaschema definitions are abstracted away from details of the system, data sets conformant to these models (and thereby pre-fitted for operations that leverage them) can be developed, validated externally and readily processed by first, second or third parties to contracts. Prior knowledge to make informed and 'intelligent' inferences regarding information sets is provided by metaschema definitions, while metaschema-based tools can test for and enforce the constraints that come with Metaschema data (type) definitions.

In support of metaschemas defined using this language, this software can be used to generate utilities and software artifacts including XML Schema (XSD) and JSON Schema, data conversion scripts, and model documentation. All of these can be deployed in support of other technologies addressing requirements in this domain.

### Statement of purpose

NIST ITL/CSD Metaschema is a data modeling technology, which works by providing formal and validable descriptions of data models such that they can be cast and rewritten in various alternative syntaxes, i.e. optimized at the level of format, while permitting lossless conversion of defined-as-equal information sets across format boundaries.

The software in this repository began as a 'scaffolding' demonstration and proof-of-concept of the capabilities of the Metaschema language, as an instance and demonstration of this concept. However, the Metaschema language is also defined in such a way as to be distinct from and independent of software that implements it. As such, by standing as a functional demonstration of metaschema capabilities, this software can serve in appropriate contexts 

Accordingly, the current effort seeks not only to implement, demonstrate and enable the capabilities of a NIST Metaschema system, with respect to functionalities including schema generation, data conversion or pipelining, stylesheet generation or a host of other potential uses of Metaschema and metaschemas considered broadly. In addition, we aspire to do so sustainably, not in the sense that the software will work forever, but that its users and adopters will at all times be able to trace the data flows it supports.

Considering data traceability and process transparency as the primary goal makes secondary goals, such as the creation of use cases (for this and compatible software) and the codification and maturation of relevant standards, including standards supported by Metaschema such as OSCAL.

Stress is therefore on:

- Transparency, testability and maintainability of processing on an open-source stack
- Generality of support of Metaschema features
- Conformance in support of Metaschema-based data interchange / interop

What we do not emphasize:

- Performance
- Portability beyond the XML/XSLT dependency stack (instead see other Metaschema initiatives)
- Use cases (only)

### Origins

Formerly housed in the Metaschema repository, this code base traces the history of development of the Metaschema concept in the context of the OSCAL project. It was originally conceived as a demonstration and proof of concept, providing a bridge enabling JSON- and XML-based development in parallel over common problem sets. Success in this effort led to a determination that multiple implementations of a platform-independent specification were needed, at which point this implementation was carved out into its own repository. 

### Project sunset

Currently there is no plan to continue maintaining this project or code base beyond the retirement of its lead researcher. Indeed a project goal is to enable the stabilization and socialization of the Metaschema technology, as evidenced by the use and support of *other* Metaschema implementations.

### Description of the repository contents

`src` includes XSLT source code, with supporting infrastructure including ad-hoc testing

`support` includes dependent submodules

### Installation and use

The software is designed to be used in any of a range of ways:

- Dynamically, in development of metaschemas and Metaschema-based software and tools
- Within CI/CD, to generate artifacts or productions from metaschema source under controlled conditions

Accordingly, there will generally be multiple points of entry or invocation methods for any process, with  the software dependencies maintained as appropriate for different use cases.

This being the case, since the applications are written in XSLT 3.0, the latest stable version of the [Saxon](https://saxonica.com/documentation11/documentation.xml) processor is regarded as the primary dependency.

At one extreme, an XML IDE such as oXygen XML (or extended VS Code), integrating Saxon, can be used to run processes and tests in diagnostic mode, using its runtime and interfaces for XSLT (`*.xsl`) or XProc (`*.xproc`).

At the other, command-line scripts or makefiles can be used to automate processes to run externally to produce outputs, and the repository includes examples of these.

In this case, a convenient way to manage dependencies is to use Maven to manage a Java-based stack deploying SaxonHE and/or XML Calabash, as open-source XML processors. Scripts are provided for running under Maven.

#### To run

With `bash` and Maven installed, run any script given at the top level. Use `--help` for help.

For testing, all XSpec scenarios (`*.xspec`) can be run in place to generate local test reports.

## Contact information

Principal Investigator: Wendell Piez, NIST ITL/CSD (Information Technology Laboratory, Computer Security Division). Email w e n d e l l (dot) p i e z (at) n i s t (dot) g o v.

This initiative spins off from and supports the ITL/CSD [Metaschema](https://pages.nist.gov/metaschema) Project, originally and currently being developed in support of OSCAL, the [Open Security Controls Assessment Language](https://pages.nist.gov/OSCAL).

For OSCAL-related discussions see the [OSCAL Site](https://pages.nist.gov/OSCAL/contribute).

## Related Material

See the [Metaschema Repository](https://github.com/usnistgov/metaschema) and its [Pages Site](https://pages.nist.gov/metaschema/) for a description and specification of the technology this software is designed to support.

See the Project [Wiki](https://github.com/usnistgov/metaschema-xslt/wiki)  for documentation maintained on this site.

Projects in support of NIST Metaschema (at time of writing)

- https://github.com/usnistgov/metaschema-java
- https://github.com/usnistgov/metaschema-node
- https://github.com/usnistgov/nmetaschema

Using NIST Metaschema

- [OSCAL: the Open Security Controls Assessment Language](https://pages.nist.gov/OSCAL/)


## Cite this work

Piez, Wendell (2023), Metaschema-XSLT. US National Institute of Standards and Technology (NIST). https://github.com/usnistgov/metaschema-xslt.

## Dependencies

As noted above, the Saxon XSLT engine can be regarded as a *de facto* dependency - while this XSLT-conformant code should in principle run in *any* processor implementing the language. SaxonHE can be bundled using Maven as noted above. This makes Maven (and Java) the dependency for practical purposes.

Developers interested in demonstrating the viability of these processes in different processors and environments are eagerly invited to participate.

## Required outline

See https://raw.githubusercontent.com/usnistgov/opensource-repo/main/README.md

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

