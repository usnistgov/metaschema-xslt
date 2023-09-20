<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="3.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:mx="http://csrc.nist.gov/ns/csd/metaschema-xslt"
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
    
    <xsl:param name="IN" select="/"/>
    
    <xsl:template match="/" name="xsl:initial-template">
        <xsl:apply-templates select="$IN" mode="validate"/>            
    </xsl:template>

    <xsl:mode name="validate" on-no-match="shallow-copy"/>
    
    <xsl:mode name="value-only" on-no-match="text-only-copy"/>
    
    <xsl:mode name="validate-markup-line" on-no-match="text-only-copy"/>
    <xsl:mode name="validate-markup-multiline" on-no-match="shallow-skip"/>
    
    <xsl:template match="*" mode="validate">
        <xsl:copy>
            <xsl:namespace name="mx">http://csrc.nist.gov/ns/csd/metaschema-xslt</xsl:namespace>
            <xsl:copy-of select="@*"/>
            <xsl:apply-templates select="." mode="test"/>
            <xsl:apply-templates mode="validate"/>
        </xsl:copy>
            
    </xsl:template>
    
    <xsl:template match="text()" mode="validate">
        <xsl:apply-templates select="." mode="test"/>
        <xsl:copy-of select="."/>
    </xsl:template>
    
    <!-- wrapper template for testing on each node, to be overridden
         and extended for known elements -->
    <xsl:template match="*" mode="test">
        <!-- report if not recognized -->
        <xsl:call-template name="notice">
            <xsl:with-param name="cat">unknown element</xsl:with-param>
            <xsl:with-param name="msg" expand-text="true">Unrecognized element <mx:gi>{ name() }</mx:gi>.</xsl:with-param>
        </xsl:call-template>
    </xsl:template>
    
    <xsl:template match="text()[not(matches(.,'\S'))]" priority="0.1" mode="test"/>
        
    <xsl:template match="text()" mode="test">
        <!-- report if not recognized -->
        <xsl:call-template name="notice">
            <xsl:with-param name="cat">misplaced text</xsl:with-param>
            <xsl:with-param name="msg" expand-text="true">Errant text content.</xsl:with-param>
        </xsl:call-template>
    </xsl:template>
    
    
    
    <!-- report if not recognized -->
    <xsl:template match="*" mode="validate-markup-multiline" name="notice-multiline">
        <xsl:call-template name="notice">
            <xsl:with-param name="cat">unknown element</xsl:with-param>
            <xsl:with-param name="msg" expand-text="true">Unrecognized element <mx:gi>{ name() }</mx:gi> in multiline markup.</xsl:with-param>
        </xsl:call-template>
    </xsl:template>
    
    <xsl:variable name="markup-multline-blocks" select="'p','pre','ul','ol','table',
        'h1','h2','h3','h4','h5'"/>
    
    <!--<xsl:template match="p | pre | h1 | h2 | h3 | h5 | h5 | h6 | li | td" mode="validate-markup-multiline">
        <xsl:apply-templates mode="validate-markup-line"/>
    </xsl:template>
    
    <xsl:template match="ul | ol" mode="validate-markup-multiline">
        <xsl:apply-templates select="li" mode="validate-markup-multiline"/>
        <xsl:for-each select="* except li">
            <xsl:call-template name="notice-multiline"/>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template match="table" mode="validate-markup-multiline">
        <xsl:apply-templates select="tr" mode="validate-markup-multiline"/>
        <xsl:for-each select="* except tr">
            <xsl:call-template name="notice-multiline"/>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template match="tr" mode="validate-markup-multiline">
        <xsl:apply-templates select="td" mode="validate-markup-multiline"/>
        <xsl:for-each select="* except td">
            <xsl:call-template name="notice-multiline"/>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template match="em | strong | i | b | sub | sup | q | a | insert" mode="validate-markup-line">
        <xsl:apply-templates mode="validate-markup-line"/>
    </xsl:template>
    
    <xsl:template match="text()" mode="validate-markup-line"/>-->
    
    <xsl:template match="*" mode="validate-markup-line">
        <!-- report if not recognized -->
        <xsl:call-template name="notice">
            <xsl:with-param name="cat">unknown element</xsl:with-param>
            <xsl:with-param name="msg" expand-text="true">Unrecognized element <mx:gi>{ name() }</mx:gi>.</xsl:with-param>
        </xsl:call-template>
    </xsl:template>
    
    <!-- ... and attributes ...  -->
    <xsl:template match="@*" mode="test validate-markup-line validate-markup-multiline">
        <xsl:call-template name="notice">
            <xsl:with-param name="cat">unknown attribute</xsl:with-param>
            <xsl:with-param name="msg" expand-text="true">Unrecognized attribute <mx:gi>@{ name() }</mx:gi> on element <mx:gi>{ name(..) }</mx:gi> .</xsl:with-param>
        </xsl:call-template>
    </xsl:template>
    
    <xsl:template mode="test" match="@xsi:*" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"/>

    <xsl:template name="notice">
        <xsl:param name="condition" as="xs:boolean" select="true()"/>
        <xsl:param name="testing" as="xs:string">true()</xsl:param>
        <xsl:param name="cat" as="xs:string">[category]</xsl:param>
        <xsl:param name="msg">[info]</xsl:param>
        <xsl:if test="$condition">
            <xsl:variable name="xpath">
                <xsl:apply-templates select="." mode="xpath"/>
            </xsl:variable>
            <mx:report test="{ $testing }" cat="{$cat}" xpath="{ $xpath }">
                <xsl:sequence select="$msg"/>
            </mx:report>
        </xsl:if>
    </xsl:template>
    
    <xsl:template mode="xpath" match="*">
        <xsl:apply-templates select="parent::*" mode="#current"/>
        <xsl:text expand-text="true">/{ name() }</xsl:text>
    </xsl:template>
    
    <xsl:template mode="xpath" match="*[node-name()=(../* except current() )/node-name()]">
        <xsl:apply-templates select="parent::*" mode="#current"/>
        <xsl:variable name="kin" select="../*[node-name()=current()/node-name()]"/>
        <xsl:text expand-text="true">/{ name() }[{ mx:element-position(.)[count($kin) gt 1] }]</xsl:text>
    </xsl:template>
    
    <xsl:template mode="xpath" match="@*">
        <xsl:apply-templates select="parent::*" mode="#current"/>
        <xsl:text expand-text="true">/@{ name() }</xsl:text>
    </xsl:template>
    
    <xsl:template mode="xpath" match="text()">
        <xsl:apply-templates select="parent::*" mode="#current"/>
        <xsl:variable name="kin" select="../text()"/>
        <xsl:variable name="place" expand-text="true">[{ count(preceding-sibling::text()|.) }]</xsl:variable>
        <xsl:text expand-text="true">/text(){ (count($kin)[. gt 1]) ! $place }</xsl:text>
    </xsl:template>
    
    <xsl:template mode="xpath" match="comment()">
        <xsl:apply-templates select="parent::*" mode="#current"/>
        <xsl:variable name="kin" select="../comment()"/>
        <xsl:variable name="place" expand-text="true">[{ count(preceding-sibling::comment()|.) }]</xsl:variable>
        <xsl:text expand-text="true">/text(){ (count($kin)[. gt 1]) ! $place }</xsl:text>
    </xsl:template>
    
    <xsl:template mode="xpath" match="processing-instruction()">
        <xsl:apply-templates select="parent::*" mode="#current"/>
        <xsl:variable name="kin" select="../processing-instruction()"/>
        <xsl:variable name="place" expand-text="true">[{ count(preceding-sibling::processing-instruction()|.) }]</xsl:variable>
        <xsl:text expand-text="true">/text(){ (count($kin)[. gt 1]) ! $place }</xsl:text>
    </xsl:template>
    
    <xsl:template name="check-datatype">
        <xsl:apply-templates select="." mode="test-datatype"/>
    </xsl:template>
    
    <xsl:template mode="test-datatype" match="*"/>
   
    <xsl:function name="mx:element-position">
        <xsl:param name="for" as="element()"/>
        <xsl:variable name="qname" select="node-name($for)"/>
        <xsl:sequence select="count($for | $for/preceding-sibling::*[node-name() = $qname])"/>
    </xsl:function>
   
    <xsl:template name="check-markup-line-datatype">
        <xsl:apply-templates mode="validate-markup-line"/>
    </xsl:template>
    
    <xsl:template name="check-markup-multiline-datatype">
        <xsl:apply-templates mode="validate-markup-multiline"/>
    </xsl:template>
   
    <!-- stub to be replaced with results from produce-datatype-functions.xsl  -->
    <xsl:function name="mx:datatype-validate" as="xs:boolean">
        <xsl:param name="value" as="item()"/>
        <xsl:param name="nominal-type" as="item()?"/>
        <xsl:sequence select="true()"/>
    </xsl:function>
</xsl:stylesheet>
