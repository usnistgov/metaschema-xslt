<?xml version="1.0" encoding="UTF-8"?>
<p:declare-step xmlns:p="http://www.w3.org/ns/xproc"
  xmlns:c="http://www.w3.org/ns/xproc-step" version="1.0"
  xmlns:metaschema="http://csrc.nist.gov/ns/metaschema/1.0"
  type="metaschema:METASCHEMA-ALL-SCHEMAS" name="METASCHEMA-ALL-SCHEMAS">
  
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
    <p:pipe port="report" step="simple-check"/>
  </p:output>
  
  <p:identity name="echo-input"/>
  
  <p:validate-with-schematron name="simple-check" assert-valid="false">
    <p:input port="schema">
      <p:document href="metaschema-composition-check.sch"/>
    </p:input>
  </p:validate-with-schematron>
  
  <p:sink/>
  <!--<p:xslt name="serialize-json">
    <p:input port="stylesheet">
      <p:document href="../common/xpath-json-to-json.xsl"/>
    </p:input>
  </p:xslt>-->
  
</p:declare-step>