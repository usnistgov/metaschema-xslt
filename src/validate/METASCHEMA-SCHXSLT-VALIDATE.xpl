<?xml version="1.0" encoding="UTF-8"?>
<p:declare-step xmlns:p="http://www.w3.org/ns/xproc"
  xmlns:c="http://www.w3.org/ns/xproc-step" version="1.0"
  xmlns:metaschema="http://csrc.nist.gov/ns/metaschema/1.0"
  xmlns:schxslt="https://doi.org/10.5281/zenodo.1495494"
  type="metaschema:METASCHEMA-SCHXSLT-VALIDATE" name="METASCHEMA-SCHXSLT-VALIDATE">
  
  <!-- &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& -->
  <!-- Ports -->
  
  <p:input port="METASCHEMA" primary="true"/>
  <p:input port="parameters" kind="parameter"/>
  
  <p:serialization port="INT_0_echo-input" indent="true"  method="xml"/>
  <p:output port="INT_0_echo-input" primary="false">
    <p:pipe port="result" step="echo-input"/>
  </p:output>
  
  <p:serialization port="OUT_report-SVRL" indent="true"  method="xml"/>
  <p:output port="OUT_report-SVRL" primary="false">
    <p:pipe port="report" step="schematron-check"/>
  </p:output>
  
  <p:serialization port="OUT_report-plaintext" indent="true"  method="text"/>
  <p:output port="OUT_report-plaintext" primary="false">
    <p:pipe port="result" step="plaintext-report"/>
  </p:output>
  
  <p:import href="../../support/schxslt/core/src/main/resources/xproc/1.0/validate-with-schematron.xpl"/> 
   
  <p:identity name="echo-input"/>

  <schxslt:validate-with-schematron name="schematron-check">
    <p:input port="schema">
      <p:document href="metaschema-composition-check.sch"/>
    </p:input>
  </schxslt:validate-with-schematron>
  
  <!-- primary result is the document again, which we are done with -->
  <p:sink/>
  
  <p:xslt name="plaintext-report">
    <p:input port="source">
      <p:pipe port="report" step="schematron-check"/>
    </p:input>
    <p:input port="stylesheet">
      <p:document href="svrl-reduce.xsl"/>
    </p:input>
  </p:xslt>
  
</p:declare-step>