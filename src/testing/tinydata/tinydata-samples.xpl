<?xml version="1.0" encoding="UTF-8"?>
<p:declare-step xmlns:p="http://www.w3.org/ns/xproc" xmlns:c="http://www.w3.org/ns/xproc-step"
   xmlns:cx="http://xmlcalabash.com/ns/extensions" version="1.0"
   xmlns:metaschema="http://csrc.nist.gov/ns/metaschema/1.0"
   type="metaschema:tinydata-samples"
   name="tinydata-samples"
   xmlns:x="http://www.jenitennison.com/xslt/xspec"
   xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:nm="http://csrc.nist.gov/ns/metaschema"
   xmlns:xs="http://www.w3.org/2001/XMLSchema">

   


   <!-- &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& -->
   <!-- Ports -->

   <p:input port="parameters" kind="parameter"/>

   <p:input port="samples" sequence="true">
      <!-- for the XML, invalid documents are marked with a PI <?ERROR ?> to show an expectation of INVALID -->
      <p:document href="tiny-data/tiny1.xml"/>
      <p:document href="tiny-data/bigbadtiny.xml"/>
      <p:document href="tiny-data/terms-of-art.xml"/>
   </p:input>
   
   <p:output port="tinydata" sequence="true">
      <p:pipe port="result" step="pass-through"/>
   </p:output>
         
   
   <p:identity name="pass-through"/>
   
</p:declare-step>