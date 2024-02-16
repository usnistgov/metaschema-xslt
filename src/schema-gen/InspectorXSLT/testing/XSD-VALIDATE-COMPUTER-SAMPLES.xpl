<?xml version="1.0" encoding="UTF-8"?>
<p:declare-step xmlns:p="http://www.w3.org/ns/xproc" xmlns:c="http://www.w3.org/ns/xproc-step"
   xmlns:cx="http://xmlcalabash.com/ns/extensions" version="1.0"
   xmlns:metaschema="http://csrc.nist.gov/ns/metaschema/1.0" type="metaschema:XSD-FUNCTIONAL-SAMPLES"
   name="XSD-FUNCTIONAL-SAMPLES" xmlns:x="http://www.jenitennison.com/xslt/xspec"
   xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:nm="http://csrc.nist.gov/ns/metaschema"
   xmlns:xs="http://www.w3.org/2001/XMLSchema">

   <!-- Input: depends on finding file 'inspector-functional-xspec/validations-in-batch.xspec' in place -->
   <!-- Input: Additionally, all inputs named therein (expect errors for files broken or missing)-->
   <!-- Input: Additionally, an up-to-date XSD for the computer model located at '../current/computer_metaschema-schema.xsd' -->
   <!-- Output: an 'all is well' message, or unexpected results such as errors from files expected to be valid or validity from files expected to be invalid -->
   <!-- Purpose: test alignment between XSD-based Metaschea validates and other forms, by providing a basis for comparisohn-->


   <!-- &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& -->
   <!-- Ports -->

   <p:input port="parameters" kind="parameter"/>


   <!-- Lists are being maintained by hand for now, for clarity and robustness -->
   <!-- Align with file 'inspector-functional-xspec/validations-in-batch.xspec'-->

   <!-- TODO: separate out layers
     provide valid and invalid tags as options
     (along with file list and XSD)
     parameterizing them for XSLT -->

   <p:input port="samples" sequence="true">
      <p:document href="computer-valid/valid1.xml"/>
      <p:document href="computer-valid/valid2.xml"/>

      <p:document href="computer-invalid/invalid1.xml"/>
      <p:document href="computer-invalid/invalid2.xml"/>
      <p:document href="computer-invalid/invalid3.xml"/>
      <p:document href="computer-invalid/invalid4.xml"/>
      <p:document href="computer-invalid/invalid5.xml"/>
      <p:document href="computer-invalid/invalid6.xml"/>
      <p:document href="computer-invalid/invalid7.xml"/>
      <p:document href="computer-invalid/invalid8.xml"/>
      <p:document href="computer-invalid/invalid9.xml"/>
      <p:document href="computer-invalid/invalid10.xml"/>
   </p:input>

   <p:input port="computer-schema">
      <p:document href="current/computer_metaschema-schema.xsd"/>
   </p:input>
   
   <p:serialization port="survey" indent="true"/>
   <p:output port="survey">
      <p:pipe port="result" step="assessment"/>
   </p:output>
   
   <p:serialization port="summary" indent="true" method="text"/>
   <p:output port="summary">
      <p:pipe port="result" step="summary"/>
   </p:output>
   
   <p:for-each>
      <p:iteration-source>
         <p:pipe port="samples" step="XSD-FUNCTIONAL-SAMPLES"/>
      </p:iteration-source>
      <p:variable name="base" select="base-uri(.)"/>

      <p:try>
         <p:group>
            <p:validate-with-xml-schema name="validate-sample" assert-valid="true" mode="strict">
               <!--<cx:message>
                  <p:with-option name="message" select="'here a message'"/>
               </cx:message>-->
               <p:input port="schema">
                  <p:pipe port="computer-schema" step="XSD-FUNCTIONAL-SAMPLES"/>
               </p:input>
               <!-- xsi:VALIDATING will be invalid unless contrived to be otherwise, but coming back valid also indicates success -->

            </p:validate-with-xml-schema>

         </p:group>
         <p:catch>
            <p:add-attribute attribute-name="VALIDATION-STATUS" match="/*" attribute-value="XSD-INVALID"/>
         </p:catch>
      </p:try>

      <p:add-attribute attribute-name="base-uri" match="/*">
         <p:with-option name="attribute-value" select="$base"/>
      </p:add-attribute>


   </p:for-each>


   <p:wrap-sequence name="wrapup" wrapper="ANY-VALID"/>

   <p:xslt name="assessment">
      <p:input port="stylesheet">
         <p:inline>
            <xsl:stylesheet version="3.0" exclude-result-prefixes="#all">
               <xsl:mode on-no-match="shallow-copy"/>

               <xsl:function name="nm:found-in-path" as="xs:boolean">
                  <xsl:param name="path" as="xs:anyURI"/>
                  <xsl:param name="dirname" as="xs:string"/>
                  <xsl:sequence select="tokenize($path,'/')=$dirname"/>
               </xsl:function>
               
               <xsl:template match="/*">
                  <xsl:copy>
                     <NOMINALLY-VALID>
                        <xsl:apply-templates select="*[nm:found-in-path(@base-uri => xs:anyURI(),'computer-valid')]"/>
                     </NOMINALLY-VALID>
                     <NOMINALLY-INVALID>
                        <xsl:apply-templates select="*[nm:found-in-path(@base-uri => xs:anyURI(),'computer-invalid')]"/>
                     </NOMINALLY-INVALID>
                  </xsl:copy>
               </xsl:template>
               <xsl:template match="/*/*">
                  <document href="{@base-uri}">
                     <xsl:copy-of select="@VALIDATION-STATUS"/>
                  </document>
               </xsl:template>
            </xsl:stylesheet>
         </p:inline>
      </p:input>
   </p:xslt>

   <p:xslt name="summary">
      <p:input port="stylesheet">
         <p:inline>
            <xsl:stylesheet version="3.0" exclude-result-prefixes="#all">
               <!--<xsl:mode on-no-match="shallow-copy"/>-->
               
               
            <xsl:template match="/*">
               
               <REPORT>
                        <xsl:apply-templates select="child::NOMINALLY-VALID/document[@VALIDATION-STATUS='XSD-INVALID']"/>
                        <xsl:apply-templates
                           select="child::NOMINALLY-INVALID/document[not(@VALIDATION-STATUS='XSD-INVALID')]"/>

                        <xsl:on-empty>
                           <summary>ALL GOOD - confirming expected results from XSD validation</summary>
                        </xsl:on-empty>
                     
               </REPORT>
            </xsl:template>
               
               <xsl:template match="NOMINALLY-VALID/document[@VALIDATION-STATUS='XSD-INVALID']">
                  <finding href="{@href}">Unexpectedly found to be INVALID against the current computer_metaschema XSD</finding>
               </xsl:template>
               
               <xsl:template match="NOMINALLY-INVALID/document[not(@VALIDATION-STATUS='XSD-INVALID')]">
                  <finding href="{@href}">Unexpectedly found to be VALID against the current computer_metaschema XSD</finding>
               </xsl:template>
               
            </xsl:stylesheet>
            
         </p:inline>
      </p:input>
   </p:xslt>

</p:declare-step>