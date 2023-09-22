<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="3.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:mx="http://csrc.nist.gov/ns/csd/metaschema-xslt"
    exclude-result-prefixes="#all" >

    <xsl:output indent="yes"/>

    <xsl:mode on-no-match="shallow-skip"/>

<!-- Provides functions and processes for handling documents with mx elements
     interspersed. Filter them out but also count them-->

    <xsl:function name="mx:pull-reports" as="element()*">
        <xsl:param name="rr" as="node()*"/>
        <xsl:apply-templates select="$rr"/>
    </xsl:function>

    <xsl:template match="mx:*">
        <xsl:copy-of select="."/>
    </xsl:template>

</xsl:stylesheet>
