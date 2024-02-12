<?xml version="1.0" encoding="UTF-8"?>
<p:declare-step xmlns:p="http://www.w3.org/ns/xproc"
  xmlns:c="http://www.w3.org/ns/xproc-step" version="1.0"
  xmlns:metaschema="http://csrc.nist.gov/ns/metaschema/1.0"
  type="metaschema:INSPECTOR-XSLT-TEST" name="INSPECTOR-XSLT-TEST">
  
  <!-- Purpose: Builds and runs an Inspector XSLT on a document using a metaschema -->


  <!-- Output: Port exposes an XSLT, while another port exposes a validation result -->
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
  <p:output        port="INT_50_inspector" primary="true">
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