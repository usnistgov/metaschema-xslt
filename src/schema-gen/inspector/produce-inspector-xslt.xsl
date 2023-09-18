<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:XSLT="http://www.w3.org/1999/XSL/Transform/alias"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:pb="http://github.com/wendellpiez/XMLjellysandwich"
  xmlns="http://www.w3.org/1999/xhtml"
  xmlns:mx="http://csrc.nist.gov/ns/oscal/metaschema-xslt"
  xpath-default-namespace="http://csrc.nist.gov/ns/oscal/metaschema/1.0"
  version="3.0">
  
  <xsl:output indent="yes"/>
  
  <xsl:namespace-alias stylesheet-prefix="XSLT" result-prefix="xsl"/>
  
  <xsl:mode on-no-match="deep-copy"/>
  
  <xsl:template match="xsl:transform | xsl:stylesheet">
    <xsl:copy>
      <xsl:copy-of select="@*"/>
      
      <xsl:apply-templates/>
      
      <XSLT:template name="notice">
        <XSLT:param name="cat"/>
        <XSLT:param name="condition"/>
        <XSLT:param name="msg"/>
      </XSLT:template>      
      
      <XSLT:template name="notice-multiline"/>
      
      <XSLT:function name="mx:datatype-validate">
        <XSLT:param name="who"/>
        <XSLT:param name="waht"/>
      </XSLT:function>
    </xsl:copy>
  </xsl:template>
 
</xsl:stylesheet>