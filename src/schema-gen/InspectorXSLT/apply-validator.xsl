<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="3.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:mx="http://csrc.nist.gov/ns/csd/metaschema-xslt"
    exclude-result-prefixes="#all"
    xmlns="http://www.w3.org/1999/xhtml">

    <xsl:output indent="false" encoding="us-ascii" omit-xml-declaration="true"/>
   
   
<!-- parameter $mode' affects the output:
     mode=silent-when-valid suppresses all results when no errors are reported
     mode=concise brings back a single line of Markdown reporting valid/invalid status (it has no effect on HTML)
   
   more elaborate reports with support for sorting, warning levels etc. are tbd -->

   <xsl:param name="mode" as="xs:string">verbose</xsl:param>
   
    <!-- returns annotated copy of input tree   -->
    <xsl:template match="/" name="xsl:initial-template">
        <mx:validation src="{ base-uri(.) }">
           <xsl:apply-templates select="." mode="metaschema-metadata"/>
           <xsl:apply-templates mode="validate"/>
        </mx:validation>            
    </xsl:template>

    <xsl:template match="/" mode="mx-reports mx">
        <xsl:call-template name="mx-reports"/>
    </xsl:template>
    
    <!-- returns mx reports only, with a summary - can be parameterized to filter -->
    <xsl:template name="mx-reports">
        <xsl:variable name="mx-validation">
            <xsl:call-template name="xsl:initial-template"/>
        </xsl:variable>
        <xsl:apply-templates mode="grab-mx" select="$mx-validation/*"/>   
    </xsl:template>
    
    <xsl:template name="mx">
        <xsl:call-template name="mx-reports"/>
    </xsl:template>

    <xsl:template match="/" mode="html">
        <xsl:call-template name="html"/>
    </xsl:template>
    
    <xsl:template name="html">
        <xsl:variable name="mx-reports"><!-- reports has a summary along with any reports -->
            <xsl:call-template name="mx-reports"/>
        </xsl:variable>
        <xsl:apply-templates mode="mx-to-html" select="$mx-reports/*"/>
    </xsl:template>
    
    <xsl:template match="/" mode="markdown md">
        <xsl:call-template name="markdown"/>
    </xsl:template>
    
    <xsl:template name="markdown">
        <xsl:variable name="html-report">
            <xsl:call-template name="html"/>
        </xsl:variable>
        <xsl:apply-templates mode="html-to-md" select="$html-report/*"/>
    </xsl:template>
    
    <xsl:template name="md">
        <xsl:call-template name="markdown"/>
    </xsl:template>
    
    <xsl:mode name="validate" on-no-match="shallow-copy"/>
    
    <xsl:mode name="value-only" on-no-match="text-only-copy"/>
    
    <xsl:mode name="validate-markup-line" on-no-match="text-only-copy"/>
    <xsl:mode name="validate-markup-multiline" on-no-match="shallow-skip"/>

    <xsl:template match="* | @*" priority="1" mode="constraint-cascade"/>
      
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
            <xsl:with-param name="cf">av.103</xsl:with-param>
            <xsl:with-param name="class">_UE unmatched-element</xsl:with-param>
            <xsl:with-param name="msg" expand-text="true">Unrecognized element <mx:gi>{ name() }</mx:gi>.</xsl:with-param>
        </xsl:call-template>
    </xsl:template>
    
    <xsl:template match="text()[not(matches(.,'\S'))]" priority="0.1" mode="test"/>
        
    <xsl:template match="text()" mode="test">
        <!-- report if not recognized -->
        <xsl:call-template name="notice">
            <xsl:with-param name="cf">av.114</xsl:with-param>
            <xsl:with-param name="class">_UT unexpected-text</xsl:with-param>
            <xsl:with-param name="msg" expand-text="true">Errant text content.</xsl:with-param>
        </xsl:call-template>
    </xsl:template>
    
    <!-- report if not recognized -->
    <xsl:template match="*" mode="validate-markup-multiline" name="notice-multiline">
        <xsl:call-template name="notice">
            <xsl:with-param name="cf">av.123</xsl:with-param>
            <xsl:with-param name="class">_UMM unmatched-markup-multiline</xsl:with-param>
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
            <xsl:with-param name="cf">av.166</xsl:with-param>
            <xsl:with-param name="class">_UM unmatched-markup</xsl:with-param>
            <xsl:with-param name="msg" expand-text="true">Unrecognized element <mx:gi>{ name() }</mx:gi>.</xsl:with-param>
        </xsl:call-template>
    </xsl:template>
    
    <!-- ... and attributes ...  -->
    <xsl:template match="@*" mode="test validate-markup-line validate-markup-multiline">
        <xsl:call-template name="notice">
            <xsl:with-param name="cf">av.175</xsl:with-param>
            <xsl:with-param name="class">_UA unmatched-attribute</xsl:with-param>
            <xsl:with-param name="msg" expand-text="true">Unrecognized attribute <mx:gi>@{ name() }</mx:gi> on element <mx:gi>{ name(..) }</mx:gi>.</xsl:with-param>
        </xsl:call-template>
    </xsl:template>
    
    <xsl:template mode="test" match="@xsi:*" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"/>

   <xsl:template name="notice">
      <xsl:param name="cf" as="xs:string" select="AV.186"/><!-- default expecting override -->
      <xsl:param name="condition" as="xs:boolean" select="true()"/>
      <xsl:param name="testing" as="xs:string">exists(.)</xsl:param><!-- hints at why something is reported -->
      <xsl:param name="class" as="xs:string">__U uncategorized</xsl:param>
      <xsl:param name="msg">[info]</xsl:param>
      <xsl:param name="level" as="xs:string">error</xsl:param>
      <xsl:if test="$condition">
         <xsl:variable name="xpath"><!-- handmade paths avoid namespaces and other complications of path(.) -->
            <xsl:apply-templates select="." mode="xpath"/>
         </xsl:variable>
         <mx:report cf="{$cf}" test="{ $testing }" class="{$class}" xpath="{ $xpath }">
            <xsl:if test="not($level = 'error')">
               <xsl:attribute name="level" select="$level"/>
            </xsl:if>
            <xsl:sequence select="$msg"/>
         </mx:report>
      </xsl:if>
   </xsl:template>
   
   <xsl:template name="announce-aside">
      <xsl:param name="msg">[info]</xsl:param>
      <xsl:if test="$mode='noisy'">
         <xsl:message>
            <xsl:sequence select="$msg"/>
         </xsl:message>
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
    
    <xsl:function name="mx:pluralize" as="xs:string" expand-text="true">
        <xsl:param name="for" as="xs:double"/>
        <xsl:param name="as" as="xs:string"/>
        <xsl:choose>
            <xsl:when test="$for eq 1">{ $as }</xsl:when>
            <xsl:otherwise>{ $as }s</xsl:otherwise><!-- we could dive into templates if we hit a special case -->
        </xsl:choose>
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
    
    <!-- Mode grab-mx filters mx from its 'host' XML -->
    
    <xsl:mode name="grab-mx" on-no-match="shallow-skip"/>
    
    <!--copied from mx-grabber.xsl -->
    
    <xsl:template match="mx:*" mode="grab-mx">
        <xsl:copy-of select="."/>
    </xsl:template>

   <!--silences empty validation reports -->
   <xsl:template match="/mx:validation[$mode='silent-when-valid'][empty(descendant::mx:report)]" priority="104" mode="grab-mx"/>
   
   <xsl:template match="/mx:validation[$mode='noisy'][empty(descendant::mx:report)]" priority="103" mode="grab-mx">
      <xsl:call-template name="announce-aside" expand-text="true">
         <xsl:with-param name="msg">File { replace(@src,'.*/','') } is reported VALID, no issues ... </xsl:with-param>
      </xsl:call-template>
      <xsl:next-match/>
   </xsl:template>
   
   <xsl:template match="/mx:validation[$mode='noisy'][exists(descendant::mx:report)]" priority="102" mode="grab-mx">
      <xsl:variable name="report-count" select="count(.//mx:report)"/>
      <xsl:call-template name="announce-aside" expand-text="true">
         <xsl:with-param name="msg">File { replace(@src,'.*/','') } has { $report-count } { mx:pluralize($report-count,'issue') } reported ... </xsl:with-param>
      </xsl:call-template>
      <xsl:next-match/>
    </xsl:template>
   
   <xsl:template match="/mx:validation" priority="101" mode="grab-mx">
      <xsl:copy>
            <xsl:copy-of select="@*"/>
            <xsl:attribute name="elements" select="count(descendant::* except .//mx:*/descendant-or-self::*)"/>
            <xsl:attribute name="attributes" select="count(descendant::*/@* except .//mx:*/descendant-or-self::*/@*)"/>
            <xsl:attribute name="reports" select="count(.//mx:report)"/>
            <xsl:apply-templates mode="grab-mx"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:mode name="mx-to-html" on-no-match="text-only-copy"/>

    <xsl:template match="/mx:validation" mode="mx-to-html" expand-text="true">
       <xsl:variable name="reported-valid" select="@reports = 0"/>
       <xsl:variable name="validating-filename" select="replace(@src,'.*/','')"/>
       <xsl:variable name="checked" select="if ($reported-valid) then '&#x2714;' else '&#x2718;'"/>
        <html>
           <head>
              <title>{ $validating-filename } - { $checked } - { mx:metaschema/@shortname } validation</title>
           <xsl:call-template name="html-css"/>
           </head>
         <body>
            <h1>{ $checked } Validating <a href="{ @src }">{ $validating-filename }</a> - { mx:metaschema } - found { 'IN'[not($reported-valid)] }VALID</h1>
            <xsl:apply-templates mode="#current" select="mx:metaschema"/>
            <p><code>{ $validating-filename }</code> contains { @elements} { mx:pluralize(@elements/number(),'element') } and { @attributes } {
               mx:pluralize(@attributes/number(),'attribute') }.</p>
            <xsl:apply-templates select="." mode="summary"/>
            <main>
              <xsl:apply-templates mode="#current" select="child::* except mx:metaschema"/>
            </main>
         </body>
        </html>
    </xsl:template>
   
   <xsl:template name="html-css" xml:space="preserve" expand-text="false">
<style type="text/css">
main { max-width: fit-content }
details { margin-top: 0.5em; padding: 0.5em; outline: thin solid black }
summary { margin: 0em }
details p { margin: 0.2em 0em }   
.xpath    { font-family: monospace }
.exc { font-size: 85%; padding: 0.2em; background-color: cornsilk; font-family: sans-serif }
</style>
   </xsl:template>
    
    <xsl:template match="mx:validation" mode="summary" expand-text="true">
        <div class="summary">
            <p>{ count(.//mx:report) } { mx:pluralize(count(.//mx:report),'issue') } reported.</p>
            <p>{ (1 to count(.//mx:report)) ! '&#x1F4A5;' }</p>
        </div>
    </xsl:template>
    
    <xsl:template match="mx:validation[empty(descendant::mx:report)]" mode="summary">
        <div class="summary valid">
            <p>Good news - nothing to report - the instance is valid. &#x1F680;</p>
        </div>
    </xsl:template>
    
   <xsl:template match="mx:metaschema" mode="mx-to-html" expand-text="true">
      <p class="metadata">Checking against rules derived from <b>{ . }</b> metaschema (namespace <code>{ @namespace }</code>)</p>
   </xsl:template>
   
   <xsl:template match="mx:report" mode="mx-to-html" expand-text="true">
      <details class="report { @class }">
         <summary>
            <xsl:apply-templates mode="#current"/>
         </summary>
         <p class="xpath">{ @xpath }</p>
         <p class="exc">[{ @class }]</p>
         <p class="test">test: <code>{ @test }</code></p>
      </details>
   </xsl:template>
   
    <xsl:template match="mx:gi" mode="mx-to-html" priority="1">
        <b>
            <xsl:apply-templates mode="#current"/>
        </b>
    </xsl:template>
    
    <xsl:template match="mx:code | mx:tt" mode="mx-to-html" priority="1">
       <code style="white-space:pre-wrap">
            <xsl:apply-templates mode="#current"/>
        </code>
    </xsl:template>
    
    <xsl:template match="mx:report/mx:*" mode="mx-to-html">
        <i>
            <xsl:apply-templates mode="#current"/>
        </i>
    </xsl:template>
    
    <xsl:mode name="html-to-md" on-no-match="text-only-copy"/>
    
    <xsl:variable name="lf" as="xs:string"  expand-text="true">{ codepoints-to-string(10) }</xsl:variable>
    <xsl:variable name="lf2" as="xs:string" expand-text="true">{$lf || $lf}</xsl:variable>
    
   <xsl:template mode="html-to-md" match="html" xpath-default-namespace="http://www.w3.org/1999/xhtml">
      <xsl:apply-templates mode="#current" select="body"/>
   </xsl:template>
   
   <xsl:template mode="html-to-md" match="style" xpath-default-namespace="http://www.w3.org/1999/xhtml"/>
   
   <xsl:template mode="html-to-md" match="body[$mode='concise']" expand-text="true" xpath-default-namespace="http://www.w3.org/1999/xhtml">
      <xsl:apply-templates mode="#current" select="h1"/>
   </xsl:template>
   
   <xsl:template mode="html-to-md" match="body" expand-text="true" xpath-default-namespace="http://www.w3.org/1999/xhtml">
      <xsl:apply-templates mode="#current"/>
      <xsl:text>{ $lf }</xsl:text>
   </xsl:template>
   
   <xsl:template mode="html-to-md" match="div | details" expand-text="true" xpath-default-namespace="http://www.w3.org/1999/xhtml">
        <xsl:text>{ $lf2 }---</xsl:text>
        <xsl:apply-templates mode="#current"/>
    </xsl:template>
    
   <xsl:template mode="html-to-md" match="body/*[1]/self::h1" expand-text="true" xpath-default-namespace="http://www.w3.org/1999/xhtml">
      <xsl:text># </xsl:text>
      <xsl:apply-templates mode="#current"/>
   </xsl:template>
   
   <xsl:template mode="html-to-md" match="h1" expand-text="true" xpath-default-namespace="http://www.w3.org/1999/xhtml">
      <xsl:text>{ $lf2 }# </xsl:text>
      <xsl:apply-templates mode="#current"/>
   </xsl:template>
   
   <xsl:template mode="html-to-md" match="h2" expand-text="true" xpath-default-namespace="http://www.w3.org/1999/xhtml">
        <xsl:text>{ $lf2 }## </xsl:text>
        <xsl:apply-templates mode="#current"/>
    </xsl:template>
    
    <xsl:template mode="html-to-md" match="h3 | details/summary" expand-text="true" xpath-default-namespace="http://www.w3.org/1999/xhtml">
        <xsl:text>{ $lf2 }### </xsl:text>
        <xsl:apply-templates mode="#current"/>
    </xsl:template>
    
    <xsl:template mode="html-to-md" match="p" expand-text="true" xpath-default-namespace="http://www.w3.org/1999/xhtml">
        <xsl:text>{ $lf2 }</xsl:text>
        <xsl:apply-templates mode="#current"/>
    </xsl:template>
    
    <xsl:template mode="html-to-md" match="b" priority="2" xpath-default-namespace="http://www.w3.org/1999/xhtml">
        <xsl:text>**</xsl:text>
        <xsl:apply-templates mode="#current"/>
        <xsl:text>**</xsl:text>
    </xsl:template>
    <xsl:template mode="html-to-md" match="i | p/*" xpath-default-namespace="http://www.w3.org/1999/xhtml">
        <xsl:text>*</xsl:text>
        <xsl:apply-templates mode="#current"/>
        <xsl:text>*</xsl:text>
    </xsl:template>
    <xsl:template mode="html-to-md" match="code" priority="2" xpath-default-namespace="http://www.w3.org/1999/xhtml">
        <xsl:text>`</xsl:text>
        <xsl:apply-templates mode="#current"/>
        <xsl:text>`</xsl:text>
    </xsl:template>
</xsl:stylesheet>
