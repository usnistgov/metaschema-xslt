<?xml version="1.0" encoding="UTF-8"?>
<p:declare-step xmlns:p="http://www.w3.org/ns/xproc" xmlns:c="http://www.w3.org/ns/xproc-step" version="1.0"
   xmlns:metaschema="http://csrc.nist.gov/ns/metaschema/1.0" type="metaschema:VALIDATORS-REFRESH"
   name="VALIDATORS-REFRESH">

   <!-- Purpose: For a given metaschema instance, produces both a viable InspectorXSLT and a viable XSD -->
   <!-- Use to refresh artifacts for testing metaschemas -->
   <!-- Input: A valid, properly-linked metaschema -->

   <!-- Output: For a metaschema input, produces both an XSD and an InspectorXSLT, together -->

   <!-- &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& -->
   <!-- Import (subpipeline) -->

   <p:input port="parameters" kind="parameter"/>
   
   <p:input port="METASCHEMA" primary="true"/>
   
   <p:serialization port="inspector-xslt" indent="true" method="xml" encoding="us-ascii" omit-xml-declaration="false"/>
   <p:output port="inspector-xslt">
      <p:pipe port="INT_50_inspector" step="produce-inspector"/>
   </p:output>
   
   <p:serialization port="xsd-schema" indent="true" method="xml" encoding="us-ascii" omit-xml-declaration="false"/>
   <p:output port="xsd-schema">
      <p:pipe port="OUT_XSD" step="produce-xsd"/>
   </p:output>
   
   <p:import href="INSPECTOR-XSLT-TEST.xpl"/>
   
   <p:import href="../../METASCHEMA-XSD-TEST.xpl"/>
   
   <metaschema:INSPECTOR-XSLT-TEST name="produce-inspector">
      <p:input port="METASCHEMA">
         <p:pipe port="METASCHEMA" step="VALIDATORS-REFRESH"/>
      </p:input>
      <p:input port="instance">
         <p:inline><X/></p:inline>
      </p:input>
      <p:input port="parameters"/>
   </metaschema:INSPECTOR-XSLT-TEST>

   <metaschema:METASCHEMA-XSD-TEST name="produce-xsd">
      <p:input port="METASCHEMA">
         <p:pipe port="METASCHEMA" step="VALIDATORS-REFRESH"/>
      </p:input>
   </metaschema:METASCHEMA-XSD-TEST>

<p:sink/>
   
</p:declare-step>