

# Directory Manifest: `converter-gen`

July 3 2023 2:35 p.m. - 2023-07-03T14:35:07.0264575-04:00 -

Listing files suffixed `xml`, `xpl`, `sch`, `xsl`, `xslt`, `xsd` or `xspec`.

### make-metaschema-converters.xpl

XProc pipeline version 1.0 (9 steps)

Output ports - `a.composed-metaschema`, `b.initial-model-map`, `c.unfolded-model-map`, `d.definition-model`, `E.xml-supermodel-converter`, `E.json-supermodel-converter`

- Reads from (p:import) - `../compose/metaschema-compose.xpl`
- Reads from (p:document) - `../compose/make-model-map.xsl`
- Reads from (p:document) - `../compose/unfold-model-map.xsl`
- Reads from (p:document) - `../compose/reduce-map.xsl`
- Reads from (p:document) - `produce-xml-converter.xsl`
- Reads from (p:document) - `produce-json-converter.xsl`

### make-metaschema-xml-to-supermodel-xslt.xpl

XProc pipeline version 1.0 (8 steps)

Output ports - `a.echo-input`, `b.composed`, `c.abstract-model-map`, `d.unfolded-model-map`, `A.definition-map`, `C.xml-converter`

Purpose: Produces a single converter XSLT (for debugging)

Input: A valid and correct OSCAL Metaschema instance linked to its modules (also valid and correct)

Output: Port exposes a converter XSLT but does not run it

- Reads from (p:import) - `../compose/metaschema-compose.xpl`
- Reads from (p:document) - `../compose/make-model-map.xsl`
- Reads from (p:document) - `../compose/unfold-model-map.xsl`
- Reads from (p:document) - `../compose/reduce-map.xsl`
- Reads from (p:document) - `produce-xml-converter.xsl`

### markdown-to-supermodel-xml-converter.xsl

XSLT stylesheet version 3.0 (35 templates, 2 functions)

### markdown-to-xml.xsl

XSLT stylesheet version 3.0 (33 templates, 2 functions)

Stylesheet parameter `target-ns` as xs:string?

### md-converter-test.xsl

XSLT stylesheet version 3.0 (2 templates)

Purpose: test harness for calling Markdown conversion logic

Stylesheet parameter `target-ns` as xs:string?

Compile-time dependency (xsl:import) `markdown-to-supermodel-xml-converter.xsl`

### nist-metaschema-MAKE-JSON-TO-XML-CONVERTER.xsl

XSLT stylesheet version 3.0 (6 templates)

Purpose: Produce an XSLT transformation capable of converting a JSON format defined in a metaschema, into an XML JSON format capturing an equivalent data set

Dependencies: This is a 'shell' XSLT and calls several steps in sequence, each implemented as an XSLT

Dependencies: Additionally, it directly calls resources in the converter-gen subdirectory as follows: converter-gen/markdown-to-supermodel-xml-converter.xsl, converter-gen/supermodel-to-xml.xsl (see lines 132, 136)

Input: A top-level metaschema; this XSLT also composes metaschema input so composition is not necessary

Output: A standalone XSLT suitable for use or deployment, accepting JSON valid to the metaschema-defined constraints

Note: see the result XSLT for information regarding its runtime interface

Note: This XSLT uses the transform() function to execute a series of transformations (referenced out of line) over its input

Stylesheet parameter `trace` as xs:string

Compile-time dependency (xsl:import) `../common/nist-metaschema-metaprocess.xsl`

### nist-metaschema-MAKE-XML-TO-JSON-CONVERTER.xsl

XSLT stylesheet version 3.0 (3 templates)

Purpose: Produce an XSLT transformation capable of converting an XML format defined in a metaschema, into a JSON format capturing an equivalent data set

Dependencies: This is a 'shell' XSLT and calls several steps in sequence, each implemented as an XSLT

Input: A top-level metaschema; this XSLT also composes metaschema input so composition is not necessary

Output: A standalone XSLT suitable for use or deployment, accepting XML valid to the metaschema-defined constraints

Note: see the result XSLT for information regarding its runtime interface

Note: This XSLT uses the transform() function to execute a series of transformations (referenced out of line) over its input

Stylesheet parameter `trace` as xs:string

Compile-time dependency (xsl:import) `../common/nist-metaschema-metaprocess.xsl`

### produce-json-converter.xsl

XSLT stylesheet version 3.0 (23 templates)

Purpose: Produce an XSLT for converting JSON valid to a Metaschema model, to its supermodel equivalent.

Input: A Metaschema definition map

Output: An XSLT

Compile-time dependency (xsl:import) `../metapath/metapath-jsonize.xsl`

Compile-time dependency (xsl:import) `produce-xml-converter.xsl`

Stylesheet parameter `px` as xs:string

Stylesheet parameter `definition-map` 

### produce-xml-converter.xsl

XSLT stylesheet version 3.0 (36 templates)

Purpose: Produce an XSLT for converting XML valid to a Metaschema model, to its supermodel equivalent.

Input: A Metaschema definition map

Output: An XSLT

### supermodel-to-json.xsl

XSLT stylesheet version 3.0 (43 templates)

### supermodel-to-markdown.xsl

XSLT stylesheet version 3.0 (26 templates)

Purpose: Convert XML to markdown. Note that namespace bindings must be given.

### supermodel-to-xml.xsl

XSLT stylesheet version 3.0 (5 templates)

### xml-to-markdown.xsl

XSLT stylesheet version 3.0 (23 templates)

Purpose: Convert XML to markdown. Note that namespace bindings must be given.

-----


(end listing)