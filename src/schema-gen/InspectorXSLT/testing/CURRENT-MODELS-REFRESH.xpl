<?xml version="1.0" encoding="UTF-8"?>
<p:declare-step xmlns:p="http://www.w3.org/ns/xproc" xmlns:c="http://www.w3.org/ns/xproc-step" version="1.0"
   xmlns:metaschema="http://csrc.nist.gov/ns/metaschema/1.0" type="metaschema:CURRENT-MODELS-REFRESH"
   name="CURRENT-MODELS-REFRESH">

   <!-- Purpose: For a given metaschema instance, produces both a viable InspectorXSLT and a viable XSD -->
   <!-- Use to refresh artifacts for testing metaschemas -->
   <!-- Input: A valid, properly-linked metaschema -->

   <!-- Output: For a metaschema input, produces both an XSD and an InspectorXSLT, together -->

   <!-- &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& -->
   <!-- Import (subpipeline) -->

   <p:input port="parameters" kind="parameter"/>
   
   <p:import href="VALIDATORS-REFRESH.xpl"/>
   
   
   
   <p:for-each>
      <p:iteration-source>
         <p:document href="computer_metaschema.xml"/>
         <p:document href="tiny_metaschema.xml"/>
      </p:iteration-source>
      
      <p:variable name="baseURI" select="base-uri(.)"/>
      <p:variable name="inspector-update" select="replace($baseURI,'[^/]+$','') || '/current/' || $baseURI ! replace(.,'(.*/|\.xml$)','') || '-inspector.xsl'"/>
      <p:variable name="xsd-update" select="replace($baseURI,'[^/]+$','') || '/current/' || $baseURI ! replace(.,'(.*/|\.xml$)','') || '-schema.xsd'"/>
      
      <p:identity name="metaschema"/>
      
      <metaschema:VALIDATORS-REFRESH name="refreshing">
         <p:input port="METASCHEMA">
            <p:pipe port="result" step="metaschema"/>
         </p:input>
      </metaschema:VALIDATORS-REFRESH>
      
      <p:store name="save-inspector">
         <p:with-option name="href" select="$inspector-update"/>
         <p:input port="source">
            <p:pipe port="inspector-xslt" step="refreshing"/>
         </p:input>
      </p:store>
      
      <p:store name="save-xsd">
         <p:with-option name="href" select="$xsd-update"/>
         <p:input port="source">
            <p:pipe port="xsd-schema" step="refreshing"/>
         </p:input>
      </p:store>
      
   </p:for-each>
   
</p:declare-step>