

# Directory Manifest: `compose`

July 3 2023 2:42 p.m. - 2023-07-03T14:42:40.4483605-04:00 -

Listing files suffixed `xml`, `xpl`, `sch`, `xsl`, `xslt`, `xsd` or `xspec`.

### annotate-composition.xsl

XSLT stylesheet version 3.0 (6 templates)

### annotate-model-map.xsl

XSLT stylesheet version 3.0 (9 templates)

Input: an unfolded metaschema 'abstract tree' as produced by steps in ../compose subdirectory

### make-model-map.xsl

XSLT stylesheet version 3.0 (22 templates)

### metaschema-build-refs.xsl

XSLT stylesheet version 3.0 (7 templates)

### metaschema-collect.xsl

XSLT stylesheet version 3.0 (13 templates)

### metaschema-compose.xpl

XProc pipeline version 1.0 (10 steps)

Output ports - `_0_main-module`, `_1_collected`, `_2_refs-built`, `_3_extra-modules-trimmed`, `_4_defs-pruned`, `_5_using-names-added`, `_6_sibling-names-added`, `_7_digested`, `_8_annotated`, `final`

Purpose: Produce a standalone Metaschema instance representing a data model, suitable for further processing

Input: A valid and correct OSCAL Metaschema instance linked to its modules (also valid and correct)

Output: A completely standalone Metaschema instance fully resolving and disambiguating links among definitions, suitable for further processing.

- Reads from (p:document) - `metaschema-collect.xsl`
- Reads from (p:document) - `metaschema-build-refs.xsl`
- Reads from (p:document) - `metaschema-trim-extra-modules.xsl`
- Reads from (p:document) - `metaschema-prune-unused-definitions.xsl`
- Reads from (p:document) - `metaschema-resolve-use-names.xsl`
- Reads from (p:document) - `metaschema-resolve-sibling-names.xsl`
- Reads from (p:document) - `metaschema-digest.xsl`
- Reads from (p:document) - `annotate-composition.xsl`

### metaschema-digest.xsl

XSLT stylesheet version 3.0 (14 templates)

### metaschema-prune-unused-definitions.xsl

XSLT stylesheet version 3.0 (8 templates, 2 functions)

### metaschema-resolve-sibling-names.xsl

XSLT stylesheet version 3.0 (3 templates)

### metaschema-resolve-use-names.xsl

XSLT stylesheet version 3.0 (7 templates)

### metaschema-trim-extra-modules.xsl

XSLT stylesheet version 3.0 (1 template)

### nist-metaschema-COMPOSE.xsl

XSLT stylesheet version 3.0 (0 templates, 1 function)

Purpose: Assemble a logical metaschema instance out of its modules and reconcile definitions

Dependencies: This is a 'shell' XSLT and calls several steps in sequence, each implemented as an XSLT

Input: A valid and correct OSCAL Metaschema instance linked to its modules (also valid and correct)

Output: A single metaschema instance, unifying the definitions from the input modules and annotating with identifiers and pointers

Note: This XSLT uses the transform() function to execute a series of transformations (referenced out of line) over its input

Compile-time dependency (xsl:import) `../common/nist-metaschema-metaprocess.xsl`

### reduce-map.xsl

XSLT stylesheet version 3.0 (7 templates)

### unfold-model-map.xsl

XSLT stylesheet version 3.0 (5 templates)

-----


(end listing)