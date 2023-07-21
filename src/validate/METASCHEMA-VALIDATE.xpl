<?xml version="1.0" encoding="UTF-8"?>
<p:declare-step xmlns:p="http://www.w3.org/ns/xproc"
  xmlns:c="http://www.w3.org/ns/xproc-step" version="1.0"
  xmlns:metaschema="http://csrc.nist.gov/ns/metaschema/1.0"
  type="metaschema:METASCHEMA-VALIDATE" name="METASCHEMA-VALIDATE">
  
  <!--For validating using the Schematron Skeleton - if we can get 'allow-foreign' working -->
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
  
  <!-- <p:serialization port="OUT_report-plaintext" indent="true"  method="text"/>
  <p:output port="OUT_report-plaintext" primary="false">
    <p:pipe port="result" step="plaintext-report"/>
  </p:output>-->
  
  <p:identity name="echo-input"/>
  
  <p:validate-with-schematron name="schematron-check" assert-valid="false">
    <p:input port="schema">
      <p:document href="metaschema-composition-check.sch"/>
    </p:input>
    <p:with-param name="allow-foreign" select="true()"/>
  </p:validate-with-schematron>
  
  <!-- primary result is the document again, which we are done with -->
  <p:sink/>
  
  <!--<p:identity name="plaintext-report"/>-->
  
  <!--<p:xslt name="plaintext-report">
    <p:input port="source">
      <p:pipe port="report" step="schematron-check"/>
    </p:input>
    <p:input port="stylesheet">
      <p:document href="svrl-reduce.xsl"/>
    </p:input>
  </p:xslt>-->
  
</p:declare-step>