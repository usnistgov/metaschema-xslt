<?xml version="1.0" encoding="UTF-8"?>
<xsl:transform xmlns="http://www.w3.org/1999/xhtml"
               xmlns:mx="http://csrc.nist.gov/ns/oscal/metaschema-xslt"
               xmlns:pb="http://github.com/wendellpiez/XMLjellysandwich"
               xmlns:xs="http://www.w3.org/2001/XMLSchema"
               xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
               version="3.0"
               xpath-default-namespace="http://example.com/ns/computer"
               exclude-result-prefixes="#all">
   <xsl:mode name="test" on-no-match="shallow-skip"/>
   <!-- Generated 2023-09-18T17:58:32.4442644-04:00 -->
   <!-- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -->
   <!-- -#- -#- -#- -#- -#- -#- -#- -#- -#- -#- -#- -#- -#- -#- -#- -#- -#- -#- -#- -#- -#- -#- -#- -#- -->
   <!--     Root -->
   <!-- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -->
   <xsl:template match="/computer" mode="test">
      <xsl:apply-templates select="@*" mode="test"/>
      <xsl:call-template name="require-for-computer-assembly"/>
   </xsl:template>
   <!-- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -->
   <!-- -#- -#- -#- -#- -#- -#- -#- -#- -#- -#- -#- -#- -#- -#- -#- -#- -#- -#- -#- -#- -#- -#- -#- -#- -->
   <!--     Occurrences - templates in mode 'test' -->
   <!-- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -->
   <xsl:template priority="5" match="computer/motherboard/vendor" mode="test">
      <xsl:apply-templates select="@*" mode="test"/>
      <xsl:call-template name="notice">
         <xsl:with-param name="cat">cardinality</xsl:with-param>
         <xsl:with-param name="condition" select="count(. | preceding-sibling::vendor) gt 1"/>
         <xsl:with-param name="msg">
            <code>vendor</code> appears too many times: 1 maximum is permitted.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="notice">
         <xsl:with-param name="cat">ordering</xsl:with-param>
         <xsl:with-param name="condition"
                         select="exists( preceding-sibling::type | preceding-sibling::cpu | preceding-sibling::ata-socket | preceding-sibling::memory | preceding-sibling::expansion-card )"/>
         <xsl:with-param name="msg">
            <code>vendor</code> is not expected to follow <code>type</code>, <code>cpu</code>, <code>ata-socket</code>, <code>memory</code>,  or <code>expansion-card</code>.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="require-for-vendor-assembly"/>
   </xsl:template>
   <xsl:template priority="5" match="motherboard/cpu/vendor" mode="test">
      <xsl:apply-templates select="@*" mode="test"/>
      <xsl:call-template name="notice">
         <xsl:with-param name="cat">cardinality</xsl:with-param>
         <xsl:with-param name="condition" select="count(. | preceding-sibling::vendor) gt 1"/>
         <xsl:with-param name="msg">
            <code>vendor</code> appears too many times: 1 maximum is permitted.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="notice">
         <xsl:with-param name="cat">ordering</xsl:with-param>
         <xsl:with-param name="condition"
                         select="exists( preceding-sibling::product-name | preceding-sibling::architecture | preceding-sibling::speed )"/>
         <xsl:with-param name="msg">
            <code>vendor</code> is not expected to follow <code>product-name</code>, <code>architecture</code>,  or <code>speed</code>.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="require-for-vendor-assembly"/>
   </xsl:template>
   <xsl:template priority="5" match="motherboard/ata-socket/vendor" mode="test">
      <xsl:apply-templates select="@*" mode="test"/>
      <xsl:call-template name="notice">
         <xsl:with-param name="cat">cardinality</xsl:with-param>
         <xsl:with-param name="condition" select="count(. | preceding-sibling::vendor) gt 1"/>
         <xsl:with-param name="msg">
            <code>vendor</code> appears too many times: 1 maximum is permitted.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="notice">
         <xsl:with-param name="cat">ordering</xsl:with-param>
         <xsl:with-param name="condition"
                         select="exists( preceding-sibling::product-name | preceding-sibling::type )"/>
         <xsl:with-param name="msg">
            <code>vendor</code> is not expected to follow <code>product-name</code> or <code>type</code>.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="require-for-vendor-assembly"/>
   </xsl:template>
   <xsl:template priority="5" match="motherboard/memory/vendor" mode="test">
      <xsl:apply-templates select="@*" mode="test"/>
      <xsl:call-template name="notice">
         <xsl:with-param name="cat">cardinality</xsl:with-param>
         <xsl:with-param name="condition" select="count(. | preceding-sibling::vendor) gt 1"/>
         <xsl:with-param name="msg">
            <code>vendor</code> appears too many times: 1 maximum is permitted.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="notice">
         <xsl:with-param name="cat">ordering</xsl:with-param>
         <xsl:with-param name="condition"
                         select="exists( preceding-sibling::product-name | preceding-sibling::byte-size )"/>
         <xsl:with-param name="msg">
            <code>vendor</code> is not expected to follow <code>product-name</code> or <code>byte-size</code>.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="require-for-vendor-assembly"/>
   </xsl:template>
   <xsl:template priority="5" match="motherboard/expansion-card/vendor" mode="test">
      <xsl:apply-templates select="@*" mode="test"/>
      <xsl:call-template name="notice">
         <xsl:with-param name="cat">cardinality</xsl:with-param>
         <xsl:with-param name="condition" select="count(. | preceding-sibling::vendor) gt 1"/>
         <xsl:with-param name="msg">
            <code>vendor</code> appears too many times: 1 maximum is permitted.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="notice">
         <xsl:with-param name="cat">ordering</xsl:with-param>
         <xsl:with-param name="condition"
                         select="exists( preceding-sibling::product-name | preceding-sibling::type )"/>
         <xsl:with-param name="msg">
            <code>vendor</code> is not expected to follow <code>product-name</code> or <code>type</code>.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="require-for-vendor-assembly"/>
   </xsl:template>
   <xsl:template priority="5" match="/computer/motherboard" mode="test">
      <xsl:apply-templates select="@*" mode="test"/>
      <xsl:call-template name="notice">
         <xsl:with-param name="cat">cardinality</xsl:with-param>
         <xsl:with-param name="condition"
                         select="count(. | preceding-sibling::motherboard) gt 1"/>
         <xsl:with-param name="msg">
            <code>motherboard</code> appears too many times: 1 maximum is permitted.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="require-for-computer_..._motherboard-assembly"/>
   </xsl:template>
   <xsl:template priority="5" match="computer/motherboard/cpu" mode="test">
      <xsl:apply-templates select="@*" mode="test"/>
      <xsl:call-template name="notice">
         <xsl:with-param name="cat">cardinality</xsl:with-param>
         <xsl:with-param name="condition" select="count(. | preceding-sibling::cpu) gt 1"/>
         <xsl:with-param name="msg">
            <code>cpu</code> appears too many times: 1 maximum is permitted.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="notice">
         <xsl:with-param name="cat">ordering</xsl:with-param>
         <xsl:with-param name="condition"
                         select="exists( preceding-sibling::ata-socket | preceding-sibling::memory | preceding-sibling::expansion-card )"/>
         <xsl:with-param name="msg">
            <code>cpu</code> is not expected to follow <code>ata-socket</code>, <code>memory</code>,  or <code>expansion-card</code>.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="require-for-computer_..._motherboard_..._cpu-assembly"/>
   </xsl:template>
   <xsl:template priority="5" match="computer/motherboard/ata-socket" mode="test">
      <xsl:apply-templates select="@*" mode="test"/>
      <xsl:call-template name="notice">
         <xsl:with-param name="cat">cardinality</xsl:with-param>
         <xsl:with-param name="condition" select="count(. | preceding-sibling::ata-socket) gt 1"/>
         <xsl:with-param name="msg">
            <code>ata-socket</code> appears too many times: 1 maximum is permitted.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="notice">
         <xsl:with-param name="cat">ordering</xsl:with-param>
         <xsl:with-param name="condition"
                         select="exists( preceding-sibling::memory | preceding-sibling::expansion-card )"/>
         <xsl:with-param name="msg">
            <code>ata-socket</code> is not expected to follow <code>memory</code> or <code>expansion-card</code>.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="require-for-computer_..._motherboard_..._ata-socket-assembly"/>
   </xsl:template>
   <xsl:template priority="5" match="computer/motherboard/memory" mode="test">
      <xsl:apply-templates select="@*" mode="test"/>
      <xsl:call-template name="notice">
         <xsl:with-param name="cat">ordering</xsl:with-param>
         <xsl:with-param name="condition" select="exists( preceding-sibling::expansion-card )"/>
         <xsl:with-param name="msg">
            <code>memory</code> is not expected to follow <code>expansion-card</code>.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="require-for-computer_..._motherboard_..._memory-assembly"/>
   </xsl:template>
   <xsl:template priority="5"
                 match="computer/motherboard/expansion-card"
                 mode="test">
      <xsl:apply-templates select="@*" mode="test"/>
      <xsl:call-template name="require-for-computer_..._motherboard_..._expansion-card-assembly"/>
   </xsl:template>
   <xsl:template match="motherboard/cpu/product-name/text()" mode="test"/>
   <xsl:template priority="5" match="motherboard/cpu/product-name" mode="test">
      <xsl:apply-templates select="@*" mode="test"/>
      <xsl:call-template name="notice">
         <xsl:with-param name="cat">cardinality</xsl:with-param>
         <xsl:with-param name="condition"
                         select="count(. | preceding-sibling::product-name) gt 1"/>
         <xsl:with-param name="msg">
            <code>product-name</code> appears too many times: 1 maximum is permitted.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="notice">
         <xsl:with-param name="cat">ordering</xsl:with-param>
         <xsl:with-param name="condition"
                         select="exists( preceding-sibling::architecture | preceding-sibling::speed )"/>
         <xsl:with-param name="msg">
            <code>product-name</code> is not expected to follow <code>architecture</code> or <code>speed</code>.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="require-for-product-name-field"/>
   </xsl:template>
   <xsl:template match="motherboard/ata-socket/product-name/text()" mode="test"/>
   <xsl:template priority="5"
                 match="motherboard/ata-socket/product-name"
                 mode="test">
      <xsl:apply-templates select="@*" mode="test"/>
      <xsl:call-template name="notice">
         <xsl:with-param name="cat">cardinality</xsl:with-param>
         <xsl:with-param name="condition"
                         select="count(. | preceding-sibling::product-name) gt 1"/>
         <xsl:with-param name="msg">
            <code>product-name</code> appears too many times: 1 maximum is permitted.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="notice">
         <xsl:with-param name="cat">ordering</xsl:with-param>
         <xsl:with-param name="condition" select="exists( preceding-sibling::type )"/>
         <xsl:with-param name="msg">
            <code>product-name</code> is not expected to follow <code>type</code>.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="require-for-product-name-field"/>
   </xsl:template>
   <xsl:template match="motherboard/memory/product-name/text()" mode="test"/>
   <xsl:template priority="5" match="motherboard/memory/product-name" mode="test">
      <xsl:apply-templates select="@*" mode="test"/>
      <xsl:call-template name="notice">
         <xsl:with-param name="cat">cardinality</xsl:with-param>
         <xsl:with-param name="condition"
                         select="count(. | preceding-sibling::product-name) gt 1"/>
         <xsl:with-param name="msg">
            <code>product-name</code> appears too many times: 1 maximum is permitted.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="notice">
         <xsl:with-param name="cat">ordering</xsl:with-param>
         <xsl:with-param name="condition" select="exists( preceding-sibling::byte-size )"/>
         <xsl:with-param name="msg">
            <code>product-name</code> is not expected to follow <code>byte-size</code>.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="require-for-product-name-field"/>
   </xsl:template>
   <xsl:template match="motherboard/expansion-card/product-name/text()" mode="test"/>
   <xsl:template priority="5"
                 match="motherboard/expansion-card/product-name"
                 mode="test">
      <xsl:apply-templates select="@*" mode="test"/>
      <xsl:call-template name="notice">
         <xsl:with-param name="cat">cardinality</xsl:with-param>
         <xsl:with-param name="condition"
                         select="count(. | preceding-sibling::product-name) gt 1"/>
         <xsl:with-param name="msg">
            <code>product-name</code> appears too many times: 1 maximum is permitted.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="notice">
         <xsl:with-param name="cat">ordering</xsl:with-param>
         <xsl:with-param name="condition" select="exists( preceding-sibling::type )"/>
         <xsl:with-param name="msg">
            <code>product-name</code> is not expected to follow <code>type</code>.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="require-for-product-name-field"/>
   </xsl:template>
   <xsl:template match="motherboard/vendor/name/text() | cpu/vendor/name/text() | ata-socket/vendor/name/text() | memory/vendor/name/text() | expansion-card/vendor/name/text()"
                 mode="test"/>
   <xsl:template priority="5"
                 match="motherboard/vendor/name | cpu/vendor/name | ata-socket/vendor/name | memory/vendor/name | expansion-card/vendor/name"
                 mode="test">
      <xsl:apply-templates select="@*" mode="test"/>
      <xsl:call-template name="notice">
         <xsl:with-param name="cat">cardinality</xsl:with-param>
         <xsl:with-param name="condition" select="count(. | preceding-sibling::name) gt 1"/>
         <xsl:with-param name="msg">
            <code>name</code> appears too many times: 1 maximum is permitted.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="notice">
         <xsl:with-param name="cat">ordering</xsl:with-param>
         <xsl:with-param name="condition"
                         select="exists( preceding-sibling::address | preceding-sibling::website )"/>
         <xsl:with-param name="msg">
            <code>name</code> is not expected to follow <code>address</code> or <code>website</code>.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="require-for-vendor_..._name-field"/>
   </xsl:template>
   <xsl:template match="motherboard/vendor/address/text() | cpu/vendor/address/text() | ata-socket/vendor/address/text() | memory/vendor/address/text() | expansion-card/vendor/address/text()"
                 mode="test"/>
   <xsl:template priority="5"
                 match="motherboard/vendor/address | cpu/vendor/address | ata-socket/vendor/address | memory/vendor/address | expansion-card/vendor/address"
                 mode="test">
      <xsl:apply-templates select="@*" mode="test"/>
      <xsl:call-template name="notice">
         <xsl:with-param name="cat">cardinality</xsl:with-param>
         <xsl:with-param name="condition" select="count(. | preceding-sibling::address) gt 1"/>
         <xsl:with-param name="msg">
            <code>address</code> appears too many times: 1 maximum is permitted.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="notice">
         <xsl:with-param name="cat">ordering</xsl:with-param>
         <xsl:with-param name="condition" select="exists( preceding-sibling::website )"/>
         <xsl:with-param name="msg">
            <code>address</code> is not expected to follow <code>website</code>.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="require-for-vendor_..._address-field"/>
   </xsl:template>
   <xsl:template match="motherboard/vendor/website/text() | cpu/vendor/website/text() | ata-socket/vendor/website/text() | memory/vendor/website/text() | expansion-card/vendor/website/text()"
                 mode="test"/>
   <xsl:template priority="5"
                 match="motherboard/vendor/website | cpu/vendor/website | ata-socket/vendor/website | memory/vendor/website | expansion-card/vendor/website"
                 mode="test">
      <xsl:apply-templates select="@*" mode="test"/>
      <xsl:call-template name="notice">
         <xsl:with-param name="cat">cardinality</xsl:with-param>
         <xsl:with-param name="condition" select="count(. | preceding-sibling::website) gt 1"/>
         <xsl:with-param name="msg">
            <code>website</code> appears too many times: 1 maximum is permitted.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="require-for-vendor_..._website-field"/>
   </xsl:template>
   <xsl:template match="computer/motherboard/type/text()" mode="test"/>
   <xsl:template priority="5" match="computer/motherboard/type" mode="test">
      <xsl:apply-templates select="@*" mode="test"/>
      <xsl:call-template name="notice">
         <xsl:with-param name="cat">cardinality</xsl:with-param>
         <xsl:with-param name="condition" select="count(. | preceding-sibling::type) gt 1"/>
         <xsl:with-param name="msg">
            <code>type</code> appears too many times: 1 maximum is permitted.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="notice">
         <xsl:with-param name="cat">ordering</xsl:with-param>
         <xsl:with-param name="condition"
                         select="exists( preceding-sibling::cpu | preceding-sibling::ata-socket | preceding-sibling::memory | preceding-sibling::expansion-card )"/>
         <xsl:with-param name="msg">
            <code>type</code> is not expected to follow <code>cpu</code>, <code>ata-socket</code>, <code>memory</code>,  or <code>expansion-card</code>.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="require-for-computer_..._motherboard_..._type-field"/>
   </xsl:template>
   <xsl:template match="motherboard/cpu/architecture/text()" mode="test"/>
   <xsl:template priority="5" match="motherboard/cpu/architecture" mode="test">
      <xsl:apply-templates select="@*" mode="test"/>
      <xsl:call-template name="notice">
         <xsl:with-param name="cat">cardinality</xsl:with-param>
         <xsl:with-param name="condition"
                         select="count(. | preceding-sibling::architecture) gt 1"/>
         <xsl:with-param name="msg">
            <code>architecture</code> appears too many times: 1 maximum is permitted.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="notice">
         <xsl:with-param name="cat">ordering</xsl:with-param>
         <xsl:with-param name="condition" select="exists( preceding-sibling::speed )"/>
         <xsl:with-param name="msg">
            <code>architecture</code> is not expected to follow <code>speed</code>.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="require-for-computer_..._motherboard_..._cpu_..._architecture-field"/>
   </xsl:template>
   <xsl:template match="motherboard/cpu/speed/text()" mode="test"/>
   <xsl:template priority="5" match="motherboard/cpu/speed" mode="test">
      <xsl:apply-templates select="@*" mode="test"/>
      <xsl:call-template name="notice">
         <xsl:with-param name="cat">cardinality</xsl:with-param>
         <xsl:with-param name="condition" select="count(. | preceding-sibling::speed) gt 1"/>
         <xsl:with-param name="msg">
            <code>speed</code> appears too many times: 1 maximum is permitted.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="require-for-computer_..._motherboard_..._cpu_..._speed-field"/>
   </xsl:template>
   <xsl:template match="motherboard/ata-socket/type/text()" mode="test"/>
   <xsl:template priority="5" match="motherboard/ata-socket/type" mode="test">
      <xsl:apply-templates select="@*" mode="test"/>
      <xsl:call-template name="notice">
         <xsl:with-param name="cat">cardinality</xsl:with-param>
         <xsl:with-param name="condition" select="count(. | preceding-sibling::type) gt 1"/>
         <xsl:with-param name="msg">
            <code>type</code> appears too many times: 1 maximum is permitted.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="require-for-computer_..._motherboard_..._ata-socket_..._type-field"/>
   </xsl:template>
   <xsl:template match="motherboard/memory/byte-size/text()" mode="test"/>
   <xsl:template priority="5" match="motherboard/memory/byte-size" mode="test">
      <xsl:apply-templates select="@*" mode="test"/>
      <xsl:call-template name="notice">
         <xsl:with-param name="cat">cardinality</xsl:with-param>
         <xsl:with-param name="condition" select="count(. | preceding-sibling::byte-size) gt 1"/>
         <xsl:with-param name="msg">
            <code>byte-size</code> appears too many times: 1 maximum is permitted.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="require-for-computer_..._motherboard_..._memory_..._byte-size-field"/>
   </xsl:template>
   <xsl:template match="motherboard/expansion-card/type/text()" mode="test"/>
   <xsl:template priority="5" match="motherboard/expansion-card/type" mode="test">
      <xsl:apply-templates select="@*" mode="test"/>
      <xsl:call-template name="notice">
         <xsl:with-param name="cat">cardinality</xsl:with-param>
         <xsl:with-param name="condition" select="count(. | preceding-sibling::type) gt 1"/>
         <xsl:with-param name="msg">
            <code>type</code> appears too many times: 1 maximum is permitted.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="require-for-computer_..._motherboard_..._expansion-card_..._type-field"/>
   </xsl:template>
   <xsl:template match="motherboard/vendor/@id | cpu/vendor/@id | ata-socket/vendor/@id | memory/vendor/@id | expansion-card/vendor/@id"
                 mode="test">
      <xsl:call-template name="require-for-vendor_..._id-flag"/>
   </xsl:template>
   <xsl:template match="/computer/@id" mode="test">
      <xsl:call-template name="require-for-computer_..._id-flag"/>
   </xsl:template>
   <!-- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -->
   <!-- -#- -#- -#- -#- -#- -#- -#- -#- -#- -#- -#- -#- -#- -#- -#- -#- -#- -#- -#- -#- -#- -#- -#- -#- -->
   <!--     Fallbacks for occurrences of known elements and attributes, except out of context -->
   <!-- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -->
   <xsl:template mode="test"
                 match="name | address | website | computer | motherboard | vendor | type | cpu | product-name | architecture | speed | ata-socket | memory | byte-size | expansion-card">
      <xsl:call-template name="notice">
         <xsl:with-param name="cat">context</xsl:with-param>
         <xsl:with-param name="msg" expand-text="true">
            <code>{ name() }</code> is not expected here.</xsl:with-param>
      </xsl:call-template>
   </xsl:template>
   <xsl:template mode="test" match="@id">
      <xsl:call-template name="notice">
         <xsl:with-param name="cat">context</xsl:with-param>
         <xsl:with-param name="msg" expand-text="true">
            <code>@{ name() }</code> is not expected here.</xsl:with-param>
      </xsl:call-template>
   </xsl:template>
   <!-- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -->
   <!-- -#- -#- -#- -#- -#- -#- -#- -#- -#- -#- -#- -#- -#- -#- -#- -#- -#- -#- -#- -#- -#- -#- -#- -#- -->
   <!--     Definitions - a named template for each -->
   <!-- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -->
   <xsl:template name="require-for-vendor-assembly">
      <xsl:call-template name="notice">
         <xsl:with-param name="cat">required flag</xsl:with-param>
         <xsl:with-param name="condition" select="empty(@id)"/>
         <xsl:with-param name="msg" expand-text="true">
            <code>{ name() }</code> requires <code>@id</code>.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="notice">
         <xsl:with-param name="cat">required contents</xsl:with-param>
         <xsl:with-param name="condition" select="empty(name)"/>
         <xsl:with-param name="msg" expand-text="true">
            <code>{ name() }</code> requires <code>name</code>.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="notice">
         <xsl:with-param name="cat">required contents</xsl:with-param>
         <xsl:with-param name="condition" select="empty(address)"/>
         <xsl:with-param name="msg" expand-text="true">
            <code>{ name() }</code> requires <code>address</code>.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="notice">
         <xsl:with-param name="cat">required contents</xsl:with-param>
         <xsl:with-param name="condition" select="empty(website)"/>
         <xsl:with-param name="msg" expand-text="true">
            <code>{ name() }</code> requires <code>website</code>.</xsl:with-param>
      </xsl:call-template>
   </xsl:template>
   <xsl:template name="require-for-vendor_..._id-flag"/>
   <xsl:template name="require-for-vendor_..._name-field"/>
   <xsl:template name="require-for-vendor_..._address-field"/>
   <xsl:template name="require-for-vendor_..._website-field">
      <xsl:call-template name="check-uri-datatype"/>
   </xsl:template>
   <xsl:template name="require-for-product-name-field"/>
   <xsl:template name="require-for-computer-assembly">
      <xsl:call-template name="notice">
         <xsl:with-param name="cat">required flag</xsl:with-param>
         <xsl:with-param name="condition" select="empty(@id)"/>
         <xsl:with-param name="msg" expand-text="true">
            <code>{ name() }</code> requires <code>@id</code>.</xsl:with-param>
      </xsl:call-template>
   </xsl:template>
   <xsl:template name="require-for-computer_..._id-flag"/>
   <xsl:template name="require-for-computer_..._motherboard-assembly">
      <xsl:call-template name="notice">
         <xsl:with-param name="cat">required contents</xsl:with-param>
         <xsl:with-param name="condition" select="empty(type)"/>
         <xsl:with-param name="msg" expand-text="true">
            <code>{ name() }</code> requires <code>type</code>.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="notice">
         <xsl:with-param name="cat">required contents</xsl:with-param>
         <xsl:with-param name="condition" select="empty(memory)"/>
         <xsl:with-param name="msg" expand-text="true">
            <code>{ name() }</code> requires <code>memory</code>.</xsl:with-param>
      </xsl:call-template>
   </xsl:template>
   <xsl:template name="require-for-computer_..._motherboard_..._type-field"/>
   <xsl:template name="require-for-computer_..._motherboard_..._cpu-assembly">
      <xsl:call-template name="notice">
         <xsl:with-param name="cat">required contents</xsl:with-param>
         <xsl:with-param name="condition" select="empty(product-name)"/>
         <xsl:with-param name="msg" expand-text="true">
            <code>{ name() }</code> requires <code>product-name</code>.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="notice">
         <xsl:with-param name="cat">required contents</xsl:with-param>
         <xsl:with-param name="condition" select="empty(architecture)"/>
         <xsl:with-param name="msg" expand-text="true">
            <code>{ name() }</code> requires <code>architecture</code>.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="notice">
         <xsl:with-param name="cat">required contents</xsl:with-param>
         <xsl:with-param name="condition" select="empty(speed)"/>
         <xsl:with-param name="msg" expand-text="true">
            <code>{ name() }</code> requires <code>speed</code>.</xsl:with-param>
      </xsl:call-template>
   </xsl:template>
   <xsl:template name="require-for-computer_..._motherboard_..._cpu_..._architecture-field"/>
   <xsl:template name="require-for-computer_..._motherboard_..._cpu_..._speed-field"/>
   <xsl:template name="require-for-computer_..._motherboard_..._ata-socket-assembly">
      <xsl:call-template name="notice">
         <xsl:with-param name="cat">required contents</xsl:with-param>
         <xsl:with-param name="condition" select="empty(product-name)"/>
         <xsl:with-param name="msg" expand-text="true">
            <code>{ name() }</code> requires <code>product-name</code>.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="notice">
         <xsl:with-param name="cat">required contents</xsl:with-param>
         <xsl:with-param name="condition" select="empty(type)"/>
         <xsl:with-param name="msg" expand-text="true">
            <code>{ name() }</code> requires <code>type</code>.</xsl:with-param>
      </xsl:call-template>
   </xsl:template>
   <xsl:template name="require-for-computer_..._motherboard_..._ata-socket_..._type-field"/>
   <xsl:template name="require-for-computer_..._motherboard_..._memory-assembly">
      <xsl:call-template name="notice">
         <xsl:with-param name="cat">required contents</xsl:with-param>
         <xsl:with-param name="condition" select="empty(product-name)"/>
         <xsl:with-param name="msg" expand-text="true">
            <code>{ name() }</code> requires <code>product-name</code>.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="notice">
         <xsl:with-param name="cat">required contents</xsl:with-param>
         <xsl:with-param name="condition" select="empty(byte-size)"/>
         <xsl:with-param name="msg" expand-text="true">
            <code>{ name() }</code> requires <code>byte-size</code>.</xsl:with-param>
      </xsl:call-template>
   </xsl:template>
   <xsl:template name="require-for-computer_..._motherboard_..._memory_..._byte-size-field">
      <xsl:call-template name="check-positive-integer-datatype"/>
   </xsl:template>
   <xsl:template name="require-for-computer_..._motherboard_..._expansion-card-assembly">
      <xsl:call-template name="notice">
         <xsl:with-param name="cat">required contents</xsl:with-param>
         <xsl:with-param name="condition" select="empty(product-name)"/>
         <xsl:with-param name="msg" expand-text="true">
            <code>{ name() }</code> requires <code>product-name</code>.</xsl:with-param>
      </xsl:call-template>
      <xsl:call-template name="notice">
         <xsl:with-param name="cat">required contents</xsl:with-param>
         <xsl:with-param name="condition" select="empty(type)"/>
         <xsl:with-param name="msg" expand-text="true">
            <code>{ name() }</code> requires <code>type</code>.</xsl:with-param>
      </xsl:call-template>
   </xsl:template>
   <xsl:template name="require-for-computer_..._motherboard_..._expansion-card_..._type-field"/>
   <!-- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -->
   <!-- -#- -#- -#- -#- -#- -#- -#- -#- -#- -#- -#- -#- -#- -#- -#- -#- -#- -#- -#- -#- -#- -#- -#- -#- -->
   <!--     Datatypes - a named template for each occurring -->
   <!-- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -~- -->
   <xsl:template name="check-string-datatype">
      <xsl:call-template name="notice">
         <xsl:with-param name="cat">datatype</xsl:with-param>
         <xsl:with-param name="condition" select="not( mx:datatype-validate(.,'string') )"/>
         <xsl:with-param name="msg" expand-text="true">
            <code>{ name() }</code> does not conform to <em>string</em> datatype.</xsl:with-param>
      </xsl:call-template>
   </xsl:template>
   <xsl:template name="check-uri-datatype">
      <xsl:call-template name="notice">
         <xsl:with-param name="cat">datatype</xsl:with-param>
         <xsl:with-param name="condition" select="not( mx:datatype-validate(.,'uri') )"/>
         <xsl:with-param name="msg" expand-text="true">
            <code>{ name() }</code> does not conform to <em>uri</em> datatype.</xsl:with-param>
      </xsl:call-template>
   </xsl:template>
   <xsl:template name="check-positive-integer-datatype">
      <xsl:call-template name="notice">
         <xsl:with-param name="cat">datatype</xsl:with-param>
         <xsl:with-param name="condition"
                         select="not( mx:datatype-validate(.,'positive-integer') )"/>
         <xsl:with-param name="msg" expand-text="true">
            <code>{ name() }</code> does not conform to <em>positive-integer</em> datatype.</xsl:with-param>
      </xsl:call-template>
   </xsl:template>
   <xsl:template match="ul | ol" mode="validate-markup-multiline">
      <xsl:apply-templates select="li" mode="validate-markup-multiline"/>
      <xsl:for-each select="* except li">
         <xsl:call-template name="notice-multiline"/>
      </xsl:for-each>
   </xsl:template>
   <xsl:template match="table" mode="validate-markup-multiline">
      <xsl:apply-templates select="tr" mode="validate-markup-multiline"/>
      <xsl:for-each select="* except tr">
         <xsl:call-template name="notice-multiline"/>
      </xsl:for-each>
   </xsl:template>
   <xsl:template match="tr" mode="validate-markup-multiline">
      <xsl:apply-templates select="td" mode="validate-markup-multiline"/>
      <xsl:for-each select="* except td">
         <xsl:call-template name="notice-multiline"/>
      </xsl:for-each>
   </xsl:template>
   <xsl:template match="p | li | h1 | h2 | h3 | h4 | h5 | h6"
                 mode="validate-markup-multiline">
      <xsl:apply-templates mode="validate-markup-multiline" select="@*"/>
      <xsl:apply-templates mode="validate-markup-line"/>
   </xsl:template>
   <xsl:template match="a | em | i | strong | b | u | q | code | img | insert"
                 mode="validate-markup-line">
      <xsl:apply-templates mode="validate-markup-line" select="@*"/>
      <xsl:apply-templates mode="validate-markup-line"/>
   </xsl:template>
   <xsl:template match="a/@href | img/@src | img/@title | insert/@type | insert/@id-ref"
                 mode="validate-markup-line"/>
   <xsl:template match="p/text() | li/text() | h1/text() | h2/text() | h3/text() | h4/text() | h5/text() | h6/text()"
                 mode="test"/>
   <xsl:template match="em/text() | i/text() | strong/text() | b/text() | u/text() | q/text() | code/text() | a/text()"
                 mode="test"/>
   <xsl:template name="notice">
      <xsl:param name="cat"/>
      <xsl:param name="condition"/>
      <xsl:param name="msg"/>
      <notice cat="{$cat}" condition="$condition">
         <xsl:copy-of select="$msg"/>
      </notice>
   </xsl:template>
   <xsl:template name="notice-multiline"/>
   <xsl:function name="mx:datatype-validate">
      <xsl:param name="who"/>
      <xsl:param name="waht"/>
   </xsl:function>
   <xsl:template match="/">
      <result>
         <xsl:apply-templates mode="test"/>
      </result>
   </xsl:template>
</xsl:transform>
