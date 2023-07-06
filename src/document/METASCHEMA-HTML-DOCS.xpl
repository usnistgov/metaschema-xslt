<?xml version="1.0" encoding="UTF-8"?>
<p:declare-step xmlns:p="http://www.w3.org/ns/xproc" xmlns:c="http://www.w3.org/ns/xproc-step"
  version="1.0" xmlns:metaschema="http://csrc.nist.gov/ns/metaschema/1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" type="metaschema:METASCHEMA-HTML-DOCS"
  name="METASCHEMA-HTML-DOCS">

  <!-- Purpose: Emit XML and JSON-oriented metaschema documentation -->
  <!-- Input: A valid and correct OSCAL Metaschema instance linked to its modules (also valid and correct) -->
  <!-- Input: options 'path' and 'metaschema-id' must be set, to populate a/@href in crosslinks -->
  <!-- Output: Writes outputs to designated subdirectory; exposes no ports -->
  
  <!-- NIST/ITL Metaschema github.com/usnistgov/metaschema https://pages.nist.gov/metaschema/ -->
  
  <!-- &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& -->
  <!-- Ports -->

  <p:input port="METASCHEMA" primary="true"/>
  
  <p:input port="parameters" kind="parameter"/>

  <!--<p:option name="metaschema-id" select="'oscal'"/>-->
  
  <p:option name="output-path" required="true"/>
  <p:option name="metaschema-id" required="true"/>
  
  <p:option name="json-outline-filename"     select="$metaschema-id || '-json-outline.html'"/>
  <p:option name="json-reference-filename"   select="$metaschema-id || '-json-reference.html'"/>
  <p:option name="json-index-filename"       select="$metaschema-id || '-json-index.html'"/>
  <p:option name="json-definitions-filename" select="$metaschema-id || '-json-definitions.html'"/>
  <p:option name="xml-outline-filename"      select="$metaschema-id || '-xml-outline.html'"/>
  <p:option name="xml-reference-filename"    select="$metaschema-id || '-xml-reference.html'"/>
  <p:option name="xml-index-filename"        select="$metaschema-id || '-xml-index.html'"/>
  <p:option name="xml-definitions-filename"  select="$metaschema-id || '-xml-definitions.html'"/>
  
  <!-- &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& -->
  <!-- Import (subpipeline) -->

  <p:import href="METASCHEMA-DOCS-TRACE.xpl"/>
  
  <p:variable name="xml-outline-uri"      select="resolve-uri($xml-outline-filename,     $output-path)"/>
  <p:variable name="xml-reference-uri"    select="resolve-uri($xml-reference-filename,   $output-path)"/>
  <p:variable name="xml-index-uri"        select="resolve-uri($xml-index-filename,       $output-path)"/>
  <p:variable name="xml-definitions-uri"  select="resolve-uri($xml-definitions-filename, $output-path)"/>
  <p:variable name="json-outline-uri"     select="resolve-uri($json-outline-filename,    $output-path)"/>
  <p:variable name="json-reference-uri"   select="resolve-uri($json-reference-filename,  $output-path)"/>
  <p:variable name="json-index-uri"       select="resolve-uri($json-index-filename,      $output-path)"/>
  <p:variable name="json-definitions-uri" select="resolve-uri($json-definitions-filename,$output-path)"/>
  
  <!--  * . * . * . * . * . * . * . * . * . * . * . * . * . * . * . * . * . * . * . * . * . * . * . * . * . * -->
  
  <!-- Implicit source is on the METASCHEMA input port -->
  
  <metaschema:metaschema-docs-trace name="DOCS-PIPELINE">
    <!--<p:with-option name="output-path"   select="$output-path"/>-->
    <p:with-option name="metaschema-id" select="$metaschema-id"/>
  </metaschema:metaschema-docs-trace>
    
  <p:store  method="html" version="5.0">
    <p:with-option name="href" select="$json-outline-uri"/>
    <p:input port="source">
      <p:pipe step="DOCS-PIPELINE" port="JSON-object-map-html"/>
    </p:input>
  </p:store>
  
  <p:store method="html" version="5.0">
    <p:with-option name="href" select="$json-reference-uri"/>
    <p:input port="source">
      <p:pipe step="DOCS-PIPELINE" port="JSON-object-reference-html"/>
    </p:input>
  </p:store>
  
  <p:store method="html" version="5.0">
    <p:with-option name="href" select="$json-index-uri"/>
    <p:input port="source">
      <p:pipe step="DOCS-PIPELINE" port="JSON-object-index-html"/>
    </p:input>
  </p:store>
  
  <p:store method="html" version="5.0">
    <p:with-option name="href" select="$json-definitions-uri"/>
    <p:input port="source">
      <p:pipe step="DOCS-PIPELINE" port="JSON-definitions-html"/>
    </p:input>
  </p:store>
  
  <p:store method="html" version="5.0">
    <p:with-option name="href" select="$xml-outline-uri"/>
    <p:input port="source">
      <p:pipe step="DOCS-PIPELINE" port="XML-element-map-html"/>
    </p:input>
  </p:store>
  
  <p:store method="html" version="5.0">
    <p:with-option name="href" select="$xml-reference-uri"/>
    <p:input port="source">
      <p:pipe step="DOCS-PIPELINE" port="XML-element-reference-html"/>
    </p:input>
  </p:store>
  
  <p:store method="html" version="5.0">
    <p:with-option name="href" select="$xml-index-uri"/>
    <p:input port="source">
      <p:pipe step="DOCS-PIPELINE" port="XML-element-index-html"/>
    </p:input>
  </p:store>
  
  <p:store >
    <p:with-option name="href" select="$xml-definitions-uri"/>
    <p:input port="source">
      <p:pipe step="DOCS-PIPELINE" port="XML-definitions-html"/>
    </p:input>
  </p:store>
  
  
  
</p:declare-step>