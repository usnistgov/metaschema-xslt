<?xml version="1.0" encoding="UTF-8"?>
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2"
   xmlns:sqf="http://www.schematron-quickfix.com/validator/process"
   xmlns:x="http://www.jenitennison.com/xslt/xspec"
   xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
   xmlns:mx="http://csrc.nist.gov/ns/csd/metaschema-xslt">
   
   <sch:ns prefix="x"  uri="http://www.jenitennison.com/xslt/xspec"/>
   <sch:ns prefix="mx" uri="http://csrc.nist.gov/ns/csd/metaschema-xslt"/>
   
   <xsl:import href="xspec-renumber.xsl"/>

   <!--<sch:let name="nm-delim" value="'###'"/>-->
   
   <sch:pattern>
      <sch:rule context="x:scenario[matches(@label,$num-regex)]">
         <xsl:variable name="no">[<xsl:apply-templates select="." mode="countup"/>]</xsl:variable>
         <sch:assert test="starts-with(@label,$no)" sqf:fix="renumberScenario">Label is misnumbered: expecting <sch:value-of select="$no"/></sch:assert>
         <sqf:fix id="renumberScenario">
            <sqf:description>
               <sqf:title>Label scenario as '<sch:value-of select="$no"/>'</sqf:title>
            </sqf:description>
            <sqf:replace match="@label" node-type="attribute" target="label">
               <sch:value-of select="$no || ' ' || replace(.,$num-regex,'')"/>
            </sqf:replace>
         </sqf:fix>
      </sch:rule>
      <sch:rule context="mx:report">
         <xsl:variable name="no">[<xsl:apply-templates select="." mode="countup"/>]</xsl:variable>
         <sch:report test="@cf != '...'" sqf:fix="mask-report-cf">MX report @cf is likely to break</sch:report>
         <sqf:fix id="mask-report-cf">
            <sqf:description>
               <sqf:title>Mask @cf</sqf:title>
            </sqf:description>
            <sqf:replace match="@cf" node-type="attribute" target="cf">
               <sch:value-of select="'...'"/>
            </sqf:replace>
         </sqf:fix>
      </sch:rule>
   </sch:pattern>
 
   
</sch:schema>