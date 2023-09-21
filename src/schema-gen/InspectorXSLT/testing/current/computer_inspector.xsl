<?xml version="1.0" encoding="UTF-8"?>
<xsl:transform xmlns:mx="http://csrc.nist.gov/ns/csd/metaschema-xslt"
               xmlns:xs="http://www.w3.org/2001/XMLSchema"
               xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
               version="3.0"
               xpath-default-namespace="http://example.com/ns/computer"
               exclude-result-prefixes="#all">
   <xsl:mode name="test" on-no-match="shallow-skip"/>
   <!-- Generated 2023-09-21T15:37:36.7380354-04:00 -->
   <!-- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -->
   <!-- -#- -#- -#- -#- -#- -#- -#- -#- -#- -#- -#- -#- -#- -#- -#- -#- -#- -#- -#- -#- -#- -#- -#- -#- -->
   <!--    Templates copied from boilerplate-->
   <!-- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -->
   <xsl:output indent="yes"/>
   <!-- treat elements in other namespaces as interlopers? -->
   <!--<xsl:variable name="allow-foreign" select="true()"/>-->
   <xsl:variable name="indented-serialization" as="element()">
      <output:serialization-parameters xmlns:output="http://www.w3.org/2010/xslt-xquery-serialization">
         <output:indent value="true"/>
      </output:serialization-parameters>
   </xsl:variable>
   <xsl:param name="IN" select="/"/>
   <xsl:template match="/" name="xsl:initial-template">
      <mx:validation src=" base-uri(.) ">
         <xsl:apply-templates select="$IN" mode="validate"/>
      </mx:validation>
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
   <!-- tossing these as preventive measure -->
   <xsl:template mode="validate" match="processing-instruction()"/>
   <!-- as they may however be informative, comments are kept   -->
   <xsl:template mode="validate" match="comment()">
      <xsl:copy-of select="."/>
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
         <xsl:with-param name="cf">av.60</xsl:with-param>
         <xsl:with-param name="cat">unmatched</xsl:with-param>
         <xsl:with-param name="msg" expand-text="true">Unrecognized element <mx:gi>{ name() }</mx:gi>.</xsl:with-param>
      </xsl:call-template>
   </xsl:template>
   <xsl:template match="text()[not(matches(.,'\S'))]" priority="0.1" mode="test"/>
   <xsl:template match="text()" mode="test">
        <!-- report if not recognized -->
      <xsl:call-template name="notice">
         <xsl:with-param name="cf">av.71</xsl:with-param>
         <xsl:with-param name="cat">misplaced</xsl:with-param>
         <xsl:with-param name="msg" expand-text="true">Errant text content.</xsl:with-param>
      </xsl:call-template>
   </xsl:template>
   <!-- report if not recognized -->
   <xsl:template match="*" mode="validate-markup-multiline" name="notice-multiline">
      <xsl:call-template name="notice">
         <xsl:with-param name="cf">av.82</xsl:with-param>
         <xsl:with-param name="cat">unmatched in markup-multiline</xsl:with-param>
         <xsl:with-param name="msg" expand-text="true">Unrecognized element <mx:gi>{ name() }</mx:gi> in multiline markup.</xsl:with-param>
      </xsl:call-template>
   </xsl:template>
   <xsl:variable name="markup-multline-blocks"
                 select="'p','pre','ul','ol','table',         'h1','h2','h3','h4','h5'"/>
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
         <xsl:with-param name="cf">av.124</xsl:with-param>
         <xsl:with-param name="cat">unmatched in markup-line</xsl:with-param>
         <xsl:with-param name="msg" expand-text="true">Unrecognized element <mx:gi>{ name() }</mx:gi>.</xsl:with-param>
      </xsl:call-template>
   </xsl:template>
   <!-- ... and attributes ...  -->
   <xsl:template match="@*" mode="test validate-markup-line validate-markup-multiline">
      <xsl:call-template name="notice">
         <xsl:with-param name="cf">av.131</xsl:with-param>
         <xsl:with-param name="cat">unmatched attribute</xsl:with-param>
         <xsl:with-param name="msg" expand-text="true">Unrecognized attribute <mx:gi>@{ name() }</mx:gi> on element <mx:gi>{ name(..) }</mx:gi> .</xsl:with-param>
      </xsl:call-template>
   </xsl:template>
   <xsl:template xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                 mode="test"
                 match="@xsi:*"/>
   <xsl:template name="notice">
      <xsl:param name="cf"
                 as="xs:string"
                 select="document('') =&gt; base-uri() =&gt; replace('.*/','')"/>
      <xsl:param name="condition" as="xs:boolean" select="true()"/>
      <xsl:param name="testing" as="xs:string">true()</xsl:param>
      <xsl:param name="cat" as="xs:string">[category]</xsl:param>
      <xsl:param name="msg">[info]</xsl:param>
      <xsl:if test="$condition">
         <xsl:variable name="xpath">
            <xsl:apply-templates select="." mode="xpath"/>
         </xsl:variable>
         <mx:report cf="{$cf}" test="{ $testing }" cat="{$cat}" xpath="{ $xpath }">
            <xsl:sequence select="$msg"/>
         </mx:report>
      </xsl:if>
   </xsl:template>
   <xsl:template mode="xpath" match="*">
      <xsl:apply-templates select="parent::*" mode="#current"/>
      <xsl:text expand-text="true">/{ name() }</xsl:text>
   </xsl:template>
   <xsl:template mode="xpath"
                 match="*[node-name()=(../* except current() )/node-name()]">
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
   <!-- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -->
   <!-- -#- -#- -#- -#- -#- -#- -#- -#- -#- -#- -#- -#- -#- -#- -#- -#- -#- -#- -#- -#- -#- -#- -#- -#- -->
   <!--    Generated rules - first, any roots-->
   <!-- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -->
   <!-- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -->
   <!-- -#- -#- -#- -#- -#- -#- -#- -#- -#- -#- -#- -#- -#- -#- -#- -#- -#- -#- -#- -#- -#- -#- -#- -#- -->
   <!--     Root -->
   <!-- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -->
   <xsl:template match="/computer" mode="test">
      <xsl:apply-templates select="@*" mode="test"/>
      <xsl:call-template name="require-for-computer-assembly"/>
   </xsl:template>
   <!-- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -->
   <!-- -#- -#- -#- -#- -#- -#- -#- -#- -#- -#- -#- -#- -#- -#- -#- -#- -#- -#- -#- -#- -#- -#- -#- -#- -->
   <!--     Occurrences - templates in mode 'test' -->
   <!-- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -->
   <xsl:template priority="5" match="computer/motherboard/vendor" mode="test">
      <xsl:apply-templates select="@*" mode="test"/>
      <xsl:call-template name="notice">
         <xsl:with-param name="cf">gix.244</xsl:with-param>
         <xsl:with-param name="cat">cardinality</xsl:with-param>
         <xsl:with-param name="testing" as="xs:string">count(. | preceding-sibling::vendor) gt 1</xsl:with-param>
         <xsl:with-param name="condition" select="count(. | preceding-sibling::vendor) gt 1"/>
         <xsl:with-param name="msg">
            <mx:gi>vendor</mx:gi> appears too many times: 1 maximum is permitted.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="notice">
         <xsl:with-param name="cf">gix.287</xsl:with-param>
         <xsl:with-param name="cat">ordering</xsl:with-param>
         <xsl:with-param name="testing" as="xs:string">exists( preceding-sibling::type | preceding-sibling::cpu | preceding-sibling::ata-socket | preceding-sibling::memory | preceding-sibling::expansion-card )</xsl:with-param>
         <xsl:with-param name="condition"
                         select="exists( preceding-sibling::type | preceding-sibling::cpu | preceding-sibling::ata-socket | preceding-sibling::memory | preceding-sibling::expansion-card )"/>
         <xsl:with-param name="msg">
            <mx:gi>vendor</mx:gi> is unexpected following <mx:gi>type</mx:gi>, <mx:gi>cpu</mx:gi>, <mx:gi>ata-socket</mx:gi>, <mx:gi>memory</mx:gi>,  or <mx:gi>expansion-card</mx:gi>.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="require-for-vendor-assembly"/>
   </xsl:template>
   <xsl:template priority="5" match="motherboard/cpu/vendor" mode="test">
      <xsl:apply-templates select="@*" mode="test"/>
      <xsl:call-template name="notice">
         <xsl:with-param name="cf">gix.244</xsl:with-param>
         <xsl:with-param name="cat">cardinality</xsl:with-param>
         <xsl:with-param name="testing" as="xs:string">count(. | preceding-sibling::vendor) gt 1</xsl:with-param>
         <xsl:with-param name="condition" select="count(. | preceding-sibling::vendor) gt 1"/>
         <xsl:with-param name="msg">
            <mx:gi>vendor</mx:gi> appears too many times: 1 maximum is permitted.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="notice">
         <xsl:with-param name="cf">gix.287</xsl:with-param>
         <xsl:with-param name="cat">ordering</xsl:with-param>
         <xsl:with-param name="testing" as="xs:string">exists( preceding-sibling::product-name | preceding-sibling::architecture | preceding-sibling::speed )</xsl:with-param>
         <xsl:with-param name="condition"
                         select="exists( preceding-sibling::product-name | preceding-sibling::architecture | preceding-sibling::speed )"/>
         <xsl:with-param name="msg">
            <mx:gi>vendor</mx:gi> is unexpected following <mx:gi>product-name</mx:gi>, <mx:gi>architecture</mx:gi>,  or <mx:gi>speed</mx:gi>.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="require-for-vendor-assembly"/>
   </xsl:template>
   <xsl:template priority="5" match="motherboard/ata-socket/vendor" mode="test">
      <xsl:apply-templates select="@*" mode="test"/>
      <xsl:call-template name="notice">
         <xsl:with-param name="cf">gix.244</xsl:with-param>
         <xsl:with-param name="cat">cardinality</xsl:with-param>
         <xsl:with-param name="testing" as="xs:string">count(. | preceding-sibling::vendor) gt 1</xsl:with-param>
         <xsl:with-param name="condition" select="count(. | preceding-sibling::vendor) gt 1"/>
         <xsl:with-param name="msg">
            <mx:gi>vendor</mx:gi> appears too many times: 1 maximum is permitted.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="notice">
         <xsl:with-param name="cf">gix.287</xsl:with-param>
         <xsl:with-param name="cat">ordering</xsl:with-param>
         <xsl:with-param name="testing" as="xs:string">exists( preceding-sibling::product-name | preceding-sibling::type )</xsl:with-param>
         <xsl:with-param name="condition"
                         select="exists( preceding-sibling::product-name | preceding-sibling::type )"/>
         <xsl:with-param name="msg">
            <mx:gi>vendor</mx:gi> is unexpected following <mx:gi>product-name</mx:gi> or <mx:gi>type</mx:gi>.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="require-for-vendor-assembly"/>
   </xsl:template>
   <xsl:template priority="5" match="motherboard/memory/vendor" mode="test">
      <xsl:apply-templates select="@*" mode="test"/>
      <xsl:call-template name="notice">
         <xsl:with-param name="cf">gix.244</xsl:with-param>
         <xsl:with-param name="cat">cardinality</xsl:with-param>
         <xsl:with-param name="testing" as="xs:string">count(. | preceding-sibling::vendor) gt 1</xsl:with-param>
         <xsl:with-param name="condition" select="count(. | preceding-sibling::vendor) gt 1"/>
         <xsl:with-param name="msg">
            <mx:gi>vendor</mx:gi> appears too many times: 1 maximum is permitted.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="notice">
         <xsl:with-param name="cf">gix.287</xsl:with-param>
         <xsl:with-param name="cat">ordering</xsl:with-param>
         <xsl:with-param name="testing" as="xs:string">exists( preceding-sibling::product-name | preceding-sibling::byte-size )</xsl:with-param>
         <xsl:with-param name="condition"
                         select="exists( preceding-sibling::product-name | preceding-sibling::byte-size )"/>
         <xsl:with-param name="msg">
            <mx:gi>vendor</mx:gi> is unexpected following <mx:gi>product-name</mx:gi> or <mx:gi>byte-size</mx:gi>.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="require-for-vendor-assembly"/>
   </xsl:template>
   <xsl:template priority="5" match="motherboard/expansion-card/vendor" mode="test">
      <xsl:apply-templates select="@*" mode="test"/>
      <xsl:call-template name="notice">
         <xsl:with-param name="cf">gix.244</xsl:with-param>
         <xsl:with-param name="cat">cardinality</xsl:with-param>
         <xsl:with-param name="testing" as="xs:string">count(. | preceding-sibling::vendor) gt 1</xsl:with-param>
         <xsl:with-param name="condition" select="count(. | preceding-sibling::vendor) gt 1"/>
         <xsl:with-param name="msg">
            <mx:gi>vendor</mx:gi> appears too many times: 1 maximum is permitted.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="notice">
         <xsl:with-param name="cf">gix.287</xsl:with-param>
         <xsl:with-param name="cat">ordering</xsl:with-param>
         <xsl:with-param name="testing" as="xs:string">exists( preceding-sibling::product-name | preceding-sibling::type )</xsl:with-param>
         <xsl:with-param name="condition"
                         select="exists( preceding-sibling::product-name | preceding-sibling::type )"/>
         <xsl:with-param name="msg">
            <mx:gi>vendor</mx:gi> is unexpected following <mx:gi>product-name</mx:gi> or <mx:gi>type</mx:gi>.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="require-for-vendor-assembly"/>
   </xsl:template>
   <xsl:template priority="5" match="/computer/motherboard" mode="test">
      <xsl:apply-templates select="@*" mode="test"/>
      <xsl:call-template name="notice">
         <xsl:with-param name="cf">gix.244</xsl:with-param>
         <xsl:with-param name="cat">cardinality</xsl:with-param>
         <xsl:with-param name="testing" as="xs:string">count(. | preceding-sibling::motherboard) gt 1</xsl:with-param>
         <xsl:with-param name="condition"
                         select="count(. | preceding-sibling::motherboard) gt 1"/>
         <xsl:with-param name="msg">
            <mx:gi>motherboard</mx:gi> appears too many times: 1 maximum is permitted.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="require-for-computer_..._motherboard-assembly"/>
   </xsl:template>
   <xsl:template priority="5" match="computer/motherboard/cpu" mode="test">
      <xsl:apply-templates select="@*" mode="test"/>
      <xsl:call-template name="notice">
         <xsl:with-param name="cf">gix.244</xsl:with-param>
         <xsl:with-param name="cat">cardinality</xsl:with-param>
         <xsl:with-param name="testing" as="xs:string">count(. | preceding-sibling::cpu) gt 1</xsl:with-param>
         <xsl:with-param name="condition" select="count(. | preceding-sibling::cpu) gt 1"/>
         <xsl:with-param name="msg">
            <mx:gi>cpu</mx:gi> appears too many times: 1 maximum is permitted.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="notice">
         <xsl:with-param name="cf">gix.287</xsl:with-param>
         <xsl:with-param name="cat">ordering</xsl:with-param>
         <xsl:with-param name="testing" as="xs:string">exists( preceding-sibling::ata-socket | preceding-sibling::memory | preceding-sibling::expansion-card )</xsl:with-param>
         <xsl:with-param name="condition"
                         select="exists( preceding-sibling::ata-socket | preceding-sibling::memory | preceding-sibling::expansion-card )"/>
         <xsl:with-param name="msg">
            <mx:gi>cpu</mx:gi> is unexpected following <mx:gi>ata-socket</mx:gi>, <mx:gi>memory</mx:gi>,  or <mx:gi>expansion-card</mx:gi>.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="require-for-computer_..._motherboard_..._cpu-assembly"/>
   </xsl:template>
   <xsl:template priority="5" match="computer/motherboard/ata-socket" mode="test">
      <xsl:apply-templates select="@*" mode="test"/>
      <xsl:call-template name="notice">
         <xsl:with-param name="cf">gix.244</xsl:with-param>
         <xsl:with-param name="cat">cardinality</xsl:with-param>
         <xsl:with-param name="testing" as="xs:string">count(. | preceding-sibling::ata-socket) gt 1</xsl:with-param>
         <xsl:with-param name="condition" select="count(. | preceding-sibling::ata-socket) gt 1"/>
         <xsl:with-param name="msg">
            <mx:gi>ata-socket</mx:gi> appears too many times: 1 maximum is permitted.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="notice">
         <xsl:with-param name="cf">gix.287</xsl:with-param>
         <xsl:with-param name="cat">ordering</xsl:with-param>
         <xsl:with-param name="testing" as="xs:string">exists( preceding-sibling::memory | preceding-sibling::expansion-card )</xsl:with-param>
         <xsl:with-param name="condition"
                         select="exists( preceding-sibling::memory | preceding-sibling::expansion-card )"/>
         <xsl:with-param name="msg">
            <mx:gi>ata-socket</mx:gi> is unexpected following <mx:gi>memory</mx:gi> or <mx:gi>expansion-card</mx:gi>.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="require-for-computer_..._motherboard_..._ata-socket-assembly"/>
   </xsl:template>
   <xsl:template priority="5" match="computer/motherboard/memory" mode="test">
      <xsl:apply-templates select="@*" mode="test"/>
      <xsl:call-template name="notice">
         <xsl:with-param name="cf">gix.287</xsl:with-param>
         <xsl:with-param name="cat">ordering</xsl:with-param>
         <xsl:with-param name="testing" as="xs:string">exists( preceding-sibling::expansion-card )</xsl:with-param>
         <xsl:with-param name="condition" select="exists( preceding-sibling::expansion-card )"/>
         <xsl:with-param name="msg">
            <mx:gi>memory</mx:gi> is unexpected following <mx:gi>expansion-card</mx:gi>.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="require-for-computer_..._motherboard_..._memory-assembly"/>
   </xsl:template>
   <xsl:template priority="5"
                 match="computer/motherboard/expansion-card"
                 mode="test">
      <xsl:apply-templates select="@*" mode="test"/>
      <xsl:call-template name="require-for-computer_..._motherboard_..._expansion-card-assembly"/>
   </xsl:template>
   <xsl:template match="motherboard/cpu/product-name/text()" mode="test"/>
   <xsl:template priority="5" match="motherboard/cpu/product-name" mode="test">
      <xsl:apply-templates select="@*" mode="test"/>
      <xsl:call-template name="notice">
         <xsl:with-param name="cf">gix.244</xsl:with-param>
         <xsl:with-param name="cat">cardinality</xsl:with-param>
         <xsl:with-param name="testing" as="xs:string">count(. | preceding-sibling::product-name) gt 1</xsl:with-param>
         <xsl:with-param name="condition"
                         select="count(. | preceding-sibling::product-name) gt 1"/>
         <xsl:with-param name="msg">
            <mx:gi>product-name</mx:gi> appears too many times: 1 maximum is permitted.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="notice">
         <xsl:with-param name="cf">gix.287</xsl:with-param>
         <xsl:with-param name="cat">ordering</xsl:with-param>
         <xsl:with-param name="testing" as="xs:string">exists( preceding-sibling::architecture | preceding-sibling::speed )</xsl:with-param>
         <xsl:with-param name="condition"
                         select="exists( preceding-sibling::architecture | preceding-sibling::speed )"/>
         <xsl:with-param name="msg">
            <mx:gi>product-name</mx:gi> is unexpected following <mx:gi>architecture</mx:gi> or <mx:gi>speed</mx:gi>.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="require-for-product-name-field"/>
   </xsl:template>
   <xsl:template match="motherboard/ata-socket/product-name/text()" mode="test"/>
   <xsl:template priority="5"
                 match="motherboard/ata-socket/product-name"
                 mode="test">
      <xsl:apply-templates select="@*" mode="test"/>
      <xsl:call-template name="notice">
         <xsl:with-param name="cf">gix.244</xsl:with-param>
         <xsl:with-param name="cat">cardinality</xsl:with-param>
         <xsl:with-param name="testing" as="xs:string">count(. | preceding-sibling::product-name) gt 1</xsl:with-param>
         <xsl:with-param name="condition"
                         select="count(. | preceding-sibling::product-name) gt 1"/>
         <xsl:with-param name="msg">
            <mx:gi>product-name</mx:gi> appears too many times: 1 maximum is permitted.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="notice">
         <xsl:with-param name="cf">gix.287</xsl:with-param>
         <xsl:with-param name="cat">ordering</xsl:with-param>
         <xsl:with-param name="testing" as="xs:string">exists( preceding-sibling::type )</xsl:with-param>
         <xsl:with-param name="condition" select="exists( preceding-sibling::type )"/>
         <xsl:with-param name="msg">
            <mx:gi>product-name</mx:gi> is unexpected following <mx:gi>type</mx:gi>.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="require-for-product-name-field"/>
   </xsl:template>
   <xsl:template match="motherboard/memory/product-name/text()" mode="test"/>
   <xsl:template priority="5" match="motherboard/memory/product-name" mode="test">
      <xsl:apply-templates select="@*" mode="test"/>
      <xsl:call-template name="notice">
         <xsl:with-param name="cf">gix.244</xsl:with-param>
         <xsl:with-param name="cat">cardinality</xsl:with-param>
         <xsl:with-param name="testing" as="xs:string">count(. | preceding-sibling::product-name) gt 1</xsl:with-param>
         <xsl:with-param name="condition"
                         select="count(. | preceding-sibling::product-name) gt 1"/>
         <xsl:with-param name="msg">
            <mx:gi>product-name</mx:gi> appears too many times: 1 maximum is permitted.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="notice">
         <xsl:with-param name="cf">gix.287</xsl:with-param>
         <xsl:with-param name="cat">ordering</xsl:with-param>
         <xsl:with-param name="testing" as="xs:string">exists( preceding-sibling::byte-size )</xsl:with-param>
         <xsl:with-param name="condition" select="exists( preceding-sibling::byte-size )"/>
         <xsl:with-param name="msg">
            <mx:gi>product-name</mx:gi> is unexpected following <mx:gi>byte-size</mx:gi>.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="require-for-product-name-field"/>
   </xsl:template>
   <xsl:template match="motherboard/expansion-card/product-name/text()" mode="test"/>
   <xsl:template priority="5"
                 match="motherboard/expansion-card/product-name"
                 mode="test">
      <xsl:apply-templates select="@*" mode="test"/>
      <xsl:call-template name="notice">
         <xsl:with-param name="cf">gix.244</xsl:with-param>
         <xsl:with-param name="cat">cardinality</xsl:with-param>
         <xsl:with-param name="testing" as="xs:string">count(. | preceding-sibling::product-name) gt 1</xsl:with-param>
         <xsl:with-param name="condition"
                         select="count(. | preceding-sibling::product-name) gt 1"/>
         <xsl:with-param name="msg">
            <mx:gi>product-name</mx:gi> appears too many times: 1 maximum is permitted.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="notice">
         <xsl:with-param name="cf">gix.287</xsl:with-param>
         <xsl:with-param name="cat">ordering</xsl:with-param>
         <xsl:with-param name="testing" as="xs:string">exists( preceding-sibling::type )</xsl:with-param>
         <xsl:with-param name="condition" select="exists( preceding-sibling::type )"/>
         <xsl:with-param name="msg">
            <mx:gi>product-name</mx:gi> is unexpected following <mx:gi>type</mx:gi>.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="require-for-product-name-field"/>
   </xsl:template>
   <xsl:template match="motherboard/vendor/name/text() | cpu/vendor/name/text() | ata-socket/vendor/name/text() | memory/vendor/name/text() | expansion-card/vendor/name/text()"
                 mode="test"/>
   <xsl:template priority="5"
                 match="motherboard/vendor/name | cpu/vendor/name | ata-socket/vendor/name | memory/vendor/name | expansion-card/vendor/name"
                 mode="test">
      <xsl:apply-templates select="@*" mode="test"/>
      <xsl:call-template name="notice">
         <xsl:with-param name="cf">gix.244</xsl:with-param>
         <xsl:with-param name="cat">cardinality</xsl:with-param>
         <xsl:with-param name="testing" as="xs:string">count(. | preceding-sibling::name) gt 1</xsl:with-param>
         <xsl:with-param name="condition" select="count(. | preceding-sibling::name) gt 1"/>
         <xsl:with-param name="msg">
            <mx:gi>name</mx:gi> appears too many times: 1 maximum is permitted.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="notice">
         <xsl:with-param name="cf">gix.287</xsl:with-param>
         <xsl:with-param name="cat">ordering</xsl:with-param>
         <xsl:with-param name="testing" as="xs:string">exists( preceding-sibling::address | preceding-sibling::website )</xsl:with-param>
         <xsl:with-param name="condition"
                         select="exists( preceding-sibling::address | preceding-sibling::website )"/>
         <xsl:with-param name="msg">
            <mx:gi>name</mx:gi> is unexpected following <mx:gi>address</mx:gi> or <mx:gi>website</mx:gi>.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="require-for-vendor_..._name-field"/>
   </xsl:template>
   <xsl:template match="motherboard/vendor/address/text() | cpu/vendor/address/text() | ata-socket/vendor/address/text() | memory/vendor/address/text() | expansion-card/vendor/address/text()"
                 mode="test"/>
   <xsl:template priority="5"
                 match="motherboard/vendor/address | cpu/vendor/address | ata-socket/vendor/address | memory/vendor/address | expansion-card/vendor/address"
                 mode="test">
      <xsl:apply-templates select="@*" mode="test"/>
      <xsl:call-template name="notice">
         <xsl:with-param name="cf">gix.244</xsl:with-param>
         <xsl:with-param name="cat">cardinality</xsl:with-param>
         <xsl:with-param name="testing" as="xs:string">count(. | preceding-sibling::address) gt 1</xsl:with-param>
         <xsl:with-param name="condition" select="count(. | preceding-sibling::address) gt 1"/>
         <xsl:with-param name="msg">
            <mx:gi>address</mx:gi> appears too many times: 1 maximum is permitted.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="notice">
         <xsl:with-param name="cf">gix.287</xsl:with-param>
         <xsl:with-param name="cat">ordering</xsl:with-param>
         <xsl:with-param name="testing" as="xs:string">exists( preceding-sibling::website )</xsl:with-param>
         <xsl:with-param name="condition" select="exists( preceding-sibling::website )"/>
         <xsl:with-param name="msg">
            <mx:gi>address</mx:gi> is unexpected following <mx:gi>website</mx:gi>.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="require-for-vendor_..._address-field"/>
   </xsl:template>
   <xsl:template match="motherboard/vendor/website/text() | cpu/vendor/website/text() | ata-socket/vendor/website/text() | memory/vendor/website/text() | expansion-card/vendor/website/text()"
                 mode="test"/>
   <xsl:template priority="5"
                 match="motherboard/vendor/website | cpu/vendor/website | ata-socket/vendor/website | memory/vendor/website | expansion-card/vendor/website"
                 mode="test">
      <xsl:apply-templates select="@*" mode="test"/>
      <xsl:call-template name="notice">
         <xsl:with-param name="cf">gix.244</xsl:with-param>
         <xsl:with-param name="cat">cardinality</xsl:with-param>
         <xsl:with-param name="testing" as="xs:string">count(. | preceding-sibling::website) gt 1</xsl:with-param>
         <xsl:with-param name="condition" select="count(. | preceding-sibling::website) gt 1"/>
         <xsl:with-param name="msg">
            <mx:gi>website</mx:gi> appears too many times: 1 maximum is permitted.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="require-for-vendor_..._website-field"/>
   </xsl:template>
   <xsl:template match="computer/motherboard/type/text()" mode="test"/>
   <xsl:template priority="5" match="computer/motherboard/type" mode="test">
      <xsl:apply-templates select="@*" mode="test"/>
      <xsl:call-template name="notice">
         <xsl:with-param name="cf">gix.244</xsl:with-param>
         <xsl:with-param name="cat">cardinality</xsl:with-param>
         <xsl:with-param name="testing" as="xs:string">count(. | preceding-sibling::type) gt 1</xsl:with-param>
         <xsl:with-param name="condition" select="count(. | preceding-sibling::type) gt 1"/>
         <xsl:with-param name="msg">
            <mx:gi>type</mx:gi> appears too many times: 1 maximum is permitted.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="notice">
         <xsl:with-param name="cf">gix.287</xsl:with-param>
         <xsl:with-param name="cat">ordering</xsl:with-param>
         <xsl:with-param name="testing" as="xs:string">exists( preceding-sibling::cpu | preceding-sibling::ata-socket | preceding-sibling::memory | preceding-sibling::expansion-card )</xsl:with-param>
         <xsl:with-param name="condition"
                         select="exists( preceding-sibling::cpu | preceding-sibling::ata-socket | preceding-sibling::memory | preceding-sibling::expansion-card )"/>
         <xsl:with-param name="msg">
            <mx:gi>type</mx:gi> is unexpected following <mx:gi>cpu</mx:gi>, <mx:gi>ata-socket</mx:gi>, <mx:gi>memory</mx:gi>,  or <mx:gi>expansion-card</mx:gi>.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="require-for-computer_..._motherboard_..._type-field"/>
   </xsl:template>
   <xsl:template match="motherboard/cpu/architecture/text()" mode="test"/>
   <xsl:template priority="5" match="motherboard/cpu/architecture" mode="test">
      <xsl:apply-templates select="@*" mode="test"/>
      <xsl:call-template name="notice">
         <xsl:with-param name="cf">gix.244</xsl:with-param>
         <xsl:with-param name="cat">cardinality</xsl:with-param>
         <xsl:with-param name="testing" as="xs:string">count(. | preceding-sibling::architecture) gt 1</xsl:with-param>
         <xsl:with-param name="condition"
                         select="count(. | preceding-sibling::architecture) gt 1"/>
         <xsl:with-param name="msg">
            <mx:gi>architecture</mx:gi> appears too many times: 1 maximum is permitted.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="notice">
         <xsl:with-param name="cf">gix.287</xsl:with-param>
         <xsl:with-param name="cat">ordering</xsl:with-param>
         <xsl:with-param name="testing" as="xs:string">exists( preceding-sibling::speed )</xsl:with-param>
         <xsl:with-param name="condition" select="exists( preceding-sibling::speed )"/>
         <xsl:with-param name="msg">
            <mx:gi>architecture</mx:gi> is unexpected following <mx:gi>speed</mx:gi>.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="require-for-computer_..._motherboard_..._cpu_..._architecture-field"/>
   </xsl:template>
   <xsl:template match="motherboard/cpu/speed/text()" mode="test"/>
   <xsl:template priority="5" match="motherboard/cpu/speed" mode="test">
      <xsl:apply-templates select="@*" mode="test"/>
      <xsl:call-template name="notice">
         <xsl:with-param name="cf">gix.244</xsl:with-param>
         <xsl:with-param name="cat">cardinality</xsl:with-param>
         <xsl:with-param name="testing" as="xs:string">count(. | preceding-sibling::speed) gt 1</xsl:with-param>
         <xsl:with-param name="condition" select="count(. | preceding-sibling::speed) gt 1"/>
         <xsl:with-param name="msg">
            <mx:gi>speed</mx:gi> appears too many times: 1 maximum is permitted.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="require-for-computer_..._motherboard_..._cpu_..._speed-field"/>
   </xsl:template>
   <xsl:template match="motherboard/ata-socket/type/text()" mode="test"/>
   <xsl:template priority="5" match="motherboard/ata-socket/type" mode="test">
      <xsl:apply-templates select="@*" mode="test"/>
      <xsl:call-template name="notice">
         <xsl:with-param name="cf">gix.244</xsl:with-param>
         <xsl:with-param name="cat">cardinality</xsl:with-param>
         <xsl:with-param name="testing" as="xs:string">count(. | preceding-sibling::type) gt 1</xsl:with-param>
         <xsl:with-param name="condition" select="count(. | preceding-sibling::type) gt 1"/>
         <xsl:with-param name="msg">
            <mx:gi>type</mx:gi> appears too many times: 1 maximum is permitted.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="require-for-computer_..._motherboard_..._ata-socket_..._type-field"/>
   </xsl:template>
   <xsl:template match="motherboard/memory/byte-size/text()" mode="test"/>
   <xsl:template priority="5" match="motherboard/memory/byte-size" mode="test">
      <xsl:apply-templates select="@*" mode="test"/>
      <xsl:call-template name="notice">
         <xsl:with-param name="cf">gix.244</xsl:with-param>
         <xsl:with-param name="cat">cardinality</xsl:with-param>
         <xsl:with-param name="testing" as="xs:string">count(. | preceding-sibling::byte-size) gt 1</xsl:with-param>
         <xsl:with-param name="condition" select="count(. | preceding-sibling::byte-size) gt 1"/>
         <xsl:with-param name="msg">
            <mx:gi>byte-size</mx:gi> appears too many times: 1 maximum is permitted.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="require-for-computer_..._motherboard_..._memory_..._byte-size-field"/>
   </xsl:template>
   <xsl:template match="motherboard/expansion-card/type/text()" mode="test"/>
   <xsl:template priority="5" match="motherboard/expansion-card/type" mode="test">
      <xsl:apply-templates select="@*" mode="test"/>
      <xsl:call-template name="notice">
         <xsl:with-param name="cf">gix.244</xsl:with-param>
         <xsl:with-param name="cat">cardinality</xsl:with-param>
         <xsl:with-param name="testing" as="xs:string">count(. | preceding-sibling::type) gt 1</xsl:with-param>
         <xsl:with-param name="condition" select="count(. | preceding-sibling::type) gt 1"/>
         <xsl:with-param name="msg">
            <mx:gi>type</mx:gi> appears too many times: 1 maximum is permitted.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="require-for-computer_..._motherboard_..._expansion-card_..._type-field"/>
   </xsl:template>
   <xsl:template match="motherboard/vendor/@id | cpu/vendor/@id | ata-socket/vendor/@id | memory/vendor/@id | expansion-card/vendor/@id"
                 mode="test">
      <xsl:call-template name="require-for-vendor_..._id-flag"/>
   </xsl:template>
   <xsl:template match="/computer/@id" mode="test">
      <xsl:call-template name="require-for-computer_..._id-flag"/>
   </xsl:template>
   <!-- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -->
   <!-- -#- -#- -#- -#- -#- -#- -#- -#- -#- -#- -#- -#- -#- -#- -#- -#- -#- -#- -#- -#- -#- -#- -#- -#- -->
   <!--     Fallbacks for occurrences of known elements and attributes, except out of context -->
   <!-- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -->
   <xsl:template mode="test"
                 match="name | address | website | computer | motherboard | vendor | type | cpu | product-name | architecture | speed | ata-socket | memory | byte-size | expansion-card">
      <xsl:call-template name="notice">
         <xsl:with-param name="cat">context</xsl:with-param>
         <xsl:with-param name="msg" expand-text="true">
            <mx:gi>{ name() }</mx:gi> is not expected here.</xsl:with-param>
      </xsl:call-template>
   </xsl:template>
   <xsl:template mode="test" match="@id">
      <xsl:call-template name="notice">
         <xsl:with-param name="cat">context</xsl:with-param>
         <xsl:with-param name="msg" expand-text="true">
            <mx:gi>@{ name() }</mx:gi> is not expected here.</xsl:with-param>
      </xsl:call-template>
   </xsl:template>
   <!-- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -->
   <!-- -#- -#- -#- -#- -#- -#- -#- -#- -#- -#- -#- -#- -#- -#- -#- -#- -#- -#- -#- -#- -#- -#- -#- -#- -->
   <!--     Definitions - a named template for each -->
   <!-- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -->
   <xsl:template name="require-for-vendor-assembly">
      <xsl:call-template name="notice">
         <xsl:with-param name="cf">gix.422</xsl:with-param>
         <xsl:with-param name="cat">required flag</xsl:with-param>
         <xsl:with-param name="testing" as="xs:string">empty(@id)</xsl:with-param>
         <xsl:with-param name="condition" select="empty(@id)"/>
         <xsl:with-param name="msg" expand-text="true">
            <mx:gi>{ name() }</mx:gi> requires <mx:gi>@id</mx:gi>.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="notice">
         <xsl:with-param name="cf">gix.329</xsl:with-param>
         <xsl:with-param name="cat">required contents</xsl:with-param>
         <xsl:with-param name="testing" as="xs:string">empty(name)</xsl:with-param>
         <xsl:with-param name="condition" select="empty(name)"/>
         <xsl:with-param name="msg" expand-text="true">
            <mx:gi>{ name() }</mx:gi> requires <mx:gi>name</mx:gi>.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="notice">
         <xsl:with-param name="cf">gix.329</xsl:with-param>
         <xsl:with-param name="cat">required contents</xsl:with-param>
         <xsl:with-param name="testing" as="xs:string">empty(address)</xsl:with-param>
         <xsl:with-param name="condition" select="empty(address)"/>
         <xsl:with-param name="msg" expand-text="true">
            <mx:gi>{ name() }</mx:gi> requires <mx:gi>address</mx:gi>.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="notice">
         <xsl:with-param name="cf">gix.329</xsl:with-param>
         <xsl:with-param name="cat">required contents</xsl:with-param>
         <xsl:with-param name="testing" as="xs:string">empty(website)</xsl:with-param>
         <xsl:with-param name="condition" select="empty(website)"/>
         <xsl:with-param name="msg" expand-text="true">
            <mx:gi>{ name() }</mx:gi> requires <mx:gi>website</mx:gi>.</xsl:with-param>
      </xsl:call-template>
   </xsl:template>
   <xsl:template name="require-for-vendor_..._id-flag"/>
   <xsl:template name="require-for-vendor_..._name-field"/>
   <xsl:template name="require-for-vendor_..._address-field"/>
   <xsl:template name="require-for-vendor_..._website-field">
      <xsl:call-template name="check-uri-datatype"/>
   </xsl:template>
   <xsl:template name="require-for-product-name-field"/>
   <xsl:template name="require-for-computer-assembly">
      <xsl:call-template name="notice">
         <xsl:with-param name="cf">gix.422</xsl:with-param>
         <xsl:with-param name="cat">required flag</xsl:with-param>
         <xsl:with-param name="testing" as="xs:string">empty(@id)</xsl:with-param>
         <xsl:with-param name="condition" select="empty(@id)"/>
         <xsl:with-param name="msg" expand-text="true">
            <mx:gi>{ name() }</mx:gi> requires <mx:gi>@id</mx:gi>.</xsl:with-param>
      </xsl:call-template>
   </xsl:template>
   <xsl:template name="require-for-computer_..._id-flag"/>
   <xsl:template name="require-for-computer_..._motherboard-assembly">
      <xsl:call-template name="notice">
         <xsl:with-param name="cf">gix.329</xsl:with-param>
         <xsl:with-param name="cat">required contents</xsl:with-param>
         <xsl:with-param name="testing" as="xs:string">empty(type)</xsl:with-param>
         <xsl:with-param name="condition" select="empty(type)"/>
         <xsl:with-param name="msg" expand-text="true">
            <mx:gi>{ name() }</mx:gi> requires <mx:gi>type</mx:gi>.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="notice">
         <xsl:with-param name="cf">gix.329</xsl:with-param>
         <xsl:with-param name="cat">required contents</xsl:with-param>
         <xsl:with-param name="testing" as="xs:string">empty(memory)</xsl:with-param>
         <xsl:with-param name="condition" select="empty(memory)"/>
         <xsl:with-param name="msg" expand-text="true">
            <mx:gi>{ name() }</mx:gi> requires <mx:gi>memory</mx:gi>.</xsl:with-param>
      </xsl:call-template>
   </xsl:template>
   <xsl:template name="require-for-computer_..._motherboard_..._type-field"/>
   <xsl:template name="require-for-computer_..._motherboard_..._cpu-assembly">
      <xsl:call-template name="notice">
         <xsl:with-param name="cf">gix.329</xsl:with-param>
         <xsl:with-param name="cat">required contents</xsl:with-param>
         <xsl:with-param name="testing" as="xs:string">empty(product-name)</xsl:with-param>
         <xsl:with-param name="condition" select="empty(product-name)"/>
         <xsl:with-param name="msg" expand-text="true">
            <mx:gi>{ name() }</mx:gi> requires <mx:gi>product-name</mx:gi>.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="notice">
         <xsl:with-param name="cf">gix.329</xsl:with-param>
         <xsl:with-param name="cat">required contents</xsl:with-param>
         <xsl:with-param name="testing" as="xs:string">empty(architecture)</xsl:with-param>
         <xsl:with-param name="condition" select="empty(architecture)"/>
         <xsl:with-param name="msg" expand-text="true">
            <mx:gi>{ name() }</mx:gi> requires <mx:gi>architecture</mx:gi>.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="notice">
         <xsl:with-param name="cf">gix.329</xsl:with-param>
         <xsl:with-param name="cat">required contents</xsl:with-param>
         <xsl:with-param name="testing" as="xs:string">empty(speed)</xsl:with-param>
         <xsl:with-param name="condition" select="empty(speed)"/>
         <xsl:with-param name="msg" expand-text="true">
            <mx:gi>{ name() }</mx:gi> requires <mx:gi>speed</mx:gi>.</xsl:with-param>
      </xsl:call-template>
   </xsl:template>
   <xsl:template name="require-for-computer_..._motherboard_..._cpu_..._architecture-field"/>
   <xsl:template name="require-for-computer_..._motherboard_..._cpu_..._speed-field"/>
   <xsl:template name="require-for-computer_..._motherboard_..._ata-socket-assembly">
      <xsl:call-template name="notice">
         <xsl:with-param name="cf">gix.329</xsl:with-param>
         <xsl:with-param name="cat">required contents</xsl:with-param>
         <xsl:with-param name="testing" as="xs:string">empty(product-name)</xsl:with-param>
         <xsl:with-param name="condition" select="empty(product-name)"/>
         <xsl:with-param name="msg" expand-text="true">
            <mx:gi>{ name() }</mx:gi> requires <mx:gi>product-name</mx:gi>.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="notice">
         <xsl:with-param name="cf">gix.329</xsl:with-param>
         <xsl:with-param name="cat">required contents</xsl:with-param>
         <xsl:with-param name="testing" as="xs:string">empty(type)</xsl:with-param>
         <xsl:with-param name="condition" select="empty(type)"/>
         <xsl:with-param name="msg" expand-text="true">
            <mx:gi>{ name() }</mx:gi> requires <mx:gi>type</mx:gi>.</xsl:with-param>
      </xsl:call-template>
   </xsl:template>
   <xsl:template name="require-for-computer_..._motherboard_..._ata-socket_..._type-field"/>
   <xsl:template name="require-for-computer_..._motherboard_..._memory-assembly">
      <xsl:call-template name="notice">
         <xsl:with-param name="cf">gix.329</xsl:with-param>
         <xsl:with-param name="cat">required contents</xsl:with-param>
         <xsl:with-param name="testing" as="xs:string">empty(product-name)</xsl:with-param>
         <xsl:with-param name="condition" select="empty(product-name)"/>
         <xsl:with-param name="msg" expand-text="true">
            <mx:gi>{ name() }</mx:gi> requires <mx:gi>product-name</mx:gi>.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="notice">
         <xsl:with-param name="cf">gix.329</xsl:with-param>
         <xsl:with-param name="cat">required contents</xsl:with-param>
         <xsl:with-param name="testing" as="xs:string">empty(byte-size)</xsl:with-param>
         <xsl:with-param name="condition" select="empty(byte-size)"/>
         <xsl:with-param name="msg" expand-text="true">
            <mx:gi>{ name() }</mx:gi> requires <mx:gi>byte-size</mx:gi>.</xsl:with-param>
      </xsl:call-template>
   </xsl:template>
   <xsl:template name="require-for-computer_..._motherboard_..._memory_..._byte-size-field">
      <xsl:call-template name="check-positive-integer-datatype"/>
   </xsl:template>
   <xsl:template name="require-for-computer_..._motherboard_..._expansion-card-assembly">
      <xsl:call-template name="notice">
         <xsl:with-param name="cf">gix.329</xsl:with-param>
         <xsl:with-param name="cat">required contents</xsl:with-param>
         <xsl:with-param name="testing" as="xs:string">empty(product-name)</xsl:with-param>
         <xsl:with-param name="condition" select="empty(product-name)"/>
         <xsl:with-param name="msg" expand-text="true">
            <mx:gi>{ name() }</mx:gi> requires <mx:gi>product-name</mx:gi>.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="notice">
         <xsl:with-param name="cf">gix.329</xsl:with-param>
         <xsl:with-param name="cat">required contents</xsl:with-param>
         <xsl:with-param name="testing" as="xs:string">empty(type)</xsl:with-param>
         <xsl:with-param name="condition" select="empty(type)"/>
         <xsl:with-param name="msg" expand-text="true">
            <mx:gi>{ name() }</mx:gi> requires <mx:gi>type</mx:gi>.</xsl:with-param>
      </xsl:call-template>
   </xsl:template>
   <xsl:template name="require-for-computer_..._motherboard_..._expansion-card_..._type-field"/>
   <!-- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -->
   <!-- -#- -#- -#- -#- -#- -#- -#- -#- -#- -#- -#- -#- -#- -#- -#- -#- -#- -#- -#- -#- -#- -#- -#- -#- -->
   <!--     Datatypes - a named template for each occurring -->
   <!-- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -->
   <xsl:template name="check-string-datatype">
      <xsl:call-template name="notice">
         <xsl:with-param name="cat">datatype</xsl:with-param>
         <xsl:with-param name="testing" as="xs:string">not( mx:datatype-validate(.,'string') )</xsl:with-param>
         <xsl:with-param name="condition" select="not( mx:datatype-validate(.,'string') )"/>
         <xsl:with-param name="msg" expand-text="true">
            <mx:gi>{ name() }</mx:gi> does not conform to <em>string</em> datatype.</xsl:with-param>
      </xsl:call-template>
   </xsl:template>
   <xsl:template name="check-uri-datatype">
      <xsl:call-template name="notice">
         <xsl:with-param name="cat">datatype</xsl:with-param>
         <xsl:with-param name="testing" as="xs:string">not( mx:datatype-validate(.,'uri') )</xsl:with-param>
         <xsl:with-param name="condition" select="not( mx:datatype-validate(.,'uri') )"/>
         <xsl:with-param name="msg" expand-text="true">
            <mx:gi>{ name() }</mx:gi> does not conform to <em>uri</em> datatype.</xsl:with-param>
      </xsl:call-template>
   </xsl:template>
   <xsl:template name="check-positive-integer-datatype">
      <xsl:call-template name="notice">
         <xsl:with-param name="cat">datatype</xsl:with-param>
         <xsl:with-param name="testing" as="xs:string">not( mx:datatype-validate(.,'positive-integer') )</xsl:with-param>
         <xsl:with-param name="condition"
                         select="not( mx:datatype-validate(.,'positive-integer') )"/>
         <xsl:with-param name="msg" expand-text="true">
            <mx:gi>{ name() }</mx:gi> does not conform to <em>positive-integer</em> datatype.</xsl:with-param>
      </xsl:call-template>
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
   <xsl:template match="p | li | h1 | h2 | h3 | h4 | h5 | h6"
                 mode="validate-markup-multiline">
      <xsl:apply-templates mode="validate-markup-multiline" select="@*"/>
      <xsl:apply-templates mode="validate-markup-line"/>
   </xsl:template>
   <xsl:template match="a | em | i | strong | b | u | q | code | img | insert"
                 mode="validate-markup-line">
      <xsl:apply-templates mode="validate-markup-line" select="@*"/>
      <xsl:apply-templates mode="validate-markup-line"/>
   </xsl:template>
   <xsl:template match="a/@href | img/@src | img/@title | insert/@type | insert/@id-ref"
                 mode="validate-markup-line"/>
   <xsl:template match="p/text() | li/text() | h1/text() | h2/text() | h3/text() | h4/text() | h5/text() | h6/text()"
                 mode="test"/>
   <xsl:template match="em/text() | i/text() | strong/text() | b/text() | u/text() | q/text() | code/text() | a/text()"
                 mode="test"/>
</xsl:transform>
