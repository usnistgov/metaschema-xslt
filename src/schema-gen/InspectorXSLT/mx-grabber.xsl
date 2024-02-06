<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="3.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:mx="http://csrc.nist.gov/ns/csd/metaschema-xslt"
    exclude-result-prefixes="#all" >

    <xsl:output indent="yes"/>

    <!-- fails except on /mx:validation documents -->
    <xsl:mode on-no-match="shallow-skip"/>
    
    <xsl:mode name="grab-mx" on-no-match="shallow-skip"/>
    
    <!-- Provides functions and processes for handling documents with mx elements
     interspersed. Filter them out but also count them-->

    <xsl:function name="mx:pull-reports" as="element()*">
        <xsl:param name="rr" as="node()*"/>
        <xsl:apply-templates mode="grab-mx" select="$rr"/>
    </xsl:function>

    <xsl:template match="mx:*" mode="grab-mx">
        <xsl:copy-of select="."/>
    </xsl:template>

    <xsl:template match="/mx:validation">
        <xsl:copy>
            <xsl:copy-of select="@*"/>
            <xsl:attribute name="elements" select="count(descendant::* except .//mx:*/descendant-or-self::*)"/>
            <xsl:attribute name="attributes" select="count(descendant::*/@* except .//mx:*/descendant-or-self::*/@*)"/>
            <xsl:apply-templates mode="grab-mx"/>
        </xsl:copy>
    </xsl:template>
    
</xsl:stylesheet>
