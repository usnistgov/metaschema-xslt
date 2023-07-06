# Schema generation

For generating XML Schema (XSD) and JSON Schema artifacts from Metaschema source.

Depends on datatype definitions in subdirectory (submodule) `../support/metaschema/schema`. 

See the file manifest for a [survey of file contents](manifest.md) by file.


Currently, schemas in two formats are supported, with a third under development:

- XSD (version 1.1)
- JSON Schema (v 7)
- Schematron - Metaschema Constraints model (in development) - code-name *Metatron*

## Producing schemas for a single metaschema source

Schema generation from NIST Metaschema source data is currently supported by XSLT in this subdirectory. This can be done in any of several ways as is convenient for a developer, tester or Metaschema end user (metaschema author or developer):

- **make** files supporting the testing and production infrastructure
- **Command line scripts** calling Apache Maven for Java configuration and support
- **calling XSLT directly** the same transformations can be executed directly from an environment already supporting XSLT
- **using XProc** the same transformations are orchestrated using XProc for efficiency and speed

Currently, all these assume a single top-level metaschema as input, with its modules called via `import`.

Routines that provide the same services over sets or batches of metaschemas, for efficiency, are to be developed.
### Produce an XSD using `make`

XXX tbd XXX

### Produce an XSD with a script (calling Maven)

With Apache Maven installed, to produce a single standalone XSD from a single metaschema source, use the `bash` script `mvn-xsd-schema-xsl.sh`:

```
/path/to/mvn-xsd-schema-xsl.sh metaschema.xml schema.xsd
```

where `metaschema.xml` is the name (path) of your metaschema input file (top-level component), and `schema.xsd` is the name of the XSD file generated as a result.

### Produce an XSD calling Saxon/XSLT directly

The shell script in the preceding command works by invoking an XSLT transformation. The same XSLT can be also executed directly using Saxon (up to Saxon 10) and the following command line flags (bindings):

- `-xsl` (stylesheet) - `nist-metaschema-MAKE-XSD.xsl`
- `-s` (source document) - your metaschema
- `-o` (result path) - where to write your XSD

Note: Saxon 11 is being tested. See the Issue tracker for more info.

### Produce any kind of schema using Saxon/XSLT

The same pattern works for any schema supported, with any of the following XSLT transformations:

- XSD (XML Schema Definition Language) - `nist-metaschema-MAKE-XSD.xsl`
- JSON Schema v7 as JSON - `nist-metaschema-MAKE-JSON-SCHEMA.xsl`
- JSON Schema v7 as XML (for debugging) - `nist-metaschema-MAKE-JSON-SCHEMA-as-xml.xsl`
- Metatron - experimental implementation of Metaschema Constraints - `nist-metaschema-MAKE-XML-METATRON.xsl`

One of these stylesheets, when run on a top-level metaschema module, will deliver the appropriate output as directed by the `-o` flag or by a consuming application.

### Produce all schemas at once, with a script

The Maven configuration is also set up for XML Calabash, an implementation of XProc.

This is helpful since all schema outputs can be produced together from a given metaschema, more efficiently than one at a time.

```
/path/to/mvn-xsd-schema-xsl.sh metaschema.xml newschema
```

where `metaschema.xml` is the source metaschema, and `newschema` is a label to be prepended to XSD and JSON Schema output file names, in this case `newschema.xsd` and `newschema.json`.

### Using XProc directly

An XProc 1.0 engine can be configured with the pipeline `METASCHEMA-ALL-SCHEMAS.xpl` and run directly. It assumes a single top-level metaschema as input, and produces multiple outputs on multiple ports:

- `-i` input port `METASCHEMA` for the metaschema
- `-o` output port `INT_0_echo-input` echoes the input
- `-o` `INT_1_composed-metaschema=/dev/null` after composition
- `-o` `OUT_json-schema-xml` JSON Schema in XML format
- `-o` `OUT_json-schema` JSON Schema in JSON
- `-o` `OUT_xml-schema` XML Schema (XSD)

This pipeline is used by the `mvn-schemas-xpl.sh` script.

It can also be run independently to help in debugging.

For metaschema composition, this pipeline uses the subpipeline `../compose/metaschema-compose.xpl`.
