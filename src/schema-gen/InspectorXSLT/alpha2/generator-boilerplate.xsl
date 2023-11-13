<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="3.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
   xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:mx="http://csrc.nist.gov/ns/csd/metaschema-xslt"
   exclude-result-prefixes="#all" xmlns="http://www.w3.org/1999/xhtml">

   <xsl:output indent="true" encoding="us-ascii" omit-xml-declaration="true"/>
   
   <xsl:param name="format" as="xs:string">inspected</xsl:param>
   <!-- format = (plaintext|markdown|html|mx-report|inspected) -->

   <xsl:param name="form" as="xs:string">full</xsl:param>
   <!-- form = (full|summary|one-line) -->
   
   <xsl:param name="echo" as="xs:string">none</xsl:param>
   <!-- echo = (none|invalid-only|docs|info|warnings|all) - runtime messaging provided with grab-mx mode - does not work with format=inspected -->
   
   <xsl:param name="css" as="xs:string"/>
   
   <!-- Entry points - or use initial-template or initial-mode in supporting processors  -->

   <xsl:template mode="#default" priority="101" name="xsl:initial-template" match="root()[$format='inspected']">
      <xsl:call-template name="inspect"/>
   </xsl:template>
   
   <xsl:template mode="#default" priority="101" match="root()[$format='mx-report']">
      <xsl:call-template name="mx-report"/>
   </xsl:template>
   
   <xsl:template mode="#default" priority="101" match="root()[$format='html']">
      <xsl:call-template name="html"/>
   </xsl:template>
   
   <xsl:template mode="#default" priority="101" match="root()[$format='markdown']">
      <xsl:call-template name="markdown"/>
   </xsl:template>
   
   <xsl:template mode="#default" priority="101" match="root()[$format='plaintext']">
      <xsl:call-template name="plaintext"/>
   </xsl:template>
   
   <!-- these modes are reserved for entry points matching "/" and should never match otherwise  -->
   <xsl:mode name="inspect"   on-no-match="fail"/>
   <xsl:mode name="mx-report" on-no-match="fail"/>
   <xsl:mode name="mx"        on-no-match="fail"/>
   <xsl:mode name="html"      on-no-match="fail"/>
   <xsl:mode name="markdown"  on-no-match="fail"/>
   <xsl:mode name="md"        on-no-match="fail"/>
   <xsl:mode name="plaintext" on-no-match="fail"/>
   
   <!-- entering with no mode or 'inspect' mode, or by name 'inspect' returns an annotated copy of input tree   -->
   <xsl:template match="/" name="inspect" mode="inspect">
      <mx:validation src="{ base-uri(.) }">
         <xsl:apply-templates select="." mode="metaschema-metadata"/>
         <!-- initiates the actual validation traversal          -->
         <xsl:apply-templates mode="validate"/>
      </mx:validation>
   </xsl:template>

   <xsl:template match="/" mode="mx-report mx">
      <xsl:call-template name="mx-report"/>
   </xsl:template>

   <!-- returns mx reports only, with a summary - can be parameterized to filter -->
   <xsl:template name="mx-report">
      <xsl:variable name="mx-validation">
         <xsl:call-template name="inspect"/>
      </xsl:variable>
      <xsl:apply-templates mode="grab-mx" select="$mx-validation/*"/>
   </xsl:template>

   <xsl:template name="mx">
      <xsl:call-template name="mx-report"/>
   </xsl:template>

   <xsl:template match="/" mode="html">
      <xsl:call-template name="html"/>
   </xsl:template>

   <xsl:template name="html">
      <xsl:variable name="mx-reports">
         <!-- reports has a summary along with any reports -->
         <xsl:call-template name="mx-report"/>
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

   <xsl:template match="/" mode="plaintext">
      <xsl:call-template name="plaintext"/>
   </xsl:template>

   <xsl:template name="plaintext">
      <xsl:variable name="html-report">
         <xsl:call-template name="html"/>
      </xsl:variable>
      <xsl:apply-templates mode="html-to-md" select="$html-report/*">
         <!--single lf passed to override double lf -->
         <xsl:with-param name="lf2" tunnel="true" as="xs:string" select="codepoints-to-string(10)"/>
      </xsl:apply-templates>
   </xsl:template>

   <xsl:template name="md">
      <xsl:call-template name="markdown"/>
   </xsl:template>

   <xsl:mode name="validate" on-no-match="shallow-copy"/>

   <xsl:mode name="value-only" on-no-match="text-only-copy"/>

   <xsl:mode name="validate-markup-line" on-no-match="text-only-copy"/>
   <xsl:mode name="validate-markup-multiline" on-no-match="shallow-skip"/>
   <xsl:mode name="constraint-cascade" on-no-match="fail" on-multiple-match="use-last"/>

   <xsl:template match="* | @*" priority="1" mode="constraint-cascade"/>

   <xsl:template match="*" mode="validate">
      <xsl:copy>
         <!--<xsl:namespace name="mx">http://csrc.nist.gov/ns/csd/metaschema-xslt</xsl:namespace>-->
         <xsl:copy-of select="@*"/>
         <xsl:apply-templates select="." mode="test"/>
         <xsl:apply-templates select="@*" mode="test"/>
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

   
<!--   -->
   
   <!-- wrapper template for testing on each node, to be overridden
         and extended for known elements -->
   <xsl:template match="*" mode="test">
      <!-- report if not recognized -->
      <xsl:call-template name="notice">
         <xsl:with-param name="cf">av.157</xsl:with-param>
         <xsl:with-param name="class">_UE unmatched-element</xsl:with-param>
         <xsl:with-param name="msg" expand-text="true">Unrecognized element <mx:gi>{ name() }</mx:gi>.</xsl:with-param>
      </xsl:call-template>
   </xsl:template>

   <xsl:template match="text()[not(matches(., '\S'))]" priority="0.1" mode="test"/>

   <xsl:template mode="test" match="ul/li | oi/li"/>
   
   <xsl:template mode="test" match="table/tr | tr/td | tr/th"/>
   
   <xsl:template mode="test" match="a/@href | a/@title | img/@alt-text | img/@src (: other legal attributes :)"/>

   <xsl:template mode="test" match="p/br | li/br | h1/br | h2/br | h3/br | h4/br | h5/br | h6/br | pre/br | tr/br | td/br"/>
   
   <!-- XXX cover all text in mixed content -->
   <xsl:template mode="test"
      match="p/text() | li/text() | h1/text() | h2/text() | h3/text() | h4/text() | h5/text() | h6/text() | pre/text() | tr/text() | td/text()"/>
   <xsl:template mode="test"
      match="em/text() | i/text() | strong/text() | b/text() | u/text() | q/text() | code/text() | a/text()"/>

   <xsl:template match="text()" mode="test">
      <!-- report if not recognized -->
      <xsl:call-template name="notice">
         <xsl:with-param name="cf">av.182</xsl:with-param>
         <xsl:with-param name="class">_UT unexpected-text</xsl:with-param>
         <xsl:with-param name="msg" expand-text="true">Errant text content.</xsl:with-param>
      </xsl:call-template>
   </xsl:template>

   <!-- report if not recognized -->
   <!--<xsl:template match="*" mode="validate-markup-multiline" name="notice-multiline">
      <xsl:call-template name="notice">
         <xsl:with-param name="cf">av.138</xsl:with-param>
         <xsl:with-param name="class">_UMM unmatched-markup-multiline</xsl:with-param>
         <xsl:with-param name="msg" expand-text="true">Unrecognized element <mx:gi>{ name() }</mx:gi> in multiline
            markup.</xsl:with-param>
      </xsl:call-template>
   </xsl:template>-->

   <xsl:variable name="markup-multline-blocks" select="
         'p', 'pre', 'ul', 'ol', 'table',
         'h1', 'h2', 'h3', 'h4', 'h5'"/>

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

   <!--<xsl:template match="*" mode="validate-markup-line">
      <!-\- report if not recognized -\->
      <xsl:call-template name="notice">
         <xsl:with-param name="cf">av.181</xsl:with-param>
         <xsl:with-param name="class">_UM unmatched-markup</xsl:with-param>
         <xsl:with-param name="msg" expand-text="true">Unrecognized element <mx:gi>{ name() }</mx:gi>.</xsl:with-param>
      </xsl:call-template>
   </xsl:template>-->

   <!-- ... and attributes ...  -->
   <xsl:template match="@*" mode="test"> <!-- validate-markup-line validate-markup-multiline -->
      <xsl:call-template name="notice">
         <xsl:with-param name="cf">av.245</xsl:with-param>
         <xsl:with-param name="class">_UA unmatched-attribute</xsl:with-param>
         <xsl:with-param name="msg"
            expand-text="true">Unrecognized attribute <mx:gi>@{ name() }</mx:gi> on element <mx:gi>{ name(..) }</mx:gi>.</xsl:with-param>
      </xsl:call-template>
   </xsl:template>

   <xsl:template mode="test" match="@xsi:*" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"/>

   <xsl:template name="notice">
      <xsl:param name="cf" as="xs:string" select="AV.255"/>
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
         <xsl:variable name="xpath">
            <!-- handmade paths avoid namespaces and other complications of path(.) -->
            <xsl:apply-templates select="." mode="xpath"/>
         </xsl:variable>
         <mx:report cf="{$cf}" test="{ $testing }" class="{$class}" xpath="{ $xpath }" level="{ $level }">
            <xsl:if test="exists($rule-id[matches(., '\S')])">
               <xsl:attribute name="rule-id" select="string-join($rule-id[matches(., '\S')], ' ')"/>
            </xsl:if>
            <xsl:if test="not($matching = '*')">
               <xsl:attribute name="matching" select="$matching"/>
            </xsl:if>
            <xsl:sequence select="$msg"/>
         </mx:report>
      </xsl:if>
   </xsl:template>

   <xsl:template name="echoing">
      <xsl:param name="msg">[info]</xsl:param>
      <xsl:if test="not($echo = 'none')">
         <xsl:message>
            <xsl:sequence select="$msg"/>
         </xsl:message>
      </xsl:if>
   </xsl:template>

   <xsl:template mode="xpath" match="*">
      <xsl:apply-templates select="parent::*" mode="#current"/>
      <xsl:text expand-text="true">/{ name() }</xsl:text>
   </xsl:template>

   <xsl:template mode="xpath" match="*[node-name() = (../* except current())/node-name()]">
      <xsl:apply-templates select="parent::*" mode="#current"/>
      <xsl:variable name="kin" select="../*[node-name() = current()/node-name()]"/>
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
      <xsl:variable name="place" expand-text="true">[{ count(preceding-sibling::processing-instruction()|.)
         }]</xsl:variable>
      <xsl:text expand-text="true">/text(){ (count($kin)[. gt 1]) ! $place }</xsl:text>
   </xsl:template>

   <!--<xsl:template name="check-datatype">
      <xsl:apply-templates select="." mode="test-datatype"/>
   </xsl:template>-->

   <!--<xsl:template mode="test-datatype" match="*"/>-->

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
      <xsl:comment>clean me up</xsl:comment>
      <!--<xsl:apply-templates mode="validate-markup-line"/>-->
   </xsl:template>

   <xsl:template name="check-markup-multiline-datatype">
      <xsl:comment>clean me up</xsl:comment>
   </xsl:template>

   <!-- stub to be replaced with results from produce-datatype-functions.xsl  -->
   <!--<xsl:function name="mx:datatype-validate" as="xs:boolean">
      <xsl:param name="value" as="item()"/>
      <xsl:param name="nominal-type" as="item()?"/>
      <xsl:sequence select="true()"/>
   </xsl:function>-->
   
<!-- given a node, a key name, value (sequence) and scope for evaluation, and a sequence of items,
     returns those items that are returned by the key (in document order) -->
   <xsl:function name="mx:key-matches-among-items" as="node()*">
      <xsl:param name="item" as="item()"/>
      <xsl:param name="items" as="item()+"/>
      <xsl:param name="keyname" as="xs:string"/>
      <xsl:param name="keyval" as="item()*"/>
      <xsl:param name="keyscope" as="node()"/>      
      <xsl:sequence select="$item!key($keyname,$keyval,$keyscope/root()) intersect $items"/>
   </xsl:function>
   
   <!-- Mode grab-mx filters mx from its 'host' XML -->

   <xsl:mode name="grab-mx" on-no-match="shallow-skip"/>

   <!--copied from mx-grabber.xsl -->

   <xsl:template match="mx:*" mode="grab-mx">
      <xsl:copy-of select="." copy-namespaces="false"/>
   </xsl:template>

   <!-- Nominally invalid examples has errors or critical along with warning and info reports but no errors or critical -->
   <xsl:template match="/mx:validation[descendant::mx:report/@level = ('CRITICAL', 'ERROR')]" priority="103"
      mode="grab-mx">
      <xsl:variable name="report-count" select="count(.//mx:report)"/>
      <xsl:variable name="error-count" select="count(.//mx:report[@level = ('CRITICAL', 'ERROR')])"/>
      <xsl:call-template name="echoing" expand-text="true">
         <xsl:with-param name="msg">
            <xsl:choose>
               <xsl:when test="$report-count eq $error-count">File { replace(@src,'.*/','') } has { $error-count } {
                  mx:pluralize($error-count,'error')}.</xsl:when>
               <xsl:otherwise>File { replace(@src,'.*/','') } has { $report-count } {
                  mx:pluralize($report-count,'issue') } reported including { $error-count } {
                  mx:pluralize($error-count,'error')}.</xsl:otherwise>
            </xsl:choose>
         </xsl:with-param>
      </xsl:call-template>
      <xsl:next-match/>
   </xsl:template>

   <!-- Nominally valid examples may have warning or info reports but no errors or critical -->
   <xsl:template match="/mx:validation[not(descendant::mx:report/@level = ('CRITICAL', 'ERROR'))]" priority="102"
      mode="grab-mx">
      <xsl:if test="not($echo = 'invalid-only')">
         <xsl:call-template name="echoing" expand-text="true">
            <xsl:with-param name="msg">File { replace(@src,'.*/','') } is reported VALID, no issues ...</xsl:with-param>
         </xsl:call-template>
      </xsl:if>
      <xsl:next-match/>
   </xsl:template>

   <xsl:template match="/mx:validation" priority="101" mode="grab-mx">
      <xsl:copy copy-namespaces="false">
         <xsl:copy-of select="@*"/>
         <xsl:attribute name="elements" select="count(descendant::* except .//mx:*/descendant-or-self::*)"/>
         <xsl:attribute name="attributes" select="count(descendant::*/@* except .//mx:*/descendant-or-self::*/@*)"/>
         <xsl:attribute name="reports" select="count(.//mx:report)"/>
         <xsl:attribute name="severe-reports" select="count(.//mx:report[@level = ('CRITICAL', 'ERROR')])"/>
         <xsl:apply-templates mode="grab-mx"/>
      </xsl:copy>
   </xsl:template>

   <!-- copy reports but do not announce them -->
   <xsl:template match="mx:report[$echo = ('docs', 'info')][@level = ('ERROR', 'CRITICAL', 'WARNING')]" mode="grab-mx">
      <xsl:copy-of select="." copy-namespaces="false"/>
   </xsl:template>

   <xsl:template match="mx:report[$echo = 'warnings'][@level = ('ERROR', 'CRITICAL')]" mode="grab-mx">
      <xsl:copy-of select="." copy-namespaces="false"/>
   </xsl:template>


   <xsl:template match="mx:report" mode="grab-mx" expand-text="true">
      <xsl:if test="not($form = ('summary', 'one-line'))">
         <xsl:call-template name="echoing" expand-text="true">
            <xsl:with-param name="msg">{ (@level,'ERROR')[1] } [CLASS) { @class } ][PATH) { @xpath } ][REPORT) {
               string(.) }]</xsl:with-param>
         </xsl:call-template>
      </xsl:if>
      <xsl:next-match/>
   </xsl:template>

   <xsl:mode name="mx-to-html" on-no-match="text-only-copy"/>

   <xsl:template match="/mx:validation" mode="mx-to-html" expand-text="true">
      <xsl:variable name="reported-valid" select="@reports = 0"/>
      <xsl:variable name="validating-filename" select="replace(@src, '.*/', '')"/>
      <xsl:variable name="checked" select="if ($reported-valid) then '&#x2714;' else '&#x2718;'"/>
      <html>
         <head>
            <title>{ $validating-filename } - { $checked } - { mx:metaschema/@shortname } validation</title>
            <xsl:if test="boolean($css)"><link rel="stylesheet" href="{ $css }"/></xsl:if>
            <xsl:call-template name="html-css"/>
         </head>
         <body>
            <h1>{ $checked } Validating <a href="{ @src }">{ $validating-filename }</a> - { mx:metaschema } - found {
               'IN'[not($reported-valid)] }VALID</h1>
            <xsl:if test="not($form = 'one-line')">
               <xsl:apply-templates mode="#current" select="mx:metaschema"/>
               <p><code>{ $validating-filename }</code> contains { @elements} {
                  mx:pluralize(@elements/number(),'element') } and { @attributes } {
                  mx:pluralize(@attributes/number(),'attribute') }.</p>
               <xsl:apply-templates select="." mode="summary"/>
               <xsl:if test="not($form = ('one-line', 'summary'))">
                  <main>
                     <xsl:apply-templates mode="#current" select="child::* except mx:metaschema"/>
                  </main>
               </xsl:if>
            </xsl:if>
         </body>
      </html>
   </xsl:template>

   <xsl:template name="html-css">
      <xsl:if test="not($css)" xml:space="preserve" expand-text="false">
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
      </xsl:if>
   </xsl:template>

   <xsl:template match="mx:validation" mode="summary" expand-text="true">
      <div class="summary">
         <p>{ count(.//mx:report) } { mx:pluralize(count(.//mx:report),'issue') } reported.</p>
         <p>
            <xsl:iterate select="descendant::mx:report">
               <span class="ji">&#x1F4A5;</span>
            </xsl:iterate>
         </p>
      </div>
   </xsl:template>

   <xsl:template match="mx:validation[empty(descendant::mx:report)]" mode="summary">
      <div class="summary valid">
         <p>Good news - nothing to report - the instance is valid. <span class="ji">&#x1F680;</span></p>
      </div>
   </xsl:template>

   <xsl:template match="mx:metaschema" mode="mx-to-html" expand-text="true">
      <p class="metadata">Checking against the rules defined in metaschema <b>{ . }</b>{ @version ! (', version ' || .)} (namespace <code>{ @namespace
            }</code>)</p>
   </xsl:template>

   <xsl:template match="mx:report" mode="mx-to-html" expand-text="true">
      <details class="report { @class }{ @level[not(.='ERROR')] ! (' ' || .) }">
         <summary>
            <xsl:apply-templates mode="#current"/>
         </summary>
         <p class="exc">{ @class }{ @level[not(.='ERROR')] ! (' ' || .) }</p>
         <ul>
            <xsl:for-each select="@rule-id">
               <li class="test">Rule ID: <code>{ . }</code></li>
            </xsl:for-each>
            <li class="test">test: <code>{ @test }</code></li>
            <xsl:if test="@matching != '*'">
               <li class="matching">matching: <code>{ @matching }</code></li>
            </xsl:if>
            <li>XPath: <code class="xpath">{ @xpath }</code></li>

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


   <xsl:template mode="html-to-md" match="html" xpath-default-namespace="http://www.w3.org/1999/xhtml">
      <xsl:apply-templates mode="#current" select="body"/>
   </xsl:template>

   <xsl:template mode="html-to-md" match="style" xpath-default-namespace="http://www.w3.org/1999/xhtml"/>

   <xsl:template mode="html-to-md" match="body" expand-text="true"
      xpath-default-namespace="http://www.w3.org/1999/xhtml">
      <xsl:apply-templates mode="#current"/>
      <xsl:text>{ $lf }</xsl:text>
   </xsl:template>

   <xsl:template mode="html-to-md" match="div | details" expand-text="true"
      xpath-default-namespace="http://www.w3.org/1999/xhtml">
      <xsl:param name="lf2" tunnel="true" as="xs:string" select="$lf || $lf"/>
      <xsl:text>{ $lf2 }---</xsl:text>
      <xsl:apply-templates mode="#current"/>
   </xsl:template>

   <xsl:template mode="html-to-md" match="body/*[1]/self::h1" expand-text="true"
      xpath-default-namespace="http://www.w3.org/1999/xhtml">
      <xsl:text># </xsl:text>
      <xsl:apply-templates mode="#current"/>
   </xsl:template>

   <xsl:template mode="html-to-md" match="h1" expand-text="true" xpath-default-namespace="http://www.w3.org/1999/xhtml">
      <xsl:param name="lf2" tunnel="true" as="xs:string" select="$lf || $lf"/>
      <xsl:text>{ $lf2 }# </xsl:text>
      <xsl:apply-templates mode="#current"/>
   </xsl:template>

   <xsl:template mode="html-to-md" match="h2" expand-text="true" xpath-default-namespace="http://www.w3.org/1999/xhtml">
      <xsl:param name="lf2" tunnel="true" as="xs:string" select="$lf || $lf"/>
      <xsl:text>{ $lf2 }## </xsl:text>
      <xsl:apply-templates mode="#current"/>
   </xsl:template>

   <xsl:template mode="html-to-md" match="h3 | details/summary" expand-text="true"
      xpath-default-namespace="http://www.w3.org/1999/xhtml">
      <xsl:param name="lf2" tunnel="true" as="xs:string" select="$lf || $lf"/>
      <xsl:text>{ $lf2 }### </xsl:text>
      <xsl:apply-templates mode="#current"/>
   </xsl:template>

   <xsl:template mode="html-to-md" match="p" expand-text="true" xpath-default-namespace="http://www.w3.org/1999/xhtml">
      <xsl:param name="lf2" tunnel="true" as="xs:string" select="$lf || $lf"/>
      <xsl:text>{ $lf2 }</xsl:text>
      <xsl:apply-templates mode="#current"/>
   </xsl:template>

   <xsl:template mode="html-to-md" match="ul" expand-text="true" xpath-default-namespace="http://www.w3.org/1999/xhtml">
      <xsl:param name="lf2" tunnel="true" as="xs:string" select="$lf || $lf"/>
      <xsl:sequence select="replace($lf2, '&#xA;$', '')"/>
      <xsl:apply-templates mode="#current"/>
   </xsl:template>

   <xsl:template mode="html-to-md" match="li" expand-text="true" xpath-default-namespace="http://www.w3.org/1999/xhtml">
      <xsl:text>{ $lf }- </xsl:text>
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
