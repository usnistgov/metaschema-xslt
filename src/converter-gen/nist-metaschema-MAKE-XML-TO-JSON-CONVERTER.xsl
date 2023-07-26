<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:nm="http://csrc.nist.gov/ns/metaschema"
  xmlns="http://csrc.nist.gov/ns/oscal/metaschema/1.0/supermodel"
  xpath-default-namespace="http://csrc.nist.gov/ns/oscal/metaschema/1.0/supermodel"
  xmlns:XSLT="http://csrc.nist.gov/ns/oscal/metaschema/xslt-alias"
  exclude-result-prefixes="#all"
  version="3.0">

  <!-- Purpose: Produce an XSLT transformation capable of converting an XML format defined in a metaschema, into a JSON format capturing an equivalent data set-->
  <!-- Dependencies: This is a 'shell' XSLT and calls several steps in sequence, each implemented as an XSLT -->
  <!-- Input: A top-level metaschema; this XSLT also composes metaschema input so composition is not necessary -->
  <!-- Output: A standalone XSLT suitable for use or deployment, accepting XML valid to the metaschema-defined constraints -->
  <!-- Note: see the result XSLT for information regarding its runtime interface -->  
  <!-- Note: This XSLT uses the transform() function to execute a series of transformations (referenced out of line) over its input -->
  
  <xsl:output indent="yes"/>

  <xsl:namespace-alias stylesheet-prefix="XSLT" result-prefix="xsl"/>
  
  <!-- 
    From a metaschema
    Produces a single XSLT with simple interfaces
      named shortname=xml-to-json-converter.xsl
      -source - XML to be converted to JSON
      produce='json' (default) emit serialized JSON
      produce='supermodel' emit supermodel notation
      produce='xdm-json-xml' emit XPath XML notation JSON
    
      
    stylesheet sequence
    
    source: metaschema
      pipeline through external calls to
        compose
        produce definition map
        produce XML converter
      result is XML converter: stitch that into a result XSLT
        XML converter + supermodel JSON serializer
          producing optional intermediate results
      
    -->
  
  
  <xsl:output method="xml" indent="yes"/>
  
  <!-- Turning $trace to 'on' will
         - emit runtime messages with each transformation, and
         - retain nm:ERROR and nm:WARNING messages in results. -->
  
  <xsl:mode name="package-converter" on-no-match="shallow-copy"/>
  
  <xsl:param name="trace" as="xs:string">off</xsl:param>
  <xsl:variable name="louder" select="$trace = 'on'"/>
  
  <xsl:variable name="xslt-base" select="document('')/document-uri()"/>
  
  <xsl:import href="../common/nist-metaschema-metaprocess.xsl"/>
  
  <!-- The $transformation-sequence declares transformations to be applied in order. -->
  <xsl:variable name="produce-xml-converter" expand-text="true">
    <xsl:variable as="xs:string" name="composer-dir">../compose</xsl:variable>
    <nm:transform version="3.0">{ $composer-dir }/metaschema-collect.xsl</nm:transform>
    <nm:transform version="3.0">{ $composer-dir }/metaschema-build-refs.xsl</nm:transform>
    <nm:transform version="3.0">{ $composer-dir }/metaschema-trim-extra-modules.xsl</nm:transform>
    <nm:transform version="3.0">{ $composer-dir }/metaschema-prune-unused-definitions.xsl</nm:transform>
    <nm:transform version="3.0">{ $composer-dir }/metaschema-resolve-use-names.xsl</nm:transform>
    <nm:transform version="3.0">{ $composer-dir }/metaschema-resolve-sibling-names.xsl</nm:transform>
    <nm:transform version="3.0">{ $composer-dir }/metaschema-digest.xsl</nm:transform>
    <nm:transform version="3.0">{ $composer-dir }/annotate-composition.xsl</nm:transform>
    
    <!-- next produce definition map -->
    <nm:transform version="3.0">{ $composer-dir }/make-model-map.xsl</nm:transform>
    <nm:transform version="3.0">{ $composer-dir }/unfold-model-map.xsl</nm:transform>
    <nm:transform version="3.0">{ $composer-dir }/reduce-map.xsl</nm:transform>
    
    <nm:transform version="3.0">xml-to-json/produce-xml-converter.xsl</nm:transform>
    <nm:transform version="3.0">xml-to-json/package-xml-converter.xsl</nm:transform>
    
  </xsl:variable>
  
  <xsl:template match="/">
    <xsl:call-template name="nm:process-pipeline">
      <xsl:with-param name="sequence" select="$produce-xml-converter"/>
    </xsl:call-template>
  </xsl:template>
  
</xsl:stylesheet>