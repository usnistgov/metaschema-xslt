<?xml version="1.0" encoding="UTF-8"?>
<p:declare-step xmlns:p="http://www.w3.org/ns/xproc"
  xmlns:c="http://www.w3.org/ns/xproc-step" version="1.0"
  xmlns:metaschema="http://csrc.nist.gov/ns/metaschema/1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  type="metaschema:METASCHEMA-VALIDATE" name="METASCHEMA-VALIDATE">
  

<!-- Purpose: Validate a single Metaschema instance (top-level or component module) against the Metaschema XSD, only -->
   <!-- For use as a pre-check on inputs for Metaschema processing - use METASCHEMA-VALIDATE.xpl as a wrapper for this XProc along with other validators for Metaschema syntax -->
   
  <p:input port="METASCHEMA" primary="true"/>
  <p:input port="parameters" kind="parameter"/>
  
  <p:serialization port="success-report" indent="true"  method="text"/>
   <p:output port="success-report" primary="true">
     <p:pipe port="result" step="dummy-answer"/>
  </p:output>
  
   <p:variable name="baseURI" select="base-uri(.)"/>
   
  <!-- On XSD-failing inputs, instead of marking and continuing (with try/catch), we crash,
       there being no more interesting information to acquire -->
   <p:validate-with-xml-schema name="metaschema-xsd-validate"
     assert-valid="true" mode="strict">
      <p:input port="schema">
         <p:document href="../../support/metaschema/schema/xml/metaschema.xsd"/>
      </p:input>
   </p:validate-with-xml-schema>         
  
   <!-- If we haven't failed we move along-->
   <p:xslt name="dummy-answer">
      <p:input port="stylesheet">
         <p:inline>
            <xsl:stylesheet version="3.0" exclude-result-prefixes="#all">
               <xsl:param name="base" select="'[UNKNOWN]'"/>
               <xsl:template match="/*" expand-text="true">
                  <SUCCESS>SUCCESS - XSD Validation has apparently run without error on document { $base }</SUCCESS>
               </xsl:template>
            </xsl:stylesheet>
         </p:inline>
      </p:input>
      <p:with-param name="base" select="$baseURI"/>   
   </p:xslt>
   
   
</p:declare-step>