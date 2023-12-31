<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:m="http://csrc.nist.gov/ns/oscal/metaschema/1.0"
    xmlns="http://csrc.nist.gov/ns/oscal/metaschema/1.0"
    xpath-default-namespace="http://csrc.nist.gov/ns/oscal/metaschema/1.0"
    exclude-result-prefixes="#all" version="3.0">

    <xsl:output indent="yes"/>

    <xsl:strip-space
        elements="METASCHEMA define-flag define-field define-assembly remarks model choice assembly flag field"/>

    
    <!-- ====== ====== ====== ====== ====== ====== ====== ====== ====== ====== ====== ====== -->
    <!-- Pass: filter definitions (2) - keep only top-level definitions that are actually
         called by references in the models descending from assemblies with root-name
         (evaluated recursively, to include (*only*) definitions referenced by the referenced definitions).
    -->
    
    <xsl:mode on-no-match="shallow-copy"/>

    <xsl:function name="m:definition-key" as="xs:string">
        <xsl:param name="d"/>
        <xsl:sequence select="$d ! (substring-after(name(.),'define-'), @_key-name) => string-join('#')"/>
    </xsl:function>
    
    <xsl:key name="m:definition-by-key" match="METASCHEMA/define-assembly |
        METASCHEMA/define-field | METASCHEMA/define-flag" use="m:definition-key(.)"/>
    
    <xsl:function name="m:referencing-key" as="xs:string">
        <xsl:param name="r"/>
        <xsl:sequence select="$r ! (name(.), @_key-ref) => string-join('#')"/>
    </xsl:function>
    
    <xsl:variable name="definitions" as="xs:string*">
        <xsl:call-template name="read-for-definitions">
            <xsl:with-param name="refs" select="//root-name"/>
        </xsl:call-template>
    </xsl:variable>
     
    <!-- Debug mode traverses for the definitions list only    -->
    <!-- For the main entry point (no mode) see below   -->
    <xsl:template match="/METASCHEMA" mode="debug">
        <xsl:call-template name="read-for-definitions">
            <xsl:with-param name="refs" select="//root-name"/>
        </xsl:call-template>
    </xsl:template>
    
    <!-- Generic template traverses a sequence of references and returns any *new* definitions found. -->
    <xsl:template name="read-for-definitions">
        <xsl:param name="refs" as="node()*"/>
        <xsl:param name="defined-so-far" tunnel="true" select="()" as="xs:string*"/>
        <!-- Entering when $refs is empty we get () back. -->
        <xsl:iterate select="$refs">
            <xsl:param name="so-far" select="$defined-so-far" as="xs:string*"/>
            <xsl:param name="new" select="()" as="xs:string*"/>
            <xsl:on-completion select="$new"/>
            <xsl:variable name="captured" as="xs:string*">
                <xsl:apply-templates select="." mode="collect-definitions">
                    <xsl:with-param name="defined-so-far" tunnel="true" select="$so-far"/>
                </xsl:apply-templates>
            </xsl:variable>
            <xsl:next-iteration>
                <xsl:with-param name="so-far" select="$so-far, $captured"/>
                <xsl:with-param name="new" select="$new, $captured"/>
            </xsl:next-iteration>
        </xsl:iterate>
    </xsl:template>
    
    <!-- root-name fetches its parent definition -->
    <xsl:template mode="collect-definitions" match="root-name" as="xs:string*">
        <xsl:apply-templates select="parent::define-assembly" mode="#current"/>
    </xsl:template>

    <!-- a reference fetches its definition (referenced) -->
    <xsl:template mode="collect-definitions" match="@ref" as="xs:string*">
       <xsl:apply-templates select="key('m:definition-by-key',m:referencing-key(..))" mode="#current"/>
    </xsl:template>
    
   <!-- For any assembly, field or flag definition, announce it if not already found, and
        also get any new definitions referenced (if any) -->
    <xsl:template mode="collect-definitions"
        match="METASCHEMA/define-flag | METASCHEMA/define-field | METASCHEMA/define-assembly" as="xs:string*">
        <xsl:param name="defined-so-far" tunnel="true" select="()" as="xs:string*"/>
        <xsl:variable name="key" select="m:definition-key(.)"/>
        <xsl:if test="not($key = $defined-so-far)">
            <!-- emitting the value of $key into the result -->
            <xsl:sequence select="$key"/>
            <!-- now providing definitions for any references
                (an empty sequence for flags, fields with no flags, empty assemblies with no flags) -->
            <xsl:call-template name="read-for-definitions">
                <xsl:with-param name="refs" select=".//@ref"/>
                <xsl:with-param name="defined-so-far" tunnel="true" select="$defined-so-far, $key"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>
    
    <!-- 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 -->    

    <!-- Main entry copies input, warns of issues so far -->
    
    <xsl:template match="/METASCHEMA">
        <xsl:copy expand-text="true">
            <xsl:copy-of select="@*"/>
            <INFO info-type="objects-used">Seeing { $definitions => string-join(', ') }</INFO>
            <xsl:if test="not(@abstract='yes') and empty(//METASCHEMA/define-assembly/root-name)">
                <EXCEPTION problem-type="missing-root">No root found in this metaschema composition.</EXCEPTION>
            </xsl:if>
            <xsl:apply-templates/>
        </xsl:copy>
    </xsl:template>
    
    <!-- Given $definitions, top-level definitions can be filtered out if not referenced. -->
    
    <xsl:template match="METASCHEMA[not(@abstract='yes')]/define-assembly[not(m:definition-key(.) = $definitions)] |
        METASCHEMA[not(@abstract='yes')]/define-field[not(m:definition-key(.) = $definitions)] | 
        METASCHEMA[not(@abstract='yes')]/define-flag[not(m:definition-key(.) = $definitions)]">
        <xsl:variable name="def-type" select="('assembly','field','flag')[contains(current()!local-name(),.)]"/>
        <xsl:call-template name="warning">
            <xsl:with-param name="type">unused-definition</xsl:with-param>
            <xsl:with-param name="msg" expand-text="true">REMOVING unused { $def-type } definition for '{ @name }' from { (ancestor::METASCHEMA[1]/@module,'[unnamed module]')[1] }.</xsl:with-param>
        </xsl:call-template>
    </xsl:template>
    
    <xsl:template name="warning">
        <xsl:param name="msg"/>
        <xsl:param name="type">warning</xsl:param>
        <EXCEPTION problem-type="{ $type }">
            <xsl:copy-of select="$msg"/>
        </EXCEPTION>
    </xsl:template>
    
</xsl:stylesheet>
