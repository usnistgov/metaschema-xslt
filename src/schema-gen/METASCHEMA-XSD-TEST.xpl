<?xml version="1.0" encoding="UTF-8"?>
<p:declare-step xmlns:p="http://www.w3.org/ns/xproc"
  xmlns:c="http://www.w3.org/ns/xproc-step" version="1.0"
  xmlns:metaschema="http://csrc.nist.gov/ns/metaschema/1.0"
  type="metaschema:METASCHEMA-XSD-TEST" name="METASCHEMA-XSD-TEST">
  
  <!-- Input: a metaschema (root) module -->
  <!-- Output: an 'all is well' message, or *runtime errors* if a functional XSD fails to be produced from metaschema input -->
  <!-- Purpose: test whether a top-level metaschema module produces a viable / semantically correct and usable XSD -->
  <!-- Note: the only output port exposes a plain-text message indicating a successful run; no validation errors are reported -->
  
  <!-- &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& -->
  <!-- Ports -->
  
  <p:input port="METASCHEMA" primary="true"/>
  <p:input port="parameters" kind="parameter"/>
  
  <p:serialization port="OUT_success-message" method="text"/>
  <p:output port="OUT_success-message" primary="false">
    <p:pipe port="result" step="invalidate-stub"/>
  </p:output>
  
  <p:serialization port="OUT_XSD" method="xml" indent="true"/>
  <p:output port="OUT_XSD" primary="true">
    <p:pipe port="result" step="make-xsd"/>
  </p:output>
  
  <!-- &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& -->
  <!-- Import (subpipeline) -->
  
  <p:import href="../compose/metaschema-compose.xpl"/>
  
  <!-- &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& -->
  <!-- Pipeline -->
  
  <p:identity name="echo-input"/>
  
  <metaschema:metaschema-compose name="compose"/>
  
  <p:identity name="composed"/>
  
  <p:xslt name="make-xsd">
    <p:input port="stylesheet">
      <p:document href="XSD/make-metaschema-xsd.xsl"/>
    </p:input>
  </p:xslt>
  
  <p:sink/>
  
<!-- Note that in XML Calabash, even an invalid fragment comes back,
    and due to no PSVI support it looks the same as going in.
    Hence we leave assert-valid='false'
    ONLY if the schema is broken will we error out
    -->
  <p:validate-with-xml-schema name="invalidate-stub" assert-valid="false" mode="strict">
    <p:input port="schema">
      <p:pipe port="result" step="make-xsd"/>
    </p:input>
    <!-- xsi:VALIDATING will be invalid unless contrived to be otherwise, but coming back valid also indicates success -->
    <p:input port="source" xmlns="http://www.w3.org/2001/XMLSchema-instance">
      <p:inline><VALIDATING>The generated XSD has been applied and validation completes successfully</VALIDATING></p:inline>
    </p:input>
  </p:validate-with-xml-schema>

</p:declare-step>