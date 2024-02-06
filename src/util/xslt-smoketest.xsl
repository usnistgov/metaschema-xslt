<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
   xmlns:xs="http://www.w3.org/2001/XMLSchema"
   xmlns:math="http://www.w3.org/2005/xpath-functions/math"
   xmlns:nm="http://csrc.nist.gov/ns/metaschema"
   xmlns:err="http://www.w3.org/2005/xqt-errors"
   exclude-result-prefixes="#all"
   version="3.0">
   
<!--   Generator Smoke tester -

   The source document is either (marked as) XSLT, or it is not.
   If it is not, nothing comes back from this test.
   If it is, and it runs successfully, a <nm:SUCCESS> element results.
   If it appears to be XSLT but results in runtime errors If the document provon $xslt is not (actually) XSLT an ERROR element comes back.
   If an XSLT spoofs this output, it will result in a false positive for errors in this runtime
   
   accepts as a runtime parameter a path to an XSLT transformation
   
   this XSLT attempts to execute the provided XSLT
   
   embed it inside an XProc smoke test which -
     Generates an XSLT from a Metaschema
     Providing this XSLT as a runtime parameter, executes the smoker
       (path as xs:string or xslt as document-node())
     report results - Metaschema produces successfully, or does not
     -->
   
   <!--<xsl:param name="xslt-path" as="xs:string"/>-->
   
   <!--<xsl:param name="xslt-doc" as="document-node()?" select="()"/>-->

   <xsl:variable name="testing-xslt" select="/"/>
   
   <xsl:param name="try-src" as="document-node()">
      <xsl:document>
        <x/>
      </xsl:document>
   </xsl:param>

   <!-- We'll try anything provided - non-XSLT produces an ERROR anyway...  -->
   <xsl:template match="/">
      <xsl:sequence select="nm:try-xslt($testing-xslt,$try-src)"/>
      <!--if primary input is an XSLT, we will try applying it -->
   </xsl:template>
   
   <!--<xsl:template name="xslt-attempt" expand-text="true">
      <xsl:param name="xslt" as="document-node()"/>
      <xsl:sequence select="nm:try-xslt($xslt,())"/>
   </xsl:template>-->
   
   <!-- Given an XSLT and a nominal source, the function returns an ERROR in err namespace if the XSLT errors,
   or an OKAY element in no namespace if it runs successfully.
   If $try-source is not provided, it falls back to a stub "<x/>" document. -->
   
   
   <xsl:function name="nm:try-xslt" as="element()">
      <xsl:param name="xslt" as="document-node()"/>
      <xsl:param name="try-src" as="document-node()"/>
      <!--map result of fn:transform is main result on the map()?output, secondary result bindings
         on properties named for their putative result URLs -->
      <xsl:variable name="attempt">
         <xsl:try select="nm:execute($xslt, $try-src)">
         <xsl:catch expand-text="true">
            <err:ERROR code="{$err:code}" lineno="{$err:line-number}" colno="{$err:column-number}">{$err:description} - document element is *{ $xslt/name(*) }* in namespace *{ $xslt/*/namespace-uri() }*</err:ERROR>
            <!--<xsl:copy-of select="$xslt"/>-->
         </xsl:catch>
      </xsl:try>
      </xsl:variable>
      <xsl:apply-templates select="$attempt" mode="report-attempt"/>
      <xsl:if test="empty($attempt/*)" expand-text="true">
         <OKAY>Applying XSLT { $testing-xslt/*/replace(base-uri(),'.*/','') } it runs without error, but with no result on tested input (element *{ $try-src/*/name() }*)</OKAY>
      </xsl:if>
   </xsl:function>
      
   <xsl:template match="err:*" mode="report-attempt">
      <xsl:copy-of select="." copy-namespaces="no"/>
   </xsl:template>
   
   <xsl:template match="*" mode="report-attempt" expand-text="true">
      <xsl:variable name="c" select="count(//*)"/>
      <OKAY>Applying XSLT { $testing-xslt/*/replace(base-uri(),'.*/','') } produces a result: document root at *{ name() }*, with { $c } { if ($c = 1) then 'element' else 'elements' }</OKAY>
   </xsl:template>
      
   <xsl:function name="nm:execute">
      <xsl:param name="xslt" as="document-node()"/>
      <xsl:param name="src"  as="document-node()"/>
      <xsl:variable name="runtime-params" as="map(xs:QName,item()*)">
         <xsl:map/>
      </xsl:variable>
      <xsl:variable name="runtime" as="map(xs:string, item())">
         <xsl:map>
            <xsl:map-entry key="'xslt-version'"        select="3.0"/>
            <xsl:map-entry key="'stylesheet-location'" select="$xslt/base-uri()"/>
            <xsl:map-entry key="'source-node'"         select="$src"/>
            <xsl:map-entry key="'stylesheet-params'"   select="$runtime-params"/>
         </xsl:map>
      </xsl:variable>
      
      <!-- The function returns a map; primary results are under 'output'
             unless a base output URI is given
             https://www.w3.org/TR/xpath-functions-31/#func-transform -->
      <xsl:sequence select="transform($runtime)?output"/>
   </xsl:function>
   
</xsl:stylesheet>