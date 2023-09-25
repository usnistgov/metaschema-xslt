<?xml version="1.0" encoding="UTF-8"?>
<p:declare-step xmlns:p="http://www.w3.org/ns/xproc" xmlns:c="http://www.w3.org/ns/xproc-step"
  version="1.0" xmlns:metaschema="http://csrc.nist.gov/ns/metaschema/1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" type="metaschema:make-all-metaschema-docs"
  name="make-all-metaschema-docs">

  <!-- Purpose: Write Hugo-ready HTML with XML and JSON-oriented metaschema documentation -->
  <!-- Input: A valid and correct OSCAL Metaschema instance linked to its modules (also valid and
  correct) -->
  <!-- Output: Options indicate file names to assign to outputs in serialization -->
  <!-- Note: See make-metaschema-standalone-docs.xpl for debugging -->

  <!-- &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& -->
  <!-- Ports -->

  <p:input port="source" primary="true" />

  <p:input port="parameters" kind="parameter" />

  <p:option name="output-path" required="true">
    <p:documentation>
      The output directory to write to. This should be an absolute URI.
    </p:documentation>
  </p:option>

  <p:option name="json-outline-filename" select="'json-outline.html'" />
  <p:option name="json-reference-filename" select="'json-reference.html'" />
  <p:option name="json-index-filename" select="'json-index.html'" />
  <p:option name="json-definitions-filename" select="'json-definitions.html'" />
  <p:option name="xml-outline-filename" select="'xml-outline.html'" />
  <p:option name="xml-reference-filename" select="'xml-reference.html'" />
  <p:option name="xml-index-filename" select="'xml-index.html'" />
  <p:option name="xml-definitions-filename" select="'xml-definitions.html'" />

  <p:option name="page-base-path" select="''">
    <p:documentation>
      The base path that will be prepended to all relative links (e.g. '' or 'model-name/').
    </p:documentation>
  </p:option>

  <p:option name="json-outline-page" select="concat($page-base-path, replace($json-outline-filename, '.html', ''))" />
  <p:option name="json-reference-page" select="concat($page-base-path, replace($json-reference-filename, '.html', ''))" />
  <p:option name="json-index-page" select="concat($page-base-path, replace($json-index-filename, '.html', ''))" />
  <p:option name="json-definitions-page" select="concat($page-base-path, replace($json-definitions-filename, '.html', ''))" />
  <p:option name="xml-outline-page" select="concat($page-base-path, replace($xml-outline-filename, '.html', ''))" />
  <p:option name="xml-reference-page" select="concat($page-base-path, replace($xml-reference-filename, '.html', ''))" />
  <p:option name="xml-index-page" select="concat($page-base-path, replace($xml-index-filename, '.html', ''))" />
  <p:option name="xml-definitions-page" select="concat($page-base-path, replace($xml-definitions-filename, '.html', ''))" />

  <!-- &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& -->
  <!-- Import (subpipeline) -->

  <p:import href="../compose/metaschema-compose.xpl" />

  <p:variable name="xml-outline-uri" select="resolve-uri($xml-outline-filename,     $output-path)" />
  <p:variable name="xml-reference-uri" select="resolve-uri($xml-reference-filename,   $output-path)" />
  <p:variable name="xml-index-uri" select="resolve-uri($xml-index-filename,       $output-path)" />
  <p:variable name="xml-definitions-uri"
    select="resolve-uri($xml-definitions-filename, $output-path)" />
  <p:variable name="json-outline-uri" select="resolve-uri($json-outline-filename,    $output-path)" />
  <p:variable name="json-reference-uri"
    select="resolve-uri($json-reference-filename,  $output-path)" />
  <p:variable name="json-index-uri" select="resolve-uri($json-index-filename,      $output-path)" />
  <p:variable name="json-definitions-uri"
    select="resolve-uri($json-definitions-filename,$output-path)" />

  <!-- &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& -->
  <!-- Pipeline -->

  <p:identity name="input" />

  <metaschema:metaschema-compose name="compose" />

  <p:identity name="composed" />

  <p:xslt name="make-abstract-map">
    <p:input port="stylesheet">
      <p:document href="../compose/make-model-map.xsl" />
    </p:input>
  </p:xslt>

  <!-- next step unfolds map (making groups into wrappers)
     and expands identifiers -->
  <p:xslt name="unfold-instance-map">
    <p:input port="stylesheet">
      <p:document href="../compose/unfold-model-map.xsl" />
    </p:input>
  </p:xslt>

  <p:xslt name="annotate-instance-map">
    <p:input port="stylesheet">
      <p:document href="../compose/annotate-model-map.xsl" />
    </p:input>
  </p:xslt>

  <!--Making
  the XML model map -->
  <p:xslt name="make-xml-element-tree">
    <!--<p:input
    port="source">
      <p:pipe port="result" step="unfold-model-map"/>
    </p:input>-->
    <p:input port="stylesheet">
      <p:document href="xml/element-tree.xsl" />
    </p:input>
  </p:xslt>

  <p:xslt name="make-xml-model-map">
    <p:input port="stylesheet">
      <p:document href="xml/element-map-html.xsl" />
    </p:input>
    <p:with-param name="outline-page" select="$xml-outline-page" />
    <p:with-param name="reference-page" select="$xml-reference-page" />
  </p:xslt>

  <!-- Done with that. -->
  <p:sink />

  <p:xslt name="render-xml-element-reference">
    <p:input port="source">
      <p:pipe port="result" step="make-xml-element-tree" />
    </p:input>
    <p:input port="stylesheet">
      <p:document href="xml/element-reference-html.xsl" />
    </p:input>
    <p:with-param name="xml-reference-page" select="$xml-reference-page" />
    <p:with-param name="xml-definitions-page" select="$xml-definitions-page" />
    <p:with-param name="json-reference-page" select="$json-reference-page" />
    <p:with-param name="xml-map-page" select="$xml-outline-page" />
  </p:xslt>

  <p:sink />

  <p:xslt name="render-xml-element-index">
    <p:input port="source">
      <p:pipe port="result" step="make-xml-element-tree" />
    </p:input>
    <p:input port="stylesheet">
      <p:document href="xml/element-index-html.xsl" />
    </p:input>
    <p:with-param name="index-page" select="$xml-index-page" />
    <p:with-param name="reference-page" select="$xml-reference-page" />
    <p:with-param name="definitions-page" select="$xml-definitions-page" />
  </p:xslt>

  <p:sink />

  <!-- For the straight-up definitions directory we go back to the composed metaschema before
  explosion -->
  <p:xslt name="render-xml-definitions">
    <p:input port="source">
      <p:pipe port="result" step="composed" />
    </p:input>
    <p:input port="stylesheet">
      <!-- XXX fix up / reduce this XSLT (from RC2) -->
      <p:document href="xml/xml-definitions.xsl" />
    </p:input>
    <p:with-param name="xml-definitions-page" select="$xml-definitions-page" />
    <p:with-param name="json-definitions-page" select="$json-definitions-page" />
    <p:with-param name="xml-reference-page" select="$xml-reference-page" />
  </p:xslt>

  <p:sink />


  <!--  JSON pipelines start here -->
  <!--  A representation of the JSON object tree is rendered out from the unfolded blown out model
  map -->
  <p:xslt name="make-json-object-tree">
    <p:input port="source">
      <p:pipe port="result" step="annotate-instance-map" />
    </p:input>
    <p:input port="stylesheet">
      <p:document href="json/object-tree.xsl" />
    </p:input>
  </p:xslt>

  <!-- From this, we first make the model map (ready to inject into the web build) -->
  <p:xslt name="make-json-model-map">
    <p:input port="stylesheet">
      <p:document href="json/object-map-html.xsl" />
    </p:input>
    <p:with-param name="outline-page" select="$json-outline-page" />
    <p:with-param name="reference-page" select="$json-reference-page" />
  </p:xslt>

  <!-- Done with that. -->
  <p:sink />


  <!--Next,
  picking up from the object tree we make the main reference document -->

  <!-- Making page contents for site -->
  <p:xslt name="render-json-object-reference">
    <p:input port="source">
      <p:pipe port="result" step="make-json-object-tree" />
    </p:input>
    <!--<p:with-option
    name="initial-mode" select="QName('','make-page')"/>-->
    <p:input port="stylesheet">
      <p:document href="json/object-reference-html.xsl" />
    </p:input>
    <p:with-param name="json-reference-page" select="$json-reference-page" />
    <p:with-param name="json-definitions-page" select="$json-definitions-page" />
    <p:with-param name="xml-reference-page" select="$xml-reference-page" />
    <p:with-param name="json-map-page" select="$json-outline-page" />
  </p:xslt>

  <p:sink />

  <!-- The JSON object index is produced from the full blown out instance tree
       as already rendered into HTML   -->
  <p:xslt name="render-json-object-index">
    <!--<p:with-option
    name="initial-mode" select="QName('','make-page')"/>-->
    <p:input port="source">
      <p:pipe port="result" step="make-json-object-tree" />
    </p:input>
    <p:input port="stylesheet">
      <p:document href="json/object-index-html.xsl" />
    </p:input>
    <p:with-param name="index-page" select="$json-index-page" />
    <p:with-param name="reference-page" select="$json-reference-page" />
    <p:with-param name="definitions-page" select="$json-definitions-page" />
  </p:xslt>

  <p:sink />

  <!-- For the straight-up definitions directory we go back to the composed metaschema before
  explosion -->
  <p:xslt name="render-json-definitions">
    <p:input port="source">
      <p:pipe port="result" step="composed" />
    </p:input>
    <p:input port="stylesheet">
      <!-- XXX fix up / reduce this XSLT (from RC2) -->
      <p:document href="json/json-definitions.xsl" />
    </p:input>
    <p:with-param name="json-definitions-page" select="$json-definitions-page" />
    <p:with-param name="xml-definitions-page" select="$xml-definitions-page" />
    <p:with-param name="json-reference-page" select="$json-reference-page" />
  </p:xslt>

  <p:sink />

  <!--<p:xslt
  name="diagnostic">
    <p:input port="source">
      <p:inline><dummy/></p:inline>
    </p:input>
    <p:input port="stylesheet">
      <p:document href="common/pipeline-diagnostic.xsl"/>
    </p:input>
    <p:with-param name="test1" select="$json-outline-uri"/>
    <p:with-param name="test2"  select="$source-doc"/>
  </p:xslt>-->

  <p:store method="xhtml" indent="true">
    <p:input port="source">
      <p:pipe port="result" step="make-xml-model-map" />
    </p:input>
    <p:with-option name="href" select="$xml-outline-uri" />
  </p:store>

  <p:store method="xhtml" indent="true">
    <p:input port="source">
      <p:pipe port="result" step="render-xml-element-reference" />
    </p:input>
    <p:with-option name="href" select="$xml-reference-uri" />
  </p:store>

  <p:store method="xhtml" indent="true">
    <p:input port="source">
      <p:pipe port="result" step="render-xml-definitions" />
    </p:input>
    <p:with-option name="href" select="$xml-definitions-uri" />
  </p:store>

  <p:store method="xhtml" indent="true">
    <p:input port="source">
      <p:pipe port="result" step="render-xml-element-index" />
    </p:input>
    <p:with-option name="href" select="$xml-index-uri" />
  </p:store>

  <p:store method="xhtml" indent="true">
    <p:input port="source">
      <p:pipe port="result" step="make-json-model-map" />
    </p:input>
    <p:with-option name="href" select="$json-outline-uri" />
  </p:store>

  <p:store method="xhtml" indent="true">
    <p:input port="source">
      <p:pipe port="result" step="render-json-object-reference" />
    </p:input>
    <p:with-option name="href" select="$json-reference-uri" />
  </p:store>

  <p:store method="xhtml" indent="true">
    <p:input port="source">
      <p:pipe port="result" step="render-json-definitions" />
    </p:input>
    <p:with-option name="href" select="$json-definitions-uri" />
  </p:store>

  <p:store method="xhtml" indent="true">
    <p:input port="source">
      <p:pipe port="result" step="render-json-object-index" />
    </p:input>
    <p:with-option name="href" select="$json-index-uri" />
  </p:store>

</p:declare-step>