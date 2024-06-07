<xsl:stylesheet xmlns="http://csrc.nist.gov/ns/oscal/metaschema/1.0/supermodel"
                 xmlns:m="http://csrc.nist.gov/ns/oscal/metaschema/1.0"
                 xmlns:xs="http://www.w3.org/2001/XMLSchema"
                 xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                 version="3.0"
                 exclude-result-prefixes="#all"
                 xpath-default-namespace="http://example.com/ns/tinydata">
<!-- XML to JSON conversion: pipeline -->
<!-- Supports either of two interfaces:
      simply handle the XML as source (easier), producing the JSON as output, or
      use arguments (equivalent to): -it from-xml produce=json file=[file] (mirrors the JSON converter interface) -->
<!-- Parameter 'produce' supports acquiring outputs other than JSON:
      produce=xpath produces XPath JSON (an XML syntax)
      produce=supermodel produces intermediate (internal) 'supermodel' format-->
<!-- Parameter setting 'json-indent=yes' produces JSON indented using the internal serializer-->
   <xsl:param name="file" as="xs:string?"/>
   <xsl:param name="produce" as="xs:string">json</xsl:param>
   <xsl:param name="json-indent" as="xs:string">no</xsl:param>
   <!-- NB the output method is XML but serialized JSON is written with disable-output-escaping (below)
     permitting inspection of intermediate results without changing the serialization method.-->
   <xsl:output omit-xml-declaration="true" method="xml"/>
   <xsl:variable name="write-options" as="map(*)">
      <xsl:map>
         <xsl:map-entry key="'indent'" select="$json-indent='yes'"/>
      </xsl:map>
   </xsl:variable>
   <xsl:variable name="source-xml" select="/"/>
   <xsl:template match="/" name="from-xml">
      <xsl:param name="source">
         <xsl:choose><!-- evaluating $file as URI relative to nominal source directory -->
            <xsl:when test="exists($file)">
               <xsl:try xmlns:err="http://www.w3.org/2005/xqt-errors"
                         select="$file ! document(.,$source-xml)">
                  <xsl:catch expand-text="true">
                     <nm:ERROR xmlns:nm="http://csrc.nist.gov/ns/metaschema" code="{ $err:code }">{ $err:description }</nm:ERROR>
                  </xsl:catch>
               </xsl:try>
            </xsl:when>
            <xsl:otherwise>
               <xsl:sequence select="/"/>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:param>
      <xsl:variable name="supermodel">
         <xsl:apply-templates select="$source/*"/>
      </xsl:variable>
      <xsl:variable name="result">
         <xsl:choose>
            <xsl:when test="$produce = 'supermodel'">
               <xsl:sequence select="$supermodel"/>
            </xsl:when>
            <xsl:otherwise>
               <xsl:variable name="new-json-xml">
                  <xsl:apply-templates select="$supermodel/*" mode="write-json"/>
               </xsl:variable>
               <xsl:choose>
                  <xsl:when test="matches($produce,('xpath|xdm|xml'))">
                     <xsl:sequence select="$new-json-xml"/>
                  </xsl:when>
                  <xsl:otherwise>
                     <xsl:try xmlns:err="http://www.w3.org/2005/xqt-errors"
                               select="xml-to-json($new-json-xml, $write-options)">
                        <xsl:catch expand-text="true">
                           <nm:ERROR xmlns:nm="http://csrc.nist.gov/ns/metaschema" code="{ $err:code }">{ $err:description }</nm:ERROR>
                        </xsl:catch>
                     </xsl:try>
                  </xsl:otherwise>
               </xsl:choose>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
      <xsl:sequence select="$result/*"/>
      <xsl:if test="matches($result,'\S') and empty($result/*)">
         <xsl:value-of select="$result" disable-output-escaping="true"/>
      </xsl:if>
   </xsl:template>
   <!-- XML to JSON conversion: object filters -->
   <xsl:strip-space elements="TINY part sheet entry"/>
   <!-- METASCHEMA conversion stylesheet supports XML -> METASCHEMA/SUPERMODEL conversion -->
   <!-- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ -->
   <!-- METASCHEMA: Computer Model (version 0.0.5) in namespace "http://example.com/ns/tinydata"-->
   <xsl:variable as="xs:string" name="metaschema-namespace">http://example.com/ns/tinydata</xsl:variable>
   <xsl:template match="TINY" xpath-default-namespace="http://example.com/ns/tinydata">
      <xsl:param name="with-key" select="true()"/>
      <assembly name="TINY" key="TINY" gi="TINY">
         <xsl:if test="$with-key">
            <xsl:attribute name="key">TINY</xsl:attribute>
         </xsl:if>
         <xsl:if test=". is /*">
            <xsl:attribute name="namespace" select="$metaschema-namespace"/>
         </xsl:if>
         <xsl:apply-templates select="@id"/>
         <xsl:apply-templates select="title"/>
         <xsl:for-each-group select="term" group-by="true()">
            <group in-json="SINGLETON_OR_ARRAY" key="terminology">
               <xsl:apply-templates select="current-group()">
                  <xsl:with-param name="with-key" select="false()"/>
               </xsl:apply-templates>
            </group>
         </xsl:for-each-group>
         <xsl:for-each-group select="p | ul | ol | pre | h1 | h2 | h3 | h4 | h5 | h6 | table"
                              group-by="true()">
            <field in-json="SCALAR"
                    in-xml="UNWRAPPED"
                    collapsible="no"
                    as-type="markup-multiline"
                    name="stuff"
                    key="stuff">
               <value in-json="string"
                       as-type="markup-multiline"
                       _metaschema-xml-id="/assembly/computer/TINY/stuff/PROSE"
                       _metaschema-json-id="/assembly/computer/TINY/stuff/PROSE">
                  <xsl:apply-templates select="current-group()" mode="cast-prose"/>
               </value>
            </field>
         </xsl:for-each-group>
         <xsl:for-each-group select="part" group-by="true()">
            <group in-json="SINGLETON_OR_ARRAY" key="parts">
               <xsl:apply-templates select="current-group()">
                  <xsl:with-param name="with-key" select="false()"/>
               </xsl:apply-templates>
            </group>
         </xsl:for-each-group>
         <xsl:apply-templates select="notes"/>
      </assembly>
   </xsl:template>
   <xsl:template match="part" xpath-default-namespace="http://example.com/ns/tinydata">
      <xsl:param name="with-key" select="true()"/>
      <assembly name="part" gi="part" key="part">
         <xsl:if test="$with-key">
            <xsl:attribute name="key">part</xsl:attribute>
         </xsl:if>
         <xsl:apply-templates select="title"/>
         <xsl:for-each-group select="term" group-by="true()">
            <group in-json="SINGLETON_OR_ARRAY" key="terminology">
               <xsl:apply-templates select="current-group()">
                  <xsl:with-param name="with-key" select="false()"/>
               </xsl:apply-templates>
            </group>
         </xsl:for-each-group>
         <xsl:for-each-group select="p | ul | ol | pre | h1 | h2 | h3 | h4 | h5 | h6 | table"
                              group-by="true()">
            <field in-json="SCALAR"
                    in-xml="UNWRAPPED"
                    collapsible="no"
                    as-type="markup-multiline"
                    name="stuff"
                    key="stuff">
               <value in-json="string"
                       as-type="markup-multiline"
                       _metaschema-xml-id="/assembly/computer/part/stuff/PROSE"
                       _metaschema-json-id="/assembly/computer/part/stuff/PROSE">
                  <xsl:apply-templates select="current-group()" mode="cast-prose"/>
               </value>
            </field>
         </xsl:for-each-group>
         <xsl:for-each-group select="part" group-by="true()">
            <group in-json="SINGLETON_OR_ARRAY" key="parts">
               <xsl:apply-templates select="current-group()">
                  <xsl:with-param name="with-key" select="false()"/>
               </xsl:apply-templates>
            </group>
         </xsl:for-each-group>
         <xsl:for-each-group select="sheet" group-by="true()">
            <group in-json="SINGLETON_OR_ARRAY" key="sheets">
               <xsl:apply-templates select="current-group()">
                  <xsl:with-param name="with-key" select="false()"/>
               </xsl:apply-templates>
            </group>
         </xsl:for-each-group>
         <xsl:apply-templates select="note"/>
      </assembly>
   </xsl:template>
   <xsl:template match="sheet" xpath-default-namespace="http://example.com/ns/tinydata">
      <xsl:param name="with-key" select="true()"/>
      <assembly name="sheet" gi="sheet" key="sheet">
         <xsl:if test="$with-key">
            <xsl:attribute name="key">sheet</xsl:attribute>
         </xsl:if>
         <xsl:apply-templates select="@key"/>
         <xsl:apply-templates select="@class"/>
         <xsl:apply-templates select="title"/>
         <xsl:for-each-group select="entry" group-by="true()">
            <group in-json="ARRAY" key="entries">
               <xsl:apply-templates select="current-group()">
                  <xsl:with-param name="with-key" select="false()"/>
               </xsl:apply-templates>
            </group>
         </xsl:for-each-group>
         <xsl:for-each-group select="items" group-by="true()">
            <group in-json="SINGLETON_OR_ARRAY" key="items">
               <xsl:apply-templates select="current-group()">
                  <xsl:with-param name="with-key" select="false()"/>
               </xsl:apply-templates>
            </group>
         </xsl:for-each-group>
         <xsl:apply-templates select="note"/>
      </assembly>
   </xsl:template>
   <xsl:template match="entry" xpath-default-namespace="http://example.com/ns/tinydata">
      <xsl:param name="with-key" select="true()"/>
      <assembly recursive="true" name="sheet" gi="entry">
         <xsl:apply-templates select="sheet"/>
         <xsl:apply-templates select="@key"/>
         <xsl:apply-templates select="@class"/>
         <xsl:apply-templates select="title"/>
         <xsl:for-each-group select="entry" group-by="true()">
            <group in-json="ARRAY" key="entries">
               <xsl:apply-templates select="current-group()">
                  <xsl:with-param name="with-key" select="false()"/>
               </xsl:apply-templates>
            </group>
         </xsl:for-each-group>
         <xsl:for-each-group select="items" group-by="true()">
            <group in-json="SINGLETON_OR_ARRAY" key="items">
               <xsl:apply-templates select="current-group()">
                  <xsl:with-param name="with-key" select="false()"/>
               </xsl:apply-templates>
            </group>
         </xsl:for-each-group>
         <xsl:apply-templates select="entry"/>
         <xsl:apply-templates select="note"/>
      </assembly>
   </xsl:template>
   <xsl:template match="title" xpath-default-namespace="http://example.com/ns/tinydata">
      <xsl:param name="with-key" select="true()"/>
      <field collapsible="no"
              as-type="markup-line"
              name="title"
              key="title"
              gi="title"
              in-json="SCALAR">
         <xsl:if test="$with-key">
            <xsl:attribute name="key">title</xsl:attribute>
         </xsl:if>
         <value as-type="markup-line" in-json="string">
            <xsl:apply-templates mode="cast-prose"/>
         </value>
      </field>
   </xsl:template>
   <xsl:template match="term" xpath-default-namespace="http://example.com/ns/tinydata">
      <xsl:param name="with-key" select="true()"/>
      <field collapsible="no"
              as-type="string"
              name="term"
              gi="term"
              key="term">
         <xsl:if test="$with-key">
            <xsl:attribute name="key">term</xsl:attribute>
         </xsl:if>
         <xsl:apply-templates select="@id"/>
         <value as-type="string" key="STRVALUE" in-json="string">
            <xsl:value-of select="."/>
         </value>
      </field>
   </xsl:template>
   <xsl:template match="items" xpath-default-namespace="http://example.com/ns/tinydata">
      <xsl:param name="with-key" select="true()"/>
      <field collapsible="no"
              as-type="markup-line"
              name="item"
              gi="items"
              key="items">
         <xsl:if test="$with-key">
            <xsl:attribute name="key">items</xsl:attribute>
         </xsl:if>
         <xsl:apply-templates select="@key"/>
         <xsl:apply-templates select="@class"/>
         <xsl:apply-templates select="@n"/>
         <value as-type="markup-line" key="RICHTEXT" in-json="string">
            <xsl:apply-templates mode="cast-prose"/>
         </value>
      </field>
   </xsl:template>
   <xsl:template match="note" xpath-default-namespace="http://example.com/ns/tinydata">
      <xsl:param name="with-key" select="true()"/>
      <field in-xml="WRAPPED"
              collapsible="no"
              as-type="markup-multiline"
              name="note"
              key="note"
              gi="note"
              in-json="SCALAR">
         <xsl:if test="$with-key">
            <xsl:attribute name="key">note</xsl:attribute>
         </xsl:if>
         <value as-type="markup-multiline" in-json="string">
            <xsl:for-each-group select="p | ul | ol | pre | h1 | h2 | h3 | h4 | h5 | h6 | table"
                                 group-by="true()">
               <xsl:apply-templates select="current-group()" mode="cast-prose"/>
            </xsl:for-each-group>
         </value>
      </field>
   </xsl:template>
   <xsl:template match="TINY/@id"
                  priority="1"
                  xpath-default-namespace="http://example.com/ns/tinydata">
      <flag in-json="string" as-type="token" name="id" key="id" gi="id">
         <xsl:value-of select="."/>
      </flag>
   </xsl:template>
   <xsl:template match="term/@id"
                  priority="1"
                  xpath-default-namespace="http://example.com/ns/tinydata">
      <flag in-json="string" as-type="token" name="id" key="id" gi="id">
         <xsl:value-of select="."/>
      </flag>
   </xsl:template>
   <xsl:template match="sheet/@key"
                  xpath-default-namespace="http://example.com/ns/tinydata">
      <flag in-json="string"
             as-type="token"
             name="key"
             key="key"
             gi="key">
         <xsl:value-of select="."/>
      </flag>
   </xsl:template>
   <xsl:template match="sheet/@class"
                  xpath-default-namespace="http://example.com/ns/tinydata">
      <flag in-json="string"
             as-type="string"
             name="class"
             key="class"
             gi="class">
         <xsl:value-of select="."/>
      </flag>
   </xsl:template>
   <xsl:template match="items/@key"
                  xpath-default-namespace="http://example.com/ns/tinydata">
      <flag in-json="string"
             as-type="token"
             name="key"
             key="key"
             gi="key">
         <xsl:value-of select="."/>
      </flag>
   </xsl:template>
   <xsl:template match="items/@class"
                  xpath-default-namespace="http://example.com/ns/tinydata">
      <flag in-json="string"
             as-type="string"
             name="class"
             key="class"
             gi="class">
         <xsl:value-of select="."/>
      </flag>
   </xsl:template>
   <xsl:template match="items/@n"
                  priority="1"
                  xpath-default-namespace="http://example.com/ns/tinydata">
      <flag in-json="string"
             as-type="non-negative-integer"
             name="n"
             key="n"
             gi="n">
         <xsl:value-of select="."/>
      </flag>
   </xsl:template>
   <xsl:template match="*"
                  mode="cast-prose"
                  xpath-default-namespace="http://example.com/ns/tinydata">
      <xsl:element name="{ local-name() }"
                    namespace="http://csrc.nist.gov/ns/oscal/metaschema/1.0/supermodel">
         <xsl:copy-of select="@*"/>
         <xsl:apply-templates mode="#current"/>
      </xsl:element>
   </xsl:template>
   <!-- XML to JSON conversion: Supermodel serialization as JSON
        including markdown production -->
   <xsl:variable xmlns="http://www.w3.org/2005/xpath-functions"
                  name="ns"
                  select="/*/@namespace"/>
   <xsl:template xmlns="http://www.w3.org/2005/xpath-functions"
                  match="group"
                  mode="write-json"
                  xpath-default-namespace="http://csrc.nist.gov/ns/oscal/metaschema/1.0/supermodel">
      <array>
         <xsl:copy-of select="@key"/>
         <xsl:apply-templates mode="#current"/>
      </array>
   </xsl:template>
   <xsl:template xmlns="http://www.w3.org/2005/xpath-functions"
                  match="group[@in-json='BY_KEY']"
                  mode="write-json"
                  xpath-default-namespace="http://csrc.nist.gov/ns/oscal/metaschema/1.0/supermodel">
      <map>
         <xsl:copy-of select="@key"/>
         <xsl:apply-templates mode="#current"/>
      </map>
   </xsl:template>
   <xsl:template xmlns="http://www.w3.org/2005/xpath-functions"
                  match="flag[@key=../@json-key-flag]"
                  mode="write-json"
                  xpath-default-namespace="http://csrc.nist.gov/ns/oscal/metaschema/1.0/supermodel"/>
   <xsl:template xmlns="http://www.w3.org/2005/xpath-functions"
                  match="group[@in-json='SINGLETON_OR_ARRAY'][count(*)=1]"
                  mode="write-json"
                  xpath-default-namespace="http://csrc.nist.gov/ns/oscal/metaschema/1.0/supermodel">
      <xsl:apply-templates mode="write-json">
         <xsl:with-param name="group-key" select="@key"/>
      </xsl:apply-templates>
   </xsl:template>
   <xsl:template xmlns="http://www.w3.org/2005/xpath-functions"
                  priority="2"
                  match="group/assembly | group/field"
                  mode="write-json"
                  xpath-default-namespace="http://csrc.nist.gov/ns/oscal/metaschema/1.0/supermodel">
        <!-- $group-key is only provided when group/@in-json="SINGLETON_OR_ASSEMBLY" and there is one member of the group -->
      <xsl:param name="group-key" select="()"/>
      <!--@json-key-flag is only available when group/@in-json="BY_KEY"-->
      <xsl:variable name="json-key-flag-name" select="@json-key-flag"/>
      <!-- this will be an array member unless its group is a singleton or BY_KEY -->
      <!-- so we want no key except -->
      <map>
            <!-- we take a $group-key if given -->
         <xsl:copy-of select="$group-key"/>
         <!-- when there's a JSON key flag, we get the key from there -->
         <xsl:for-each select="flag[@key=$json-key-flag-name]">
            <xsl:attribute name="key" select="."/>
         </xsl:for-each>
         <xsl:apply-templates mode="#current"/>
      </map>
   </xsl:template>
   <xsl:template xmlns="http://www.w3.org/2005/xpath-functions"
                  priority="3"
                  match="group/field[@in-json='SCALAR']"
                  mode="write-json"
                  xpath-default-namespace="http://csrc.nist.gov/ns/oscal/metaschema/1.0/supermodel">
      <xsl:param name="group-key" select="()"/>
      <xsl:variable name="json-key-flag-name" select="@json-key-flag"/>
      <!-- with no flags, this field has only its value -->
      <xsl:apply-templates mode="write-json">
         <xsl:with-param name="use-key" select="flag[@key = $json-key-flag-name]"/>
      </xsl:apply-templates>
   </xsl:template>
   <xsl:template xmlns="http://www.w3.org/2005/xpath-functions"
                  match="/assembly"
                  mode="write-json"
                  xpath-default-namespace="http://csrc.nist.gov/ns/oscal/metaschema/1.0/supermodel">
      <map>
         <xsl:next-match/>
      </map>
   </xsl:template>
   <xsl:template xmlns="http://www.w3.org/2005/xpath-functions"
                  match="assembly"
                  mode="write-json"
                  xpath-default-namespace="http://csrc.nist.gov/ns/oscal/metaschema/1.0/supermodel">
      <map key="{@key}">
         <xsl:apply-templates mode="#current"/>
      </map>
   </xsl:template>
   <xsl:template xmlns="http://www.w3.org/2005/xpath-functions"
                  match="field"
                  mode="write-json"
                  xpath-default-namespace="http://csrc.nist.gov/ns/oscal/metaschema/1.0/supermodel">
      <map key="{@key}">
         <xsl:apply-templates mode="#current"/>
      </map>
   </xsl:template>
   <xsl:template xmlns="http://www.w3.org/2005/xpath-functions"
                  match="field[@in-json='SCALAR']"
                  mode="write-json"
                  xpath-default-namespace="http://csrc.nist.gov/ns/oscal/metaschema/1.0/supermodel">
      <xsl:apply-templates mode="#current"/>
      <!--
        <!-\- when there are no flags, the field is a string whose value is the value -\->
        <string>
            <xsl:copy-of select="@key"/>
            <xsl:value-of select="value"/>
        </string> -->
   </xsl:template>
   <xsl:template xmlns="http://www.w3.org/2005/xpath-functions"
                  match="flag[@key=../value/@key-flag]"
                  mode="write-json"
                  xpath-default-namespace="http://csrc.nist.gov/ns/oscal/metaschema/1.0/supermodel"/>
   <xsl:template xmlns="http://www.w3.org/2005/xpath-functions"
                  match="flag"
                  mode="write-json"
                  xpath-default-namespace="http://csrc.nist.gov/ns/oscal/metaschema/1.0/supermodel">
      <xsl:element name="{(@in-json[matches(.,'\S')],'string')[1]}"
                    namespace="http://www.w3.org/2005/xpath-functions">
         <xsl:copy-of select="@key"/>
         <xsl:apply-templates mode="#current"/>
      </xsl:element>
   </xsl:template>
   <xsl:template xmlns="http://www.w3.org/2005/xpath-functions"
                  priority="2"
                  match="field[exists(@json-key-flag)]/value"
                  mode="write-json"
                  xpath-default-namespace="http://csrc.nist.gov/ns/oscal/metaschema/1.0/supermodel">
      <xsl:variable name="key-flag-name" select="../@json-key-flag"/>
      <xsl:element name="{@in-json}" namespace="http://www.w3.org/2005/xpath-functions">
         <xsl:attribute name="key" select="../flag[@key = $key-flag-name]"/>
         <xsl:apply-templates mode="#current"/>
      </xsl:element>
   </xsl:template>
   <xsl:template xmlns="http://www.w3.org/2005/xpath-functions"
                  match="value"
                  mode="write-json"
                  xpath-default-namespace="http://csrc.nist.gov/ns/oscal/metaschema/1.0/supermodel">
      <xsl:variable name="key-flag-name" select="@key-flag"/>
      <xsl:element name="{(@in-json[matches(.,'\S')],'string')[1]}"
                    namespace="http://www.w3.org/2005/xpath-functions">
            <!-- emit a key only if needed -->
         <xsl:copy-of select="((../flag[@key = $key-flag-name], parent::field[@in-json = 'SCALAR'])/@key, @key)[1]"/>
         <!-- overriding the key           -->
         <xsl:if test="exists(@key-flag)">
            <xsl:attribute name="key">
               <xsl:apply-templates select="../flag[@name = $key-flag-name]" mode="cast-data"/>
            </xsl:attribute>
         </xsl:if>
         <xsl:apply-templates select="." mode="cast-data"/>
      </xsl:element>
   </xsl:template>
   <xsl:template xmlns="http://www.w3.org/2005/xpath-functions"
                  match="*"
                  mode="cast-data"
                  xpath-default-namespace="http://csrc.nist.gov/ns/oscal/metaschema/1.0/supermodel">
      <xsl:value-of select="."/>
   </xsl:template>
   <xsl:template xmlns="http://www.w3.org/2005/xpath-functions"
                  match="value[@as-type='markup-line']"
                  mode="cast-data"
                  xpath-default-namespace="http://csrc.nist.gov/ns/oscal/metaschema/1.0/supermodel">
      <xsl:apply-templates mode="md"/>
   </xsl:template>
   <xsl:template xmlns="http://www.w3.org/2005/xpath-functions"
                  match="value[@as-type='markup-multiline']"
                  mode="cast-data"
                  xpath-default-namespace="http://csrc.nist.gov/ns/oscal/metaschema/1.0/supermodel">
      <xsl:variable name="lines" as="node()*">
         <xsl:apply-templates select="*" mode="md"/>
      </xsl:variable>
      <xsl:value-of select="$lines/self::* =&gt; string-join('&#xA;')"/>
   </xsl:template>
   <xsl:template xmlns="http://www.w3.org/2005/xpath-functions"
                  name="conditional-lf"
                  xpath-default-namespace="http://csrc.nist.gov/ns/oscal/metaschema/1.0/supermodel">
      <xsl:if test="exists(preceding-sibling::*)">
         <string/>
      </xsl:if>
   </xsl:template>
   <xsl:template xmlns="http://www.w3.org/2005/xpath-functions"
                  mode="md"
                  match="text()[empty(ancestor::pre)]"
                  xpath-default-namespace="http://csrc.nist.gov/ns/oscal/metaschema/1.0/supermodel">
      <xsl:variable name="escaped">
         <xsl:value-of select="replace(., '([`~\^\*&#34;])', '\\$1')"/>
      </xsl:variable>
      <xsl:value-of select="replace($escaped,'\s+',' ')"/>
   </xsl:template>
   <xsl:template xmlns="http://www.w3.org/2005/xpath-functions"
                  mode="md"
                  match="text()"
                  xpath-default-namespace="http://csrc.nist.gov/ns/oscal/metaschema/1.0/supermodel">
        <!-- Escapes go here       -->
        <!-- prefixes ` ~ ^ * with char E0000 from Unicode PUA -->
        <!--<xsl:value-of select="replace(., '([`~\^\*''&quot;])', '&#xE0000;$1')"/>-->
        <!-- prefixes ` ~ ^ * ' " with reverse solidus -->
      <xsl:value-of select="replace(., '([`~\^\*&#34;])', '\\$1')"/>
      <!--<xsl:value-of select="."/>-->
   </xsl:template>
   <xsl:template xmlns="http://www.w3.org/2005/xpath-functions"
                  mode="md"
                  match="p"
                  xpath-default-namespace="http://csrc.nist.gov/ns/oscal/metaschema/1.0/supermodel">
      <xsl:call-template name="conditional-lf"/>
      <string>
         <xsl:apply-templates mode="md"/>
      </string>
   </xsl:template>
   <xsl:template xmlns="http://www.w3.org/2005/xpath-functions"
                  mode="md"
                  match="h1 | h2 | h3 | h4 | h5 | h6"
                  xpath-default-namespace="http://csrc.nist.gov/ns/oscal/metaschema/1.0/supermodel">
      <xsl:call-template name="conditional-lf"/>
      <string>
         <xsl:apply-templates select="." mode="mark"/>
         <xsl:apply-templates mode="md"/>
      </string>
   </xsl:template>
   <xsl:template xmlns="http://www.w3.org/2005/xpath-functions"
                  mode="mark"
                  match="h1"
                  xpath-default-namespace="http://csrc.nist.gov/ns/oscal/metaschema/1.0/supermodel"># </xsl:template>
   <xsl:template xmlns="http://www.w3.org/2005/xpath-functions"
                  mode="mark"
                  match="h2"
                  xpath-default-namespace="http://csrc.nist.gov/ns/oscal/metaschema/1.0/supermodel">## </xsl:template>
   <xsl:template xmlns="http://www.w3.org/2005/xpath-functions"
                  mode="mark"
                  match="h3"
                  xpath-default-namespace="http://csrc.nist.gov/ns/oscal/metaschema/1.0/supermodel">### </xsl:template>
   <xsl:template xmlns="http://www.w3.org/2005/xpath-functions"
                  mode="mark"
                  match="h4"
                  xpath-default-namespace="http://csrc.nist.gov/ns/oscal/metaschema/1.0/supermodel">#### </xsl:template>
   <xsl:template xmlns="http://www.w3.org/2005/xpath-functions"
                  mode="mark"
                  match="h5"
                  xpath-default-namespace="http://csrc.nist.gov/ns/oscal/metaschema/1.0/supermodel">##### </xsl:template>
   <xsl:template xmlns="http://www.w3.org/2005/xpath-functions"
                  mode="mark"
                  match="h6"
                  xpath-default-namespace="http://csrc.nist.gov/ns/oscal/metaschema/1.0/supermodel">###### </xsl:template>
   <xsl:template xmlns="http://www.w3.org/2005/xpath-functions"
                  mode="md"
                  match="table"
                  xpath-default-namespace="http://csrc.nist.gov/ns/oscal/metaschema/1.0/supermodel">
      <xsl:call-template name="conditional-lf"/>
      <xsl:apply-templates select="*" mode="md"/>
   </xsl:template>
   <xsl:template xmlns="http://www.w3.org/2005/xpath-functions"
                  mode="md"
                  match="tr"
                  xpath-default-namespace="http://csrc.nist.gov/ns/oscal/metaschema/1.0/supermodel">
      <string>
         <xsl:apply-templates select="*" mode="md"/>
      </string>
      <xsl:if test="empty(preceding-sibling::tr)">
         <string>
            <xsl:text>|</xsl:text>
            <xsl:for-each select="th | td">
               <xsl:text> --- |</xsl:text>
            </xsl:for-each>
         </string>
      </xsl:if>
   </xsl:template>
   <xsl:template xmlns="http://www.w3.org/2005/xpath-functions"
                  mode="md"
                  match="th | td"
                  xpath-default-namespace="http://csrc.nist.gov/ns/oscal/metaschema/1.0/supermodel">
      <xsl:if test="empty(preceding-sibling::*)">|</xsl:if>
      <xsl:text> </xsl:text>
      <xsl:apply-templates mode="md"/>
      <xsl:text> |</xsl:text>
   </xsl:template>
   <xsl:template xmlns="http://www.w3.org/2005/xpath-functions"
                  mode="md"
                  priority="1"
                  match="pre"
                  xpath-default-namespace="http://csrc.nist.gov/ns/oscal/metaschema/1.0/supermodel">
      <xsl:call-template name="conditional-lf"/>
      <string>```</string>
      <string>
         <xsl:apply-templates mode="md"/>
      </string>
      <string>```</string>
   </xsl:template>
   <xsl:template xmlns="http://www.w3.org/2005/xpath-functions"
                  mode="md"
                  priority="1"
                  match="ul | ol"
                  xpath-default-namespace="http://csrc.nist.gov/ns/oscal/metaschema/1.0/supermodel">
      <xsl:call-template name="conditional-lf"/>
      <xsl:apply-templates mode="md"/>
      <string/>
   </xsl:template>
   <xsl:template xmlns="http://www.w3.org/2005/xpath-functions"
                  mode="md"
                  match="ul//ul | ol//ol | ol//ul | ul//ol"
                  xpath-default-namespace="http://csrc.nist.gov/ns/oscal/metaschema/1.0/supermodel">
      <xsl:apply-templates mode="md"/>
   </xsl:template>
   <xsl:template xmlns="http://www.w3.org/2005/xpath-functions"
                  mode="md"
                  match="li"
                  xpath-default-namespace="http://csrc.nist.gov/ns/oscal/metaschema/1.0/supermodel">
      <string>
         <xsl:for-each select="(../ancestor::ul | ../ancestor::ol)">
            <xsl:text>  </xsl:text>
         </xsl:for-each>
         <xsl:text>* </xsl:text>
         <xsl:apply-templates mode="md"/>
      </string>
   </xsl:template>
   <xsl:template xmlns="http://www.w3.org/2005/xpath-functions"
                  mode="md"
                  match="ol/li"
                  xpath-default-namespace="http://csrc.nist.gov/ns/oscal/metaschema/1.0/supermodel">
      <string>
         <xsl:for-each select="(../ancestor::ul | ../ancestor::ol)">
            <xsl:text xml:space="preserve">  </xsl:text>
         </xsl:for-each>
         <xsl:text>1. </xsl:text>
         <xsl:apply-templates mode="md"/>
      </string>
   </xsl:template>
   <xsl:template xmlns="http://www.w3.org/2005/xpath-functions"
                  mode="md"
                  match="code | span[contains(@class, 'code')]"
                  xpath-default-namespace="http://csrc.nist.gov/ns/oscal/metaschema/1.0/supermodel">
      <xsl:text>`</xsl:text>
      <xsl:apply-templates mode="md"/>
      <xsl:text>`</xsl:text>
   </xsl:template>
   <xsl:template xmlns="http://www.w3.org/2005/xpath-functions"
                  mode="md"
                  match="em | i"
                  xpath-default-namespace="http://csrc.nist.gov/ns/oscal/metaschema/1.0/supermodel">
      <xsl:text>*</xsl:text>
      <xsl:apply-templates mode="md"/>
      <xsl:text>*</xsl:text>
   </xsl:template>
   <xsl:template xmlns="http://www.w3.org/2005/xpath-functions"
                  mode="md"
                  match="strong | b"
                  xpath-default-namespace="http://csrc.nist.gov/ns/oscal/metaschema/1.0/supermodel">
      <xsl:text>**</xsl:text>
      <xsl:apply-templates mode="md"/>
      <xsl:text>**</xsl:text>
   </xsl:template>
   <xsl:template xmlns="http://www.w3.org/2005/xpath-functions"
                  mode="md"
                  match="q"
                  xpath-default-namespace="http://csrc.nist.gov/ns/oscal/metaschema/1.0/supermodel">
      <xsl:text>"</xsl:text>
      <xsl:apply-templates mode="md"/>
      <xsl:text>"</xsl:text>
   </xsl:template>
   <xsl:template xmlns="http://www.w3.org/2005/xpath-functions"
                  mode="md"
                  match="insert"
                  xpath-default-namespace="http://csrc.nist.gov/ns/oscal/metaschema/1.0/supermodel">
      <xsl:text>{{ insert: </xsl:text>
      <xsl:value-of select="@type, @id-ref" separator=", "/>
      <xsl:text> }}</xsl:text>
   </xsl:template>
   <xsl:template xmlns="http://www.w3.org/2005/xpath-functions"
                  mode="md"
                  match="a"
                  xpath-default-namespace="http://csrc.nist.gov/ns/oscal/metaschema/1.0/supermodel">
      <xsl:text>[</xsl:text>
      <xsl:value-of select="."/>
      <xsl:text>]</xsl:text>
      <xsl:text>(</xsl:text>
      <xsl:value-of select="@href"/>
      <xsl:text>)</xsl:text>
   </xsl:template>
   <xsl:template xmlns="http://www.w3.org/2005/xpath-functions"
                  mode="md"
                  match="img"
                  xpath-default-namespace="http://csrc.nist.gov/ns/oscal/metaschema/1.0/supermodel">
      <xsl:text>![</xsl:text>
      <xsl:value-of select="(@alt,@src)[1]"/>
      <xsl:text>]</xsl:text>
      <xsl:text>(</xsl:text>
      <xsl:value-of select="@src"/>
      <xsl:for-each select="@title">
         <xsl:text expand-text="true"> "{.}"</xsl:text>
      </xsl:for-each>
      <xsl:text>)</xsl:text>
   </xsl:template>
</xsl:stylesheet>
