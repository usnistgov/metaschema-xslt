<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
  xmlns:nm="http://csrc.nist.gov/ns/metaschema"
  exclude-result-prefixes="#all" version="3.0">


  <!-- Purpose: Rewrites SVRL coming back from SCHXSLT into quiet, legible plain text -->
  
  <xsl:output method="text" indent="no"/>
  <!-- when embedded in XProc, serialize as plain text to
       avoid XML markup in the results -->
  
  <xsl:variable name="incidents"
    select="//svrl:failed-assert | //svrl:successful-report"/>

  <xsl:variable name="home" select="/"/>
  
  <xsl:template match="/">
    <report>
      <xsl:if test="not($incidents)">You are good - well-formed, with no reported Schematron messages (reports or failed assertions)</xsl:if>
      <xsl:apply-templates select="$incidents"/>
    </report>
  </xsl:template>

  <xsl:template match="svrl:failed-assert | svrl:successful-report">
    <incident>
      <xsl:variable name="code">
        <xsl:value-of select="@role"/>
        <xsl:if test="@role and @id">:</xsl:if>
        <xsl:value-of select="@id"/>
      </xsl:variable>
      <xsl:if test="normalize-space($code)">
        <xsl:text>[</xsl:text>
        <xsl:value-of select="$code"/>
        <xsl:text>] </xsl:text>
      </xsl:if>
      <xsl:text>- </xsl:text>
      <xsl:value-of select="nm:path-ns-prefix(@location)"/>
      <xsl:text> - </xsl:text>
      <xsl:value-of select="normalize-space(.)"/>
      <xsl:text>&#xA;</xsl:text>
    </incident>
  </xsl:template>

  <xsl:function name="nm:path-ns-prefix" as="xs:string">
    <xsl:param name="s"/>
    <xsl:variable name="prefix-regex" as="xs:string">Q\{(.*?)\}</xsl:variable>
    <xsl:value-of>
    <xsl:analyze-string select="string($s)" regex="{$prefix-regex}">
      <xsl:matching-substring>
        <xsl:sequence select="nm:prefix-for-ns(regex-group(1))"/>
        <xsl:text>:</xsl:text>
      </xsl:matching-substring>
      <xsl:non-matching-substring>
        <xsl:sequence select="."/>
      </xsl:non-matching-substring>
    </xsl:analyze-string>
    </xsl:value-of>
  </xsl:function>
  
  <xsl:function name="nm:prefix-for-ns" as="xs:string?">
    <xsl:param name="uri" as="xs:string"/>
    <xsl:sequence select="$home/*/*[@uri=$uri]/@prefix/string()"/>
  </xsl:function>
  
</xsl:stylesheet>
