<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="3.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:array="http://www.w3.org/2005/xpath-functions/array"
    exclude-result-prefixes="#all"
    xpath-default-namespace="http://csrc.nist.gov/ns/oscal/metaschema/1.0"
    xmlns="http://csrc.nist.gov/ns/oscal/metaschema/1.0">

    <!-- Purpose: Provide splitting logic for choices, rendering a model sequence containing choices as a choice of model sequences. -->
        
    <!-- Note: this XSLT will only be used on its own for development and debugging.
        It is however imported by `make-json-schema-metamap.xsl` and possibly other stylesheets. -->
   
   <xsl:strip-space elements="*"/>
   
   <xsl:output indent="yes"/>
   
   <!--<xsl:variable name="m">
      <model>
         <choice>
            <a1/>
            <a2/>
            <a3/>
         </choice>
         <b/>
      </model>
   </xsl:variable>
   
   <xsl:template match="/">
      <xsl:apply-templates select="$m/*" mode="splitting"/>
   </xsl:template>-->
   
   <xsl:mode name="splitting" on-no-match="fail"/>
        
   <xsl:template match="model" name="split-model" mode="splitting">
      <xsl:variable name="splits" as="array( element()* ) *">
         <xsl:apply-templates select="child::*[1]" mode="splitting">
            <!-- $splits is an array of sequences -->
            <xsl:with-param name="split" select="[]" as="array( element()* ) "/>
         </xsl:apply-templates>
      </xsl:variable>
      
      <xsl:iterate select="$splits">
         <model>
            <xsl:sequence select="."/>
         </model>
      </xsl:iterate>
   </xsl:template>
   
   <xsl:template match="choice" mode="splitting" as="array( element()* )*">
      <xsl:param name="split" required="true" as="array( element()* ) "/>
      <xsl:variable name="here" select="."/>
      <xsl:variable name="splitters" as="array( element()* )*">
         <xsl:for-each select="child::*">
            <xsl:sequence select="array:append($split, .)"/>
         </xsl:for-each>
         <xsl:if test="empty(child::*)">
            <xsl:sequence select="$split"/>
         </xsl:if>
      </xsl:variable>
      
      <xsl:iterate select="$splitters">
        <xsl:apply-templates select="$here/following-sibling::*[1]" mode="splitting">
         <xsl:with-param name="split" as="array( element()* ) " select="."/><!-- . is an array here -->
        </xsl:apply-templates>
      </xsl:iterate>
      <xsl:if test="empty(following-sibling::*)">
         <xsl:sequence select="$splitters"/>
      </xsl:if>
   </xsl:template>

   <xsl:template match="*" mode="splitting"  as="array( element()* ) *">
      <xsl:param name="split" required="true" as="array( element()* ) "/>
      <xsl:variable name="me" select="."/>
      
      <xsl:apply-templates select="$me/following-sibling::*[1]" mode="splitting">
         <xsl:with-param name="split" select="array:append($split, $me)"/>
      </xsl:apply-templates>
      <xsl:if test="empty(following-sibling::*)">
         <xsl:sequence select="array:append($split, $me)"/>
      </xsl:if>      
   </xsl:template>
              
</xsl:stylesheet>
