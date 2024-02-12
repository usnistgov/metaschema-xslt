<?xml version="1.0" encoding="UTF-8"?>
<p:declare-step xmlns:p="http://www.w3.org/ns/xproc"
  xmlns:c="http://www.w3.org/ns/xproc-step" version="1.0"
  xmlns:metaschema="http://csrc.nist.gov/ns/metaschema/1.0"
  type="metaschema:INSPECTOR-XSLT-TEST" name="INSPECTOR-XSLT-TEST">
  
  <!-- Purpose: Builds and runs an Inspector XSLT on a document using a metaschema -->

  <!-- Output: Port exposes an XSLT. A step whose result is not exposed tests the XSLT. -->
  <!-- Note: outputs do not need to be captured for this pipeline to provide
       a viability test for XSLT generation and application (irrespective of validation results) -->
  <!-- Assumptions: the input metaschema is valid and correct; 
       the input instance is well-formed (but not necessarily valid) -->
  
  <!-- &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& -->
  <!-- Ports -->
  
  <p:input port="METASCHEMA" primary="true"/>
     <!--<p:document href="computer_metaschema.xml"/>-->
  
  <p:input port="instance" primary="false" sequence="true"/>
  
  <p:input port="parameters" kind="parameter"/>
  
   <p:serialization port="OUT_INSPECTOR-XSLT" indent="true"/>
  <p:output        port="OUT_INSPECTOR-XSLT" primary="true">
    <p:pipe        port="result"     step="inspector"/>
  </p:output>
  
    
  <!-- &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& -->
  <!-- Import (subpipeline) -->
  
  <p:import href="../../METASCHEMA-INSPECTOR-XSLT.xpl"/>
  
  <!-- &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& -->
  <!-- Pipeline -->
  
  <p:identity name="metaschema-in"/>
  
  <metaschema:METASCHEMA-INSPECTOR-XSLT name="produce-inspector"/>
  
  <p:identity name="inspector"/>
  
  <p:sink/>
  
  <!-- This step fails if the artifact produced by `produce-inspector` is not XSLT -->
  <p:xslt name="inspect-input-instant">
    <p:input port="source">
      <p:pipe port="instance" step="INSPECTOR-XSLT-TEST"/>
    </p:input>
    <p:input port="stylesheet">
      <p:pipe port="result" step="inspector"/>
    </p:input>
  </p:xslt>
   
   <p:sink/>
   
  
</p:declare-step>