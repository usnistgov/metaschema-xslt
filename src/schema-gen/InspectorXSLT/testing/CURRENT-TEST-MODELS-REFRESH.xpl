<?xml version="1.0" encoding="UTF-8"?>
<p:declare-step xmlns:p="http://www.w3.org/ns/xproc" xmlns:c="http://www.w3.org/ns/xproc-step" version="1.0"
   xmlns:metaschema="http://csrc.nist.gov/ns/metaschema/1.0" type="metaschema:CURRENT-TEST-MODELS-REFRESH"
   name="CURRENT-TEST-MODELS-REFRESH">

   <!-- Purpose: For a given metaschema instance, produces both a viable InspectorXSLT and a viable XSD -->
   <!-- Use to refresh artifacts for testing metaschemas -->
   <!-- Input: A valid, properly-linked metaschema -->

   <!-- Output: For a metaschema input, produces both an XSD and an InspectorXSLT, together -->

   <!-- &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& -->
   <p:input port="parameters" kind="parameter"/>
   
<!-- For some reason this errors when run on a sequence from Maven (but not in oXygen's older XML Calabash)  -->

   <p:option name="targetDir" select="'current'"/>
   
   <p:input port="METASCHEMA" primary="true" sequence="true">
      <p:document href="tiny_metaschema.xml"/>
      <p:document href="computer_metaschema.xml"/>
   </p:input>
   
   
   <p:import href="../../METASCHEMA-XSD.xpl"/>
   
   <p:import href="INSPECTOR-XSLT-TEST.xpl"/>
   
   
   <p:for-each name="iterate">
      <p:iteration-source>
         <p:pipe port="METASCHEMA" step="CURRENT-TEST-MODELS-REFRESH"/>
      </p:iteration-source>
      
      <p:variable name="baseURI" select="base-uri(.)"/>
      <p:variable name="filepath" select="(replace($baseURI,'[^/]+$',''), $targetDir, replace($baseURI,'(.*/|\.xml$)','') ) => string-join('/')"/>
      
      <p:identity name="this-metaschema"/>
      
      <metaschema:METASCHEMA-XSD name="produce-xsd"/>
      
      <!--<p:sink/>-->
      <p:store name="save-xsd" indent="true" encoding="ASCII">
         <p:with-option name="href" select="$filepath || '-schema.xsd'"/>
         <p:input port="source">
            <p:pipe port="XSD" step="produce-xsd"/>
         </p:input>
      </p:store>
      
      
   <metaschema:INSPECTOR-XSLT-TEST name="produce-inspector">
      <p:input port="METASCHEMA">
         <p:pipe port="result" step="this-metaschema"/>
      </p:input>
      <p:input port="instance">
         <p:inline><X/></p:inline>
      </p:input>
      <p:input port="parameters"/>
   </metaschema:INSPECTOR-XSLT-TEST>


      <p:store name="save-inspector" indent="true" encoding="ASCII">
         <p:with-option name="href" select="$filepath || '-inspector.xsl'"/>
         <p:input port="source">
            <p:pipe port="INT_50_inspector" step="produce-inspector"/>
         </p:input>
      </p:store>
      
      
   </p:for-each>
   
</p:declare-step>