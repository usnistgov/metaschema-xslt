<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
   xmlns:xs="http://www.w3.org/2001/XMLSchema"
   xmlns:x="http://www.jenitennison.com/xslt/xspec"
   xmlns:math="http://www.w3.org/2005/xpath-functions/math"
   exclude-result-prefixes="xs math"
   version="3.0">
   
   <xsl:param name="nm-delim" as="xs:string">|]</xsl:param>
   
   <xsl:mode on-no-match="shallow-copy"/>
   
   <xsl:mode name="modify" on-no-match="shallow-copy"/>
   
   <xsl:variable name="num-regex" as="xs:string">^\[\S+\]\s*</xsl:variable>
   
   <xsl:template match="x:scenario/@label" expand-text="true">
      <xsl:attribute name="label">
         <xsl:text>[</xsl:text>
         <xsl:apply-templates select="parent::*" mode="countup"/>
         <xs:text>] </xs:text><!--
         <xsl:text> { $nm-delim} </xsl:text>-->
         <xsl:apply-templates select="." mode="modify"/>
      </xsl:attribute>
   </xsl:template>
   
   <xsl:template match="x:scenario" mode="countup">
      <xsl:number count="x:scenario" level="multiple" format="A.1.a.i"/>
   </xsl:template>
   
   <xsl:template mode="modify" match="@label[contains(.,$nm-delim)]" expand-text="true">{ substring-after(.,$nm-delim) }</xsl:template>
   
   <xsl:template mode="modify" match="@label[matches(.,$num-regex)]" expand-text="true">{ replace(.,$num-regex,'') }</xsl:template>
   
   
</xsl:stylesheet>
