<?xml version="1.0" encoding="UTF-8"?>
<p:declare-step xmlns:p="http://www.w3.org/ns/xproc"
  xmlns:c="http://www.w3.org/ns/xproc-step" version="1.0"
  xmlns:metaschema="http://csrc.nist.gov/ns/metaschema/1.0"
  type="metaschema:TEST-INSPECTOR-RUNTIME" name="TEST-INSPECTOR-RUNTIME">
  
  <!-- Purpose: Produces an XSLT instance (Metaschema Inspector)  -->
  <!-- Input: A valid and correct OSCAL Metaschema instance linked to its modules (also valid and correct) -->
  <!-- Output: Port exposes an XSLT -->
  
  <!-- &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& -->
  <!-- Ports -->
  
  <p:input port="METASCHEMA" primary="true"/>
  
  <p:input port="instance" primary="false">
    <p:document href="invalid/invalid1.xml"/>
  </p:input>
  
  <p:input port="parameters" kind="parameter"/>
  
  <p:serialization port="INT_0_echo-input" indent="true"/>
  <p:output        port="INT_0_echo-input" primary="false">
    <p:pipe        port="result"       step="metaschema-in"/>
  </p:output>
  
  <!--<p:serialization port="INT_1_composed" indent="true"/>
  <p:output        port="INT_1_composed" primary="false">
    <p:pipe        port="result"     step="composed"/>
  </p:output>
  
  <p:serialization port="INT_50_core-templates" indent="true"/>
  <p:output        port="INT_50_core-templates" primary="false">
    <p:pipe        port="result"     step="make-inspector"/>
  </p:output>
  
  <p:serialization port="INT_51_with-datatype-checks" indent="true"/>
  <p:output        port="INT_51_with-datatype-checks" primary="false">
    <p:pipe        port="result"     step="provide-datatype-checking"/>
  </p:output>
  
  <p:serialization port="OUT_inspector-xslt" indent="true" method="xml" omit-xml-declaration="false"/>
  <p:output        port="OUT_inspector-xslt" primary="true">
    <p:pipe        port="result" step="produce-validator"/>
  </p:output>-->
  
  <p:serialization port="INT_50_inspector" indent="true"/>
  <p:output        port="INT_50_inspector" primary="false">
    <p:pipe        port="result"     step="inspector"/>
  </p:output>
  
  <p:serialization port="OUT_validation-results" indent="true"/>
  <p:output        port="OUT_validation-results" primary="false">
    <p:pipe        port="result"     step="inspect-input-instant"/>
  </p:output>
  
  <!-- &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& -->
  <!-- Import (subpipeline) -->
  
  <p:import href="../../METASCHEMA-INSPECTOR.xpl"/>
  
  <!-- &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& -->
  <!-- Pipeline -->
  
  <p:identity name="metaschema-in"/>
  
  <metaschema:METASCHEMA-INSPECTOR name="produce-inspector"/>
  
  <p:identity name="inspector"/>
  
  <p:sink/>
  
  <p:xslt name="inspect-input-instant">
    <p:input port="source">
      <p:pipe port="instance" step="TEST-INSPECTOR-RUNTIME"/>
    </p:input>
    <p:input port="stylesheet">
      <p:pipe port="result" step="inspector"/>
    </p:input>
  </p:xslt>
  
</p:declare-step>