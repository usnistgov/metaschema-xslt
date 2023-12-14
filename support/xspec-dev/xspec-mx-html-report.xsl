<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema"
   xmlns:math="http://www.w3.org/2005/xpath-functions/math" xmlns:mx="http://csrc.nist.gov/ns/csd/metaschema-xslt"
   exclude-result-prefixes="#all"
   xpath-default-namespace="http://www.jenitennison.com/xslt/xspec"
   expand-text="true"
   version="3.0">

   <!-- 
   
   Requirements:
   
   Produce graceful and clean HTML with self-contained CSS
     stacked folders, open when containing failures
   Support simple theming (with switches) or 'skinning' (w/ external CSS)
     theme=classic - purple/green
     theme=federal - blue/black/white
     theme=toybox
     theme=clean (default)
     add your own theme with a template in mode 'theme-css'
   Take advantage of current XSLT features
   Take advantage of current CSS features (e.g. grids)
   Run without dependencies apart from XSLT 3.0/XPath 3.1
     - no imports, no libraries, all self-contained
     - and w/o a character map dependency that has foiled XProc 1.0 deployment
   XSpec this? why not?
   
   -->

<xsl:output method="xhtml"/>

   <!-- also take 'federal', 'classic', and 'dark' ? -->
   <xsl:param name="theme" as="xs:string">federal</xsl:param>
   
   <!-- implementing strip-space by hand since we don't want to lose ws when copying content through -->
   <xsl:template match="report/text() | scenario/text() | test/text() | call/text() | result/text() | expect/text() | context/text()"/>
   
   <xsl:template match="expect-test-wrap/text() | input-wrap/text()" xpath-default-namespace=""/>
   
   <xsl:template match="/">
      <html>
         <head>
            <title/>
            <xsl:call-template name="page-css"/>
         </head>
         <xsl:apply-templates/>
      </html>
   </xsl:template>

   <xsl:template match="/*" priority="101">
      <body class="{ $theme }">
         <xsl:next-match/>
      </body>
   </xsl:template>
   
   <xsl:template match="report">
      <h1>XSpec Report - <code>{ @xspec/replace(.,'.*/','') }</code></h1>
      <xsl:apply-templates select="@*"/>
      <xsl:apply-templates select="." mode="in-summary"/>
      <p class="gauntlet">
         <xsl:apply-templates select="descendant::test" mode="gauntlet"/>
      </p>
      <xsl:apply-templates/>
   </xsl:template>
   
   <xsl:template priority="5" match="test[matches(@pending,'\S')]" mode="gauntlet">
      <a href="#{@id}">&#9208;</a><!-- pause butten -->
   </xsl:template>
   
   <xsl:template match="test[@successful='true']" mode="gauntlet">
      <a href="#{@id}">&#10004;</a><!-- check mark -->
   </xsl:template>
   
   <xsl:template match="test" mode="gauntlet">
      <a href="#{@id}">&#10060;</a><!-- red X -->
   </xsl:template>
   
   
   <xsl:template match="@*">
      <p class="{local-name(.)}"><b class="pg">{ local-name(..) }/{ local-name(.) }</b>: <span class="pg">{ . }</span></p>
   </xsl:template>
   
   <xsl:template priority="20" match="report/@xspec | report/@stylesheet">
      <p class="{local-name(.)}"><b class="pg">{ local-name(..) }/{ local-name(.) }</b>: <a class="pg" href="{ . }">{ . }</a></p>
   </xsl:template>
   
   <xsl:template priority="20" match="test/@successful"/>
   
   <xsl:template match="scenario">
      <details class="{ (@pending/'pending',.[descendant::test/@successful = 'false']/'failing','passing')[1]}">
         <xsl:copy-of select="@id"/>
         <xsl:if test="descendant::test/@successful = 'false'">
            <xsl:attribute name="open">open</xsl:attribute>
         </xsl:if>
         <summary>
            <xsl:apply-templates select="." mode="in-summary"/>
         </summary>
         <div class="scenario-results">
           <xsl:apply-templates/>
         </div>
      </details>
   </xsl:template>
   
   <xsl:template match="scenario/label"/>
   
   <xsl:template match="report | scenario" mode="in-summary">
      <xsl:variable name="here" select="."/>
      <xsl:variable name="subtotal" select="exists(//test except descendant::test)"/>
      <span class="label">{ self::report/'Total tests '}{ child::label }</span>
      <span class="result">
      <xsl:iterate select="'passing', 'pending', 'failing','total'[not($subtotal)],'subtotal'[$subtotal]">
         <xsl:text> </xsl:text>
         <span class="{ . }">
            <b class="pg">{ . }</b>
            <xsl:text>: </xsl:text>
            <xsl:apply-templates select="." mode="count-tests">
               <xsl:with-param name="where" select="$here"/>
            </xsl:apply-templates>
         </span>
      </xsl:iterate>
      </span>
   </xsl:template>
   
   <xsl:template priority="20" match="scenario[exists(child::test)]" mode="in-summary">
      <xsl:variable name="here" select="."/>
      <span class="label">{ child::label }</span>
      <span class="result { child::test/(@pending/'pending', @successful)[1] }">{ (child::test/@pending/('Pending ' || .),child::test[@successful='true']/'passes','fails')[1] }</span>
   </xsl:template>
   
   <xsl:template match="result">
      <div class="result-reported">
         <xsl:apply-templates select="@select"/>
         <xsl:apply-templates/>
      </div>
   </xsl:template>
   
   <xsl:template match="test">
      <div class="tested { if (@successful='true') then 'succeeds' else 'fails' }">
         <xsl:copy-of select="@id"/>
         <xsl:apply-templates select="@*"/>
         <xsl:apply-templates/>
      </div>
   </xsl:template>
   
   <xsl:template match="call | expect | context">
      <div class="{ local-name() }">
         <xsl:apply-templates select="@*"/>
         <xsl:apply-templates/>
      </div>
   </xsl:template>
   
   <xsl:template match="test/label" priority="5">
      <p class="label">
         <xsl:apply-templates/>
      </p>
   </xsl:template>
   
   <!-- should match content-wrap in no namespace -->
   <xsl:template match="content-wrap" xpath-default-namespace="">
      <textarea class="{ local-name(.) }">
         <xsl:copy-of select="child::node()" exclude-result-prefixes="#all" copy-namespaces="false"/>
      </textarea>
   </xsl:template>
   
  <!-- <xsl:template match="processing-instruction()">
      <xsl:text>&lt;?{ name() }{ string(.) }?></xsl:text>
   </xsl:template>-->
   
   <xsl:template name="page-css">
      <style type="text/css">
<xsl:text  xml:space="preserve" expand-text="false">

body { font-family: 'Calibri', 'Arial', 'Helvetica' }

details { outline: thin solid black; padding: 0.4em }

.summary-line { margin: 0.6em 0em; font-size: 110% }

.scenario-results * { margin: 0em }
.scenario-results div { outline: thin dotted black; padding: 0.2em; margin-top: 0.2em }
.scenario-results div:first-child { margin-top: 0em }

span.result { float: right; display: inline-block }
span.result span { padding: 0.2em; display: inline-block; outline: thin solid black }

.label { font-weight: bold; background-color: gainsboro; padding: 0.2em; max-width: fit-content; outline: thin solid black }
.pending .label { background-color: inherit; color: black; font-weight: normal; outline: thin solid black }

span.label { display: inline-block }

.gauntlet a { text-decoration: none }
</xsl:text>
         <xsl:apply-templates select="$theme" mode="theme-css"/>
      </style>
      
   </xsl:template>
   
   <xsl:template mode="theme-css" match=".[.='federal']">
      <xsl:text xml:space="preserve" expand-text="false">
.federal {
  .label {    background-color: midnightblue; color: white}
  .pending .label { background-color: inherit; color: black }
  .passing, .pending { background-color: white }
  .failing { background-color: mistyrose }
}
</xsl:text>
   </xsl:template>
   
   <xsl:template mode="theme-css" match=".[.='classic']"><!-- 'classic' theme emulates JT's purple-and-green -->
      <xsl:text xml:space="preserve" expand-text="false">
.classic {
  .label {   background-color: #606; color: #6f6;}
  .pending .label { background-color: inherit; color: black }
  .passing { background-color: #cfc }
  .pending { background-color: gainsboro }
  .failing { background-color: pink }
}
</xsl:text>
   </xsl:template>
   
   <xsl:template mode="theme-css" match=".[.='toybox']">
      <xsl:text xml:space="preserve" expand-text="false">
.toybox {
   .label {   background-color: black; color: white }
   .pending .label { background-color: inherit; color: black }
   .failing .label { background-color: darkred }
   .passing .label { background-color: darkgreen }
   .passing { background-color: aliceblue }
   .pending { background-color: cornsilk }
   .failing { background-color: mistyrose }
   .total, .subtotal { background-color: white }
}
</xsl:text>
   </xsl:template>

   <xsl:mode name="count-tests" on-no-match="fail"/>
   
   <!-- 'Visitor' pattern matches strings to dispatch processing -->
   <xsl:template mode="count-tests" match=".[.='passing']">
      <xsl:param name="where" as="element()"/>
      <xsl:sequence select="count($where/descendant::test[@successful='true'])"/>
   </xsl:template>
   
   <xsl:template mode="count-tests" match=".[.='pending']">
      <xsl:param name="where" as="element()"/>
      <xsl:sequence select="count($where/descendant::test[matches(@pending,'\S')])"/>
   </xsl:template>
   
   <xsl:template mode="count-tests" match=".[.='failing']">
      <xsl:param name="where" as="element()"/>
      <xsl:sequence select="count($where/descendant::test[@successful!='true'])"/>
   </xsl:template>
   
   <xsl:template mode="count-tests" match=".[.=('total','subtotal')]">
      <xsl:param name="where" as="element()"/>
      <xsl:sequence select="count($where/descendant::test)"/>
   </xsl:template>
   
</xsl:stylesheet>
