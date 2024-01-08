<?xml version="1.0" encoding="UTF-8"?>
<p:declare-step xmlns:p="http://www.w3.org/ns/xproc"
   xmlns:c="http://www.w3.org/ns/xproc-step" version="1.0"
   xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
   xmlns:metaschema="http://csrc.nist.gov/ns/metaschema/1.0" type="metaschema:METASCHEMA-INSPECTOR-XSLT"
   name="METASCHEMA-INSPECTOR-XSLT">

   <!-- Purpose: Produces an Inspector XSLT  -->
   <!-- Input: A valid and correct OSCAL Metaschema instance linked to its modules (also valid and correct) -->
   <!-- Output: Port `OUT_inspector-xslt` exposes an XSLT -->
   <!-- Option: passing 'xslt-test' as 'skip' suppresses the test run of the result (via try/catch) - quieter when this is known to be bad -->

   <p:option name="xslt-test" select="'okay'"/>
   <!-- set to 'skip' to skip the testing -->

   <!-- &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& -->
   <!-- Ports -->

   <p:input port="METASCHEMA" primary="true"/>
   <p:input port="parameters" kind="parameter"/>

   <p:serialization port="INT_0_echo-input" indent="true"/>
   <p:output port="INT_0_echo-input" primary="false">
      <p:pipe port="result" step="metaschema-in"/>
   </p:output>

   <p:serialization port="INT_1_composed" indent="true"/>
   <p:output port="INT_1_composed" primary="false">
      <p:pipe port="result" step="composed"/>
   </p:output>

   <p:serialization port="OUT_inspector-xslt" indent="true" method="xml" encoding="us-ascii"
      omit-xml-declaration="false"/>
   <p:output port="OUT_inspector-xslt" primary="true">
      <p:pipe port="result" step="produce-inspector"/>
   </p:output>

   <p:serialization port="OUT_xslt-prooftest" indent="true" method="xml" encoding="us-ascii"
      omit-xml-declaration="false"/>
   <p:output port="OUT_xslt-prooftest">
      <p:pipe port="result" step="final"/>
   </p:output>

   <!--<p:variable name="proof-checking" select="false()"/>-->


   <!-- &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& -->
   <!-- Import (subpipeline) -->

   <p:import href="../compose/metaschema-compose.xpl"/>

   <!-- &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& -->
   <!-- Pipeline -->

   <p:identity name="metaschema-in"/>

   <metaschema:metaschema-compose name="compose"/>

   <p:identity name="composed"/>

   <p:xslt name="produce-inspector">
      <p:input port="stylesheet">
         <p:document href="InspectorXSLT/generator/generate-inspector-xslt.xsl"/>
         <!--<p:document href="../common/no-op.xsl"/>-->
      </p:input>
   </p:xslt>

   <!-- We hear XProc 3.0 is even better with try/catch -->
   <p:choose>
      <p:when test="$xslt-test='skip'">
         <p:xslt>
            <p:input port="stylesheet">
               <p:inline>
                  <xsl:stylesheet version="3.0"
                     exclude-result-prefixes="#all">
                     <xsl:template match="/">
                        <MAYBE>XSLT generated but not proof-tested ...</MAYBE>
                     </xsl:template>
                  </xsl:stylesheet>
               </p:inline>
            </p:input>
         </p:xslt>
      </p:when>
      <p:otherwise>
         <p:try name="try-inspector">
            <p:group>
               <p:xslt name="check-inspector">
                  <p:input port="source">
                     <p:inline>
                        <x/>
                     </p:inline>
                  </p:input>
                  <p:input port="stylesheet">
                     <p:pipe port="result" step="produce-inspector"/>
                     <!--         <p:document href="../common/xslt-smoketest.xsl"/>-->
                  </p:input>
               </p:xslt>
               <p:xslt>
                  <p:input port="stylesheet">
                     <p:inline>
                        <xsl:stylesheet version="3.0" exclude-result-prefixes="#all">
                           <xsl:template match="/">
                              <OKAY>Generated XSLT runs successfully on 'x' input</OKAY>
                           </xsl:template>
                        </xsl:stylesheet>
                     </p:inline>
                  </p:input>
               </p:xslt>
            </p:group>
            <p:catch name="xslt-fail-catch">
               <p:identity>
                  <p:input port="source">
                     <p:inline>
                        <ERROR>Generated XSLT fails to compile and run</ERROR>
                     </p:inline>
                  </p:input>
               </p:identity>
               <!--<p:input port="source">
               <p:pipe port="result" step="produce-inspector"/>
            </p:input>-->
            </p:catch>
         </p:try>

      </p:otherwise>
   </p:choose>

   <p:identity name="final"/>

</p:declare-step>
