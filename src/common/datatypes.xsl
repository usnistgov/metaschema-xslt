<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:m="http://csrc.nist.gov/ns/oscal/metaschema/1.0"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="3.0">
    <!--
         Normalize deprecated datatype names
         ex. m:datatype-normalize('dateTime-with-timezone') => date-time-with-timezone
         Note: unknown and valid datatypes will be passed along as-is
    -->
    <xsl:function
        name="m:datatype-normalize" as="xs:string">
        <xsl:param name="raw-datatype" as="xs:string" />
        <xsl:variable name="deprecation-map">
            <!-- these old names are permitted for now, while only deprecated -->
            <!--metaschema/schema/xml/metaschema.xsd
                 line 1052 inside  /*/xs:simpleType[@name='SimpleDatatypesType']> -->
            <entry key="base64Binary">base64</entry>
            <entry key="dateTime">date-time</entry>
            <entry key="dateTime-with-timezone">date-time-with-timezone</entry>
            <entry key="email">email-address</entry>
            <entry key="nonNegativeInteger">non-negative-integer</entry>
            <entry key="positiveInteger">positive-integer</entry>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="$deprecation-map/entry[@key=$raw-datatype]">
                <xsl:value-of select="$deprecation-map/entry[@key=$raw-datatype]"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$raw-datatype"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>
    
    <!-- used in documentation generation pipelines -->
    <xsl:param name="metaschema-reference-url" as="xs:string">https://pages.nist.gov/metaschema/specification/datatypes</xsl:param>
    
    <!--
         Create an href link to the metaschema documentation for a given datatype
         Warning this function makes no attempt to validate datatype names, only fixing explicitly deprecated names.
    -->
    <xsl:function name="m:datatype-create-link" as="element()">
        <xsl:param name="raw-datatype" as="xs:string" />
        <xsl:variable name="datatype" as="xs:string" select="m:datatype-normalize($raw-datatype)" />
        
        <xsl:element name="a">
            <xsl:attribute name="href">
                <xsl:value-of select="$metaschema-reference-url"/>
                <xsl:text>/#</xsl:text>
                <xsl:value-of select="$datatype"/>
            </xsl:attribute>
            <xsl:value-of select="$datatype"/>
        </xsl:element>
    </xsl:function>
</xsl:stylesheet>