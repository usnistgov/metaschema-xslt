<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="3.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns="http://www.w3.org/1999/xhtml"
    xmlns:html="http://www.w3.org/1999/xhtml"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    xmlns:mx="http://csrc.nist.gov/ns/csd/metaschema-xslt"
    xmlns:map="http://www.w3.org/2005/xpath-functions/map"
    exclude-result-prefixes="#all"
    >

    <xsl:output indent="yes"/>

    <!-- treat elements in other namespaces as interlopers? -->
    <!--<xsl:variable name="allow-foreign" select="true()"/>-->
    
    <xsl:variable name="indented-serialization" as="element()">
        <output:serialization-parameters
            xmlns:output="http://www.w3.org/2010/xslt-xquery-serialization">
            <output:indent value="true"/>
        </output:serialization-parameters>
    </xsl:variable>
    
    <xsl:template match="/" name="xsl:initial-template">
        <section class="validation">
                        <xsl:variable name="findings" select="//mx:*"/>

                <h3>Element (tree) structure<xsl:if test="exists($findings)"> (with validation findings)</xsl:if></h3>
                <ul>
                    <xsl:sequence expand-text="true">
                        <xsl:variable name="elements" select="//* except $findings/descendant-or-self::*"/>
                        <li>elements: { count($elements) }</li>
                        <li>attributes: { count($elements/@*) }</li>
                        <li>findings: { count($findings) }</li>
                    </xsl:sequence>
                </ul>
                <xsl:if test="empty($findings)">
                    <h4>Congratulations: there is nothing to report</h4>
                </xsl:if>
                <xsl:apply-templates select="/" mode="outline"/>
                <details class="xml-source">
                    <summary>XML source</summary>
                    <pre id="document-source">
                    <xsl:value-of select="serialize(/, $indented-serialization)"/>
                </pre>
                </details>

            </section>
    </xsl:template>

    <xsl:template match="*" mode="outline" expand-text="true">
        <div class="outline">
            <div class="oll">{ name() }</div>
            <div class="olc">
                <xsl:apply-templates mode="outline"/>
            </div>
        </div>
    </xsl:template>
    
    <xsl:template match="mx:report" mode="outline" expand-text="true">
        <div class="report">
            <h4 class="title">{ @cat }</h4>
            <p class="reported{ @level ! (' ' || .) }">
                <xsl:apply-templates/>
            </p>
            <p class="xpath">{ @xpath }</p>
        </div>
    </xsl:template>
    
    <xsl:template match="mx:gi">
        <b class="gi">
            <xsl:apply-templates/>
        </b>
    </xsl:template>
    
    <xsl:template match="mx:kwd">
        <code class="kwd">
            <xsl:apply-templates/>
        </code>
    </xsl:template>
    
    <!-- <xsl:template match="*[exists(child::text()[matches(.,'\S')])]" mode="outline" expand-text="true">
        <div class="oll">{ name() }</div>
        <xsl:apply-templates mode="outline"/>
    </xsl:template> -->
    
    <xsl:template match="text()[matches(.,'^\s+$')]" mode="outline"/>
    
    <xsl:template match="text()" mode="outline" expand-text="true">
        <!-- <div class="olt" style="width: { normalize-space(.) ! string-length(.) }; flex-basis: { normalize-space(.) ! string-length(.) }">&#xA0;</div> -->
        <div class="olt">{ normalize-space(.) }</div>
    </xsl:template>
    
</xsl:stylesheet>
