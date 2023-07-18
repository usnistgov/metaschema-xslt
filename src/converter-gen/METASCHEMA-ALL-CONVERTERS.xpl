<?xml version="1.0" encoding="UTF-8"?>
<p:declare-step xmlns:p="http://www.w3.org/ns/xproc"
  xmlns:c="http://www.w3.org/ns/xproc-step" version="1.0"
  xmlns:metaschema="http://csrc.nist.gov/ns/metaschema/1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  type="metaschema:METASCHEMA-ALL-CONVERTERS" name="METASCHEMA-ALL-CONVERTERS">

<!--
    Build out with ports (stub out packing XSLTs)
    Carve out packing/finishing XSLTs from standalones
      XML to JSON
      JSON to XML
    Install in pipeline
    Diff against XSLTs delivered via Saxon
    Scripts
    
  -->

  <!-- &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& -->
  <!-- Ports -->
  
  <p:input port="METASCHEMA" primary="true"/>
  <p:input port="parameters" kind="parameter"/>
  
  <p:serialization port="INT_0_echo-input" indent="true"  method="xml"/>
  <p:output port="INT_0_echo-input" primary="false">
    <p:pipe port="result" step="echo-input"/>
  </p:output>
  
  <p:serialization port="INT_1_composed-metaschema" indent="true" method="xml"/>
  <p:output port="INT_1_composed-metaschema" primary="false">
    <p:pipe port="result" step="composed"/>
  </p:output>
  
  
  <p:serialization port="INT_2_initial-model-map" indent="true"/>
  <p:output        port="INT_2_initial-model-map" primary="false">
    <p:pipe        port="result"           step="make-model-map"/>
  </p:output>
  
  <p:serialization port="INT_3_unfolded-model-map" indent="true"/>
  <p:output        port="INT_3_unfolded-model-map" primary="false">
    <p:pipe        port="result"           step="unfold-model-map"/>
  </p:output>
  
  <p:serialization port="INT_4_definition-model" indent="true"/>
  <p:output        port="INT_4_definition-model" primary="false">
    <p:pipe        port="result"           step="definition-map"/>
  </p:output>
  
  <p:serialization port="INT_5X_xml-supermodel-converter" indent="true"/>
  <p:output        port="INT_5X_xml-supermodel-converter" primary="false">
    <p:pipe        port="result"               step="make-xml-converter"/>
  </p:output>
  
  <p:serialization port="INT_5J_json-supermodel-converter" indent="true"/>
  <p:output        port="INT_5J_json-supermodel-converter" primary="false">
    <p:pipe        port="result"               step="make-json-converter"/>
  </p:output>
  
  <p:serialization port="OUT_xml-to-json-converter" indent="true"/>
  <p:output        port="OUT_xml-to-json-converter" primary="false">
    <p:pipe        port="result"               step="pack-xml-converter"/>
  </p:output>
  
  <p:serialization port="OUT_json-to-xml-converter" indent="true"/>
  <p:output        port="OUT_json-to-xml-converter" primary="false">
    <p:pipe        port="result"               step="pack-json-converter"/>
  </p:output>
  
  
  <!-- &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& -->
  <!-- Import (subpipeline) -->
  
  <p:import href="../compose/metaschema-compose.xpl"/>
  
  <!-- &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& -->
  <!-- Pipeline -->
  
  <p:identity name="echo-input"/>
  
  <metaschema:metaschema-compose name="compose"/>
  
  <p:identity name="composed"/>
  
  <!--<p:identity  name="render-xml-model-map"/>-->
  <p:xslt name="make-model-map">
    <p:input port="source">
      <p:pipe port="result" step="composed"/>
    </p:input>
    <p:input port="stylesheet">
      <p:document href="../compose/make-model-map.xsl"/>
    </p:input>
  </p:xslt>
  
  <p:xslt name="unfold-model-map">
    <p:input port="stylesheet">
      <p:document href="../compose/unfold-model-map.xsl"/>
    </p:input>
  </p:xslt>
  
  <p:xslt name="definition-map">
    <p:input port="source">
      <p:pipe port="result" step="unfold-model-map"/>
    </p:input>
    <p:input port="stylesheet">
      <p:document href="../compose/reduce-map.xsl"/>
    </p:input>
  </p:xslt>
  
  <p:xslt name="make-xml-converter">
    <p:input port="stylesheet">
      <p:document href="xml-to-json/produce-xml-converter.xsl"/>
    </p:input>
  </p:xslt>
  
  <p:xslt name="pack-xml-converter">
    <p:input port="stylesheet">
      <p:document href="xml-to-json/package-xml-converter.xsl"/>
    </p:input>
  </p:xslt>
  
  <p:sink/>
  
  <p:xslt name="make-json-converter">
    <p:input port="source">
      <p:pipe port="result" step="definition-map"/>
    </p:input>
    <p:input port="stylesheet">
      <p:document href="json-to-xml/produce-json-converter.xsl"/>
    </p:input>
  </p:xslt>
  
  <!--<p:identity name="pack-json-converter"/>-->
  <p:xslt name="pack-json-converter">
    <p:input port="stylesheet">
      <p:document href="json-to-xml/package-json-converter.xsl"/>
    </p:input>
  </p:xslt>
  
  <p:sink/>

</p:declare-step>