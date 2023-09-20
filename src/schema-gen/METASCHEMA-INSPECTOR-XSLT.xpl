<?xml version="1.0" encoding="UTF-8"?>
<p:declare-step xmlns:p="http://www.w3.org/ns/xproc"
  xmlns:c="http://www.w3.org/ns/xproc-step" version="1.0"
  xmlns:metaschema="http://csrc.nist.gov/ns/metaschema/1.0"
  type="metaschema:METASCHEMA-INSPECTOR-XSLT" name="METASCHEMA-INSPECTOR-XSLT">
  
  <!-- Purpose: Produces a Schematron instance (Metatron)  -->
  <!-- Input: A valid and correct OSCAL Metaschema instance linked to its modules (also valid and correct) -->
  <!-- Output: Port exposes a Schematron -->
  
  <!-- &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& -->
  <!-- Ports -->
  
  <p:input port="METASCHEMA" primary="true"/>
  <p:input port="parameters" kind="parameter"/>
  
  <p:serialization port="INT_0_echo-input" indent="true"/>
  <p:output        port="INT_0_echo-input" primary="false">
    <p:pipe        port="result"       step="metaschema-in"/>
  </p:output>
  
  <p:serialization port="INT_1_composed" indent="true"/>
  <p:output        port="INT_1_composed" primary="false">
    <p:pipe        port="result"     step="composed"/>
  </p:output>
  
  <p:serialization port="OUT_inspector-xslt" indent="true" method="xml" omit-xml-declaration="false"/>
  <p:output        port="OUT_inspector-xslt" primary="true">
    <p:pipe        port="result" step="produce-validator"/>
  </p:output>
  
  
  <!-- &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& -->
  <!-- Import (subpipeline) -->
  
  <p:import href="../compose/metaschema-compose.xpl"/>
  
  <!-- &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& -->
  <!-- Pipeline -->
  
  <p:identity name="metaschema-in"/>
  
  <metaschema:metaschema-compose name="compose"/>
  
  <p:identity name="composed"/>
  
  <p:xslt name="produce-validator">
    <p:input port="stylesheet">
      <p:document href="InspectorXSLT/generate-inspector-xslt.xsl"/>
    </p:input>
  </p:xslt>
  
 
</p:declare-step>