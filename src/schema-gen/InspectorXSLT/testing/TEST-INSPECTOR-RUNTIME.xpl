<?xml version="1.0" encoding="UTF-8"?>
<p:declare-step xmlns:p="http://www.w3.org/ns/xproc"
  xmlns:c="http://www.w3.org/ns/xproc-step" version="1.0"
  xmlns:metaschema="http://csrc.nist.gov/ns/metaschema/1.0"
  type="metaschema:TEST-INSPECTOR-RUNTIME" name="TEST-INSPECTOR-RUNTIME">
  
  <!-- Purpose: Builds and runs an Inspector XSLT on a document using a metaschema -->
  <!-- Input: `computer_metaschema.xml` (hard-wired) -->
  <!-- Input: `computer-invalid/invalid1.xml` (hard-wired) -->
   
  <!-- Output: Port exposes an XSLT, while another port exposes a validation result -->
  <!-- Note: outputs do not need to be captured for this pipeline to provide
       a viability test for XSLT generation and application (irrespective of validation results) -->
  <!-- Assumptions: the input metaschema is valid and correct; 
       the input instance is well-formed (but not necessarily valid) -->
  
  <!-- &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& -->
  <!-- Ports -->
  
  <p:input port="METASCHEMA" primary="true">
     <p:document href="computer_metaschema.xml"/>
  </p:input>
  
  <p:input port="instance" primary="false" sequence="true">
    <p:document href="computer-invalid/invalid1.xml"/>
  </p:input>
  
  <p:input port="parameters" kind="parameter"/>
  
  <p:serialization port="OUT_INSPECTOR-XSLT" indent="true"/>
  <p:output        port="OUT_INSPECTOR-XSLT" primary="false">
    <p:pipe        port="result"     step="inspector"/>
  </p:output>
  
  <p:serialization port="OUT_0_validation-results" indent="true"/>
  <p:output        port="OUT_0_validation-results" primary="false">
    <p:pipe        port="result"     step="inspect-input-instant"/>
  </p:output>
  
  <p:serialization port="OUT_1_reports-only" indent="true"/>
  <p:output        port="OUT_1_reports-only" primary="false">
    <p:pipe        port="result"     step="grab-mx"/>
  </p:output>
  
  <p:serialization port="OUT_2_html-report" indent="true"/>
  <p:output        port="OUT_2_html-report" primary="false">
    <p:pipe        port="result"     step="report-mx"/>
  </p:output>
  
  <!-- &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& -->
  <!-- Import (subpipeline) -->
  
  <p:import href="../../METASCHEMA-INSPECTOR-XSLT.xpl"/>
  
  <!-- &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& -->
  <!-- Pipeline -->
  
  <p:identity name="metaschema-in"/>
  
  <metaschema:METASCHEMA-INSPECTOR-XSLT name="produce-inspector">
     <!-- Not running a test there, because it is effectively run here -->
     <p:with-option name="xslt-test" select="'skip'"/>
  </metaschema:METASCHEMA-INSPECTOR-XSLT>
  
  <p:identity name="inspector"/>
  
  <p:sink/>
  
  <!-- This step fails if the artifact produced by `produce-inspector` is not XSLT -->
  <p:xslt name="inspect-input-instant">
    <p:input port="source">
      <p:pipe port="instance" step="TEST-INSPECTOR-RUNTIME"/>
    </p:input>
    <p:input port="stylesheet">
      <p:pipe port="result" step="inspector"/>
    </p:input>
  </p:xslt>
  
  <p:xslt name="grab-mx">
    <p:input port="stylesheet">
      <p:document href="../mx-grabber.xsl"/>
    </p:input>
  </p:xslt>
  
  <p:xslt name="report-mx">
    <p:input port="stylesheet">
      <p:document href="../mx-reporter.xsl"/>
    </p:input>
  </p:xslt>
  
</p:declare-step>
