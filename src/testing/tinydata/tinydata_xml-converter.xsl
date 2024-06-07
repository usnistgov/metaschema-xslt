<xsl:stylesheet  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                 version="3.0"
                 exclude-result-prefixes="#all">
   
   
   <!-- Wrapper XSLT for current/choices_xml-to-json.xsl
        so we can call it inside XProc 1.0 -->
   <xsl:import href="current/tiny_xml-to-json.xsl"/>
   
   <xsl:param name="json-indent">yes</xsl:param>
   <xsl:template match="/">
      <json>
         <xsl:next-match/>
      </json>
   </xsl:template>
            
</xsl:stylesheet>
