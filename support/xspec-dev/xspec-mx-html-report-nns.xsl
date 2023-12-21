<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema"
   xmlns:math="http://www.w3.org/2005/xpath-functions/math"
   exclude-result-prefixes="#all"
   xmlns:xspec="http://www.jenitennison.com/xslt/xspec"
   expand-text="true"
   version="3.0">
   
   
   <!-- Component XSLT to xspec-mx-html-report.xsl
   
        Containing templates matching elements in the no-namespace
        
   -->
   <xsl:template match="expect-test-wrap/text() | input-wrap/text()"/>
   
   
   <xsl:template match="input-wrap" mode="header" priority="3">
      <h3>From input</h3>
   </xsl:template>
   
   
   <xsl:template match="expect-test-wrap" mode="header" priority="3">
      <h4>Expecting</h4>
   </xsl:template>
   
   
   <xsl:template match="input-wrap" priority="3"/>
   
   <!-- should match content-wrap in no namespace -->
   <xsl:template match="content-wrap | expect-test-wrap" priority="3">
      <div class="{ local-name(.) }{ parent::xspec:scenario/' panel' }">
         <xsl:apply-templates select="." mode="header"/>
         <xsl:next-match/>
         <!--<xsl:copy-of select="child::node()" exclude-result-prefixes="#all" copy-namespaces="false"/>-->
      </div>
   </xsl:template>
   
   <xsl:template match="content-wrap">
      <div class="codeblock { local-name() }" onclick="javascript:clipboardCopy(this);">
         <xsl:call-template name="write-xml"/>
      </div>
   </xsl:template>
</xsl:stylesheet>