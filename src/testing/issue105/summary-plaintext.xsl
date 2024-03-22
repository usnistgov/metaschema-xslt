<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
   xmlns:xs="http://www.w3.org/2001/XMLSchema"
   xmlns:math="http://www.w3.org/2005/xpath-functions/math"
   xmlns:xvrl="http://www.xproc.org/ns/xvrl"
   xmlns:nm="http://csrc.nist.gov/ns/metaschema"
   exclude-result-prefixes="xs math"
    expand-text="true"
   version="3.0">
   
   <xsl:mode on-no-match="shallow-copy"/>
   
   <xsl:output method="text"/>
   
   <xsl:template match="/*">
      <xsl:copy>
         <xsl:apply-templates/>
         <xsl:text>&#xA;{ (1 to 12) ! ':::::' }</xsl:text>
      </xsl:copy>
   </xsl:template>
   
   <xsl:template match="REPORT/*">
      <xsl:text>&#xA;</xsl:text>
      <xsl:apply-templates/>
      <xsl:apply-templates select="@href"/>
   </xsl:template>
   
   <xsl:template match="@href">: { . }</xsl:template>
   
</xsl:stylesheet>