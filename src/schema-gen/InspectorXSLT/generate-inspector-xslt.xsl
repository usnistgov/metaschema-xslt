<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:XSLT="http://www.w3.org/1999/XSL/Transform/alias"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:mx="http://csrc.nist.gov/ns/csd/metaschema-xslt"
  xpath-default-namespace="http://csrc.nist.gov/ns/oscal/metaschema/1.0"
  xmlns="http://www.w3.org/1999/xhtml"
  version="3.0">
  
  <!-- For extra integrity run Schematron inspector-generator-checkup.sch on this XSLT. -->
  
  <xsl:output indent="yes" encoding="us-ascii"/><!-- pushing out upper ASCII using entity notation -->
  
  <!-- Maintaining the boilerplate out of line makes it easier to test and lint. -->
  <xsl:variable name="XSLT-template" as="document-node()"
    select="document('apply-validator.xsl')"/>
  
  <xsl:namespace-alias stylesheet-prefix="XSLT" result-prefix="xsl"/>
  
  <xsl:template match="/*">
    <XSLT:transform  version="3.0" xpath-default-namespace="{ /METASCHEMA/namespace }" exclude-result-prefixes="#all">
      
      <xsl:comment expand-text="true"> Generated { current-dateTime() } </xsl:comment>

      <XSLT:mode on-no-match="fail"/>
      
      <XSLT:mode name="test" on-no-match="shallow-skip"/>
      
      
      <xsl:call-template name="comment-xsl">
        <xsl:with-param name="head">Templates copied from boilerplate</xsl:with-param>
      </xsl:call-template>
      
      <xsl:copy-of select="$XSLT-template/*/(child::* | child::comment())"/>

      <XSLT:template mode="metaschema-metadata" match="*">
         <mx:metaschema version="{/*/schema-version}" shortname="{/*/short-name}" namespace="{/*/namespace}">
            <xsl:text expand-text="true">{ /*/schema-name }</xsl:text>
         </mx:metaschema>
      </XSLT:template>
       
      <xsl:call-template name="comment-xsl">
        <xsl:with-param name="head">Generated rules - first, any roots</xsl:with-param>
      </xsl:call-template>
      
      <xsl:call-template name="comment-xsl">
        <xsl:with-param name="head"> Root </xsl:with-param>
      </xsl:call-template>
      <xsl:apply-templates select="define-assembly[exists(root-name)]" mode="require-of"/>
      
      <xsl:call-template name="comment-xsl">
        <xsl:with-param name="head"> Occurrences - templates in mode 'test' </xsl:with-param>
      </xsl:call-template>
      <!-- assembly references -->
      <xsl:apply-templates select="//assembly" mode="require-of"/>
      <!-- inline assembly definitions (i.e. references to themselves) -->
      <xsl:apply-templates select="//model//define-assembly" mode="require-of"/>
      <!-- field references -->
      <xsl:apply-templates select="//field" mode="require-of"/>
      <!-- inline field definitions (i.e. references to themselves) -->
      <xsl:apply-templates select="//model//define-field" mode="require-of"/>
      <!-- flag references -->
      <xsl:apply-templates select="//flag" mode="require-of"/>
      <!-- inline flag definitions (i.e. references to themselves) -->
      <xsl:apply-templates select="/*/define-assembly//define-flag | /*/define-field//define-flag" mode="require-of"/>
      
      <!-- We provide fallbacks for known elements matched out of context, to provide for errors when they appear out of place. -->
      <xsl:call-template name="comment-xsl">
        <xsl:with-param name="head"> Fallbacks for occurrences of known elements and attributes, except out of context </xsl:with-param>
      </xsl:call-template>
      
      <xsl:variable name="known-elements"   select="(/*/*/root-name/parent::define-assembly | //model//define-assembly | //model//define-field | //assembly | //field)[not(@in-xml='UNWRAPPED')]/mx:use-name(.) => distinct-values()" />
      <XSLT:template mode="test" match="{ $known-elements => string-join(' | ') }">
        <XSLT:call-template name="notice">
          <XSLT:with-param name="cf" as="xs:string">gix.76</XSLT:with-param>
          <XSLT:with-param name="class">EOOP element-out-of-place</XSLT:with-param>
          <XSLT:with-param name="msg" expand-text="true"><mx:gi>{ name() }</mx:gi> is not permitted here.</XSLT:with-param>
        </XSLT:call-template>
      </XSLT:template>
      <xsl:variable name="known-attributes" select="((//flag | //define-assembly/define-flag | define-field/define-flag)/mx:use-name(.) => distinct-values()) ! ('@' || .)" />
      <XSLT:template mode="test" match="{ $known-attributes => string-join(' | ') }">
        <XSLT:call-template name="notice">
          <XSLT:with-param name="cf" as="xs:string">gix.84</XSLT:with-param>
          <XSLT:with-param name="class">AOOP attribute-out-of-place</XSLT:with-param>
          <XSLT:with-param name="msg" expand-text="true"><mx:gi>@{ name() }</mx:gi> is not permitted here.</XSLT:with-param>
        </XSLT:call-template>
      </XSLT:template>
      
      <xsl:call-template name="comment-xsl">
        <xsl:with-param name="head"> Definitions - a named template for each </xsl:with-param>
      </xsl:call-template>
      <xsl:apply-templates select="//define-assembly | //define-field | //define-flag" mode="require-for"/>
      
      <xsl:call-template name="comment-xsl">
        <xsl:with-param name="head"> Datatypes - a named template for each occurring </xsl:with-param>
      </xsl:call-template>
      
       <xsl:variable name="used-types" select="('string', //@as-type/string(.), //constraint/matches/@datatype/string(.) )[not(.= ('markup-line','markup-multiline') )] => distinct-values()"/>
      <xsl:iterate select="$used-types" expand-text="true">
        <xsl:variable name="this-type" select="."/>
        <xsl:variable name="simpleType-name" select="$type-map[@as-type=$this-type]/string(.)"/>
        <XSLT:template name="check-{ . }-datatype">
          <xsl:variable name="test" as="xs:string?" expand-text="true">
            <xsl:apply-templates select="key('simpleType-by-name',$simpleType-name,$type-definitions)" mode="datatype-test">
              <xsl:with-param name="as-type-name" select="$this-type"/>
            </xsl:apply-templates>  
          </xsl:variable>
          <XSLT:call-template name="notice">
            <XSLT:with-param name="cf" as="xs:string">gix.110</XSLT:with-param>
            <XSLT:with-param name="class">VDSX violates-datatype-syntax</XSLT:with-param>
            <XSLT:with-param name="testing" as="xs:string">not( {$test} )</XSLT:with-param>
            <XSLT:with-param name="condition" select="not({$test})"/>
            <XSLT:with-param name="msg" expand-text="true"><mx:gi>{{ name(.) }}</mx:gi> <mx:code>{{ string(.) }}</mx:code> does not conform to <mx:code>{ $this-type }</mx:code> datatype.</XSLT:with-param>
          </XSLT:call-template>
        </XSLT:template>
      </xsl:iterate>
      
      <!--
        These are generated instead of copied so that matching on LREs works with the target namespace Can these be copied not generated?
        ('Finally we have to generate these - instead of keeping them in the static host file - so they will match namespaces.') -->
      <XSLT:template match="ul | ol" mode="validate-markup-multiline">
        <XSLT:apply-templates select="li" mode="validate-markup-multiline"/>
        <XSLT:for-each select="* except li">
          <!-- 'notice-multiline' is in the calling XSLT -->
          <XSLT:call-template name="notice-multiline"/>
        </XSLT:for-each>
      </XSLT:template>
      
      <XSLT:template match="table" mode="validate-markup-multiline">
        <XSLT:apply-templates select="tr" mode="validate-markup-multiline"/>
        <XSLT:for-each select="* except tr">
          <XSLT:call-template name="notice-multiline"/>
        </XSLT:for-each>
      </XSLT:template>
      
      <XSLT:template match="tr" mode="validate-markup-multiline">
        <XSLT:apply-templates select="td" mode="validate-markup-multiline"/>
        <XSLT:for-each select="* except td">
          <XSLT:call-template name="notice-multiline"/>
        </XSLT:for-each>
      </XSLT:template>
      
      <XSLT:template match="p | li | h1 | h2 | h3 | h4 | h5 | h6" mode="validate-markup-multiline">
        <XSLT:apply-templates mode="validate-markup-multiline" select="@*"/>
        <XSLT:apply-templates mode="validate-markup-line"/>
      </XSLT:template>
      
      <XSLT:template match="a | em | i | strong | b | u | q | code | img | insert" mode="validate-markup-line">
        <XSLT:apply-templates mode="validate-markup-line" select="@*"/>
        <XSLT:apply-templates mode="validate-markup-line"/>
      </XSLT:template>
      
      <XSLT:template match="a/@href | img/@src | img/@title | insert/@type | insert/@id-ref" mode="validate-markup-line"/>
      
      <XSLT:template match="p/text() | li/text() | h1/text() | h2/text() | h3/text() | h4/text() | h5/text() | h6/text()"   mode="test"/>
      <XSLT:template match="em/text() | i/text() | strong/text() | b/text() | u/text() | q/text() | code/text() | a/text()" mode="test"/>
      
      
    </XSLT:transform>
  </xsl:template>
  
  <xsl:key name="simpleType-by-name" match="xs:simpleType" use="@name"/>
  
  <xsl:template match="/*/*" priority="0.25"/>
  
<!-- Assuming composed Metaschema input with disambiguated keys -->
  <xsl:key name="assembly-definitions" match="/METASCHEMA/define-assembly" use="@_key-name"/>
  <xsl:key name="field-definitions"    match="/METASCHEMA/define-field"    use="@_key-name"/>
  <xsl:key name="flag-definitions"     match="/METASCHEMA/define-flag"     use="@_key-name"/>
  
  <xsl:key name="flag-references"     match="flag"     use="@_key-ref"/>
  <xsl:key name="field-references"    match="field"    use="@_key-ref"/>
  <xsl:key name="assembly-references" match="assembly" use="@_key-ref"/>
  
  <xsl:key name="using-name" match="flag | field | assembly | define-flag | define-field | define-assembly" use="mx:use-name(.)"/>
  
  <!-- 'require-of' mode encapsulates tests on any occurrence of any node, as represented by its reference or inline definition -->
  
  <xsl:template mode="require-of" match="define-assembly[exists(root-name)]" expand-text="true">
    <xsl:variable name="matching" select="mx:use-name(.)"/>
    <XSLT:template match="/{ $matching }" mode="test">
      <!-- nothing to test for cardinality or order -->

      <XSLT:apply-templates select="@*" mode="test"/>
      <XSLT:call-template name="require-for-{ mx:definition-name(.) }-assembly"/>
      
    </XSLT:template>
  </xsl:template>
  
<!-- nothing required for unwrapped fields... -->
  <xsl:template mode="require-of" priority="10"
    match="field[@in-xml='UNWRAPPED'] | model//define-field[@in-xml='UNWRAPPED']"/>
    
  
  <xsl:template mode="require-of" expand-text="true"
    match="assembly | model//define-assembly | field | model//define-field">
    <xsl:variable name="metaschema-type" select="if (ends-with(local-name(),'assembly')) then 'assembly' else 'field'"/>
    <xsl:variable name="using-name" select="mx:match-name(.)"/>
    
    <!-- matches(.,'\S') filters out matches that come back empty for assemblies never called -->
    <xsl:variable name="matches" select="( mx:contextualized-matches(ancestor::define-assembly[1]) ! ( . || '/' || $using-name ))[matches(.,'\S')]"/>
    
    <xsl:if test="some $m in ($matches) satisfies matches($m,'\S')">
      <xsl:for-each select="self::field | self::define-field">
        <XSLT:template match="{ ($matches ! (. || '/text()') )  => string-join(' | ') }" mode="test"/>
      </xsl:for-each>

      <!-- test ordering with respect to parent when grouped   -->
      <xsl:if test="group-as/@in-xml = 'GROUPED'">
        <XSLT:template match="{ $matches ! replace(.,'/[^/]*$','') }" mode="test">
          <xsl:call-template name="test-order"/>
        </XSLT:template>
      </xsl:if>

      <XSLT:template priority="5" match="{ $matches => string-join(' | ') }" mode="test">
        <XSLT:apply-templates select="@*" mode="test"/>
        <!-- 'test-occurrence' template produces only tests needed to check this occurrence -->
        <xsl:call-template name="test-occurrence">
          <xsl:with-param name="using-name" select="$using-name"/>
        </xsl:call-template>
        <!-- while the containment, modeling or datatyping rule is held in a template for the applicable definition -->
        <XSLT:call-template name="require-for-{ mx:definition-name(.) }-{ $metaschema-type }">
          <!--<xsl:if test="exists(use-name)">
          <XSLT:with-param as="xs:string" tunnel="true" name="matching">{ $using-name }</XSLT:with-param>
        </xsl:if>-->
        </XSLT:call-template>
      </XSLT:template>
    </xsl:if>
  </xsl:template>
  <!--</xsl:template>-->

  <xsl:template mode="require-of" expand-text="true"
    match="flag | /*/define-field/define-flag | /*/define-assembly//define-flag">
    <xsl:variable name="using-name" select="mx:use-name(.)"/>
    <xsl:variable name="parentage" select="(ancestor::define-field[1] | ancestor::define-assembly[1])/mx:contextualized-matches(.)"/>
    <!-- guarding against making broken templates for definitions never used (hence no parentage) -->
    <xsl:if test="exists($parentage)">
    <XSLT:template match="{ ( $parentage[matches(.,'\S')] ! (. || '/@' || $using-name) ) => string-join(' | ') }" mode="test">
      <!-- no occurrence testing for flags -->
      <!-- datatyping rule -->
      <XSLT:call-template name="require-for-{ mx:definition-name(.) }-flag">
        <!--<xsl:if test="exists(use-name)">
          <XSLT:with-param as="xs:string" tunnel="true" name="matching">{ $using-name }</XSLT:with-param>
        </xsl:if>-->
      </XSLT:call-template>
    </XSLT:template>
    </xsl:if>
  </xsl:template>
  
  <xsl:template name="test-occurrence" expand-text="true">
    <xsl:param name="using-name" required="true"/>
    <!-- test for cardinality -->
    <xsl:if test="number(@min-occurs) gt 1">
      <xsl:variable name="min" select="(@min-occurs, 1)[1]"/>
      <xsl:variable name="test" as="xs:string">empty(following-sibling::{$using-name}) and (count(. | preceding-sibling::{$using-name}) lt {$min})</xsl:variable>
      <!--empty(following-sibling::fan) and (count(. | preceding-sibling::fan) lt 2)-->
      <XSLT:call-template name="notice">
        <XSLT:with-param name="cf">gix.259</XSLT:with-param>
        <XSLT:with-param name="class">EATI element-appears-too-infrequently</XSLT:with-param>
        <XSLT:with-param name="testing" as="xs:string">{$test}</XSLT:with-param>
        <XSLT:with-param name="condition" select="{$test}"/>
        <XSLT:with-param name="msg"><mx:gi>{ mx:use-name(.) }</mx:gi> appears too few times: { $min } minimum are required.</XSLT:with-param>
      </XSLT:call-template>
    </xsl:if>
    <xsl:if test="not(@max-occurs = 'unbounded')">
      <xsl:variable name="max" select="(@max-occurs ! number(), 1)[1]"/>
      <xsl:variable name="test" as="xs:string">count(. | preceding-sibling::{$using-name}) gt {$max}</xsl:variable>
      <XSLT:call-template name="notice">
        <XSLT:with-param name="cf">gix.270</XSLT:with-param>
        <XSLT:with-param name="class">EATO element-appears-too-often</XSLT:with-param>
        <XSLT:with-param name="testing" as="xs:string">{$test}</XSLT:with-param>
        <XSLT:with-param name="condition" select="{$test}"/>
        <XSLT:with-param name="msg"><mx:gi>{ mx:use-name(.) }</mx:gi> appears too many times: { $max } maximum { if ($max eq 1) then 'is' else 'are' } permitted.</XSLT:with-param>
      </XSLT:call-template>
    </xsl:if>
    
    <xsl:if test="exists(parent::choice)"><!-- opting to be a little noisy - reporting for all exclusive choices given -->
      <xsl:variable name="alternatives" select="(parent::choice/child::* except .)"/>
      <xsl:variable name="test" as="xs:string">empty(preceding-sibling::{$using-name}) and exists(../({ ($alternatives ! mx:use-name(.)) => string-join(' | ') }))</xsl:variable>
      <XSLT:call-template name="notice">
        <XSLT:with-param name="cf">gix.282</XSLT:with-param>
        <XSLT:with-param name="testing" as="xs:string">{$test}</XSLT:with-param>
        <XSLT:with-param name="condition" select="{$test}"/>
        <XSLT:with-param name="class">VEXC violates-exclusive-choice</XSLT:with-param>
        <XSLT:with-param name="msg">
            <mx:gi>{ mx:use-name(.) }</mx:gi>
            <xsl:text> is unexpected along with </xsl:text> 
            <xsl:call-template name="punctuate-or-code-sequence">
              <xsl:with-param name="items" select="$alternatives"/>
            </xsl:call-template>
            <xsl:text>.</xsl:text>
          </XSLT:with-param>
        </XSLT:call-template>
      </xsl:if>
  
    <xsl:if test="not(group-as/@in-xml='GROUPED')">
      <xsl:call-template name="test-order"/>
    </xsl:if>
  </xsl:template>
  
  <xsl:template name="test-order">    
    <xsl:variable name="followers"
      select="(following-sibling::field | following-sibling::assembly |
        following-sibling::define-field | following-sibling::define-assembly | following-sibling::choice/child::*) except (parent::choice/*)"/>
    <xsl:if test="exists($followers)" expand-text="true">
      <!--<XSLT:variable name="interlopers" select="{ ($followers ! mx:use-name(.)) ! ('preceding-sibling::' || .) => string-join(' | ') }"/>-->
      <xsl:variable name="test" as="xs:string">exists( { ($followers ! mx:match-name(.)) ! ('preceding-sibling::' || .) => string-join(' | ') } )</xsl:variable>
      <XSLT:call-template name="notice">
        <XSLT:with-param name="cf">gix.310</XSLT:with-param>
        <XSLT:with-param name="class">EOOO element-out-of-order</XSLT:with-param>
        <XSLT:with-param name="testing" as="xs:string">{$test}</XSLT:with-param>
        <XSLT:with-param name="condition" select="{$test}"/>
        <XSLT:with-param name="msg">
          <mx:gi>{ mx:use-name(.) }</mx:gi>
          <xsl:text> is unexpected following </xsl:text>
          <xsl:call-template name="punctuate-or-code-sequence">
            <xsl:with-param name="items" select="$followers"/>
          </xsl:call-template>
          <xsl:text>.</xsl:text>
        </XSLT:with-param>
      </XSLT:call-template>
    </xsl:if>
  </xsl:template>
  
  <xsl:template name="punctuate-or-code-sequence">
    <xsl:param name="items"/>
    <xsl:for-each select="$items" expand-text="true">
      <xsl:call-template name="punctuate-or-item"/>
      <mx:gi>{ mx:match-name(.) }</mx:gi>
    </xsl:for-each>
  </xsl:template>
  
<!-- 'require-for' encapsulates tests on assembly, field or flag types as expressed per object: 
     - attribute requirements for assemblies and fields
     - content model requirements for assemblies
     - datatype requirements for fields (values) and flags -->
  
  <xsl:template mode="require-for" match="define-assembly" expand-text="true">
    <xsl:variable name="has-unwrapped-markup-multiline" as="xs:boolean"
      select="exists( (model/field | model/define-field | model/choice/field | model/choice/define-field)[@as-type='markup-multiline'][@in-xml='UNWRAPPED'] )"/>
    <XSLT:template name="require-for-{ mx:definition-name(.) }-assembly">
      <!--<XSLT:param tunnel="true" name="matching" as="xs:string">{ (use-name,root-name,@name)[1] }</XSLT:param>-->
      <xsl:call-template name="require-attributes"/>
      <!-- for each required element ... -->
      <!--<xsl:for-each select="model/(* | choice/*)[@min-occurs ! (number() ge 1)][not(@in-xml='UNWRAPPED')]" expand-text="true">
        <!-\- XXX extend $requiring here to produce choices for choice -\->
        <xsl:variable name="requiring" select="mx:match-name(.)"/>
        <xsl:variable name="test" as="xs:string">empty({$requiring})</xsl:variable>
        <XSLT:call-template name="notice">
          <XSLT:with-param name="cf">gix.337</XSLT:with-param>
          <XSLT:with-param name="class">required contents</XSLT:with-param>
          <XSLT:with-param name="testing" as="xs:string">{$test}</XSLT:with-param>
          <XSLT:with-param name="condition" select="{$test}"/>
          <XSLT:with-param name="msg" expand-text="true"><mx:gi>{{ name() }}</mx:gi> requires <mx:gi>{ $requiring }</mx:gi>.</XSLT:with-param>
        </XSLT:call-template>
      </xsl:for-each>-->
      <xsl:for-each select="model/*[@min-occurs ! (number() ge 1)][not(@in-xml='UNWRAPPED')] | model/choice[empty( *[@min-occurs ! (number() eq 0)] | *[@in-xml='UNWRAPPED'] )]" expand-text="true">
        <!-- XXX extend $requiring here to produce choices for choice -->
        <xsl:variable name="requiring">
          <xsl:choose>
            <xsl:when test="self::choice">
              <xsl:sequence  select="*[@min-occurs ! (number() ge 1)][not(@in-xml='UNWRAPPED')]/mx:match-name(.) => string-join('|')"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:sequence  select="mx:match-name(.)"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:variable>
        <xsl:variable name="test" as="xs:string">empty({$requiring})</xsl:variable>
        <XSLT:call-template name="notice">
          <XSLT:with-param name="cf">gix.372</XSLT:with-param>
          <XSLT:with-param name="class">MRQC missing-required-contents</XSLT:with-param>
          <XSLT:with-param name="testing" as="xs:string">{$test}</XSLT:with-param>
          <XSLT:with-param name="condition" select="{$test}"/>
          <XSLT:with-param name="msg" expand-text="true"><mx:gi>{{ name() }}</mx:gi> requires <mx:gi>{ $requiring }</mx:gi>.</XSLT:with-param>
        </XSLT:call-template>
      </xsl:for-each>
      <xsl:if test="$has-unwrapped-markup-multiline">
        <XSLT:apply-templates mode="validate-markup-multiline"/>
      </xsl:if>
       <xsl:apply-templates select="." mode="produce-constraint-tests"/>
    </XSLT:template>
    <xsl:if test="$has-unwrapped-markup-multiline">
      <xsl:variable name="matches" select="mx:contextualized-matches(.)" as="xs:string+"/>
      <xsl:variable name="children"
        select="model//(field | assembly | define-field | define-assembly)[not(@in-xml='UNWRAPPED')]/mx:match-name(.)"/>
      <xsl:variable name="matched-children" as="xs:string*">
        <xsl:for-each select="$children">
          <xsl:variable name="c" select="."/>
          <xsl:sequence select="$matches ! (. || '/' || $c)"/>
        </xsl:for-each>
      </xsl:variable>
      <xsl:if test="exists($matched-children)">
         <XSLT:template match="{ $matched-children => string-join(' | ') }" mode="validate-markup-multiline"/>
      </xsl:if>
      
      <xsl:variable name="matched-multiline" as="xs:string*">
        <xsl:for-each select="tokenize($markup-elements, ' \| ')">
          <xsl:variable name="e" select="."/>
          <xsl:for-each select="$matches" expand-text="true">{ . || '/' || $e }</xsl:for-each>
        </xsl:for-each>
      </xsl:variable>
      <XSLT:template match="{ $matched-multiline => string-join(' | ') }" mode="validate"/>
    </xsl:if>
  </xsl:template>
  
  <xsl:variable name="markup-elements" select="'p | ul | ol | table | pre | h1 | h2 | h3 | h4 | h5 | h6'"/>
  
  <xsl:template mode="require-for" match="define-field" expand-text="true">
    <!-- intercept markup descendants of these fields -->
    <xsl:if test="@as-type = ('markup-line','markup-multiline') and not(@in-xml='UNWRAPPED')">
      <xsl:variable name="mine" select="mx:contextualized-matches(.) ! (. || '/node()')"/>
      <XSLT:template match="{ $mine => string-join(' | ') }" priority="5" mode="validate">
        <!--<XSLT:apply-templates mode="value-only"/>-->
      </XSLT:template>
    </xsl:if>
    <xsl:call-template name="require-for-field"/>
  </xsl:template>
  
  <xsl:template mode="require-for" match="model//define-field" expand-text="true">
    <!-- intercept markup descendants of these fields -->
    <xsl:if test="@as-type = ('markup-line','markup-multiline') and not(@in-xml='UNWRAPPED')">
      <xsl:variable name="mine" select="mx:match-name(.) || '/node()'"/>
      <XSLT:template match="{ (ancestor::define-assembly[1]/mx:contextualized-matches(.) ! (. || '/' ||  $mine)) => string-join(' | ') }" priority="5" mode="validate">
        <!--<XSLT:apply-templates mode="value-only"/>-->
      </XSLT:template>
    </xsl:if>
    <xsl:call-template name="require-for-field"/>
  </xsl:template>
  
  <xsl:template name="require-for-field">
    <XSLT:template name="require-for-{ mx:definition-name(.) }-field">
      <!-- parameter is called by instructions in `require-attributes` logic -->
      <!--<XSLT:param tunnel="true" name="matching" as="xs:string">{ (use-name,@name)[1] }</XSLT:param>-->
      <xsl:call-template name="require-attributes"/>
      <xsl:for-each select="@as-type[. != 'string']">
        <XSLT:call-template name="check-{ . }-datatype"/>
      </xsl:for-each>
       <xsl:apply-templates select="." mode="produce-constraint-tests"/>
    </XSLT:template>
  </xsl:template>
  
<!-- For an inline or global definition, the name captures the ancestry;
     for references, the definition will be at the top level (only) -->
  <xsl:function name="mx:definition-name" as="xs:string">
    <xsl:param name="def" as="node()"/>
    <xsl:sequence select="($def/@ref/string(.), $def/(ancestor::define-assembly | ancestor::define-field | .)/@name => string-join('_..._'))[1]"/>
  </xsl:function>
  
  <xsl:template mode="require-for" match="define-flag" expand-text="true">
    <XSLT:template name="require-for-{ mx:definition-name(.) }-flag">
      <!--<XSLT:param tunnel="true" name="matching" as="xs:string">{ (use-name,@name)[1] }</XSLT:param>-->
      
      <xsl:for-each select="@as-type[. != 'string']">
        <XSLT:call-template name="check-{ . }-datatype"/>
      </xsl:for-each>
       <xsl:apply-templates select="." mode="produce-constraint-tests"/>
    </XSLT:template>
  </xsl:template>
  
  <xsl:template name="require-attributes">
    <!-- for each required attribute ... -->
    <xsl:for-each select="(flag | define-flag)[@required = 'yes']" expand-text="true">
      <xsl:variable name="requiring" select="mx:use-name(.)"/>
      <xsl:variable name="test" as="xs:string">empty(@{$requiring})</xsl:variable>
      <XSLT:call-template name="notice">
        <XSLT:with-param name="cf">gix.465</XSLT:with-param>
        <XSLT:with-param name="class">MRQA missing-required-attribute</XSLT:with-param>
        <XSLT:with-param name="testing" as="xs:string">{$test}</XSLT:with-param>
        <XSLT:with-param name="condition" select="{$test}"/>
        <XSLT:with-param name="msg" expand-text="true"><mx:gi>{{ name() }}</mx:gi> requires <mx:gi>@{ $requiring }</mx:gi>.</XSLT:with-param>
      </XSLT:call-template>
    </xsl:for-each>
  </xsl:template>
  
  <xsl:variable name="type-map" as="element()*">
<!-- maps from Metaschema datatype names to Metaschema XSD constructs
     cf https://pages.nist.gov/metaschema/specification/datatypes/ -->
    <type as-type="base64">Base64Datatype</type>
    <type as-type="boolean">BooleanDatatype</type>
    <type as-type="date">DateDatatype</type>
    <type as-type="date-time">DateTimeDatatype</type>
    <type as-type="date-time-with-timezone">DateTimeWithTimezoneDatatype</type>
    <type as-type="date-with-timezone">DateWithTimezoneDatatype</type>
    <type as-type="day-time-duration">DayTimeDurationDatatype</type>
    <type as-type="decimal">DecimalDatatype</type>
    <!-- Not supporting float or double -->
    <!--<xs:enumeration as-type="float">float</xs:enumeration> -->
    <!--<xs:enumeration as-type="double">double</xs:enumeration> -->
    <type as-type="email-address">EmailAddressDatatype</type>
    <type as-type="hostname">HostnameDatatype</type>
    <type as-type="integer">IntegerDatatype</type>
    <type as-type="ip-v4-address">IPV4AddressDatatype</type>
    <type as-type="ip-v6-address">IPV6AddressDatatype</type>
    <type as-type="non-negative-integer">NonNegativeIntegerDatatype</type>
    <type as-type="positive-integer">PositiveIntegerDatatype</type>
    <type as-type="string">StringDatatype</type>
    <type as-type="token">TokenDatatype</type>
    <type as-type="uri">URIDatatype</type>
    <type as-type="uri-reference">URIReferenceDatatype</type>
    <type as-type="uuid">UUIDDatatype</type>
    
    <!-- these old names are permitted for now, while only deprecated       -->
    <!--../../../schema/xml/metaschema.xsd line 1052 inside  /*/xs:simpleType[@name='SimpleDatatypesType']> -->
    <type prefer="base64" as-type="base64Binary">Base64Datatype</type>
    <type prefer="date-time" as-type="dateTime">DateTimeDatatype</type>
    <type prefer="date-time-with-timezone" as-type="dateTime-with-timezone">DateTimeWithTimezoneDatatype</type>
    <type prefer="email-address" as-type="email">EmailAddressDatatype</type>
    <type prefer="non-negative-integer" as-type="nonNegativeInteger">NonNegativeIntegerDatatype</type>
    <type prefer="positive-integer" as-type="positiveInteger">PositiveIntegerDatatype</type>
  </xsl:variable>
  
  
  <xsl:variable name="metaschema-repository" as="xs:string">../../../support/metaschema</xsl:variable>
  
  <xsl:variable name="atomictype-modules" as="element()*" expand-text="true">
    <module>{$metaschema-repository}/schema/xml/metaschema-datatypes.xsd</module>
  </xsl:variable>
  
  <xsl:variable name="type-definitions" select="document($atomictype-modules)"/>
  
  
  
  <xsl:mode name="datatype-test" on-no-match="shallow-skip"/>
  
  <xsl:template match="*" mode="datatype-test" as="xs:string?"/>
  
  <xsl:template match="xs:simpleType" mode="datatype-test" as="xs:string?">
    <xsl:param name="as-type-name" as="xs:string" required="true"/>
    <xsl:text expand-text="true">string(.) castable as {(xs:restriction/@base,@name)[1]}</xsl:text>
  </xsl:template>
  
  <xsl:template match="xs:simpleType[xs:restriction]" mode="datatype-test" as="xs:string?">
    <xsl:param name="as-type-name" as="xs:string" required="true"/>
    <xsl:variable name="extra">
      <xsl:apply-templates mode="#current"/>
    </xsl:variable>
    <xsl:text expand-text="true">string(.) castable as {(xs:restriction/@base,@name)[1]}{ $extra[normalize-space(.)] ! (' and ' || .)}</xsl:text>
  </xsl:template>
  
  
  <xsl:template match="xs:restriction" mode="datatype-test" as="xs:string?">
    <xsl:apply-templates mode="#current"/>
  </xsl:template>
  
  <xsl:template match="xs:pattern" mode="datatype-test" as="xs:string?">
    <xsl:text expand-text="true">matches(.,'^{@value}$')</xsl:text>
  </xsl:template>
  
  
  <xsl:mode name="produce-constraint-tests" on-no-match="shallow-copy" on-multiple-match="fail"/>
   <!--
   this mode is called to produce constraint tests in two contexts -
     o for constraints with target="." or no target, a test is produced on the named template for that object definition
     o for constraints with designated targets, a separate template is produced to match the targeted nodes in a separate mode to be called from mode='test' on each node through traversal-->
   
   <xsl:template match="define-assembly | define-field | define-flag" mode="produce-constraint-tests">
      <xsl:apply-templates select="constraint" mode="#current"/>
   </xsl:template>
      
  <xsl:template match="*" mode="produce-constraint-tests">
     <xsl:message expand-text="true">matching { name() } for constraint testing</xsl:message>
     <xsl:apply-templates mode="#current"/>
  </xsl:template>
   
   <xsl:template match="constraint" mode="produce-constraint-tests">
      <!-- build out constraint types allowed-values matches expect index-has-key-->
      <xsl:apply-templates select="allowed-values[not(@target != '.')] | matches[not(@target != '.')] " mode="produce-constraint-tests"/> 
   </xsl:template>
  
   <xsl:template match="allowed-values" mode="produce-constraint-tests" expand-text="true">
      <xsl:param name="values" select="enum/@value"/>
      <xsl:variable name="value-sequence" select="($values ! ('''' || . || '''')) => string-join(', ')"/>
      <xsl:variable name="test" as="xs:string" expand-text="true">. = ( {$value-sequence} )</xsl:variable><!-- test is not type-safe -->
      <xsl:variable name="allowing-others" select="@allow-other='yes'"/>      
      <XSLT:call-template name="notice">
         <XSLT:with-param name="cf">gix.572</XSLT:with-param>
         <XSLT:with-param name="class">AVCV value-not-allowed</XSLT:with-param>
         <XSLT:with-param name="testing" as="xs:string">not( {$test} )</XSLT:with-param>
         <XSLT:with-param name="condition" select="not({$test})"/>
         <XSLT:with-param name="msg" expand-text="true"><mx:code>{{ string(.) }}</mx:code> does not appear among permitted (enumerated) values for <mx:gi>{{ name() }}</mx:gi>: <mx:code>(<xsl:value-of select="$values => string-join('|')"/>)</mx:code>.</XSLT:with-param>
         <XSLT:with-param name="level" select="'{ (@level,'warning'[$allowing-others],'error')[1] }'"/>
      </XSLT:call-template>
   </xsl:template>
  
   <xsl:template match="matches" mode="produce-constraint-tests">    
      <xsl:apply-templates mode="#current" select="@regex | @datatype"/>
   </xsl:template>
   
   <xsl:template match="matches/@datatype" mode="produce-constraint-tests">
      <XSLT:call-template name="check-{ . }-datatype"/>
   </xsl:template>
   
   <xsl:template match="matches/@regex" mode="produce-constraint-tests">
      <xsl:variable name="test" expand-text="true">matches(., '^{.}$')</xsl:variable>
      <XSLT:call-template name="notice">
         <XSLT:with-param name="cf">gix.572</XSLT:with-param>
         <XSLT:with-param name="class">MRCV regex-match-fail</XSLT:with-param>
         <XSLT:with-param name="testing" as="xs:string">not( {$test} )</XSLT:with-param>
         <XSLT:with-param name="condition" select="not({$test})"/>
         <XSLT:with-param name="msg" expand-text="true"><mx:code>{ string(.) }</mx:code> does not match the regular expression defined for this <mx:gi>{ name() }</mx:gi>: <mx:code>(<xsl:value-of select="."/>)</mx:code>.</XSLT:with-param>
      </XSLT:call-template>
   </xsl:template>
   
   <!--name="check-{ . }-datatype"-->
   
  <xsl:function name="mx:or" as="xs:string">
    <xsl:param name="items" as="item()*"/>
     <xsl:value-of>
        <xsl:iterate select="$items">
           <xsl:call-template name="punctuate-or-item"/>
           <xsl:sequence select="."/>
        </xsl:iterate>
     </xsl:value-of>
  </xsl:function>
  
  <xsl:template name="punctuate-or-item">
    <xsl:variable name="among-more-than-two" select="last() gt 2"/>
    <xsl:variable name="comes-last" select="position() = last()"/>
    <xsl:if test="position() gt 1">
      <xsl:if test="$among-more-than-two">,</xsl:if>
      <xsl:text> </xsl:text>
      <xsl:if test="$comes-last">or </xsl:if>
    </xsl:if>
  </xsl:template>
  
  <xsl:function name="mx:tag" as="element()" expand-text="true">
    <xsl:param name="n" as="xs:string"/>
    <mx:gi>{ $n }</mx:gi>
  </xsl:function>
  
<!-- contextualized match name resolves assembly field and flag
     definitions to their names in context (including parents) whereever referenced -->
  <xsl:function name="mx:contextualized-matches" as="xs:string*">
    <xsl:param name="who" as="element()"/>
    <!-- for a reference, return the use-name and the use-name of the parent   -->
    <!-- for an inline definition, the same   -->
    <!-- for a global definition, find its points of reference -->
    <xsl:variable name="found-matches" as="xs:string*">
      <xsl:apply-templates select="$who" mode="name-used"/>
    </xsl:variable>
    <xsl:sequence select="$found-matches[matches(., '\S')]"/>
  </xsl:function>
  
  <xsl:template mode="name-used" match="model//*" as="xs:string">
    <xsl:text expand-text="true">{ mx:match-name(ancestor::model[1]/..) }/{ mx:match-name(.) }</xsl:text>
  </xsl:template>
  
  <xsl:template mode="name-used" match="METASCHEMA/define-assembly" as="xs:string*">
    <xsl:if test="exists(root-name)" expand-text="true">/{ root-name }</xsl:if>
    <xsl:apply-templates mode="#current" select="key('assembly-references',@_key-name)"/>
  </xsl:template>
  
  <xsl:template mode="name-used" match="METASCHEMA/define-field" as="xs:string*">
    <xsl:apply-templates mode="#current" select="key('field-references',@_key-name)"/>
  </xsl:template>
  
  <xsl:template mode="name-used" match="METASCHEMA/define-flag" as="xs:string*">
    <xsl:apply-templates mode="#current" select="key('flag-references',@_key-name)"/>
  </xsl:template>
  
  <xsl:function name="mx:match-name" as="xs:string?">
    <xsl:param name="who" as="element()"/>
    <xsl:text expand-text="true">{ $who/group-as[@in-xml='GROUPED']/@name ! (. || '/') }{ mx:use-name($who) }</xsl:text>
  </xsl:function>
  
  <xsl:function name="mx:match-name-with-parent" as="xs:string?">
    <xsl:param name="who" as="element()"/>
    <xsl:text expand-text="true">{ $who/ancestor::model[1]/parent::*/(mx:match-name(.) || '/') }{ mx:match-name($who) }</xsl:text>
  </xsl:function>
  
  <xsl:function name="mx:use-name" as="xs:string?">
    <xsl:param name="who" as="element()"/>
    <xsl:variable name="definition" select="$who/self::assembly/key('assembly-definitions', @_key-ref) |
      $who/self::field/key('field-definitions', @_key-ref) | $who/self::flag/key('flag-definitions',@_key-ref)"/>
    <xsl:sequence
      select="($who/root-name, $who/use-name, $definition/root-name, $definition/use-name, $definition/@name, $who/@name)[1]"/>  
  </xsl:function>
  
  <xsl:template name="comment-xsl">
    <xsl:param name="head"/>
    <xsl:comment> .     .     .     .     .     .     .     .     .     .     .     .     .     .     .     .     . </xsl:comment>
    <xsl:for-each select="$head">
      <xsl:comment>
        <xsl:text>    </xsl:text>
        <xsl:value-of select="."/>
        <xsl:text>    </xsl:text>
      </xsl:comment>
      <xsl:text>&#xA;</xsl:text>
    </xsl:for-each>
    <xsl:comment> .     .     .     .     .     .     .     .     .     .     .     .     .     .     .     .     . </xsl:comment>
  </xsl:template>
  
</xsl:stylesheet>