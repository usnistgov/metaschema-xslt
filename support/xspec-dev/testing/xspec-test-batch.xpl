<?xml version="1.0" encoding="UTF-8"?>
<p:declare-step xmlns:p="http://www.w3.org/ns/xproc"
            xmlns:c="http://www.w3.org/ns/xproc-step"
            xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
            xmlns:xs="http://www.w3.org/2001/XMLSchema"
            xmlns:t="http://www.jenitennison.com/xslt/xspec"
            xmlns:mx="http://csrc.nist.gov/ns/csd/metaschema-xslt"
            name="xspec-test-batch"
            type="mx:xspec-test-batch"
            version="1.0">
   
<!-- A model XProc showing how to run a set of XSpec documents in place,
     showing:
   XSpec results - 'xspec-results'
   XML-based summary - 'summary'
   one-line synopsis - 'determination' for plain text results e.g. to console
   
   copy this file plus the shell script mvn-run-xspec-test-batch.sh to a convenient location
   update the import link
   point the batch to your XSpec documents
   run to capture the collected results of those XSpecs together
   -->
   
   <!--<p:option name="here" select="'file:/mnt/c/Users/wap1/Documents/usnistgov/metaschema-xslt/support/xspec-dev/xspec-batch.xpl'"/>-->
   
   <!-- XSpecs to run -->
   <p:input port="batch" sequence="true">
      <p:document href="xspec-shell.xspec"/>
      <p:document href="./xspec-basic.xspec"/>
   </p:input>
   
   <p:input port="parameters" kind="parameter"/>
   
   <p:serialization port="xspec-results" indent="true"/>
   <p:output port="xspec-results">
      <p:pipe port="xspec-results" step="test-batch"/>
   </p:output>
   
   <!-- Any of these output ports can be removed, if unwanted, or redirected to /dev/null -->
   <p:serialization port="summary" indent="true"/>
   <p:output port="summary">
      <p:pipe port="summary" step="test-batch"/>
   </p:output>
   
   <p:serialization port="determination" indent="true" method="text"/>
   <p:output port="determination">
      <p:pipe port="determination" step="test-batch"/>
   </p:output>
   
   <p:import href="../xspec-batch.xpl"/>

<!--
   
   Could not load file:/C:/Users/wap1/Documents/usnistgov/metaschema-xslt/support/xspec/src/compiler/compile-xslt-tests.xsl (file:/mnt/c/Users/wap1/Documents/usnistgov/metaschema-xslt/support/xspec/src/harnesses/harness-lib.xpl) dtd-validate=false
   -->

   <!-- incipit -->
   <mx:xspec-batch name="test-batch">
      <!--<p:with-option name="" select=""-->
   </mx:xspec-batch>
   
</p:declare-step>
