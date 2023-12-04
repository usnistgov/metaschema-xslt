<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
   xmlns:xs="http://www.w3.org/2001/XMLSchema"
   xmlns:math="http://www.w3.org/2005/xpath-functions/math"
   exclude-result-prefixes="xs math"
   version="3.0">
   
   <xsl:include href="../../../generator/generator-boilerplate.xsl"/>
   
   <!--holding for integration into boilerplate: -->
   <!-- XXX cross check against schema  -->
   
   <xsl:template match="a/@href | img/@src | img/@title | insert/@type | insert/@id-ref"
      mode="test"/>
   
   <xsl:template mode="test"
      match="p/text() | li/text() | h1/text() | h2/text() | h3/text() | h4/text() | h5/text() | h6/text()"/>
   <xsl:template mode="test"
      match="em/text() | i/text() | strong/text() | b/text() | u/text() | q/text() | code/text() | a/text()"/>
   <xsl:template mode="test" match="ul/li | ol/li"/>
   <xsl:template mode="test" match="table/tr | table/tr/th | table/tr/td"/>
   
   <!-- generate these? -->
   <xsl:template mode="test" match="p/em | p/i | p/strong (: etc :)"/>
   <xsl:template mode="test" match="li/em | li/i | li/strong (: etc :)"/>
   <xsl:template mode="test" match="th/em | th/i | th/strong (: etc :)"/>
   <xsl:template mode="test" match="td/em | td/i | td/strong (: etc :)"/>
   
   <!-- emulating generated templating here  -->
   
   <!--For any p-level child of part: part/p, part/h1 etc. -->
   <!--for part being any parent of UNWRAPPED markup-multiline -->
   <!--<xsl:template mode="validate" match="part/h1 | part/p">
      <xsl:call-template name="proceed-to-validate"/>
   </xsl:template>-->

   <!--For any p-level child of part: part/p, part/h1 etc. -->
   <!--both WRAPPED and UNWRAPPED cases, i.e. part/note/p -->

   <xsl:template mode="test" match="part/h1 | part/p | part/ul | part/ol | part/table (: and the rest:)">
      <!-- to do: build sibling check test - notice if out of order (following anything unexpected) -->
      <!-- use 'test-order' template in generate-inspector-xslt -->
   </xsl:template>

   <xsl:template mode="test" match="part/note/h1 | part/note/p | part/note/ul | part/note/ol | part/note/table"/>
   
   <!-- for any field except unwrapped markup-multiline -->
   <xsl:template mode="validate" match="title/text() (: and any other field/text() :)">
      <xsl:value-of select="."/>
   </xsl:template>
   
   <!-- for any markup-line field ... the inline elements are okay, test nothing -->
   <xsl:template mode="test" match="title/a | title/b (: and the rest :)"/>
   
   <!--simulated: for testing only (remove when integrating this) 
       as these should be already provided by the generator -->
   
   <xsl:template mode="validate" match="TINY | part | title">
      <xsl:copy>
         <xsl:copy-of select="@*"/>
         <xsl:apply-templates select="@*" mode="test"/>
         <xsl:apply-templates select="." mode="test"/>
         <xsl:apply-templates mode="validate"/>
      </xsl:copy>
   </xsl:template>
      
   <xsl:template mode="test" match="TINY | part | title"/>
   
</xsl:stylesheet>