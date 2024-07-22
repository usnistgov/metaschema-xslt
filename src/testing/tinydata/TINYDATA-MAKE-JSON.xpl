<?xml version="1.0" encoding="UTF-8"?>
<p:declare-step xmlns:p="http://www.w3.org/ns/xproc" xmlns:c="http://www.w3.org/ns/xproc-step"
   xmlns:cx="http://xmlcalabash.com/ns/extensions" version="1.0"
   xmlns:metaschema="http://csrc.nist.gov/ns/metaschema/1.0"
   type="metaschema:TINYDATA-MAKE-JSON"
   name="TINYDATA-MAKE-JSON"
   xmlns:x="http://www.jenitennison.com/xslt/xspec"
   xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
   xmlns:nm="http://csrc.nist.gov/ns/metaschema"
   xmlns:xs="http://www.w3.org/2001/XMLSchema">

   <!-- Input: Static files named herein (expect errors for files broken or missing)-->
   <!-- Output: For each input file, an equivalent JSON in place with the same name. -->
   <!-- Purpose: Batch-convert XML to JSON to support testing -->
   
   <!-- &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& -->
   <!-- Ports -->

   <p:input port="parameters" kind="parameter"/>

   <p:import href="tinydata-samples.xpl"/>
   
   <metaschema:tinydata-samples name="getting-samples"/>

   <p:for-each>
      <p:iteration-source>
         <p:pipe port="tinydata" step="getting-samples"/>
      </p:iteration-source>
      <p:variable name="base" select="base-uri(.)"/>

      <p:xslt>
         <p:input port="stylesheet">
            <p:document href="tinydata_xml-converter.xsl"/>
         </p:input>
      </p:xslt>
      
      <p:store method="text">
         <p:with-option name="href" select="replace($base,'xml$','json')"/>
      </p:store>
      <!--<p:add-attribute attribute-name="base-uri" match="/*">
         <p:with-option name="attribute-value" select="$base"/>
      </p:add-attribute>-->

   </p:for-each>

   
</p:declare-step>