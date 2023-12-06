<?xml version="1.0" encoding="UTF-8"?>
<p:declare-step xmlns:p="http://www.w3.org/ns/xproc"
  xmlns:c="http://www.w3.org/ns/xproc-step" version="1.0"
  xmlns:metaschema="http://csrc.nist.gov/ns/metaschema/1.0"
  type="metaschema:METASCHEMA-XSD-VALIDATE" name="METASCHEMA-XSD-VALIDATE">
  
  <!-- Input: a metaschema (root) module -->
  <!-- Output: an 'all is well' message, or runtime errors if an XSD produced from metaschema input is invalid as an XSD (XML Schema Definition) -->
  <!-- Purpose: test whether a top-level metaschema module produces a viable / semantically correct and usable XSD -->
  <!-- Note: the only output port exposes a plain-text message indicating a successful run; no validation errors are reported -->
  
  <!-- Note: ON HOLD until we can find an XSD for XSD that works under XML Calabash -->
  
  <!-- &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& -->
  <!-- Ports -->
  
  <p:input port="METASCHEMA" primary="true"/>
  <p:input port="parameters" kind="parameter"/>
  
  <p:input port="success-message" primary="false">
    <p:inline><VALIDATING>The provided metaschema produces a valid XSD</VALIDATING></p:inline>    
  </p:input>
  
  <p:serialization port="OUT_success-message" method="text"/>
  <p:output port="OUT_success-message" primary="false">
    <p:pipe port="result" step="success"/>
  </p:output>

  <p:serialization port="OUT_XSD" method="xml" indent="true"/>
  <p:output port="OUT_XSD" primary="false">
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
    With assert-valid="true" we will error out if the schema being tested is invalid.
    -->
  <p:validate-with-xml-schema name="validate-schema" assert-valid="true" mode="strict">
    <p:input port="schema">
      <!-- XML XSD 1.1 -->
      <!--<p:document href="../../support/metaschema/support/xml/XMLSchema.xsd"/>-->
      <!-- XML Calabash supports only the 1.0 XSD XSD - cf https://www.w3.org/2001/XMLSchema.xsd -->
      <p:document href="XSD/schema/XMLSchema-1.0.xsd"/>
    </p:input>
    <p:input port="source">
      <p:pipe port="result" step="make-xsd"/>
    </p:input>
  </p:validate-with-xml-schema>

  <p:sink/>
  
  <p:identity name="success">
    <p:input port="source">
      <p:pipe port="success-message" step="METASCHEMA-XSD-VALIDATE"/>
    </p:input>
  </p:identity>
  
</p:declare-step>