<?xml version="1.0" encoding="UTF-8"?>
<p:declare-step xmlns:p="http://www.w3.org/ns/xproc" xmlns:c="http://www.w3.org/ns/xproc-step"
  version="1.0" xmlns:metaschema="http://csrc.nist.gov/ns/metaschema/1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" type="metaschema:metaschema-docs-trace"
  name="metaschema-docs-trace">

  <!-- Purpose: Emit XML and JSON-oriented metaschema documentation -->
  <!-- Input: A valid and correct OSCAL Metaschema instance linked to its modules (also valid and correct) -->
  <!-- Input: options 'path' and 'metaschema-id' must be set, to populate a/@href in crosslinks -->
  <!-- Output: Ports expose standalone (and linked) HTML for analysis -->
  <!-- Note: This is for debugging; see METASCHEMA-HTML-DOCS.xpl for build runtime XProc -->
  
  <!-- NIST/ITL Metaschema github.com/usnistgov/metaschema https://pages.nist.gov/metaschema/ -->
  
  <!-- &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& -->
  <!-- Ports -->

  <p:input port="METASCHEMA" primary="true"/>
  
  <p:input port="parameters" kind="parameter"/>

  <!--<p:option name="metaschema-id" select="'oscal'"/>-->
  
  <p:option name="metaschema-id" select="'oscal_catalog_metaschema'"/>
  
  <p:option name="json-outline-filename"     select="'json-outline.html'"/>
  <p:option name="json-reference-filename"   select="'json-reference.html'"/>
  <p:option name="json-index-filename"       select="'json-index.html'"/>
  <p:option name="json-definitions-filename" select="'json-definitions.html'"/>
  <p:option name="xml-outline-filename"      select="'xml-outline.html'"/>
  <p:option name="xml-reference-filename"    select="'xml-reference.html'"/>
  <p:option name="xml-index-filename"        select="'xml-index.html'"/>
  <p:option name="xml-definitions-filename"  select="'xml-definitions.html'"/>
  
  <!-- preview ports permit examining pipeline inputs -->
  <p:serialization port="INT_0_echo-input" indent="true"/>
  <p:output        port="INT_0_echo-input" primary="false">
    <p:pipe        port="result" step="input"/>
  </p:output>

  <p:serialization port="INT_1_composed" indent="true"/>
  <p:output        port="INT_1_composed" primary="false">
    <p:pipe        port="result" step="composed"/>
  </p:output>
  
  <p:serialization port="INT_2_abstract-model-map" indent="true"/>
  <p:output        port="INT_2_abstract-model-map" primary="false">
    <p:pipe        port="result"                step="make-abstract-map"/>
  </p:output>

  <p:serialization port="INT_3_unfolded-instance-map" indent="true"/>
  <p:output        port="INT_3_unfolded-instance-map" primary="false">
    <p:pipe        port="result"                step="unfold-instance-map"/>
  </p:output>
  
  <p:serialization port="INT_4_marked-instance-map" indent="true"/>
  <p:output        port="INT_4_marked-instance-map" primary="false">
    <p:pipe        port="result"                step="annotate-instance-map"/>
  </p:output>
  
  <p:serialization port="JSON-object-tree-xml" indent="true"/>
  <p:output        port="JSON-object-tree-xml" primary="false">
    <p:pipe        port="result"               step="make-json-object-tree"/>
  </p:output>
  
  <p:serialization port="JSON-object-map-html" indent="true"/>
  <p:output        port="JSON-object-map-html" primary="false">
    <p:pipe        port="result"               step="style-json-model-map"/>
  </p:output>
  
  <p:serialization port="JSON-object-reference-html" indent="true"/>
  <p:output        port="JSON-object-reference-html" primary="false">
    <p:pipe        port="result"                     step="style-json-object-reference"/>
  </p:output>
  
  <p:serialization port="JSON-object-index-html" indent="true"/>
  <p:output        port="JSON-object-index-html" primary="false">
    <p:pipe        port="result"                 step="style-json-object-index"/>
  </p:output>
  
  <p:serialization port="JSON-definitions-html" indent="true"/>
  <p:output        port="JSON-definitions-html" primary="false">
    <p:pipe        port="result"                step="style-json-definitions"/>
  </p:output>

  <p:serialization port="XML-element-tree-xml" indent="true"/>
  <p:output        port="XML-element-tree-xml" primary="false">
    <p:pipe        port="result"               step="make-xml-element-tree"/>
  </p:output>
  
  <p:serialization port="XML-element-map-html" indent="true"/>
  <p:output        port="XML-element-map-html" primary="false">
    <p:pipe        port="result"               step="style-xml-model-map"/>
  </p:output>
  
  <p:serialization port="XML-element-reference-html" indent="true"/>
  <p:output        port="XML-element-reference-html" primary="false">
    <p:pipe        port="result"               step="style-xml-element-reference"/>
  </p:output>
  
  <p:serialization port="XML-element-index-html" indent="true"/>
  <p:output        port="XML-element-index-html" primary="false">
    <p:pipe        port="result"                 step="style-xml-element-index"/>
  </p:output>
  
  <p:serialization port="XML-definitions-html" indent="true"/>
  <p:output        port="XML-definitions-html" primary="false">
    <p:pipe        port="result"                step="style-xml-definitions"/>
  </p:output>
  
  <!-- &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& -->
  <!-- Import (subpipeline) -->

  <p:import href="../compose/metaschema-compose.xpl"/>

  <!-- &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& -->
  <!-- Pipeline -->

  <p:identity name="input"/>

  <metaschema:metaschema-compose name="compose"/>

  <p:identity name="composed"/>

  <!--<p:identity  name="render-xml-model-map"/>-->
  <!--<p:xslt name="annotate-composition">
    <p:input port="stylesheet">
      <p:document href="compose/annotate-composition.xsl"/>
    </p:input>
  </p:xslt>-->
  
  <p:xslt name="make-abstract-map">
    <p:input port="stylesheet">
      <p:document href="../compose/make-model-map.xsl"/>
    </p:input>
  </p:xslt>
  
<!-- next step unfolds map (making groups into wrappers)
     and expands identifiers -->
  <p:xslt name="unfold-instance-map">
    <p:input port="stylesheet">
      <p:document href="../compose/unfold-model-map.xsl"/>
    </p:input>
  </p:xslt>
  
  <p:xslt name="annotate-instance-map">
    <p:input port="stylesheet">
      <p:document href="../compose/annotate-model-map.xsl"/>
    </p:input>
  </p:xslt>
  
   <!--Making the XML model map -->
   <p:xslt name="make-xml-element-tree">
    <!--<p:input port="source">
      <p:pipe port="result" step="unfold-model-map"/>
    </p:input>-->
    <p:input port="stylesheet">
      <p:document href="xml/element-tree.xsl"/>
    </p:input>
  </p:xslt>
  
  <p:xslt name="make-xml-model-map">
    <p:input port="stylesheet">
      <p:document href="xml/element-map-html.xsl"/>
    </p:input>
    <p:with-param name="outline-page"   select="$xml-outline-filename"/>
    <p:with-param name="reference-page" select="$xml-reference-filename"/>
  </p:xslt>
  
  <p:xslt name="style-xml-model-map">
    <p:input port="stylesheet">
      <p:document href="hugo-css-emulator.xsl"/>
    </p:input>
    <p:with-param name="with-toc" select="'no'"/>
    <p:with-param name="metaschema-code" select="$metaschema-id"/>
  </p:xslt>
  <!-- Done with that. -->
  <p:sink/>
  
  <p:xslt name="render-xml-element-reference">
    <p:input port="source">
      <p:pipe port="result" step="make-xml-element-tree"/>
    </p:input>
    <p:input port="stylesheet">
      <p:document href="xml/element-reference-html.xsl"/>
    </p:input>
    <p:with-param name="xml-reference-page"    select="$xml-reference-filename"/>
    <p:with-param name="xml-definitions-page"  select="$xml-definitions-filename"/>
    <p:with-param name="json-reference-page"   select="$json-reference-filename"/>
    <p:with-param name="xml-map-page"          select="$xml-outline-filename"/>
  </p:xslt>
  
  <!--  Wrapping this up to write and view locally/standalone if wanted -->
  <p:xslt name="style-xml-element-reference">
    <p:input port="stylesheet">
      <p:document href="hugo-css-emulator.xsl"/>
    </p:input>
    <p:with-param name="metaschema-code" select="$metaschema-id"/>
  </p:xslt>
  
  <p:sink/>
  <!-- The JSON object index is produced from the full blown out instance tree
       as already rendered into HTML   -->
  <p:xslt name="render-xml-element-index">
    <p:input port="source">
      <p:pipe port="result" step="make-xml-element-tree"/>
    </p:input>
    <!--<p:with-option name="initial-mode" select="QName('','make-page')"/>-->
    <p:input port="stylesheet">
      <p:document href="xml/element-index-html.xsl"/>
    </p:input>
    <p:with-param name="index-page"       select="$xml-index-filename"/>
    <p:with-param name="reference-page"   select="$xml-reference-filename"/>
    <p:with-param name="definitions-page" select="$xml-definitions-filename"/>
  </p:xslt>
  
  <p:xslt name="style-xml-element-index">
    <!--<p:with-option name="initial-mode" select="QName('','make-page')"/>-->
    <p:input port="stylesheet">
      <p:document href="hugo-css-emulator.xsl"/>
    </p:input>
    <p:with-param name="metaschema-code" select="$metaschema-id"/>
  </p:xslt>
  
  <p:sink/>
  

  <!-- For the straight-up definitions directory we go back to the composed metaschema before explosion -->
  <p:xslt name="render-xml-definitions">
    <p:input port="source">
      <p:pipe port="result" step="composed"/>
    </p:input>
    <p:input port="stylesheet">
      <!-- XXX fix up / reduce this XSLT (from RC2) -->
      <p:document href="xml/xml-definitions.xsl"/>
    </p:input>
    <p:with-param name="xml-definitions-page"  select="$xml-definitions-filename"/>
    <p:with-param name="json-definitions-page" select="$json-definitions-filename"/>
    <p:with-param name="xml-reference-page"    select="$xml-reference-filename"/>    
  </p:xslt>
  
  <p:xslt name="style-xml-definitions">
    <p:input port="stylesheet">
      <p:document href="hugo-css-emulator.xsl"/>
    </p:input>
    <p:with-param name="metaschema-code" select="$metaschema-id"/>
  </p:xslt>
  
  <p:sink/>
  
  
  <!--  JSON pipelines start here -->
  <!--  A representation of the JSON object tree is rendered out from the unfolded blown out model map -->
  <p:xslt name="make-json-object-tree">
    <p:input port="source">
      <p:pipe port="result" step="annotate-instance-map"/>
    </p:input>
    <p:input port="stylesheet">
      <p:document href="json/object-tree.xsl"/>
    </p:input>
  </p:xslt>

  <!-- From this, we first make the model map (ready to inject into the web build) -->
  <p:xslt name="make-json-model-map">
    <p:input port="stylesheet">
      <p:document href="json/object-map-html.xsl"/>
    </p:input>
    <p:with-param name="outline-page"   select="$json-outline-filename"/>
    <p:with-param name="reference-page" select="$json-reference-filename"/>
  </p:xslt>

  <!--  Next we wrap this up to write and view locally/standalone if wanted -->
  <p:xslt name="style-json-model-map">
    <!--<p:with-option name="initial-mode" select="QName('','make-page')"/>-->
    <p:input port="stylesheet">
      <p:document href="hugo-css-emulator.xsl"/>
    </p:input>
    <p:with-param name="with-toc" select="'no'"/>
    <p:with-param name="metaschema-code" select="$metaschema-id"/>
    <p:with-param name="format"          select="'json'"/>
  </p:xslt>

  <!-- Done with that. -->
  <p:sink/>


  <!--Next, picking up from the object tree we make the main reference document -->

  <!-- Making page contents for site -->
  <p:xslt name="render-json-object-reference">
    <p:input port="source">
      <p:pipe port="result" step="make-json-object-tree"/>
    </p:input>
    <!--<p:with-option name="initial-mode" select="QName('','make-page')"/>-->
    <p:input port="stylesheet">
      <p:document href="json/object-reference-html.xsl"/>
    </p:input>
    <p:with-param name="json-reference-page"   select="$json-reference-filename"/>
    <p:with-param name="json-definitions-page" select="$json-definitions-filename"/>
    <p:with-param name="xml-reference-page"    select="$xml-reference-filename"/>
    <p:with-param name="json-map-page"         select="$json-outline-filename"/>
  </p:xslt>

  <!--  Wrapping this up to write and view locally/standalone if wanted -->
  <p:xslt name="style-json-object-reference">
    <p:input port="stylesheet">
      <p:document href="hugo-css-emulator.xsl"/>
    </p:input>
    <p:with-param name="metaschema-code" select="$metaschema-id"/>
    <p:with-param name="format"          select="'json'"/>
  </p:xslt>

  <p:sink/>

  <!-- The JSON object index is produced from the full blown out instance tree
       as already rendered into HTML   -->
  <p:xslt name="render-json-object-index">
    <!--<p:with-option name="initial-mode" select="QName('','make-page')"/>-->
    <p:input port="source">
      <p:pipe port="result" step="make-json-object-tree"/>
    </p:input>
    <p:input port="stylesheet">
      <p:document href="json/object-index-html.xsl"/>
    </p:input>
    <p:with-param name="index-page"       select="$json-index-filename"/>
    <p:with-param name="reference-page"   select="$json-reference-filename"/>
    <p:with-param name="definitions-page" select="$json-definitions-filename"/>
  </p:xslt>
  
  <p:xslt name="style-json-object-index">
    <p:input port="stylesheet">
      <p:document href="hugo-css-emulator.xsl"/>
    </p:input>
    <p:with-param name="metaschema-code" select="$metaschema-id"/>
    <p:with-param name="format"          select="'json'"/>
  </p:xslt>
  
  <p:sink/>
  
  <!-- For the straight-up definitions directory we go back to the composed metaschema before explosion -->
  <p:xslt name="render-json-definitions">
    <p:input port="source">
      <p:pipe port="result" step="composed"/>
    </p:input>
    <p:input port="stylesheet">
      <!-- XXX fix up / reduce this XSLT (from RC2) -->
      <p:document href="json/json-definitions.xsl"/>
    </p:input>
    <p:with-param name="json-definitions-page" select="$json-definitions-filename"/>
    <p:with-param name="xml-definitions-page"  select="$xml-definitions-filename"/>
    <p:with-param name="json-reference-page"   select="$json-reference-filename"/>
  </p:xslt>

  <p:xslt name="style-json-definitions">
    <p:input port="stylesheet">
      <p:document href="hugo-css-emulator.xsl"/>
    </p:input>
    <p:with-param name="metaschema-code" select="$metaschema-id"/>
    <p:with-param name="format"          select="'json'"/>
  </p:xslt>

  <p:sink/>

  
</p:declare-step>