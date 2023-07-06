

# Directory Manifest: `schema-gen`

July 3 2023 10:58 a.m. - 2023-07-03T10:58:33.4245257-04:00 -

Listing files suffixed `xml`, `xpl`, `sch`, `xsl`, `xslt`, `xsd` or `xspec`.

### METASCHEMA-ALL-SCHEMAS.xpl

XProc pipeline version 1.0 (7 steps)

Output ports - `INT_0_echo-input`, `INT_1_composed-metaschema`, `OUT_json-schema-xml`, `OUT_json-schema`, `OUT_xml-schema`

Reads from (p:import) - `../compose/metaschema-compose.xpl`

Reads from (p:document) - `XSD/make-metaschema-xsd.xsl`

Reads from (p:document) - `JSON-schema/make-json-schema-metamap.xsl`

Reads from (p:document) - `../common/xpath-json-to-json.xsl`

### METASCHEMA-METATRON.xpl

XProc pipeline version 1.0 (6 steps)

Output ports - `a.echo-input`, `b.composed`, `c.metatron`, `f.final`

Purpose: Produces a Schematron instance (Metatron)

Input: A valid and correct OSCAL Metaschema instance linked to its modules (also valid and correct)

Output: Port exposes a Schematron

Reads from (p:import) - `../compose/metaschema-compose.xpl`

Reads from (p:document) - `Schematron/make-metaschema-metatron.xsl`

### nist-metaschema-MAKE-JSON-SCHEMA-debug.xsl

XSLT stylesheet version 3.0 (0 templates)

Purpose: Produce a JSON Schema reflecting constraints defined in a metaschema

Dependencies: This is a 'shell' XSLT and calls several steps in sequence, each implemented as an XSLT

Input: A top-level metaschema; this XSLT also composes metaschema input so composition is not necessary

Output: A JSON Schema (v7) describing a JSON format consistent with definitions given in the input metaschema

Note: This XSLT uses the transform() function to execute a series of transformations (referenced out of line) over its input

Stylesheet parameter `trace` as xs:string

Compile-time dependency (xsl:import) `../common/nist-metaschema-metaprocess.xsl`

### nist-metaschema-MAKE-JSON-SCHEMA.xsl

XSLT stylesheet version 3.0 (0 templates)

Purpose: Produce a JSON Schema reflecting constraints defined in a metaschema

Dependencies: This is a 'shell' XSLT and calls several steps in sequence, each implemented as an XSLT

Input: A top-level metaschema; this XSLT also composes metaschema input so composition is not necessary

Output: A JSON Schema (v7) describing a JSON format consistent with definitions given in the input metaschema

Note: This XSLT uses the transform() function to execute a series of transformations (referenced out of line) over its input

Stylesheet parameter `trace` as xs:string

Compile-time dependency (xsl:import) `../common/nist-metaschema-metaprocess.xsl`

### nist-metaschema-MAKE-XML-METATRON.xsl

XSLT stylesheet version 3.0 (0 templates)

Purpose: Produce a Schematron capable of validating metaschema-defined constraints over (schema-valid) data conforming to a metaschema

Dependencies: This is a 'shell' XSLT and calls several steps in sequence, each implemented as an XSLT

Input: A top-level metaschema; this XSLT also composes metaschema input so composition is not necessary

Output: A Schematron suitable for use or deployment, testing the formal validity of XML to metaschema-defined constraints

Note: This XSLT uses the transform() function to execute a series of transformations (referenced out of line) over its input

Stylesheet parameter `trace` as xs:string

Compile-time dependency (xsl:import) `../common/nist-metaschema-metaprocess.xsl`

### nist-metaschema-MAKE-XSD.xsl

XSLT stylesheet version 3.0 (0 templates)

Purpose: Produce an XML Schema Definition (XSD) reflecting constraints defined in a metaschema

Dependencies: This is a 'shell' XSLT and calls several steps in sequence, each implemented as an XSLT

Input: A top-level metaschema; this XSLT also composes metaschema input so composition is not necessary

Output: An XSD describing an XML format consistent with definitions given in the input metaschema

Note: This XSLT uses the transform() function to execute a series of transformations (referenced out of line) over its input

Stylesheet parameter `trace` as xs:string

Compile-time dependency (xsl:import) `../common/nist-metaschema-metaprocess.xsl`

-----


(end listing)