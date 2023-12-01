<?xml version="1.0" encoding="UTF-8"?>
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2"
   xmlns:sqf="http://www.schematron-quickfix.com/validator/process"
   xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
   
   <xsl:import href="current/computer_inspector.xsl"/>
   
   <sch:pattern>
      <sch:rule context="*">
         <xsl:variable name="tested">
            <xsl:apply-templates select="." mode="test"/>
         </xsl:variable>
         <sch:assert test="empty($tested/*)">
            <sch:value-of select="$tested/string(.)"/>
         </sch:assert>
      </sch:rule>
   </sch:pattern>
   
</sch:schema>