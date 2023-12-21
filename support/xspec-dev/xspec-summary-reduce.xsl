<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
   xmlns:xs="http://www.w3.org/2001/XMLSchema"
   xmlns:math="http://www.w3.org/2005/xpath-functions/math"
   xmlns:mx="http://csrc.nist.gov/ns/csd/metaschema-xslt"
   xpath-default-namespace="http://www.jenitennison.com/xslt/xspec"
   xmlns="http://www.jenitennison.com/xslt/xspec"
   exclude-result-prefixes="#all"
   expand-text="true"
   version="3.0">
   
   <!--<xsl:param name="static-base" as="xs:string" select="static-base-uri()"/>-->
   
   <xsl:template match="/REPORT-SUMMARY">
      <SYNOPSIS>SUCCESS - { mx:give-report-counts(.) } - NO FAILURES REPORTED</SYNOPSIS>
   </xsl:template>
   
   <xsl:template priority="20" match="/REPORT-SUMMARY[exists(descendant::fail)]">
      <SYNOPSIS>FAILURE - { mx:give-report-counts(.) } - { count(descendant::fail) } { mx:pluralize('FAILURE',count(descendant::fail)) } REPORTED</SYNOPSIS>
   </xsl:template>
   
   <xsl:function name="mx:give-report-counts" as="xs:string" expand-text="true">
      <xsl:param name="r" as="element(REPORT-SUMMARY)"/>
      <xsl:text> { mx:enumerate('report',count($r/report)) } with { mx:enumerate('test', sum($r/report/@test-count)) } ({ sum($r/report/@pending-count) } pending)</xsl:text>
   </xsl:function>
   
   <!-- mx:enumerate('elephant',1) returns '1 elephant'
        mx:enumerate('elephant',3) returns '3 elephants' -->
   <xsl:function name="mx:enumerate" as="xs:string" expand-text="true">
      <xsl:param name="nom" as="xs:string"/>
      <xsl:param name="c"   as="xs:double"/>
      <xsl:text>{ $c } { mx:pluralize($nom,$c) }</xsl:text>
   </xsl:function>
   
   <xsl:function name="mx:pluralize" as="xs:string">
      <xsl:param name="nom" as="xs:string"/>
      <xsl:param name="c"   as="xs:double"/>
      <xsl:apply-templates select="$nom" mode="pluralize">
         <xsl:with-param name="plural" as="xs:boolean" select="not($c eq 1)"/>
      </xsl:apply-templates>
   </xsl:function>
   
   <xsl:template match="." mode="pluralize">
      <xsl:param name="plural" as="xs:boolean" select="false()"/>
      <xsl:text>{ . }{ 's'[$plural] }</xsl:text>
   </xsl:template>
   
   <xsl:template priority="11" match=".[. = upper-case(.)]" mode="pluralize">
      <xsl:param name="plural" as="xs:boolean" select="false()"/>
      <xsl:text>{ . }{ 'S'[$plural] }</xsl:text>
   </xsl:template>
   
   <xsl:variable name="sample-in">
      <REPORT-SUMMARY xmlns="http://www.jenitennison.com/xslt/xspec"
         xmlns:mx="http://csrc.nist.gov/ns/csd/metaschema-xslt"
         xmlns:xs="http://www.w3.org/2001/XMLSchema"
         report-count="2"
         from="2023-12-21T10:33:11.3239881-05:00"
         t0="2023-12-21T10:33:11.6289888-05:00">
         <report date="2023-12-21T10:33:11.3239881-05:00"
            test-count="5"
            pending-count="1">
            <xspec-file>file:/C:/Users/wap1/Documents/usnistgov/metaschema-xslt/support/xspec-dev/testing/xspec-shell.xspec</xspec-file>
            <xslt-file>file:/C:/Users/wap1/Documents/usnistgov/metaschema-xslt/support/xspec-dev/testing/copy_me.xsl</xslt-file>
            <fail id="scenario1-scenario2-expect1">A Success and a failure : and not : False isn't</fail>
         </report>
         <report date="2023-12-21T10:33:11.6289888-05:00"
            test-count="10"
            pending-count="1">
            <xspec-file>file:/C:/Users/wap1/Documents/usnistgov/metaschema-xslt/support/xspec-dev/testing/xspec-basic.xspec</xspec-file>
            <xslt-file>file:/C:/Users/wap1/Documents/usnistgov/metaschema-xslt/support/xspec-dev/testing/copy_me.xsl</xslt-file>
            <fail id="scenario1-scenario2-expect1">[A] 'castable as' operation works on a few edge cases : [A.2] For April 1 : 1st day is castable</fail>
         </report>
      </REPORT-SUMMARY>
   </xsl:variable>
   
</xsl:stylesheet>