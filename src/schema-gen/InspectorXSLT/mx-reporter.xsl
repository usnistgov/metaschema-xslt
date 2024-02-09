<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="3.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:mx="http://csrc.nist.gov/ns/csd/metaschema-xslt"
    exclude-result-prefixes="#all"
     expand-text="true">

    <xsl:output indent="yes"/>

    <!-- fails except on /mx:validation documents -->
    <xsl:mode on-no-match="text-only-copy"/>
    
    <!-- Provides functions and processes for handling documents with mx elements
     interspersed. Filter them out but also count them-->

    <xsl:function name="mx:pull-reports" as="element()*">
        <xsl:param name="rr" as="node()*"/>
        <xsl:apply-templates mode="grab-mx" select="$rr"/>
    </xsl:function>


    <xsl:template match="/mx:validation">
        <html>
            <head/>
            <body>
                <h1>Validation { @src ! replace(.,'.*/','') }</h1>
                <p class="source"><a href="{ @src }">{ @src }</a></p>
                <p>{ @elements } elements and { @attributes } attributes found in the document.</p>
                <xsl:apply-templates select="." mode="summary"/>
                <xsl:apply-templates/>
            </body>
        </html>
    </xsl:template>

    <xsl:template match="mx:validation" mode="summary">
        <div class="summary">
            <p>{ count(.//mx:report) } reports</p>
        </div>
    </xsl:template>
    
    <xsl:template match="mx:metaschema">
       <h2>Metaschema: { . } (namespace '{ @namespace }')</h2>
    </xsl:template>
   
    <xsl:template match="mx:validation[empty(descendant::mx:report)]" mode="summary">
        <div class="summary valid">
            <p>Good news - nothing to report - the instance is valid.</p>
        </div>
    </xsl:template>
    
    <xsl:template match="mx:report">
        <div class="report { @cat }">
            <h3 class="xpath">{ @xpath }</h3>
            <p class="test">{ @test }</p>
            <p>
                <xsl:apply-templates/>
            </p>
        </div>
    </xsl:template>

    <xsl:template match="mx:gi">
        <b>
            <xsl:apply-templates/>
        </b>
    </xsl:template>
    
</xsl:stylesheet>
