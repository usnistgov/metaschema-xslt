<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
   version="3.0">
   
   <xsl:template match="/">
      <xsl:apply-templates select="$test/*"/>
   </xsl:template>
   
   <xsl:variable name="test">
      <a>
         <b>C</b>
         <d e="f">g</d>
         <H>I</H>
      </a>
   </xsl:variable>
   
   <xsl:template match="a//(d)"/>
   
   <xsl:key name="element-by-value" match="a//(*)" use="string(.)"/>
   
   <xsl:mode on-no-match="shallow-copy"/>
   
</xsl:stylesheet>