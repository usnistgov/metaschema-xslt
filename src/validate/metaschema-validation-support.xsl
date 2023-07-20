<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="3.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:nm="http://csrc.nist.gov/ns/metaschema"
    xmlns:m="http://csrc.nist.gov/ns/oscal/metaschema/1.0"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xpath-default-namespace="http://csrc.nist.gov/ns/oscal/metaschema/1.0"
    exclude-result-prefixes="#all">

    <!--
    This XSLT provides a functional interface to OSCAL Metaschema composition.
    
    For a Metaschema, nm:compose-metaschema($metaschema) returns its composed form.
    
    TBD: More aggressive exception handling. For example, errors for broken links in Metaschema import.
    
    Logic replicates ../nist-metaschema-COMPOSE.xsl. 
    
    -->

    <xsl:variable name="home" select="/"/>
    

    <xsl:include href="../common/nist-metaschema-metaprocess.xsl"/>
    
    <xsl:variable name="composed-metaschema" select="nm:compose-metaschema(/)"/>
    
    <xsl:key name="index-by-name" match="m:index | m:is-unique" use="@name"/>
    
    <!-- Defining transformations to be applied in order for composition. -->
    <!-- todo: see if we can call ../compose/nist-metaschema-COMPOSE.xsl in place of (same) pipeline
         then we can get rid of metaprocess here -->
    <xsl:variable name="composition-sequence">
        <nm:transform version="3.0">../compose/metaschema-collect.xsl</nm:transform>
        <nm:transform version="3.0">../compose/metaschema-build-refs.xsl</nm:transform>
        <nm:transform version="3.0">../compose/metaschema-trim-extra-modules.xsl</nm:transform>
        <nm:transform version="3.0">../compose/metaschema-prune-unused-definitions.xsl</nm:transform>
        <nm:transform version="3.0">../compose/metaschema-resolve-use-names.xsl</nm:transform>
        <nm:transform version="3.0">../compose/metaschema-resolve-sibling-names.xsl</nm:transform>
        <nm:transform version="3.0">../compose/metaschema-digest.xsl</nm:transform>
        <nm:transform version="3.0">../compose/annotate-composition.xsl</nm:transform>
    </xsl:variable>
    
    <xsl:function name="nm:compose-metaschema" as="document-node()?">
        <xsl:param name="doc" as="document-node()?"/>
        <xsl:choose>
            <xsl:when test="empty($doc/*[2]) and ($doc/*[1] is $doc/m:METASCHEMA[1])">
                <xsl:call-template name="nm:process-pipeline">
                    <xsl:with-param name="source"   select="$doc"/>
                    <xsl:with-param name="sequence" select="$composition-sequence"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise expand-text="true">
                <xsl:document>
                    <ERROR>Cannot compose a document as a METASCHEMA. The document element is "{ $doc/*[1]/name() }" in namespace "{ $doc/*[1]/namespace-uri() }"</ERROR>
                </xsl:document>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>

    <!-- 0#0|0#0|0#0|0#0|0#0|0#0|0#0|0#0|0#0|0#0|0#0|0#0|0#0|0#0|0#0|0#0|0#0|0#0|0#0|0#0|0#0|0#0|0#0|0#0|-->
    
    <!--<xsl:function name="nm:has-a-distinct-name" as="xs:boolean">
        <!-\- checks a field or assembly as referenced in a modeled (i.e. references and inline definitions)
             and returns if they have distinct names -\->
    </xsl:function>-->
    
    <!-- =========================== -->
    <!-- = Composed node retrieval = -->
    <!-- =========================== -->
    <xsl:function name="nm:as-composed" as="element()*">
        <!-- Used to get the composed node for the provided uncomposed node -->
        <xsl:param name="who" as="element()"/>
        <!-- Typically, this will return:
            1) the composed if found with no exceptions,
            2) multiple nodes if there is a naming clash among siblings, or
            3) an empty sequence if there was no matching node. -->
        <xsl:sequence select="key('composed-node-by-identifier',nm:metaschema-module-node-identifier($who),$composed-metaschema)[empty(m:EXCEPTION)]"/>
    </xsl:function>
    
    <xsl:key name="composed-node-by-identifier"
        match="m:define-assembly | m:define-field | m:define-flag
        | m:flag | m:field | m:assembly" use="nm:composed-node-id(.)"/>
    
    <xsl:function name="nm:composed-node-id" as="xs:string">
        <!-- Used to get the key of a composed definition or instance for use with key('composed-node-by-identifier') -->
        <xsl:param name="who" as="element()"/>
        <xsl:variable name="top-level-definition" select="$who/ancestor-or-self::m:define-assembly[parent::m:METASCHEMA] |             $who/ancestor-or-self::m:define-field[parent::m:METASCHEMA] |              $who/ancestor-or-self::m:define-flag[parent::m:METASCHEMA]"/>
        <xsl:variable name="module-defined" select="$top-level-definition/@module"/>
        <xsl:value-of
            select="($module-defined,
            $who/ancestor-or-self::*/(@name | @ref),
            name($who), $who/m:use-name) => string-join('#')"/>
    </xsl:function>
    
    <xsl:key name="composed-node-by-identifier"
        match="m:define-assembly | m:define-field | m:define-flag
        | m:flag | m:field | m:assembly" use="nm:composed-node-id(.)"/>
    
    
    <xsl:function name="nm:metaschema-module-node-identifier" as="xs:string">
        <!-- Used to get the key of an uncomposed definition or instance for use with key('composed-node-by-identifier') -->
        <xsl:param name="who" as="element()"/>
        <xsl:value-of
            select="($who/root()/*/m:short-name,
            $who/ancestor-or-self::*/(@name | @ref),
            name($who), $who/m:use-name) => string-join('#')"/>
    </xsl:function>
    
    
    <!-- ===================================== -->
    <!-- = Definition retrieval for instance = -->
    <!-- ===================================== -->
    <xsl:function name="nm:definitions-for-reference" as="element()*">
        <!-- Used to get the composed definition for the provided composed instance. If the composed instance is a local definition, the same instance will be returned. -->
        <!-- If two definitions have the same @_key-name, perhaps due to a short-name clash, multiple definitions might be returned. -->
        <xsl:param name="who" as="element()"/>
        <xsl:choose>
            <xsl:when test="$who/(self::m:define-assembly | self::m:define-field | self::m:define-flag)">
                <xsl:sequence select="$who"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:sequence select="key('composed-definition-by-key-name',nm:composed-definition-identifier($who),$composed-metaschema)"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>
    
    <xsl:key name="composed-definition-by-key-name"
        match="m:define-assembly | m:define-field | m:define-flag" use="nm:composed-definition-identifier(.)"/>
    
    <xsl:function name="nm:composed-definition-identifier" as="xs:string">
        <!-- Used to get the key of a composed definition or instance for use with key('composed-definition-by-key-name') -->
        <xsl:param name="who" as="element()"/>
        <xsl:choose>
            <xsl:when test="$who/(self::m:define-assembly | self::m:define-field | self::m:define-flag)">
                <xsl:value-of select="(name($who), $who/(@_key-name)) => string-join('#')"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="(concat('define-',name($who)), $who/(@_key-ref)) => string-join('#')"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>
    
    <!-- ====================================== -->
    <!-- = Get top-level definition with name = -->
    <!-- ====================================== -->
    <xsl:function name="nm:composed-top-level-definitions-matching" as="element()*">
        <!-- Used to get the matching top-level definition(s) for the provided uncomposed node -->
        <xsl:param name="who" as="element()"/>
        <!-- Typically, this will return:
            1) the composed definition if found,
            2) multiple composed definitions if there is a naming clash or shadowing among global definitions, or
            3) an empty sequence if there was no matching definition. -->
        <xsl:sequence select="key('top-level-definition-by-name',nm:metaschema-definition-identifier($who),$composed-metaschema)"/>
    </xsl:function>
    
    <xsl:key name="top-level-definition-by-name" use="nm:metaschema-definition-identifier(.)"
        match="m:METASCHEMA/m:define-assembly[not(@scope='local')] |
        m:METASCHEMA/m:define-field[not(@scope='local')] |
        m:METASCHEMA/m:define-flag[not(@scope='local')]"/>
    
    <xsl:function name="nm:metaschema-definition-identifier" as="xs:string">
        <xsl:param name="who" as="element()"/>
        <xsl:value-of
            select="(name($who),$who/(@name | @ref)) => string-join('#')"/>
    </xsl:function>
    
    
    
</xsl:stylesheet>