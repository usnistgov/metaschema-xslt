<?xml version="1.0" encoding="UTF-8"?>
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2"
    xmlns:sqf="http://www.schematron-quickfix.com/validator/process">
    
    <!--Constraints systematic usage in generate-inspector-xslt.xsl -->
    
    <sch:ns uri="http://www.w3.org/1999/XSL/Transform/alias" prefix="XSLT"/>
    <sch:ns uri="http://saxon.sf.net/" prefix="saxon"/>
    
    <sch:pattern>
        
        <sch:rule context="XSLT:call-template[@name='notice']">
            <sch:assert test="exists(XSLT:with-param[@name='cf'])">@cf missing when calling 'notice' template</sch:assert>
        </sch:rule>
        
        <sch:rule context="XSLT:with-param[@name='cf']">
            <sch:let name="ln" value="saxon:line-number(.)"/>
            <sch:assert
            test="('gix.' || $ln) = string(.)">'cf' value is expected to be 'gix.<sch:value-of select="$ln"/>' here.</sch:assert>
        </sch:rule>
    </sch:pattern>
</sch:schema>