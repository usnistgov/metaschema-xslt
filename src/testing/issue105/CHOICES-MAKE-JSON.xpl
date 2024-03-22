<?xml version="1.0" encoding="UTF-8"?>
<p:declare-step xmlns:p="http://www.w3.org/ns/xproc" xmlns:c="http://www.w3.org/ns/xproc-step"
   xmlns:cx="http://xmlcalabash.com/ns/extensions" version="1.0"
   xmlns:metaschema="http://csrc.nist.gov/ns/metaschema/1.0"
   type="metaschema:CHOICES-MAKE-JSON"
   name="CHOICES-MAKE-JSON"
   xmlns:x="http://www.jenitennison.com/xslt/xspec"
   xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:nm="http://csrc.nist.gov/ns/metaschema"
   xmlns:xs="http://www.w3.org/2001/XMLSchema">

   <!-- Input: Static files named herein (expect errors for files broken or missing)-->
   <!-- Output: For each input file, an equivalent JSON in place with the same name. -->
   <!-- Purpose: Batch-convert XML to JSON to support testing -->
   
   

   <!-- &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& -->
   <!-- Ports -->

   <p:input port="parameters" kind="parameter"/>


   <!-- Lists are being maintained by hand for now, for clarity and robustness -->
   <!-- Align with file 'testing/per-document/validations-in-batch.xspec' -->

   <!--
      Among our samples, if a document contains anywhere a processing instruction like so:
        <?EXPECT ERROR?>
      we take this to indicate a validation failure is expected at or near that spot
      
      Don't be distracted by the file system organization: every file in 'invalid' should be so marked
      (with one or more PIs) and every file in 'valid' should not be so marked
      
   -->
   
   <p:input port="samples" sequence="true">
      <!-- for the XML, invalid documents are marked with a PI <?ERROR ?> to show an expectation of INVALID -->
      <p:document href="choices-valid/colors01.xml"/>
      <p:document href="choices-valid/colors02.xml"/>
      <p:document href="choices-invalid/colors03.xml"/>
      <p:document href="choices-valid/colors04.xml"/>
      <p:document href="choices-invalid/colors05.xml"/>
      <p:document href="choices-invalid/colors06.xml"/>
      <!--<p:document href="choices-invalid/colors07.xml"/>-->
      <p:document href="choices-invalid/colors08.xml"/>
   </p:input>

   
   
   <p:for-each>
      <p:iteration-source>
         <p:pipe port="samples" step="CHOICES-MAKE-JSON"/>
      </p:iteration-source>
      <p:variable name="base" select="base-uri(.)"/>

      <p:xslt>
         <p:input port="stylesheet">
            <p:document href="choices_xml-converter.xsl"/>
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