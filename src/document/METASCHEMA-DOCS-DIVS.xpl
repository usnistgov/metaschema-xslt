<?xml version="1.0" encoding="UTF-8"?>
<p:declare-step xmlns:p="http://www.w3.org/ns/xproc" xmlns:c="http://www.w3.org/ns/xproc-step"
  version="1.0" xmlns:metaschema="http://csrc.nist.gov/ns/metaschema/1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" type="metaschema:METASCHEMA-DOCS-DIVS"
  name="METASCHEMA-DOCS-DIVS">

  <!-- Purpose: Emit XML and JSON-oriented metaschema documentation FILE FRAGMENTS (`div` elements) -->
  <!-- Input: A valid and correct OSCAL Metaschema instance linked to its modules (also valid and correct) -->
  <!-- Input: options 'path' and 'metaschema-id' must be set, to populate a/@href in crosslinks -->
  <!-- Output: exposes outputs on named ports -->
  
  <!-- NIST/ITL Metaschema github.com/usnistgov/metaschema https://pages.nist.gov/metaschema/ -->
  
  <!-- &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& -->
  <!-- Ports -->

  <p:input port="METASCHEMA" primary="true"/>
  
  <p:input port="parameters" kind="parameter"/>

  <!--<p:option name="metaschema-id" select="'oscal'"/>-->
  
  <!--<p:option name="output-path" required="true"/>-->
  <p:option name="metaschema-id" required="true"/>
  
  <!--<p:option name="json-outline-filename"     select="$metaschema-id || '-json-outline.html'"/>
  <p:option name="json-reference-filename"   select="$metaschema-id || '-json-reference.html'"/>
  <p:option name="json-index-filename"       select="$metaschema-id || '-json-index.html'"/>
  <p:option name="json-definitions-filename" select="$metaschema-id || '-json-definitions.html'"/>
  <p:option name="xml-outline-filename"      select="$metaschema-id || '-xml-outline.html'"/>
  <p:option name="xml-reference-filename"    select="$metaschema-id || '-xml-reference.html'"/>
  <p:option name="xml-index-filename"        select="$metaschema-id || '-xml-index.html'"/>
  <p:option name="xml-definitions-filename"  select="$metaschema-id || '-xml-definitions.html'"/>-->
  
  <p:serialization port="JSON-object-map-div" indent="true" method="html" version="5.0"/>
  <p:output        port="JSON-object-map-div" primary="false">
    <p:pipe step="DOCS-PIPELINE" port="JSON-object-index-div"/>
  </p:output>
  
  <p:serialization port="JSON-object-reference-div" indent="true" method="html" version="5.0"/>
  <p:output        port="JSON-object-reference-div" primary="false">
    <p:pipe step="DOCS-PIPELINE" port="JSON-object-reference-div"/>
  </p:output>
  
  <p:serialization port="JSON-object-index-div" indent="true" method="html" version="5.0"/>
  <p:output        port="JSON-object-index-div" primary="false">
    <p:pipe step="DOCS-PIPELINE" port="JSON-object-map-div"/>
  </p:output>
  
  <p:serialization port="JSON-definitions-div" indent="true" method="html" version="5.0"/>
  <p:output        port="JSON-definitions-div" primary="false">
    <p:pipe step="DOCS-PIPELINE" port="JSON-definitions-div"/>
  </p:output>
  
  <p:serialization port="XML-element-map-div" indent="true" method="html" version="5.0"/>
  <p:output        port="XML-element-map-div" primary="false">
    <p:pipe step="DOCS-PIPELINE" port="XML-element-index-div"/>
  </p:output>
  
  <p:serialization port="XML-element-reference-div" indent="true" method="html" version="5.0"/>
  <p:output        port="XML-element-reference-div" primary="false">
    <p:pipe step="DOCS-PIPELINE" port="XML-element-reference-div"/>
  </p:output>
  
  <p:serialization port="XML-element-index-div" indent="true" method="html" version="5.0"/>
  <p:output        port="XML-element-index-div" primary="false">
    <p:pipe step="DOCS-PIPELINE" port="XML-element-map-div"/>
  </p:output>
  
  <p:serialization port="XML-definitions-div" indent="true" method="html" version="5.0"/>
  <p:output        port="XML-definitions-div" primary="false">
    <p:pipe step="DOCS-PIPELINE" port="XML-definitions-div"/>
  </p:output>
  
  <!-- &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& -->
  <!-- Import (subpipeline) -->

  <p:import href="METASCHEMA-DOCS-TRACE.xpl"/>
  
  <!--  * . * . * . * . * . * . * . * . * . * . * . * . * . * . * . * . * . * . * . * . * . * . * . * . * . * -->
  
  <!-- Implicit source is on the METASCHEMA input port -->
  
  <metaschema:metaschema-docs-trace name="DOCS-PIPELINE">
    <!--<p:with-option name="output-path"   select="$output-path"/>-->
    <p:with-option name="metaschema-id" select="$metaschema-id"/>
  </metaschema:metaschema-docs-trace>
  
</p:declare-step>