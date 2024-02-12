<?xml version="1.0" encoding="UTF-8"?>
<p:declare-step xmlns:p="http://www.w3.org/ns/xproc" xmlns:c="http://www.w3.org/ns/xproc-step" version="1.0"
   xmlns:metaschema="http://csrc.nist.gov/ns/metaschema/1.0" type="metaschema:COMPUTER-INSPECTOR-PRODUCE"
   name="COMPUTER-INSPECTOR-PRODUCE">

   <!-- Purpose: Builds an XSLT dynamically from the computer metaschema and tries running the XSLT on a workable instance -->
   <!-- Input: `computer_metaschema.xml` (hard-wired) -->
   <!-- Input: `computer-invalid/invalid1.xml` (hard-wired) -->

   <!-- Output: on port 'inspector-xslt', see the InspectorXSLT  -->
   <!-- Note: if no Inspector XSLT is wanted, bind output -oinspector-xslt=/dev/null   -->
   <!-- Assumptions: Both inputs are current and viable:
       - Metaschema: correct, complete and valid
       - Instance: well-formed, not necessarily valid -->
   <!-- &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& &&& -->
   <!-- Import (subpipeline) -->


   <p:input port="parameters" kind="parameter"/>
   
   <p:serialization port="INSPECTOR-XSLT" indent="true" method="xml" encoding="us-ascii" omit-xml-declaration="false"/>
   <p:output port="INSPECTOR-XSLT">
      <p:pipe port="OUT_INSPECTOR-XSLT" step="produce-inspector"/>
   </p:output>

   <p:import href="INSPECTOR-XSLT-TEST.xpl"/>

   <metaschema:INSPECTOR-XSLT-TEST name="produce-inspector">
      <p:input port="METASCHEMA">
         <p:document href="computer_metaschema.xml"/>
      </p:input>
      <p:input port="instance">
         <p:document href="computer-invalid/invalid1.xml"/>
      </p:input>
      <p:input port="parameters"/>
   </metaschema:INSPECTOR-XSLT-TEST>

</p:declare-step>