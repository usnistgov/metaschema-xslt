<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
    xmlns:mt="http://csrc.nist.gov/ns/oscal/metaschema/xspec/testing"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="3.0">

    <!--
        The purpose of templates with match="mt:any-element" is
        to help verify that the correct routing of modes occurred
        in interface templates located in produce-xml-converter.xsl
        that are overridden in produce-json-converter.xsl.
        Matching an element that does not occur in realistic
        contexts prevents interference with tests for the modes we
        are routing to.
    -->
    <xsl:template match="mt:any-element" mode="make-xml-pull" as="comment()">
        <xsl:comment>Reached make-xml-pull mode</xsl:comment>
    </xsl:template>
    
    <xsl:template match="mt:any-element" mode="make-xml-match" as="text()+">
        <!-- Caller template with mode="make-match" concatenates text content,
            so return multiple text nodes to exercise that capability. -->
        <xsl:text>Reached make-xml-match mode</xsl:text>
        <xsl:text> for any-element</xsl:text>
    </xsl:template>

    <xsl:template match="mt:any-element" mode="make-json-pull" as="comment()">
        <xsl:comment>Reached make-json-pull mode</xsl:comment>
    </xsl:template>

    <xsl:template match="mt:any-element" mode="make-template" as="comment()">
        <xsl:comment>Reached make-template mode</xsl:comment>
    </xsl:template>

</xsl:stylesheet>