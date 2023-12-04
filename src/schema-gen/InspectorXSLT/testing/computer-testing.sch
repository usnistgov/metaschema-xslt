<?xml version="1.0" encoding="UTF-8"?>
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2"
   xmlns:mx="http://csrc.nist.gov/ns/csd/metaschema-xslt"
   xmlns:sqf="http://www.schematron-quickfix.com/validator/process"
   xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
   
   <sch:ns prefix="mx" uri="http://csrc.nist.gov/ns/csd/metaschema-xslt"/>
   <xsl:import href="current/computer_inspector.xsl"/>
   
   <xsl:variable name="mx:report" as="function(*)"
      select="function($report as element()) as xs:string {
        $report ! ((@level, @class, string(.))=>string-join(':') )
        }"/>
   
   <sch:pattern>
      <sch:rule context="*">
         <xsl:variable name="tested">
            <xsl:apply-templates select="." mode="test"/>
         </xsl:variable>
         <sch:assert test="empty($tested/*)">
            <sch:value-of select="$tested/*/$mx:report(.) => string-join(' # ')"/>
         </sch:assert>
      </sch:rule>
   </sch:pattern>
   
</sch:schema>