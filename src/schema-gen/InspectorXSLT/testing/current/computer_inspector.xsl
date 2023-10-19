<?xml version="1.0" encoding="us-ascii"?>
<xsl:transform xmlns="http://www.w3.org/1999/xhtml"
               xmlns:mx="http://csrc.nist.gov/ns/csd/metaschema-xslt"
               xmlns:xs="http://www.w3.org/2001/XMLSchema"
               xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
               version="3.0"
               xpath-default-namespace="http://example.com/ns/computer"
               exclude-result-prefixes="#all"><!-- Generated 2023-10-19T17:09:45.866171-04:00 -->
   <xsl:mode on-no-match="fail"/>
   <xsl:mode name="test" on-no-match="shallow-skip"/>
   <!-- .     .     .     .     .     .     .     .     .     .     .     .     .     .     .     .     . -->
   <!--    Templates copied from boilerplate    -->
   <!-- .     .     .     .     .     .     .     .     .     .     .     .     .     .     .     .     . -->
   <xsl:output indent="true" encoding="us-ascii" omit-xml-declaration="true"/>
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
   <xsl:mode name="constraint-cascade"
             on-no-match="fail"
             on-multiple-match="use-last"/>
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
   <xsl:template xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                 mode="test"
                 match="@xsi:*"/>
   <xsl:template name="notice">
      <xsl:param name="cf" as="xs:string" select="AV.186"/>
      <!-- default expecting override -->
      <xsl:param name="rule-id" as="xs:string*" select="()"/>
      <!-- rule-id may be multiple -->
      <xsl:param name="condition" as="xs:boolean" select="true()"/>
      <xsl:param name="testing" as="xs:string">exists(.)</xsl:param>
      <!-- hints at why something is reported -->
      <xsl:param name="class" as="xs:string">__U uncategorized</xsl:param>
      <xsl:param name="matching" as="xs:string">*</xsl:param>
      <xsl:param name="msg">[info]</xsl:param>
      <xsl:param name="level" as="xs:string">ERROR</xsl:param>
      <xsl:if test="$condition">
         <xsl:variable name="xpath"><!-- handmade paths avoid namespaces and other complications of path(.) -->
            <xsl:apply-templates select="." mode="xpath"/>
         </xsl:variable>
         <mx:report cf="{$cf}"
                    test="{ $testing }"
                    class="{$class}"
                    xpath="{ $xpath }">
            <xsl:if test="exists($rule-id[matches(.,'\S')])">
               <xsl:attribute name="rule-id" select="string-join($rule-id[matches(.,'\S')],' ')"/>
            </xsl:if>
            <xsl:if test="not($level = 'ERROR')">
               <xsl:attribute name="level" select="$level"/>
            </xsl:if>
            <xsl:if test="not($matching = '*')">
               <xsl:attribute name="matching" select="$matching"/>
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
   <xsl:function name="mx:pluralize" as="xs:string" expand-text="true">
      <xsl:param name="for" as="xs:double"/>
      <xsl:param name="as" as="xs:string"/>
      <xsl:choose>
         <xsl:when test="$for eq 1">{ $as }</xsl:when>
         <xsl:otherwise>{ $as }s</xsl:otherwise>
         <!-- we could dive into templates if we hit a special case -->
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
      <xsl:copy-of select="." copy-namespaces="false"/>
   </xsl:template>
   <!--silences empty validation reports -->
   <xsl:template match="/mx:validation[$mode='silent-when-valid'][empty(descendant::mx:report)]"
                 priority="104"
                 mode="grab-mx"/>
   <xsl:template match="/mx:validation[$mode='noisy'][empty(descendant::mx:report)]"
                 priority="103"
                 mode="grab-mx">
      <xsl:call-template name="announce-aside" expand-text="true">
         <xsl:with-param name="msg">File { replace(@src,'.*/','') } is reported VALID, no issues ... </xsl:with-param>
      </xsl:call-template>
      <xsl:next-match/>
   </xsl:template>
   <xsl:template match="/mx:validation[$mode='noisy'][exists(descendant::mx:report)]"
                 priority="102"
                 mode="grab-mx">
      <xsl:variable name="report-count" select="count(.//mx:report)"/>
      <xsl:call-template name="announce-aside" expand-text="true">
         <xsl:with-param name="msg">File { replace(@src,'.*/','') } has { $report-count } { mx:pluralize($report-count,'issue') } reported ... </xsl:with-param>
      </xsl:call-template>
      <xsl:next-match/>
   </xsl:template>
   <xsl:template match="/mx:validation" priority="101" mode="grab-mx">
      <xsl:copy copy-namespaces="false">
         <xsl:copy-of select="@*"/>
         <xsl:attribute name="elements"
                        select="count(descendant::* except .//mx:*/descendant-or-self::*)"/>
         <xsl:attribute name="attributes"
                        select="count(descendant::*/@* except .//mx:*/descendant-or-self::*/@*)"/>
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
            <p>
               <code>{ $validating-filename }</code> contains { @elements} { mx:pluralize(@elements/number(),'element') } and { @attributes } {
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
details.WARNING { outline: thin dotted grey }
details.INFORMATIONAL { outline: medium solid slateblue }
summary { margin: 0em }
details p { margin: 0.2em 0em }   
.xpath    { font-family: monospace }
.exc { font-size: 85%; padding: 0.2em; background-color: cornsilk; font-family: sans-serif }
</style>
   </xsl:template>
   <xsl:template match="mx:validation" mode="summary" expand-text="true">
      <div class="summary">
         <p>{ count(.//mx:report) } { mx:pluralize(count(.//mx:report),'issue') } reported.</p>
         <p>{ (1 to count(.//mx:report)) ! '&#x1f4a5;' }</p>
      </div>
   </xsl:template>
   <xsl:template match="mx:validation[empty(descendant::mx:report)]" mode="summary">
      <div class="summary valid">
         <p>Good news - nothing to report - the instance is valid. &#x1f680;</p>
      </div>
   </xsl:template>
   <xsl:template match="mx:metaschema" mode="mx-to-html" expand-text="true">
      <p class="metadata">Checking against rules derived from <b>{ . }</b> metaschema (namespace <code>{ @namespace }</code>)</p>
   </xsl:template>
   <xsl:template match="mx:report" mode="mx-to-html" expand-text="true">
      <details class="report { @class }{ @level[not(.='ERROR')] ! (' ' || .) }">
         <summary>
            <xsl:apply-templates mode="#current"/>
         </summary>
         <p class="exc">{ @class }{ @level[not(.='ERROR')] ! (' ' || .) }</p>
         <ul>
            <xsl:for-each select="@rule-id">
               <li class="test">Rule ID: <code>{ . }</code>
               </li>
            </xsl:for-each>
            <li class="test">test: <code>{ @test }</code>
            </li>
            <xsl:if test="@matching!='*'">
               <li class="matching">matching: <code>{ @matching }</code>
               </li>
            </xsl:if>
            <li>XPath: <code class="xpath">{ @xpath }</code>
            </li>
         </ul>
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
   <xsl:variable name="lf" as="xs:string" expand-text="true">{ codepoints-to-string(10) }</xsl:variable>
   <xsl:variable name="lf2" as="xs:string" expand-text="true">{$lf || $lf}</xsl:variable>
   <xsl:template mode="html-to-md"
                 match="html"
                 xpath-default-namespace="http://www.w3.org/1999/xhtml">
      <xsl:apply-templates mode="#current" select="body"/>
   </xsl:template>
   <xsl:template mode="html-to-md"
                 match="style"
                 xpath-default-namespace="http://www.w3.org/1999/xhtml"/>
   <xsl:template mode="html-to-md"
                 match="body[$mode='concise']"
                 expand-text="true"
                 xpath-default-namespace="http://www.w3.org/1999/xhtml">
      <xsl:apply-templates mode="#current" select="h1"/>
   </xsl:template>
   <xsl:template mode="html-to-md"
                 match="body"
                 expand-text="true"
                 xpath-default-namespace="http://www.w3.org/1999/xhtml">
      <xsl:apply-templates mode="#current"/>
      <xsl:text>{ $lf }</xsl:text>
   </xsl:template>
   <xsl:template mode="html-to-md"
                 match="div | details"
                 expand-text="true"
                 xpath-default-namespace="http://www.w3.org/1999/xhtml">
      <xsl:text>{ $lf2 }---</xsl:text>
      <xsl:apply-templates mode="#current"/>
   </xsl:template>
   <xsl:template mode="html-to-md"
                 match="body/*[1]/self::h1"
                 expand-text="true"
                 xpath-default-namespace="http://www.w3.org/1999/xhtml">
      <xsl:text># </xsl:text>
      <xsl:apply-templates mode="#current"/>
   </xsl:template>
   <xsl:template mode="html-to-md"
                 match="h1"
                 expand-text="true"
                 xpath-default-namespace="http://www.w3.org/1999/xhtml">
      <xsl:text>{ $lf2 }# </xsl:text>
      <xsl:apply-templates mode="#current"/>
   </xsl:template>
   <xsl:template mode="html-to-md"
                 match="h2"
                 expand-text="true"
                 xpath-default-namespace="http://www.w3.org/1999/xhtml">
      <xsl:text>{ $lf2 }## </xsl:text>
      <xsl:apply-templates mode="#current"/>
   </xsl:template>
   <xsl:template mode="html-to-md"
                 match="h3 | details/summary"
                 expand-text="true"
                 xpath-default-namespace="http://www.w3.org/1999/xhtml">
      <xsl:text>{ $lf2 }### </xsl:text>
      <xsl:apply-templates mode="#current"/>
   </xsl:template>
   <xsl:template mode="html-to-md"
                 match="p"
                 expand-text="true"
                 xpath-default-namespace="http://www.w3.org/1999/xhtml">
      <xsl:text>{ $lf2 }</xsl:text>
      <xsl:apply-templates mode="#current"/>
   </xsl:template>
   <xsl:template mode="html-to-md"
                 match="ul"
                 expand-text="true"
                 xpath-default-namespace="http://www.w3.org/1999/xhtml">
      <xsl:text>{ $lf }</xsl:text>
      <xsl:apply-templates mode="#current"/>
   </xsl:template>
   <xsl:template mode="html-to-md"
                 match="li"
                 expand-text="true"
                 xpath-default-namespace="http://www.w3.org/1999/xhtml">
      <xsl:text>{ $lf }- </xsl:text>
      <xsl:apply-templates mode="#current"/>
   </xsl:template>
   <xsl:template mode="html-to-md"
                 match="b"
                 priority="2"
                 xpath-default-namespace="http://www.w3.org/1999/xhtml">
      <xsl:text>**</xsl:text>
      <xsl:apply-templates mode="#current"/>
      <xsl:text>**</xsl:text>
   </xsl:template>
   <xsl:template mode="html-to-md"
                 match="i | p/*"
                 xpath-default-namespace="http://www.w3.org/1999/xhtml">
      <xsl:text>*</xsl:text>
      <xsl:apply-templates mode="#current"/>
      <xsl:text>*</xsl:text>
   </xsl:template>
   <xsl:template mode="html-to-md"
                 match="code"
                 priority="2"
                 xpath-default-namespace="http://www.w3.org/1999/xhtml">
      <xsl:text>`</xsl:text>
      <xsl:apply-templates mode="#current"/>
      <xsl:text>`</xsl:text>
   </xsl:template>
   <xsl:template mode="metaschema-metadata" match="*">
      <mx:metaschema version="0.0.5"
                     shortname="computer"
                     namespace="http://example.com/ns/computer">Computer Model</mx:metaschema>
   </xsl:template>
   <!-- .     .     .     .     .     .     .     .     .     .     .     .     .     .     .     .     . -->
   <!--    Generated rules - first, any roots    -->
   <!-- .     .     .     .     .     .     .     .     .     .     .     .     .     .     .     .     . -->
   <!-- .     .     .     .     .     .     .     .     .     .     .     .     .     .     .     .     . -->
   <!--     Root     -->
   <!-- .     .     .     .     .     .     .     .     .     .     .     .     .     .     .     .     . -->
   <xsl:template match="/computer" mode="test">
      <xsl:apply-templates select="@*" mode="test"/>
      <xsl:call-template name="require-for-computer-assembly"/>
   </xsl:template>
   <xsl:template priority="103"
                 mode="constraint-cascade"
                 match="computer/(self::*[starts-with(@id,'A')]/@date-of-manufacture)">
      <xsl:call-template name="notice">
         <xsl:with-param name="cf">gix.522</xsl:with-param>
         <xsl:with-param name="rule-id">manufacture-date-rule_1</xsl:with-param>
         <xsl:with-param name="matching" as="xs:string">computer/(self::*[starts-with(@id,'A')]/@date-of-manufacture)</xsl:with-param>
         <xsl:with-param name="class">AVCV value-not-allowed</xsl:with-param>
         <xsl:with-param name="testing" as="xs:string">not(.=('1980-04-01','1981-04-01','1982-04-01'))</xsl:with-param>
         <xsl:with-param name="condition"
                         select="not(.=('1980-04-01','1981-04-01','1982-04-01'))"/>
         <xsl:with-param name="msg" expand-text="true">
            <mx:code>{ string(.) }</mx:code>{ .[not(string(.))] ! ' (empty)' } does not appear among permitted (enumerated) values for <mx:gi>{ name() }</mx:gi>: <mx:code>1980-04-01|1981-04-01|1982-04-01</mx:code>.</xsl:with-param>
         <xsl:with-param name="level" select="'WARNING'"/>
      </xsl:call-template>
      <xsl:next-match/>
   </xsl:template>
   <xsl:template priority="102"
                 mode="constraint-cascade"
                 match="computer/(@date-of-manufacture)">
      <xsl:call-template name="notice">
         <xsl:with-param name="cf">gix.588</xsl:with-param>
         <xsl:with-param name="rule-id">manufacture-date-rule_2</xsl:with-param>
         <xsl:with-param name="matching" as="xs:string">computer/(@date-of-manufacture)</xsl:with-param>
         <xsl:with-param name="class">XPKT expectation-violation</xsl:with-param>
         <xsl:with-param name="testing" as="xs:string">not(not(. castable as xs:date) or (xs:date(.) &gt;= xs:date('1950-01-01')))</xsl:with-param>
         <xsl:with-param name="condition"
                         select="not(not(. castable as xs:date) or (xs:date(.) &gt;= xs:date('1950-01-01')))"/>
         <xsl:with-param name="msg" expand-text="true">Expression result for <mx:gi>computer/(@date-of-manufacture)</mx:gi> does not conform to expectation <mx:code>not(. castable as xs:date) or (xs:date(.) &gt;= xs:date('1950-01-01'))</mx:code>.</xsl:with-param>
      </xsl:call-template>
      <xsl:next-match/>
   </xsl:template>
   <xsl:template priority="101"
                 mode="constraint-cascade"
                 match="computer/(@date-of-manufacture)">
      <xsl:call-template name="check-date-datatype">
         <xsl:with-param name="rule-id" as="xs:string">manufacture-date-rule_3</xsl:with-param>
         <xsl:with-param name="class" as="xs:string">MDCV datatype-match-fail</xsl:with-param>
         <xsl:with-param name="matching" as="xs:string">computer/(@date-of-manufacture)</xsl:with-param>
      </xsl:call-template>
      <xsl:next-match/>
   </xsl:template>
   <!-- .     .     .     .     .     .     .     .     .     .     .     .     .     .     .     .     . -->
   <!--     Occurrences - templates in mode 'test'     -->
   <!-- .     .     .     .     .     .     .     .     .     .     .     .     .     .     .     .     . -->
   <xsl:template priority="5" match="computer/motherboard/vendor" mode="test">
      <xsl:apply-templates select="@*" mode="test"/>
      <xsl:call-template name="notice">
         <xsl:with-param name="cf">gix.303</xsl:with-param>
         <xsl:with-param name="class">EATO element-appears-too-often</xsl:with-param>
         <xsl:with-param name="testing" as="xs:string">count(. | preceding-sibling::vendor) gt 1</xsl:with-param>
         <xsl:with-param name="condition" select="count(. | preceding-sibling::vendor) gt 1"/>
         <xsl:with-param name="msg">
            <mx:gi>vendor</mx:gi> appears too many times: 1 maximum is permitted.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="notice">
         <xsl:with-param name="cf">gix.347</xsl:with-param>
         <xsl:with-param name="class">EOOO element-out-of-order</xsl:with-param>
         <xsl:with-param name="testing" as="xs:string">exists(preceding-sibling::type | preceding-sibling::cpu | preceding-sibling::ata-socket | preceding-sibling::memory | preceding-sibling::cooling | preceding-sibling::expansion-card)</xsl:with-param>
         <xsl:with-param name="condition"
                         select="exists(preceding-sibling::type | preceding-sibling::cpu | preceding-sibling::ata-socket | preceding-sibling::memory | preceding-sibling::cooling | preceding-sibling::expansion-card)"/>
         <xsl:with-param name="msg">
            <mx:gi>vendor</mx:gi> is unexpected following <mx:gi>type</mx:gi>, <mx:gi>cpu</mx:gi>, <mx:gi>ata-socket</mx:gi>, <mx:gi>memory</mx:gi>, <mx:gi>cooling</mx:gi>, or <mx:gi>expansion-card</mx:gi>.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="require-for-vendor-assembly"/>
      <xsl:apply-templates mode="constraint-cascade" select="."/>
   </xsl:template>
   <xsl:template priority="5" match="motherboard/cpu/vendor" mode="test">
      <xsl:apply-templates select="@*" mode="test"/>
      <xsl:call-template name="notice">
         <xsl:with-param name="cf">gix.303</xsl:with-param>
         <xsl:with-param name="class">EATO element-appears-too-often</xsl:with-param>
         <xsl:with-param name="testing" as="xs:string">count(. | preceding-sibling::vendor) gt 1</xsl:with-param>
         <xsl:with-param name="condition" select="count(. | preceding-sibling::vendor) gt 1"/>
         <xsl:with-param name="msg">
            <mx:gi>vendor</mx:gi> appears too many times: 1 maximum is permitted.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="notice">
         <xsl:with-param name="cf">gix.347</xsl:with-param>
         <xsl:with-param name="class">EOOO element-out-of-order</xsl:with-param>
         <xsl:with-param name="testing" as="xs:string">exists(preceding-sibling::product-name | preceding-sibling::architecture | preceding-sibling::speed)</xsl:with-param>
         <xsl:with-param name="condition"
                         select="exists(preceding-sibling::product-name | preceding-sibling::architecture | preceding-sibling::speed)"/>
         <xsl:with-param name="msg">
            <mx:gi>vendor</mx:gi> is unexpected following <mx:gi>product-name</mx:gi>, <mx:gi>architecture</mx:gi>, or <mx:gi>speed</mx:gi>.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="require-for-vendor-assembly"/>
      <xsl:apply-templates mode="constraint-cascade" select="."/>
   </xsl:template>
   <xsl:template priority="5" match="motherboard/ata-socket/vendor" mode="test">
      <xsl:apply-templates select="@*" mode="test"/>
      <xsl:call-template name="notice">
         <xsl:with-param name="cf">gix.303</xsl:with-param>
         <xsl:with-param name="class">EATO element-appears-too-often</xsl:with-param>
         <xsl:with-param name="testing" as="xs:string">count(. | preceding-sibling::vendor) gt 1</xsl:with-param>
         <xsl:with-param name="condition" select="count(. | preceding-sibling::vendor) gt 1"/>
         <xsl:with-param name="msg">
            <mx:gi>vendor</mx:gi> appears too many times: 1 maximum is permitted.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="notice">
         <xsl:with-param name="cf">gix.347</xsl:with-param>
         <xsl:with-param name="class">EOOO element-out-of-order</xsl:with-param>
         <xsl:with-param name="testing" as="xs:string">exists(preceding-sibling::product-name | preceding-sibling::type)</xsl:with-param>
         <xsl:with-param name="condition"
                         select="exists(preceding-sibling::product-name | preceding-sibling::type)"/>
         <xsl:with-param name="msg">
            <mx:gi>vendor</mx:gi> is unexpected following <mx:gi>product-name</mx:gi> or <mx:gi>type</mx:gi>.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="require-for-vendor-assembly"/>
      <xsl:apply-templates mode="constraint-cascade" select="."/>
   </xsl:template>
   <xsl:template priority="5" match="motherboard/memory/vendor" mode="test">
      <xsl:apply-templates select="@*" mode="test"/>
      <xsl:call-template name="notice">
         <xsl:with-param name="cf">gix.303</xsl:with-param>
         <xsl:with-param name="class">EATO element-appears-too-often</xsl:with-param>
         <xsl:with-param name="testing" as="xs:string">count(. | preceding-sibling::vendor) gt 1</xsl:with-param>
         <xsl:with-param name="condition" select="count(. | preceding-sibling::vendor) gt 1"/>
         <xsl:with-param name="msg">
            <mx:gi>vendor</mx:gi> appears too many times: 1 maximum is permitted.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="notice">
         <xsl:with-param name="cf">gix.347</xsl:with-param>
         <xsl:with-param name="class">EOOO element-out-of-order</xsl:with-param>
         <xsl:with-param name="testing" as="xs:string">exists(preceding-sibling::product-name | preceding-sibling::byte-size)</xsl:with-param>
         <xsl:with-param name="condition"
                         select="exists(preceding-sibling::product-name | preceding-sibling::byte-size)"/>
         <xsl:with-param name="msg">
            <mx:gi>vendor</mx:gi> is unexpected following <mx:gi>product-name</mx:gi> or <mx:gi>byte-size</mx:gi>.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="require-for-vendor-assembly"/>
      <xsl:apply-templates mode="constraint-cascade" select="."/>
   </xsl:template>
   <xsl:template priority="5" match="computer/motherboard/cooling" mode="test">
      <xsl:apply-templates select="@*" mode="test"/>
      <xsl:call-template name="notice">
         <xsl:with-param name="cf">gix.303</xsl:with-param>
         <xsl:with-param name="class">EATO element-appears-too-often</xsl:with-param>
         <xsl:with-param name="testing" as="xs:string">count(. | preceding-sibling::cooling) gt 1</xsl:with-param>
         <xsl:with-param name="condition" select="count(. | preceding-sibling::cooling) gt 1"/>
         <xsl:with-param name="msg">
            <mx:gi>cooling</mx:gi> appears too many times: 1 maximum is permitted.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="notice">
         <xsl:with-param name="cf">gix.347</xsl:with-param>
         <xsl:with-param name="class">EOOO element-out-of-order</xsl:with-param>
         <xsl:with-param name="testing" as="xs:string">exists(preceding-sibling::expansion-card)</xsl:with-param>
         <xsl:with-param name="condition" select="exists(preceding-sibling::expansion-card)"/>
         <xsl:with-param name="msg">
            <mx:gi>cooling</mx:gi> is unexpected following <mx:gi>expansion-card</mx:gi>.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="require-for-cooling-assembly"/>
      <xsl:apply-templates mode="constraint-cascade" select="."/>
   </xsl:template>
   <xsl:template priority="5" match="motherboard/expansion-card/vendor" mode="test">
      <xsl:apply-templates select="@*" mode="test"/>
      <xsl:call-template name="notice">
         <xsl:with-param name="cf">gix.303</xsl:with-param>
         <xsl:with-param name="class">EATO element-appears-too-often</xsl:with-param>
         <xsl:with-param name="testing" as="xs:string">count(. | preceding-sibling::vendor) gt 1</xsl:with-param>
         <xsl:with-param name="condition" select="count(. | preceding-sibling::vendor) gt 1"/>
         <xsl:with-param name="msg">
            <mx:gi>vendor</mx:gi> appears too many times: 1 maximum is permitted.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="notice">
         <xsl:with-param name="cf">gix.347</xsl:with-param>
         <xsl:with-param name="class">EOOO element-out-of-order</xsl:with-param>
         <xsl:with-param name="testing" as="xs:string">exists(preceding-sibling::product-name | preceding-sibling::type)</xsl:with-param>
         <xsl:with-param name="condition"
                         select="exists(preceding-sibling::product-name | preceding-sibling::type)"/>
         <xsl:with-param name="msg">
            <mx:gi>vendor</mx:gi> is unexpected following <mx:gi>product-name</mx:gi> or <mx:gi>type</mx:gi>.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="require-for-vendor-assembly"/>
      <xsl:apply-templates mode="constraint-cascade" select="."/>
   </xsl:template>
   <xsl:template priority="5" match="/computer/motherboard" mode="test">
      <xsl:apply-templates select="@*" mode="test"/>
      <xsl:call-template name="notice">
         <xsl:with-param name="cf">gix.303</xsl:with-param>
         <xsl:with-param name="class">EATO element-appears-too-often</xsl:with-param>
         <xsl:with-param name="testing" as="xs:string">count(. | preceding-sibling::motherboard) gt 1</xsl:with-param>
         <xsl:with-param name="condition"
                         select="count(. | preceding-sibling::motherboard) gt 1"/>
         <xsl:with-param name="msg">
            <mx:gi>motherboard</mx:gi> appears too many times: 1 maximum is permitted.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="require-for-computer_..._motherboard-assembly"/>
      <xsl:apply-templates mode="constraint-cascade" select="."/>
   </xsl:template>
   <xsl:template priority="104"
                 mode="constraint-cascade"
                 match="/computer/motherboard">
      <xsl:call-template name="notice">
         <xsl:with-param name="cf">gix.588</xsl:with-param>
         <xsl:with-param name="rule-id">memory-rule_1</xsl:with-param>
         <xsl:with-param name="matching" as="xs:string">/computer/motherboard</xsl:with-param>
         <xsl:with-param name="class">XPKT expectation-violation</xsl:with-param>
         <xsl:with-param name="testing" as="xs:string">not(not(memory/byte-size != memory/byte-size))</xsl:with-param>
         <xsl:with-param name="condition"
                         select="not(not(memory/byte-size != memory/byte-size))"/>
         <xsl:with-param name="msg" expand-text="true">Expression result for <mx:gi>/computer/motherboard</mx:gi> does not conform to expectation <mx:code>not(memory/byte-size != memory/byte-size)</mx:code>.</xsl:with-param>
      </xsl:call-template>
      <xsl:next-match/>
   </xsl:template>
   <xsl:template priority="5" match="computer/motherboard/cpu" mode="test">
      <xsl:apply-templates select="@*" mode="test"/>
      <xsl:call-template name="notice">
         <xsl:with-param name="cf">gix.303</xsl:with-param>
         <xsl:with-param name="class">EATO element-appears-too-often</xsl:with-param>
         <xsl:with-param name="testing" as="xs:string">count(. | preceding-sibling::cpu) gt 1</xsl:with-param>
         <xsl:with-param name="condition" select="count(. | preceding-sibling::cpu) gt 1"/>
         <xsl:with-param name="msg">
            <mx:gi>cpu</mx:gi> appears too many times: 1 maximum is permitted.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="notice">
         <xsl:with-param name="cf">gix.347</xsl:with-param>
         <xsl:with-param name="class">EOOO element-out-of-order</xsl:with-param>
         <xsl:with-param name="testing" as="xs:string">exists(preceding-sibling::ata-socket | preceding-sibling::memory | preceding-sibling::cooling | preceding-sibling::expansion-card)</xsl:with-param>
         <xsl:with-param name="condition"
                         select="exists(preceding-sibling::ata-socket | preceding-sibling::memory | preceding-sibling::cooling | preceding-sibling::expansion-card)"/>
         <xsl:with-param name="msg">
            <mx:gi>cpu</mx:gi> is unexpected following <mx:gi>ata-socket</mx:gi>, <mx:gi>memory</mx:gi>, <mx:gi>cooling</mx:gi>, or <mx:gi>expansion-card</mx:gi>.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="require-for-computer_..._motherboard_..._cpu-assembly"/>
      <xsl:apply-templates mode="constraint-cascade" select="."/>
   </xsl:template>
   <xsl:template priority="5" match="computer/motherboard/ata-socket" mode="test">
      <xsl:apply-templates select="@*" mode="test"/>
      <xsl:call-template name="notice">
         <xsl:with-param name="cf">gix.303</xsl:with-param>
         <xsl:with-param name="class">EATO element-appears-too-often</xsl:with-param>
         <xsl:with-param name="testing" as="xs:string">count(. | preceding-sibling::ata-socket) gt 1</xsl:with-param>
         <xsl:with-param name="condition" select="count(. | preceding-sibling::ata-socket) gt 1"/>
         <xsl:with-param name="msg">
            <mx:gi>ata-socket</mx:gi> appears too many times: 1 maximum is permitted.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="notice">
         <xsl:with-param name="cf">gix.347</xsl:with-param>
         <xsl:with-param name="class">EOOO element-out-of-order</xsl:with-param>
         <xsl:with-param name="testing" as="xs:string">exists(preceding-sibling::memory | preceding-sibling::cooling | preceding-sibling::expansion-card)</xsl:with-param>
         <xsl:with-param name="condition"
                         select="exists(preceding-sibling::memory | preceding-sibling::cooling | preceding-sibling::expansion-card)"/>
         <xsl:with-param name="msg">
            <mx:gi>ata-socket</mx:gi> is unexpected following <mx:gi>memory</mx:gi>, <mx:gi>cooling</mx:gi>, or <mx:gi>expansion-card</mx:gi>.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="require-for-computer_..._motherboard_..._ata-socket-assembly"/>
      <xsl:apply-templates mode="constraint-cascade" select="."/>
   </xsl:template>
   <xsl:template priority="109"
                 mode="constraint-cascade"
                 match="computer/motherboard/ata-socket/(child::product-name)">
      <xsl:call-template name="notice">
         <xsl:with-param name="cf">gix.522</xsl:with-param>
         <xsl:with-param name="rule-id">ata-socket-rule_1</xsl:with-param>
         <xsl:with-param name="matching" as="xs:string">computer/motherboard/ata-socket/(child::product-name)</xsl:with-param>
         <xsl:with-param name="class">AVCV value-not-allowed</xsl:with-param>
         <xsl:with-param name="testing" as="xs:string">not(.=('Socketeer I','Socketeer II','LampSocket socket','MiniSock Deux','SprocketSocket','[Unlisted Socket Product]'))</xsl:with-param>
         <xsl:with-param name="condition"
                         select="not(.=('Socketeer I','Socketeer II','LampSocket socket','MiniSock Deux','SprocketSocket','[Unlisted Socket Product]'))"/>
         <xsl:with-param name="msg" expand-text="true">
            <mx:code>{ string(.) }</mx:code>{ .[not(string(.))] ! ' (empty)' } does not appear among permitted (enumerated) values for <mx:gi>{ name() }</mx:gi>: <mx:code>Socketeer I|Socketeer II|LampSocket socket|MiniSock Deux|SprocketSocket|[Unlisted Socket Product]</mx:code>.</xsl:with-param>
         <xsl:with-param name="level" select="'ERROR'"/>
      </xsl:call-template>
      <xsl:next-match/>
   </xsl:template>
   <xsl:template priority="108"
                 mode="constraint-cascade"
                 match="computer/motherboard/ata-socket/(child::vendor/child::name)">
      <xsl:call-template name="notice">
         <xsl:with-param name="cf">gix.522</xsl:with-param>
         <xsl:with-param name="rule-id">ata-socket-rule_2</xsl:with-param>
         <xsl:with-param name="matching" as="xs:string">computer/motherboard/ata-socket/(child::vendor/child::name)</xsl:with-param>
         <xsl:with-param name="class">AVCV value-not-allowed</xsl:with-param>
         <xsl:with-param name="testing" as="xs:string">not(.=('Socketeer','LampSocket','MiniSock','SprocketSocket','[Unlisted Socket Vendor]'))</xsl:with-param>
         <xsl:with-param name="condition"
                         select="not(.=('Socketeer','LampSocket','MiniSock','SprocketSocket','[Unlisted Socket Vendor]'))"/>
         <xsl:with-param name="msg" expand-text="true">
            <mx:code>{ string(.) }</mx:code>{ .[not(string(.))] ! ' (empty)' } does not appear among permitted (enumerated) values for <mx:gi>{ name() }</mx:gi>: <mx:code>Socketeer|LampSocket|MiniSock|SprocketSocket|[Unlisted Socket Vendor]</mx:code>.</xsl:with-param>
         <xsl:with-param name="level" select="'ERROR'"/>
      </xsl:call-template>
      <xsl:next-match/>
   </xsl:template>
   <xsl:template priority="107"
                 mode="constraint-cascade"
                 match="computer/motherboard/ata-socket/(self::*[vendor/name='Socketeer']/product-name)">
      <xsl:call-template name="notice">
         <xsl:with-param name="cf">gix.522</xsl:with-param>
         <xsl:with-param name="rule-id">ata-socket-rule_3</xsl:with-param>
         <xsl:with-param name="matching" as="xs:string">computer/motherboard/ata-socket/(self::*[vendor/name='Socketeer']/product-name)</xsl:with-param>
         <xsl:with-param name="class">AVCV value-not-allowed</xsl:with-param>
         <xsl:with-param name="testing" as="xs:string">not(.=('Socketeer I','Socketeer II'))</xsl:with-param>
         <xsl:with-param name="condition" select="not(.=('Socketeer I','Socketeer II'))"/>
         <xsl:with-param name="msg" expand-text="true">
            <mx:code>{ string(.) }</mx:code>{ .[not(string(.))] ! ' (empty)' } does not appear among permitted (enumerated) values for <mx:gi>{ name() }</mx:gi>: <mx:code>Socketeer I|Socketeer II</mx:code>.</xsl:with-param>
         <xsl:with-param name="level" select="'ERROR'"/>
      </xsl:call-template>
      <xsl:next-match/>
   </xsl:template>
   <xsl:template priority="5" match="computer/motherboard/memory" mode="test">
      <xsl:apply-templates select="@*" mode="test"/>
      <xsl:call-template name="notice">
         <xsl:with-param name="cf">gix.347</xsl:with-param>
         <xsl:with-param name="class">EOOO element-out-of-order</xsl:with-param>
         <xsl:with-param name="testing" as="xs:string">exists(preceding-sibling::cooling | preceding-sibling::expansion-card)</xsl:with-param>
         <xsl:with-param name="condition"
                         select="exists(preceding-sibling::cooling | preceding-sibling::expansion-card)"/>
         <xsl:with-param name="msg">
            <mx:gi>memory</mx:gi> is unexpected following <mx:gi>cooling</mx:gi> or <mx:gi>expansion-card</mx:gi>.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="require-for-computer_..._motherboard_..._memory-assembly"/>
      <xsl:apply-templates mode="constraint-cascade" select="."/>
   </xsl:template>
   <xsl:template priority="5"
                 match="computer/motherboard/expansion-card"
                 mode="test">
      <xsl:apply-templates select="@*" mode="test"/>
      <xsl:call-template name="require-for-computer_..._motherboard_..._expansion-card-assembly"/>
      <xsl:apply-templates mode="constraint-cascade" select="."/>
   </xsl:template>
   <xsl:template priority="5" match="motherboard/cooling/fan" mode="test">
      <xsl:apply-templates select="@*" mode="test"/>
      <xsl:call-template name="notice">
         <xsl:with-param name="cf">gix.292</xsl:with-param>
         <xsl:with-param name="class">EATI element-appears-too-infrequently</xsl:with-param>
         <xsl:with-param name="testing" as="xs:string">empty(following-sibling::fan) and (count(. | preceding-sibling::fan) lt 2)</xsl:with-param>
         <xsl:with-param name="condition"
                         select="empty(following-sibling::fan) and (count(. | preceding-sibling::fan) lt 2)"/>
         <xsl:with-param name="msg">
            <mx:gi>fan</mx:gi> appears too few times: 2 minimum are required.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="notice">
         <xsl:with-param name="cf">gix.303</xsl:with-param>
         <xsl:with-param name="class">EATO element-appears-too-often</xsl:with-param>
         <xsl:with-param name="testing" as="xs:string">count(. | preceding-sibling::fan) gt 12</xsl:with-param>
         <xsl:with-param name="condition" select="count(. | preceding-sibling::fan) gt 12"/>
         <xsl:with-param name="msg">
            <mx:gi>fan</mx:gi> appears too many times: 12 maximum are permitted.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="notice">
         <xsl:with-param name="cf">gix.318</xsl:with-param>
         <xsl:with-param name="testing" as="xs:string">empty(preceding-sibling::fan) and exists(../(water))</xsl:with-param>
         <xsl:with-param name="condition"
                         select="empty(preceding-sibling::fan) and exists(../(water))"/>
         <xsl:with-param name="class">VEXC violates-exclusive-choice</xsl:with-param>
         <xsl:with-param name="msg">
            <mx:gi>fan</mx:gi> is unexpected along with <mx:gi>water</mx:gi>.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="require-for-cooling_..._fan-assembly"/>
      <xsl:apply-templates mode="constraint-cascade" select="."/>
   </xsl:template>
   <xsl:template priority="5" match="motherboard/cooling/water" mode="test">
      <xsl:apply-templates select="@*" mode="test"/>
      <xsl:call-template name="notice">
         <xsl:with-param name="cf">gix.303</xsl:with-param>
         <xsl:with-param name="class">EATO element-appears-too-often</xsl:with-param>
         <xsl:with-param name="testing" as="xs:string">count(. | preceding-sibling::water) gt 1</xsl:with-param>
         <xsl:with-param name="condition" select="count(. | preceding-sibling::water) gt 1"/>
         <xsl:with-param name="msg">
            <mx:gi>water</mx:gi> appears too many times: 1 maximum is permitted.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="notice">
         <xsl:with-param name="cf">gix.318</xsl:with-param>
         <xsl:with-param name="testing" as="xs:string">empty(preceding-sibling::water) and exists(../(fan))</xsl:with-param>
         <xsl:with-param name="condition"
                         select="empty(preceding-sibling::water) and exists(../(fan))"/>
         <xsl:with-param name="class">VEXC violates-exclusive-choice</xsl:with-param>
         <xsl:with-param name="msg">
            <mx:gi>water</mx:gi> is unexpected along with <mx:gi>fan</mx:gi>.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="require-for-cooling_..._water-assembly"/>
      <xsl:apply-templates mode="constraint-cascade" select="."/>
   </xsl:template>
   <xsl:template match="motherboard/cpu/product-name/text()" mode="test"/>
   <xsl:template priority="5" match="motherboard/cpu/product-name" mode="test">
      <xsl:apply-templates select="@*" mode="test"/>
      <xsl:call-template name="notice">
         <xsl:with-param name="cf">gix.303</xsl:with-param>
         <xsl:with-param name="class">EATO element-appears-too-often</xsl:with-param>
         <xsl:with-param name="testing" as="xs:string">count(. | preceding-sibling::product-name) gt 1</xsl:with-param>
         <xsl:with-param name="condition"
                         select="count(. | preceding-sibling::product-name) gt 1"/>
         <xsl:with-param name="msg">
            <mx:gi>product-name</mx:gi> appears too many times: 1 maximum is permitted.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="notice">
         <xsl:with-param name="cf">gix.347</xsl:with-param>
         <xsl:with-param name="class">EOOO element-out-of-order</xsl:with-param>
         <xsl:with-param name="testing" as="xs:string">exists(preceding-sibling::architecture | preceding-sibling::speed)</xsl:with-param>
         <xsl:with-param name="condition"
                         select="exists(preceding-sibling::architecture | preceding-sibling::speed)"/>
         <xsl:with-param name="msg">
            <mx:gi>product-name</mx:gi> is unexpected following <mx:gi>architecture</mx:gi> or <mx:gi>speed</mx:gi>.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="require-for-product-name-field"/>
      <xsl:apply-templates mode="constraint-cascade" select="."/>
   </xsl:template>
   <xsl:template match="motherboard/ata-socket/product-name/text()" mode="test"/>
   <xsl:template priority="5"
                 match="motherboard/ata-socket/product-name"
                 mode="test">
      <xsl:apply-templates select="@*" mode="test"/>
      <xsl:call-template name="notice">
         <xsl:with-param name="cf">gix.303</xsl:with-param>
         <xsl:with-param name="class">EATO element-appears-too-often</xsl:with-param>
         <xsl:with-param name="testing" as="xs:string">count(. | preceding-sibling::product-name) gt 1</xsl:with-param>
         <xsl:with-param name="condition"
                         select="count(. | preceding-sibling::product-name) gt 1"/>
         <xsl:with-param name="msg">
            <mx:gi>product-name</mx:gi> appears too many times: 1 maximum is permitted.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="notice">
         <xsl:with-param name="cf">gix.347</xsl:with-param>
         <xsl:with-param name="class">EOOO element-out-of-order</xsl:with-param>
         <xsl:with-param name="testing" as="xs:string">exists(preceding-sibling::type)</xsl:with-param>
         <xsl:with-param name="condition" select="exists(preceding-sibling::type)"/>
         <xsl:with-param name="msg">
            <mx:gi>product-name</mx:gi> is unexpected following <mx:gi>type</mx:gi>.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="require-for-product-name-field"/>
      <xsl:apply-templates mode="constraint-cascade" select="."/>
   </xsl:template>
   <xsl:template match="motherboard/memory/product-name/text()" mode="test"/>
   <xsl:template priority="5" match="motherboard/memory/product-name" mode="test">
      <xsl:apply-templates select="@*" mode="test"/>
      <xsl:call-template name="notice">
         <xsl:with-param name="cf">gix.303</xsl:with-param>
         <xsl:with-param name="class">EATO element-appears-too-often</xsl:with-param>
         <xsl:with-param name="testing" as="xs:string">count(. | preceding-sibling::product-name) gt 1</xsl:with-param>
         <xsl:with-param name="condition"
                         select="count(. | preceding-sibling::product-name) gt 1"/>
         <xsl:with-param name="msg">
            <mx:gi>product-name</mx:gi> appears too many times: 1 maximum is permitted.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="notice">
         <xsl:with-param name="cf">gix.347</xsl:with-param>
         <xsl:with-param name="class">EOOO element-out-of-order</xsl:with-param>
         <xsl:with-param name="testing" as="xs:string">exists(preceding-sibling::byte-size)</xsl:with-param>
         <xsl:with-param name="condition" select="exists(preceding-sibling::byte-size)"/>
         <xsl:with-param name="msg">
            <mx:gi>product-name</mx:gi> is unexpected following <mx:gi>byte-size</mx:gi>.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="require-for-product-name-field"/>
      <xsl:apply-templates mode="constraint-cascade" select="."/>
   </xsl:template>
   <xsl:template match="motherboard/expansion-card/product-name/text()" mode="test"/>
   <xsl:template priority="5"
                 match="motherboard/expansion-card/product-name"
                 mode="test">
      <xsl:apply-templates select="@*" mode="test"/>
      <xsl:call-template name="notice">
         <xsl:with-param name="cf">gix.303</xsl:with-param>
         <xsl:with-param name="class">EATO element-appears-too-often</xsl:with-param>
         <xsl:with-param name="testing" as="xs:string">count(. | preceding-sibling::product-name) gt 1</xsl:with-param>
         <xsl:with-param name="condition"
                         select="count(. | preceding-sibling::product-name) gt 1"/>
         <xsl:with-param name="msg">
            <mx:gi>product-name</mx:gi> appears too many times: 1 maximum is permitted.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="notice">
         <xsl:with-param name="cf">gix.347</xsl:with-param>
         <xsl:with-param name="class">EOOO element-out-of-order</xsl:with-param>
         <xsl:with-param name="testing" as="xs:string">exists(preceding-sibling::type)</xsl:with-param>
         <xsl:with-param name="condition" select="exists(preceding-sibling::type)"/>
         <xsl:with-param name="msg">
            <mx:gi>product-name</mx:gi> is unexpected following <mx:gi>type</mx:gi>.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="require-for-product-name-field"/>
      <xsl:apply-templates mode="constraint-cascade" select="."/>
   </xsl:template>
   <xsl:template match="motherboard/vendor/name/text() | cpu/vendor/name/text() | ata-socket/vendor/name/text() | memory/vendor/name/text() | expansion-card/vendor/name/text()"
                 mode="test"/>
   <xsl:template priority="5"
                 match="motherboard/vendor/name | cpu/vendor/name | ata-socket/vendor/name | memory/vendor/name | expansion-card/vendor/name"
                 mode="test">
      <xsl:apply-templates select="@*" mode="test"/>
      <xsl:call-template name="notice">
         <xsl:with-param name="cf">gix.303</xsl:with-param>
         <xsl:with-param name="class">EATO element-appears-too-often</xsl:with-param>
         <xsl:with-param name="testing" as="xs:string">count(. | preceding-sibling::name) gt 1</xsl:with-param>
         <xsl:with-param name="condition" select="count(. | preceding-sibling::name) gt 1"/>
         <xsl:with-param name="msg">
            <mx:gi>name</mx:gi> appears too many times: 1 maximum is permitted.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="notice">
         <xsl:with-param name="cf">gix.347</xsl:with-param>
         <xsl:with-param name="class">EOOO element-out-of-order</xsl:with-param>
         <xsl:with-param name="testing" as="xs:string">exists(preceding-sibling::address | preceding-sibling::website)</xsl:with-param>
         <xsl:with-param name="condition"
                         select="exists(preceding-sibling::address | preceding-sibling::website)"/>
         <xsl:with-param name="msg">
            <mx:gi>name</mx:gi> is unexpected following <mx:gi>address</mx:gi> or <mx:gi>website</mx:gi>.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="require-for-vendor_..._name-field"/>
      <xsl:apply-templates mode="constraint-cascade" select="."/>
   </xsl:template>
   <xsl:template match="motherboard/vendor/address/text() | cpu/vendor/address/text() | ata-socket/vendor/address/text() | memory/vendor/address/text() | expansion-card/vendor/address/text()"
                 mode="test"/>
   <xsl:template priority="5"
                 match="motherboard/vendor/address | cpu/vendor/address | ata-socket/vendor/address | memory/vendor/address | expansion-card/vendor/address"
                 mode="test">
      <xsl:apply-templates select="@*" mode="test"/>
      <xsl:call-template name="notice">
         <xsl:with-param name="cf">gix.303</xsl:with-param>
         <xsl:with-param name="class">EATO element-appears-too-often</xsl:with-param>
         <xsl:with-param name="testing" as="xs:string">count(. | preceding-sibling::address) gt 1</xsl:with-param>
         <xsl:with-param name="condition" select="count(. | preceding-sibling::address) gt 1"/>
         <xsl:with-param name="msg">
            <mx:gi>address</mx:gi> appears too many times: 1 maximum is permitted.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="notice">
         <xsl:with-param name="cf">gix.347</xsl:with-param>
         <xsl:with-param name="class">EOOO element-out-of-order</xsl:with-param>
         <xsl:with-param name="testing" as="xs:string">exists(preceding-sibling::website)</xsl:with-param>
         <xsl:with-param name="condition" select="exists(preceding-sibling::website)"/>
         <xsl:with-param name="msg">
            <mx:gi>address</mx:gi> is unexpected following <mx:gi>website</mx:gi>.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="require-for-vendor_..._address-field"/>
      <xsl:apply-templates mode="constraint-cascade" select="."/>
   </xsl:template>
   <xsl:template match="motherboard/vendor/website/text() | cpu/vendor/website/text() | ata-socket/vendor/website/text() | memory/vendor/website/text() | expansion-card/vendor/website/text()"
                 mode="test"/>
   <xsl:template priority="5"
                 match="motherboard/vendor/website | cpu/vendor/website | ata-socket/vendor/website | memory/vendor/website | expansion-card/vendor/website"
                 mode="test">
      <xsl:apply-templates select="@*" mode="test"/>
      <xsl:call-template name="notice">
         <xsl:with-param name="cf">gix.303</xsl:with-param>
         <xsl:with-param name="class">EATO element-appears-too-often</xsl:with-param>
         <xsl:with-param name="testing" as="xs:string">count(. | preceding-sibling::website) gt 1</xsl:with-param>
         <xsl:with-param name="condition" select="count(. | preceding-sibling::website) gt 1"/>
         <xsl:with-param name="msg">
            <mx:gi>website</mx:gi> appears too many times: 1 maximum is permitted.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="require-for-vendor_..._website-field"/>
      <xsl:apply-templates mode="constraint-cascade" select="."/>
   </xsl:template>
   <xsl:template match="computer/motherboard/type/text()" mode="test"/>
   <xsl:template priority="5" match="computer/motherboard/type" mode="test">
      <xsl:apply-templates select="@*" mode="test"/>
      <xsl:call-template name="notice">
         <xsl:with-param name="cf">gix.303</xsl:with-param>
         <xsl:with-param name="class">EATO element-appears-too-often</xsl:with-param>
         <xsl:with-param name="testing" as="xs:string">count(. | preceding-sibling::type) gt 1</xsl:with-param>
         <xsl:with-param name="condition" select="count(. | preceding-sibling::type) gt 1"/>
         <xsl:with-param name="msg">
            <mx:gi>type</mx:gi> appears too many times: 1 maximum is permitted.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="notice">
         <xsl:with-param name="cf">gix.347</xsl:with-param>
         <xsl:with-param name="class">EOOO element-out-of-order</xsl:with-param>
         <xsl:with-param name="testing" as="xs:string">exists(preceding-sibling::cpu | preceding-sibling::ata-socket | preceding-sibling::memory | preceding-sibling::cooling | preceding-sibling::expansion-card)</xsl:with-param>
         <xsl:with-param name="condition"
                         select="exists(preceding-sibling::cpu | preceding-sibling::ata-socket | preceding-sibling::memory | preceding-sibling::cooling | preceding-sibling::expansion-card)"/>
         <xsl:with-param name="msg">
            <mx:gi>type</mx:gi> is unexpected following <mx:gi>cpu</mx:gi>, <mx:gi>ata-socket</mx:gi>, <mx:gi>memory</mx:gi>, <mx:gi>cooling</mx:gi>, or <mx:gi>expansion-card</mx:gi>.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="require-for-computer_..._motherboard_..._type-field"/>
      <xsl:apply-templates mode="constraint-cascade" select="."/>
   </xsl:template>
   <xsl:template priority="111"
                 mode="constraint-cascade"
                 match="computer/motherboard/type">
      <xsl:call-template name="notice">
         <xsl:with-param name="cf">gix.522</xsl:with-param>
         <xsl:with-param name="rule-id">motherboard-type-rule_1</xsl:with-param>
         <xsl:with-param name="matching" as="xs:string">computer/motherboard/type</xsl:with-param>
         <xsl:with-param name="class">AVCV value-not-allowed</xsl:with-param>
         <xsl:with-param name="testing" as="xs:string">not(.=('at','atx','mini-itx','custom'))</xsl:with-param>
         <xsl:with-param name="condition" select="not(.=('at','atx','mini-itx','custom'))"/>
         <xsl:with-param name="msg" expand-text="true">
            <mx:code>{ string(.) }</mx:code>{ .[not(string(.))] ! ' (empty)' } does not appear among permitted (enumerated) values for <mx:gi>{ name() }</mx:gi>: <mx:code>at|atx|mini-itx|custom</mx:code>.</xsl:with-param>
         <xsl:with-param name="level" select="'ERROR'"/>
      </xsl:call-template>
      <xsl:next-match/>
   </xsl:template>
   <xsl:template match="motherboard/cpu/architecture/text()" mode="test"/>
   <xsl:template priority="5" match="motherboard/cpu/architecture" mode="test">
      <xsl:apply-templates select="@*" mode="test"/>
      <xsl:call-template name="notice">
         <xsl:with-param name="cf">gix.303</xsl:with-param>
         <xsl:with-param name="class">EATO element-appears-too-often</xsl:with-param>
         <xsl:with-param name="testing" as="xs:string">count(. | preceding-sibling::architecture) gt 1</xsl:with-param>
         <xsl:with-param name="condition"
                         select="count(. | preceding-sibling::architecture) gt 1"/>
         <xsl:with-param name="msg">
            <mx:gi>architecture</mx:gi> appears too many times: 1 maximum is permitted.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="notice">
         <xsl:with-param name="cf">gix.347</xsl:with-param>
         <xsl:with-param name="class">EOOO element-out-of-order</xsl:with-param>
         <xsl:with-param name="testing" as="xs:string">exists(preceding-sibling::speed)</xsl:with-param>
         <xsl:with-param name="condition" select="exists(preceding-sibling::speed)"/>
         <xsl:with-param name="msg">
            <mx:gi>architecture</mx:gi> is unexpected following <mx:gi>speed</mx:gi>.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="require-for-computer_..._motherboard_..._cpu_..._architecture-field"/>
      <xsl:apply-templates mode="constraint-cascade" select="."/>
   </xsl:template>
   <xsl:template match="motherboard/cpu/speed/text()" mode="test"/>
   <xsl:template priority="5" match="motherboard/cpu/speed" mode="test">
      <xsl:apply-templates select="@*" mode="test"/>
      <xsl:call-template name="notice">
         <xsl:with-param name="cf">gix.303</xsl:with-param>
         <xsl:with-param name="class">EATO element-appears-too-often</xsl:with-param>
         <xsl:with-param name="testing" as="xs:string">count(. | preceding-sibling::speed) gt 1</xsl:with-param>
         <xsl:with-param name="condition" select="count(. | preceding-sibling::speed) gt 1"/>
         <xsl:with-param name="msg">
            <mx:gi>speed</mx:gi> appears too many times: 1 maximum is permitted.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="require-for-computer_..._motherboard_..._cpu_..._speed-field"/>
      <xsl:apply-templates mode="constraint-cascade" select="."/>
   </xsl:template>
   <xsl:template priority="110"
                 mode="constraint-cascade"
                 match="motherboard/cpu/speed">
      <xsl:call-template name="notice">
         <xsl:with-param name="cf">gix.558</xsl:with-param>
         <xsl:with-param name="rule-id">cpu-speed-rule_1</xsl:with-param>
         <xsl:with-param name="matching" as="xs:string">motherboard/cpu/speed</xsl:with-param>
         <xsl:with-param name="class">MRCV regex-match-fail</xsl:with-param>
         <xsl:with-param name="testing" as="xs:string">not( matches(., '^\d+(\.\d+)?(M|G)Hz$') )</xsl:with-param>
         <xsl:with-param name="condition" select="not(matches(., '^\d+(\.\d+)?(M|G)Hz$'))"/>
         <xsl:with-param name="msg" expand-text="true">
            <mx:code>{ string(.) }</mx:code>{ string(.)[not(.)] ! ' (empty)' } does not match the regular expression defined for this <mx:gi>{ name() }</mx:gi>: <mx:code>\d+(\.\d+)?(M|G)Hz</mx:code>.</xsl:with-param>
      </xsl:call-template>
      <xsl:next-match/>
   </xsl:template>
   <xsl:template match="motherboard/ata-socket/type/text()" mode="test"/>
   <xsl:template priority="5" match="motherboard/ata-socket/type" mode="test">
      <xsl:apply-templates select="@*" mode="test"/>
      <xsl:call-template name="notice">
         <xsl:with-param name="cf">gix.303</xsl:with-param>
         <xsl:with-param name="class">EATO element-appears-too-often</xsl:with-param>
         <xsl:with-param name="testing" as="xs:string">count(. | preceding-sibling::type) gt 1</xsl:with-param>
         <xsl:with-param name="condition" select="count(. | preceding-sibling::type) gt 1"/>
         <xsl:with-param name="msg">
            <mx:gi>type</mx:gi> appears too many times: 1 maximum is permitted.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="require-for-computer_..._motherboard_..._ata-socket_..._type-field"/>
      <xsl:apply-templates mode="constraint-cascade" select="."/>
   </xsl:template>
   <xsl:template match="motherboard/memory/byte-size/text()" mode="test"/>
   <xsl:template priority="5" match="motherboard/memory/byte-size" mode="test">
      <xsl:apply-templates select="@*" mode="test"/>
      <xsl:call-template name="notice">
         <xsl:with-param name="cf">gix.303</xsl:with-param>
         <xsl:with-param name="class">EATO element-appears-too-often</xsl:with-param>
         <xsl:with-param name="testing" as="xs:string">count(. | preceding-sibling::byte-size) gt 1</xsl:with-param>
         <xsl:with-param name="condition" select="count(. | preceding-sibling::byte-size) gt 1"/>
         <xsl:with-param name="msg">
            <mx:gi>byte-size</mx:gi> appears too many times: 1 maximum is permitted.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="require-for-computer_..._motherboard_..._memory_..._byte-size-field"/>
      <xsl:apply-templates mode="constraint-cascade" select="."/>
   </xsl:template>
   <xsl:template priority="106"
                 mode="constraint-cascade"
                 match="motherboard/memory/byte-size">
      <xsl:call-template name="notice">
         <xsl:with-param name="cf">gix.588</xsl:with-param>
         <xsl:with-param name="rule-id">byte-size-test_1</xsl:with-param>
         <xsl:with-param name="matching" as="xs:string">motherboard/memory/byte-size</xsl:with-param>
         <xsl:with-param name="class">XPKT expectation-violation</xsl:with-param>
         <xsl:with-param name="testing" as="xs:string">not((number(.) &gt; 0) and not(. mod 256))</xsl:with-param>
         <xsl:with-param name="condition" select="not((number(.) &gt; 0) and not(. mod 256))"/>
         <xsl:with-param name="msg" expand-text="true">Expression result for <mx:gi>motherboard/memory/byte-size</mx:gi> does not conform to expectation <mx:code>(number(.) &gt; 0) and not(. mod 256)</mx:code>.</xsl:with-param>
      </xsl:call-template>
      <xsl:next-match/>
   </xsl:template>
   <xsl:template match="motherboard/expansion-card/type/text()" mode="test"/>
   <xsl:template priority="5" match="motherboard/expansion-card/type" mode="test">
      <xsl:apply-templates select="@*" mode="test"/>
      <xsl:call-template name="notice">
         <xsl:with-param name="cf">gix.303</xsl:with-param>
         <xsl:with-param name="class">EATO element-appears-too-often</xsl:with-param>
         <xsl:with-param name="testing" as="xs:string">count(. | preceding-sibling::type) gt 1</xsl:with-param>
         <xsl:with-param name="condition" select="count(. | preceding-sibling::type) gt 1"/>
         <xsl:with-param name="msg">
            <mx:gi>type</mx:gi> appears too many times: 1 maximum is permitted.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="require-for-computer_..._motherboard_..._expansion-card_..._type-field"/>
      <xsl:apply-templates mode="constraint-cascade" select="."/>
   </xsl:template>
   <xsl:template match="/computer/@date-of-manufacture" mode="test">
      <xsl:call-template name="require-for-date-of-manufacture-flag"/>
      <xsl:apply-templates mode="constraint-cascade" select="."/>
   </xsl:template>
   <xsl:template match="motherboard/vendor/@id | cpu/vendor/@id | ata-socket/vendor/@id | memory/vendor/@id | expansion-card/vendor/@id"
                 mode="test">
      <xsl:call-template name="require-for-vendor_..._id-flag"/>
      <xsl:apply-templates mode="constraint-cascade" select="."/>
   </xsl:template>
   <xsl:template match="/computer/@id" mode="test">
      <xsl:call-template name="require-for-computer_..._id-flag"/>
      <xsl:apply-templates mode="constraint-cascade" select="."/>
   </xsl:template>
   <xsl:template priority="112" mode="constraint-cascade" match="/computer/@id">
      <xsl:call-template name="notice">
         <xsl:with-param name="cf">gix.558</xsl:with-param>
         <xsl:with-param name="rule-id">id-naming-rule_1</xsl:with-param>
         <xsl:with-param name="matching" as="xs:string">/computer/@id</xsl:with-param>
         <xsl:with-param name="class">MRCV regex-match-fail</xsl:with-param>
         <xsl:with-param name="testing" as="xs:string">not( matches(., '^\i\c*$') )</xsl:with-param>
         <xsl:with-param name="condition" select="not(matches(., '^\i\c*$'))"/>
         <xsl:with-param name="msg" expand-text="true">
            <mx:code>{ string(.) }</mx:code>{ string(.)[not(.)] ! ' (empty)' } does not match the regular expression defined for this <mx:gi>{ name() }</mx:gi>: <mx:code>\i\c*</mx:code>.</xsl:with-param>
      </xsl:call-template>
      <xsl:next-match/>
   </xsl:template>
   <xsl:template match="motherboard/expansion-card/@state" mode="test">
      <xsl:call-template name="require-for-computer_..._motherboard_..._expansion-card_..._state-flag"/>
      <xsl:apply-templates mode="constraint-cascade" select="."/>
   </xsl:template>
   <xsl:template priority="105"
                 mode="constraint-cascade"
                 match="motherboard/expansion-card/@state">
      <xsl:call-template name="notice">
         <xsl:with-param name="cf">gix.522</xsl:with-param>
         <xsl:with-param name="rule-id">expansion-card-state-rule_1</xsl:with-param>
         <xsl:with-param name="matching" as="xs:string">motherboard/expansion-card/@state</xsl:with-param>
         <xsl:with-param name="class">AVCV value-not-allowed</xsl:with-param>
         <xsl:with-param name="testing" as="xs:string">not(.=('new','refurb','inoperative'))</xsl:with-param>
         <xsl:with-param name="condition" select="not(.=('new','refurb','inoperative'))"/>
         <xsl:with-param name="msg" expand-text="true">
            <mx:code>{ string(.) }</mx:code>{ .[not(string(.))] ! ' (empty)' } does not appear among permitted (enumerated) values for <mx:gi>{ name() }</mx:gi>: <mx:code>new|refurb|inoperative</mx:code>.</xsl:with-param>
         <xsl:with-param name="level" select="'ERROR'"/>
      </xsl:call-template>
      <xsl:next-match/>
   </xsl:template>
   <xsl:template match="cooling/water/@illuminated" mode="test">
      <xsl:call-template name="require-for-cooling_..._water_..._illuminated-flag"/>
      <xsl:apply-templates mode="constraint-cascade" select="."/>
   </xsl:template>
   <!-- .     .     .     .     .     .     .     .     .     .     .     .     .     .     .     .     . -->
   <!--     Fallbacks for occurrences of known elements and attributes, except out of
               context     -->
   <!-- .     .     .     .     .     .     .     .     .     .     .     .     .     .     .     .     . -->
   <xsl:template mode="test"
                 match="name | address | website | computer | motherboard | vendor | type | cpu | product-name | architecture | speed | ata-socket | memory | byte-size | cooling | expansion-card | fan | water">
      <xsl:call-template name="notice">
         <xsl:with-param name="cf" as="xs:string">gix.73</xsl:with-param>
         <xsl:with-param name="class">EOOP element-out-of-place</xsl:with-param>
         <xsl:with-param name="msg" expand-text="true">
            <mx:gi>{ name() }</mx:gi> is not permitted here.</xsl:with-param>
      </xsl:call-template>
   </xsl:template>
   <xsl:template mode="test" match="@id | @date-of-manufacture | @state | @illuminated">
      <xsl:call-template name="notice">
         <xsl:with-param name="cf" as="xs:string">gix.82</xsl:with-param>
         <xsl:with-param name="class">AOOP attribute-out-of-place</xsl:with-param>
         <xsl:with-param name="msg" expand-text="true">
            <mx:gi>@{ name() }</mx:gi> is not permitted here.</xsl:with-param>
      </xsl:call-template>
   </xsl:template>
   <!-- .     .     .     .     .     .     .     .     .     .     .     .     .     .     .     .     . -->
   <!--     Definitions - a named template for each     -->
   <!-- .     .     .     .     .     .     .     .     .     .     .     .     .     .     .     .     . -->
   <xsl:template name="require-for-vendor-assembly">
      <xsl:call-template name="notice">
         <xsl:with-param name="cf">gix.617</xsl:with-param>
         <xsl:with-param name="class">MRQA missing-required-attribute</xsl:with-param>
         <xsl:with-param name="testing" as="xs:string">empty(@id)</xsl:with-param>
         <xsl:with-param name="condition" select="empty(@id)"/>
         <xsl:with-param name="msg" expand-text="true">
            <mx:gi>{ name() }</mx:gi> requires <mx:gi>@id</mx:gi>.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="notice">
         <xsl:with-param name="cf">gix.415</xsl:with-param>
         <xsl:with-param name="class">MRQC missing-required-contents</xsl:with-param>
         <xsl:with-param name="testing" as="xs:string">empty(name)</xsl:with-param>
         <xsl:with-param name="condition" select="empty(name)"/>
         <xsl:with-param name="msg" expand-text="true">
            <mx:gi>{ name() }</mx:gi> requires element <mx:gi>name</mx:gi>.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="notice">
         <xsl:with-param name="cf">gix.415</xsl:with-param>
         <xsl:with-param name="class">MRQC missing-required-contents</xsl:with-param>
         <xsl:with-param name="testing" as="xs:string">empty(address)</xsl:with-param>
         <xsl:with-param name="condition" select="empty(address)"/>
         <xsl:with-param name="msg" expand-text="true">
            <mx:gi>{ name() }</mx:gi> requires element <mx:gi>address</mx:gi>.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="notice">
         <xsl:with-param name="cf">gix.415</xsl:with-param>
         <xsl:with-param name="class">MRQC missing-required-contents</xsl:with-param>
         <xsl:with-param name="testing" as="xs:string">empty(website)</xsl:with-param>
         <xsl:with-param name="condition" select="empty(website)"/>
         <xsl:with-param name="msg" expand-text="true">
            <mx:gi>{ name() }</mx:gi> requires element <mx:gi>website</mx:gi>.</xsl:with-param>
      </xsl:call-template>
   </xsl:template>
   <xsl:template name="require-for-vendor_..._id-flag"/>
   <xsl:template name="require-for-vendor_..._name-field"/>
   <xsl:template name="require-for-vendor_..._address-field"/>
   <xsl:template name="require-for-vendor_..._website-field">
      <xsl:call-template name="check-uri-datatype"/>
   </xsl:template>
   <xsl:template name="require-for-date-of-manufacture-flag"/>
   <xsl:template name="require-for-product-name-field"/>
   <xsl:template name="require-for-computer-assembly">
      <xsl:call-template name="notice">
         <xsl:with-param name="cf">gix.617</xsl:with-param>
         <xsl:with-param name="class">MRQA missing-required-attribute</xsl:with-param>
         <xsl:with-param name="testing" as="xs:string">empty(@id)</xsl:with-param>
         <xsl:with-param name="condition" select="empty(@id)"/>
         <xsl:with-param name="msg" expand-text="true">
            <mx:gi>{ name() }</mx:gi> requires <mx:gi>@id</mx:gi>.</xsl:with-param>
      </xsl:call-template>
   </xsl:template>
   <xsl:template name="require-for-computer_..._id-flag"/>
   <xsl:template name="require-for-computer_..._motherboard-assembly">
      <xsl:call-template name="notice">
         <xsl:with-param name="cf">gix.415</xsl:with-param>
         <xsl:with-param name="class">MRQC missing-required-contents</xsl:with-param>
         <xsl:with-param name="testing" as="xs:string">empty(type)</xsl:with-param>
         <xsl:with-param name="condition" select="empty(type)"/>
         <xsl:with-param name="msg" expand-text="true">
            <mx:gi>{ name() }</mx:gi> requires element <mx:gi>type</mx:gi>.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="notice">
         <xsl:with-param name="cf">gix.415</xsl:with-param>
         <xsl:with-param name="class">MRQC missing-required-contents</xsl:with-param>
         <xsl:with-param name="testing" as="xs:string">empty(memory)</xsl:with-param>
         <xsl:with-param name="condition" select="empty(memory)"/>
         <xsl:with-param name="msg" expand-text="true">
            <mx:gi>{ name() }</mx:gi> requires element <mx:gi>memory</mx:gi>.</xsl:with-param>
      </xsl:call-template>
   </xsl:template>
   <xsl:template name="require-for-computer_..._motherboard_..._type-field"/>
   <xsl:template name="require-for-computer_..._motherboard_..._cpu-assembly">
      <xsl:call-template name="notice">
         <xsl:with-param name="cf">gix.415</xsl:with-param>
         <xsl:with-param name="class">MRQC missing-required-contents</xsl:with-param>
         <xsl:with-param name="testing" as="xs:string">empty(product-name)</xsl:with-param>
         <xsl:with-param name="condition" select="empty(product-name)"/>
         <xsl:with-param name="msg" expand-text="true">
            <mx:gi>{ name() }</mx:gi> requires element <mx:gi>product-name</mx:gi>.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="notice">
         <xsl:with-param name="cf">gix.415</xsl:with-param>
         <xsl:with-param name="class">MRQC missing-required-contents</xsl:with-param>
         <xsl:with-param name="testing" as="xs:string">empty(architecture)</xsl:with-param>
         <xsl:with-param name="condition" select="empty(architecture)"/>
         <xsl:with-param name="msg" expand-text="true">
            <mx:gi>{ name() }</mx:gi> requires element <mx:gi>architecture</mx:gi>.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="notice">
         <xsl:with-param name="cf">gix.415</xsl:with-param>
         <xsl:with-param name="class">MRQC missing-required-contents</xsl:with-param>
         <xsl:with-param name="testing" as="xs:string">empty(speed)</xsl:with-param>
         <xsl:with-param name="condition" select="empty(speed)"/>
         <xsl:with-param name="msg" expand-text="true">
            <mx:gi>{ name() }</mx:gi> requires element <mx:gi>speed</mx:gi>.</xsl:with-param>
      </xsl:call-template>
   </xsl:template>
   <xsl:template name="require-for-computer_..._motherboard_..._cpu_..._architecture-field"/>
   <xsl:template name="require-for-computer_..._motherboard_..._cpu_..._speed-field"/>
   <xsl:template name="require-for-computer_..._motherboard_..._ata-socket-assembly">
      <xsl:call-template name="notice">
         <xsl:with-param name="cf">gix.415</xsl:with-param>
         <xsl:with-param name="class">MRQC missing-required-contents</xsl:with-param>
         <xsl:with-param name="testing" as="xs:string">empty(product-name)</xsl:with-param>
         <xsl:with-param name="condition" select="empty(product-name)"/>
         <xsl:with-param name="msg" expand-text="true">
            <mx:gi>{ name() }</mx:gi> requires element <mx:gi>product-name</mx:gi>.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="notice">
         <xsl:with-param name="cf">gix.415</xsl:with-param>
         <xsl:with-param name="class">MRQC missing-required-contents</xsl:with-param>
         <xsl:with-param name="testing" as="xs:string">empty(type)</xsl:with-param>
         <xsl:with-param name="condition" select="empty(type)"/>
         <xsl:with-param name="msg" expand-text="true">
            <mx:gi>{ name() }</mx:gi> requires element <mx:gi>type</mx:gi>.</xsl:with-param>
      </xsl:call-template>
   </xsl:template>
   <xsl:template name="require-for-computer_..._motherboard_..._ata-socket_..._type-field"/>
   <xsl:template name="require-for-computer_..._motherboard_..._memory-assembly">
      <xsl:call-template name="notice">
         <xsl:with-param name="cf">gix.415</xsl:with-param>
         <xsl:with-param name="class">MRQC missing-required-contents</xsl:with-param>
         <xsl:with-param name="testing" as="xs:string">empty(product-name)</xsl:with-param>
         <xsl:with-param name="condition" select="empty(product-name)"/>
         <xsl:with-param name="msg" expand-text="true">
            <mx:gi>{ name() }</mx:gi> requires element <mx:gi>product-name</mx:gi>.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="notice">
         <xsl:with-param name="cf">gix.415</xsl:with-param>
         <xsl:with-param name="class">MRQC missing-required-contents</xsl:with-param>
         <xsl:with-param name="testing" as="xs:string">empty(byte-size)</xsl:with-param>
         <xsl:with-param name="condition" select="empty(byte-size)"/>
         <xsl:with-param name="msg" expand-text="true">
            <mx:gi>{ name() }</mx:gi> requires element <mx:gi>byte-size</mx:gi>.</xsl:with-param>
      </xsl:call-template>
   </xsl:template>
   <xsl:template name="require-for-computer_..._motherboard_..._memory_..._byte-size-field">
      <xsl:call-template name="check-positive-integer-datatype"/>
   </xsl:template>
   <xsl:template name="require-for-computer_..._motherboard_..._expansion-card-assembly">
      <xsl:call-template name="notice">
         <xsl:with-param name="cf">gix.415</xsl:with-param>
         <xsl:with-param name="class">MRQC missing-required-contents</xsl:with-param>
         <xsl:with-param name="testing" as="xs:string">empty(product-name)</xsl:with-param>
         <xsl:with-param name="condition" select="empty(product-name)"/>
         <xsl:with-param name="msg" expand-text="true">
            <mx:gi>{ name() }</mx:gi> requires element <mx:gi>product-name</mx:gi>.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="notice">
         <xsl:with-param name="cf">gix.415</xsl:with-param>
         <xsl:with-param name="class">MRQC missing-required-contents</xsl:with-param>
         <xsl:with-param name="testing" as="xs:string">empty(type)</xsl:with-param>
         <xsl:with-param name="condition" select="empty(type)"/>
         <xsl:with-param name="msg" expand-text="true">
            <mx:gi>{ name() }</mx:gi> requires element <mx:gi>type</mx:gi>.</xsl:with-param>
      </xsl:call-template>
   </xsl:template>
   <xsl:template name="require-for-computer_..._motherboard_..._expansion-card_..._state-flag"/>
   <xsl:template name="require-for-computer_..._motherboard_..._expansion-card_..._type-field"/>
   <xsl:template name="require-for-cooling-assembly">
      <xsl:call-template name="notice">
         <xsl:with-param name="cf">gix.415</xsl:with-param>
         <xsl:with-param name="class">MRQC missing-required-contents</xsl:with-param>
         <xsl:with-param name="testing" as="xs:string">empty(fan|water)</xsl:with-param>
         <xsl:with-param name="condition" select="empty(fan|water)"/>
         <xsl:with-param name="msg" expand-text="true">
            <mx:gi>{ name() }</mx:gi> requires element <mx:gi>fan|water</mx:gi>.</xsl:with-param>
      </xsl:call-template>
   </xsl:template>
   <xsl:template name="require-for-cooling_..._fan-assembly"/>
   <xsl:template name="require-for-cooling_..._water-assembly"/>
   <xsl:template name="require-for-cooling_..._water_..._illuminated-flag">
      <xsl:call-template name="check-boolean-datatype"/>
   </xsl:template>
   <!-- .     .     .     .     .     .     .     .     .     .     .     .     .     .     .     .     . -->
   <!--     Datatypes - a named template for each occurring     -->
   <!-- .     .     .     .     .     .     .     .     .     .     .     .     .     .     .     .     . -->
   <xsl:template name="check-string-datatype">
      <xsl:param name="rule-id" as="xs:string*" select="()"/>
      <xsl:param name="class" as="xs:string">VDSX violates-datatype-syntax</xsl:param>
      <xsl:param name="matching" as="xs:string?" select="()"/>
      <xsl:call-template name="notice">
         <xsl:with-param name="cf" as="xs:string">gix.113</xsl:with-param>
         <xsl:with-param name="rule-id" as="xs:string*" select="$rule-id"/>
         <xsl:with-param name="matching"
                         as="xs:string"
                         select="($matching[matches(.,'\S')],'*')[1]"/>
         <xsl:with-param name="class" as="xs:string" expand-text="true">{ $class }</xsl:with-param>
         <xsl:with-param name="testing" as="xs:string">not(string(.) castable as xs:string and matches(.,'^\S(.*\S)?$'))</xsl:with-param>
         <xsl:with-param name="condition"
                         select="not(string(.) castable as xs:string and matches(.,'^\S(.*\S)?$'))"/>
         <xsl:with-param name="msg" expand-text="true">
            <mx:gi>{ name(.) }</mx:gi> value <mx:code>{ string(.) }</mx:code> does not conform to <mx:code>string</mx:code> datatype.</xsl:with-param>
      </xsl:call-template>
   </xsl:template>
   <xsl:template name="check-uri-datatype">
      <xsl:param name="rule-id" as="xs:string*" select="()"/>
      <xsl:param name="class" as="xs:string">VDSX violates-datatype-syntax</xsl:param>
      <xsl:param name="matching" as="xs:string?" select="()"/>
      <xsl:call-template name="notice">
         <xsl:with-param name="cf" as="xs:string">gix.113</xsl:with-param>
         <xsl:with-param name="rule-id" as="xs:string*" select="$rule-id"/>
         <xsl:with-param name="matching"
                         as="xs:string"
                         select="($matching[matches(.,'\S')],'*')[1]"/>
         <xsl:with-param name="class" as="xs:string" expand-text="true">{ $class }</xsl:with-param>
         <xsl:with-param name="testing" as="xs:string">not(string(.) castable as xs:anyURI and matches(.,'^[a-zA-Z][a-zA-Z0-9+\-.]+:.*\S$'))</xsl:with-param>
         <xsl:with-param name="condition"
                         select="not(string(.) castable as xs:anyURI and matches(.,'^[a-zA-Z][a-zA-Z0-9+\-.]+:.*\S$'))"/>
         <xsl:with-param name="msg" expand-text="true">
            <mx:gi>{ name(.) }</mx:gi> value <mx:code>{ string(.) }</mx:code> does not conform to <mx:code>uri</mx:code> datatype.</xsl:with-param>
      </xsl:call-template>
   </xsl:template>
   <xsl:template name="check-positive-integer-datatype">
      <xsl:param name="rule-id" as="xs:string*" select="()"/>
      <xsl:param name="class" as="xs:string">VDSX violates-datatype-syntax</xsl:param>
      <xsl:param name="matching" as="xs:string?" select="()"/>
      <xsl:call-template name="notice">
         <xsl:with-param name="cf" as="xs:string">gix.113</xsl:with-param>
         <xsl:with-param name="rule-id" as="xs:string*" select="$rule-id"/>
         <xsl:with-param name="matching"
                         as="xs:string"
                         select="($matching[matches(.,'\S')],'*')[1]"/>
         <xsl:with-param name="class" as="xs:string" expand-text="true">{ $class }</xsl:with-param>
         <xsl:with-param name="testing" as="xs:string">not(string(.) castable as xs:positiveInteger and matches(.,'^\S(.*\S)?$'))</xsl:with-param>
         <xsl:with-param name="condition"
                         select="not(string(.) castable as xs:positiveInteger and matches(.,'^\S(.*\S)?$'))"/>
         <xsl:with-param name="msg" expand-text="true">
            <mx:gi>{ name(.) }</mx:gi> value <mx:code>{ string(.) }</mx:code> does not conform to <mx:code>positive-integer</mx:code> datatype.</xsl:with-param>
      </xsl:call-template>
   </xsl:template>
   <xsl:template name="check-boolean-datatype">
      <xsl:param name="rule-id" as="xs:string*" select="()"/>
      <xsl:param name="class" as="xs:string">VDSX violates-datatype-syntax</xsl:param>
      <xsl:param name="matching" as="xs:string?" select="()"/>
      <xsl:call-template name="notice">
         <xsl:with-param name="cf" as="xs:string">gix.113</xsl:with-param>
         <xsl:with-param name="rule-id" as="xs:string*" select="$rule-id"/>
         <xsl:with-param name="matching"
                         as="xs:string"
                         select="($matching[matches(.,'\S')],'*')[1]"/>
         <xsl:with-param name="class" as="xs:string" expand-text="true">{ $class }</xsl:with-param>
         <xsl:with-param name="testing" as="xs:string">not(string(.) castable as xs:boolean and matches(.,'^true|1|false|0$'))</xsl:with-param>
         <xsl:with-param name="condition"
                         select="not(string(.) castable as xs:boolean and matches(.,'^true|1|false|0$'))"/>
         <xsl:with-param name="msg" expand-text="true">
            <mx:gi>{ name(.) }</mx:gi> value <mx:code>{ string(.) }</mx:code> does not conform to <mx:code>boolean</mx:code> datatype.</xsl:with-param>
      </xsl:call-template>
   </xsl:template>
   <xsl:template name="check-date-datatype">
      <xsl:param name="rule-id" as="xs:string*" select="()"/>
      <xsl:param name="class" as="xs:string">VDSX violates-datatype-syntax</xsl:param>
      <xsl:param name="matching" as="xs:string?" select="()"/>
      <xsl:call-template name="notice">
         <xsl:with-param name="cf" as="xs:string">gix.113</xsl:with-param>
         <xsl:with-param name="rule-id" as="xs:string*" select="$rule-id"/>
         <xsl:with-param name="matching"
                         as="xs:string"
                         select="($matching[matches(.,'\S')],'*')[1]"/>
         <xsl:with-param name="class" as="xs:string" expand-text="true">{ $class }</xsl:with-param>
         <xsl:with-param name="testing" as="xs:string">not(string(.) castable as xs:date and matches(.,'^(((2000|2400|2800|(19|2[0-9](0[48]|[2468][048]|[13579][26])))-02-29)|(((19|2[0-9])[0-9]{2})-02-(0[1-9]|1[0-9]|2[0-8]))|(((19|2[0-9])[0-9]{2})-(0[13578]|10|12)-(0[1-9]|[12][0-9]|3[01]))|(((19|2[0-9])[0-9]{2})-(0[469]|11)-(0[1-9]|[12][0-9]|30)))(Z|(-((0[0-9]|1[0-2]):00|0[39]:30)|\+((0[0-9]|1[0-4]):00|(0[34569]|10):30|(0[58]|12):45)))?$'))</xsl:with-param>
         <xsl:with-param name="condition"
                         select="not(string(.) castable as xs:date and matches(.,'^(((2000|2400|2800|(19|2[0-9](0[48]|[2468][048]|[13579][26])))-02-29)|(((19|2[0-9])[0-9]{2})-02-(0[1-9]|1[0-9]|2[0-8]))|(((19|2[0-9])[0-9]{2})-(0[13578]|10|12)-(0[1-9]|[12][0-9]|3[01]))|(((19|2[0-9])[0-9]{2})-(0[469]|11)-(0[1-9]|[12][0-9]|30)))(Z|(-((0[0-9]|1[0-2]):00|0[39]:30)|\+((0[0-9]|1[0-4]):00|(0[34569]|10):30|(0[58]|12):45)))?$'))"/>
         <xsl:with-param name="msg" expand-text="true">
            <mx:gi>{ name(.) }</mx:gi> value <mx:code>{ string(.) }</mx:code> does not conform to <mx:code>date</mx:code> datatype.</xsl:with-param>
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
