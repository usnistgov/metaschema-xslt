<?xml version="1.0" encoding="UTF-8"?>
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:m="http://csrc.nist.gov/ns/oscal/metaschema/1.0"
    xmlns:nm="http://csrc.nist.gov/ns/metaschema"
    xmlns:sqf="http://www.schematron-quickfix.com/validator/process">

<!-- Extra-XSD validation for NIST Metaschema format 

    This is ISO Schematron with XSLT extensions, requiring 'allow-foreign-namespace' to run.

       -->

    <sch:ns uri="http://csrc.nist.gov/ns/oscal/metaschema/1.0" prefix="m"/>
    <sch:ns uri="http://csrc.nist.gov/ns/metaschema" prefix="nm"/>
    
    <xsl:include href="metaschema-validation-support.xsl"/>
    
    <!--<xsl:import href="oscal-datatypes-check.xsl"/>-->
    
    <xsl:import href="oscal-datatypes-check.xsl"/>
    
    <!--<xsl:param    name="global-context" select="/"/>-->
    
    
 
    <!--<sch:let name="metaschema-is-abstract" value="/m:METASCHEMA/@abstract='yes'"/>-->
    
    <sch:pattern id="pattern-metaschema-header">
        <sch:rule id="rule-metaschema-header" context="/m:METASCHEMA">
            <sch:assert id="require-successful-composition" role="warning"
                test="exists($composed-metaschema)">Can't find composition...</sch:assert>
            <sch:assert id="require-short-name"
                test="exists(m:short-name)">Metaschema 'short-name' must be set for any top-level metaschema</sch:assert>
            <sch:assert id="require-schema-version-for-top-level"
                test="@abstract='yes' or exists(m:schema-version)">Metaschema 'schema-version' must be set for any top-level metaschema</sch:assert>
            <sch:report id="require-unique-short-names" test="exists($composed-metaschema/m:METASCHEMA/m:EXCEPTION[@problem-type='metaschema-short-name-clash'])"><sch:value-of select="$composed-metaschema/m:METASCHEMA/m:EXCEPTION[@problem-type='metaschema-short-name-clash']"/></sch:report>
            <sch:assert id="expect-root-assembly-for-top-level"
                test="@abstract='yes' or exists($composed-metaschema/m:METASCHEMA/m:define-assembly/m:root-name)">Unless marked as @abstract='yes', a metaschema (or an imported metaschema) should have at least one assembly with a root-name.</sch:assert>
        </sch:rule>
        <sch:rule id="rule-metaschema-header-import" context="/m:METASCHEMA/m:import">
            <sch:report id="detect-circular-import" test="exists($composed-metaschema/m:METASCHEMA/m:import[@href=./@href]/m:EXCEPTION[@problem-type='circular-import'])"><sch:value-of select="$composed-metaschema/m:METASCHEMA/m:import[@href=./@href]/m:EXCEPTION[@problem-type='circular-import']"/></sch:report>
            <sch:assert id="expect-resource-at-href" test="exists(document(@href)/m:METASCHEMA)">Can't find a metaschema at <sch:value-of select="@href"/></sch:assert>
        </sch:rule>
    </sch:pattern>
    
    <sch:pattern id="pattern-duplication-and-name-clashing">
        
        <sch:rule id="rule-name-clash-instances" context="m:assembly | m:field | m:flag">
<!--            <sch:report role="information" test="true()">ID: <xsl:value-of select="nm:metaschema-module-node-identifier(.)"/></sch:report>
            <sch:report role="information" test="true()">
                <xsl:for-each select="$composed-metaschema//m:define-assembly | $composed-metaschema//m:define-field | $composed-metaschema//m:define-flag
                    | $composed-metaschema//m:flag | $composed-metaschema//m:field | $composed-metaschema//m:assembly">
                    <xsl:if test="position() > 1">, </xsl:if>
                    <xsl:value-of select="nm:composed-node-id(.)"/>
                </xsl:for-each>
            </sch:report>
            <sch:report role="information" test="true()">As composed: '<xsl:value-of select="nm:as-composed(.)/serialize(.)" separator=", "/>'</sch:report>
            <sch:report role="information" test="true()">Defs ID: <xsl:value-of select="nm:composed-definition-identifier(nm:as-composed(.))"/></sch:report>
            <sch:report role="information" test="true()">Defs: '<xsl:value-of select="nm:definitions-for-reference(nm:as-composed(.))/serialize(.)" separator=", "/>'</sch:report>
-->            
            <sch:let name="as-composed" value="nm:as-composed(.)"/>
            <sch:let name="is-multiple" value="count($as-composed) gt 1"/>
            <sch:let name="defs-for-reference" value="$as-composed/nm:definitions-for-reference(.)"/>

<!-- emit some diagnostics to determine whazzup -->
            <sch:assert id="require-a-reference-in-composition" test="count($defs-for-reference) gt 0" >No <sch:name/> appears named "<sch:value-of select="@ref"/>" ... please check</sch:assert>
            
            <sch:assert id="require-unambiguous-reference-in-composition" test="count($defs-for-reference) le 1" >Ambiguous reference to '<sch:value-of select="@ref"/>' found in <sch:name/>. The reference resolved to define-<sch:name/> <sch:value-of select="if (count($defs-for-reference) gt 1) then ' definitions' else 'definition'"/> with the name '<sch:value-of select="@ref"/>' in: <sch:value-of select="$defs-for-reference/@_base-uri => string-join(', ')"/>. Is this due to a duplicated METASCHEMA/short-name in a module?</sch:assert>
            
            <sch:let name="my-xml-name"  value="$as-composed/@_in-xml-name"/>
            <sch:let name="my-json-name" value="$as-composed/@_in-json-name"/>
            
            <!-- second clause accounts for flags as separate items -->
            <sch:let name="rivals"
                value="$as-composed/ancestor::m:model[1]/(*|m:choice/*)
                     | $as-composed/../(m:flag|m:define-flag)"/>
            <sch:let name="named-like-me-in-xml" value="$rivals[@_in-xml-name=$my-xml-name]"/>
            <sch:let name="named-like-me-in-json" value="$rivals[@_in-json-name=$my-json-name]"/>
            
<!--            <sch:report role="information" test="true()">Rivals in JSON: <xsl:value-of select="$rivals/serialize(.)" separator=", "/></sch:report>
            <sch:report role="information" test="true()">Named like me in JSON: <xsl:value-of select="$named-like-me-in-json/serialize(.)" separator=", "/></sch:report>
            <sch:report role="information" test="empty($as-composed) or $is-multiple">Not finding '<sch:value-of select="$my-json-name"/>'</sch:report>
-->            
            <sch:assert id="require-unique-json-sibling-names" test="empty($as-composed) or $is-multiple or count($named-like-me-in-json) = 1">Name clash among sibling properties (of the same object) with JSON name '<sch:value-of select="$my-json-name"/>'. <sch:value-of select="count($named-like-me-in-json)"/></sch:assert>
            <sch:assert id="require-unique-xml-sibling-names" test="empty($as-composed) or $is-multiple or count($named-like-me-in-xml) = 1">Name clash among sibling elements or attributes with XML name '<sch:value-of select="$my-xml-name"/>'.</sch:assert>
        </sch:rule>
        
        <sch:rule id="rule-name-clash-definitions" context="m:define-flag | m:define-field | m:define-assembly"><sch:let name="as-composed" value="nm:as-composed(.)"/>
            <sch:let name="is-multiple" value="count($as-composed) gt 1"/>

            <sch:assert id="require-unambiguous-definitions" test="not($is-multiple)">Duplicate name found for <sch:name/> '<sch:value-of select="@name"/>' in: <sch:value-of select="$as-composed/@_base-uri => string-join(', ')"/>. Is this due to a duplicated METASCHEMA/short-name in a module?</sch:assert>
            
        </sch:rule>
    </sch:pattern>
    
    <sch:pattern id="pattern-definition-shadowing">
        <sch:rule id="rule-definition-shadowing" context="/m:METASCHEMA/m:define-assembly | /m:METASCHEMA/m:define-field | /m:METASCHEMA/m:define-flag">
            <sch:let name="as-composed" value="nm:as-composed(.)"/>
            <!-- filter out current node from defs. This allows a non-match to pass the following assertion, which can happen if the target definition was found to be unused. -->
            <sch:let name="extra-definitions" value="nm:composed-top-level-definitions-matching(.) except $as-composed"/>
            <sch:assert test="empty($extra-definitions)" id="detect-shadowed-definitions" role="warning">Definition shadows another definition in this (composed) metaschema: see <sch:name/> <sch:value-of select="$extra-definitions/concat(@module,':',@name) => string-join(', ')"/> (<sch:value-of select="$extra-definitions/@_base-uri => string-join(', ')"/>)</sch:assert>
        </sch:rule>
    </sch:pattern>

    <sch:pattern id="group-as">
        <sch:rule context="m:assembly | m:field | m:model/m:define-assembly | m:model/m:define-field">
            <sch:let name="as-composed" value="nm:as-composed(.)"/>

            <sch:assert test="not(exists($as-composed)) or number($as-composed/@max-occurs)=1 or exists($as-composed/m:group-as/@name)" id="expect-group-as-with-maxoccurs-gt-1">Unless @max-occurs is 1, a group-as name must be given within an instance or a local definition.</sch:assert>
        </sch:rule>

        <sch:rule context="m:group-as">
            <sch:let name="name" value="@name"/>
            <sch:report test="../@max-occurs/number() = 1">"group-as" should not be used when max-occurs is 1.</sch:report>

<!--            <sch:report test="true()">Parent ID: <xsl:value-of select="nm:metaschema-module-node-identifier(parent::*)"/></sch:report>-->
            
            <sch:let name="parent-as-composed" value="nm:as-composed(parent::*)"/>

<!--            <sch:report test="true()">Parent Composed: '<xsl:value-of select="$parent-as-composed/serialize(.)"/>'</sch:report>-->

            <sch:let name="def-as-composed" value="$parent-as-composed/nm:definitions-for-reference(.)"/>

<!--            <sch:report test="true()">Definition: '<xsl:value-of select="nm:definition-for-reference($parent-as-composed)/serialize(.)"/>'</sch:report>
-->            
            <sch:assert test="not($parent-as-composed/m:group-as/@in-json='BY_KEY') or exists($def-as-composed/m:json-key)">Cannot group by key since the definition of <sch:value-of select="name(..)"/> '<sch:value-of select="../(@ref | @name)"/>' has no json-key specified. Consider adding a json-key to the '<sch:value-of select="../@ref"/>' definition, or using a different 'in-json' setting.</sch:assert>

            <sch:assert test="$parent-as-composed/m:group-as/@in-json='BY_KEY' or empty($def-as-composed/m:json-key)">The definition of <sch:value-of select="name(..)"/> '<sch:value-of select="../(@ref | @name)"/>' has a json-key specified. Consider using in-json="BY_KEY".</sch:assert>
            <!-- TODO: need to test $def-as-composed/m:json-key/@flag-ref = $def-as-composed/(m:flag/@ref|m:define-flag/@name) -->
            
        </sch:rule>
    </sch:pattern>


    <sch:pattern id="atomic_datatypes">
        <sch:let name="more-types" value="'markup-line','markup-multiline'"/>
        <sch:rule context="m:field | m:define-field | m:flag | m:define-flag">
            <sch:let name="given-type" value="(@as-type,'string')[1]"/>
            <sch:let name="bound-type" value="$type-map[@as-type = $given-type]"/>
            <sch:assert test="($given-type = $more-types) or exists($bound-type)">type <sch:value-of select="@as-type"/> is unknown.</sch:assert>
            <sch:report sqf:fix="updateDatatype" id="warn-if-datatype-name-is-deprecated" role="warning"
                test="matches($bound-type/@prefer,'\S')">Type name '<sch:value-of select="$given-type" />' is deprecated: '<sch:value-of select="$bound-type/@prefer"/>' is preferred</sch:report>
            
            <sqf:fix id="updateDatatype">
                <sqf:description>
                    <sqf:title>Update the datatype to '<sch:value-of select="$bound-type/@prefer"/>'</sqf:title>
                </sqf:description>
                <sqf:replace match="@as-type" node-type="attribute" target="as-type">
                    <sch:value-of select="$bound-type/@prefer"/>
                </sqf:replace>
            </sqf:fix>
        </sch:rule>
    </sch:pattern>
    
    <sch:pattern id="flags_and_fields_and_datatypes">
        <!-- flag references and inline definitions -->
        <sch:rule context="m:flag | m:define-field/m:define-flag | m:define-assembly/m:define-flag">
            <sch:assert id="json-value-key-flag-is-required"
                test="not((@name | @ref) = ../m:json-value-key-flag/@flag-ref) or @required = 'yes'">A flag declared as a value key must be required (@required='yes')</sch:assert>
            <sch:assert id="json-value-flag-is-required"
                test="not((@name | @ref) = ../m:json-key-flag/@flag-ref) or @required = 'yes'">A flag declared as a key must be required (@required='yes')</sch:assert>
        </sch:rule>
        
        <!--field references and inline definitions -->
        <sch:rule context="m:field | m:model//m:define-field">
            <!-- constraints on markup-multiline **XXX** TEST ME -->
            <!--<sch:let name="as-composed" as="element()*" select="key('composed-node-by-identifier',nm:metaschema-module-node-identifier(.),$composed-metaschema)"/>-->
            <sch:let name="as-composed" value="nm:as-composed(.)"/>
            <sch:assert id="permit-a-single-unwrapped-markupmultiline" test="empty($as-composed) or not($as-composed/@in-xml='UNWRAPPED') or not($as-composed/@as-type='markup-multiline') or not(preceding-sibling::*[$as-composed/@in-xml='UNWRAPPED']/@as-type='markup-multiline')">Only one field may be marked as 'markup-multiline' (without xml wrapping) within a model.</sch:assert>
            <sch:report id="forbid-multiple-unwrapped-fields" test="($as-composed/@in-xml='UNWRAPPED') and (@max-occurs!='1')">An 'unwrapped' field must have a max occurrence of 1</sch:report>
            <sch:assert id="forbid-unwrapped-xml-except-markupmultiline" test="$as-composed/key('composed-definition-by-key-name',nm:composed-definition-identifier(.),$composed-metaschema)/@as-type='markup-multiline' or not(@in-xml='UNWRAPPED')">Only 'markup-multiline' fields may be unwrapped in XML. SEEING '<sch:value-of select="nm:composed-definition-identifier(.)"/>'</sch:assert>
            
            
        </sch:rule>
        
        <sch:rule context="m:define-field">
            <!-- use @subject to refine the reporting? -->
            <sch:assert id="forbid-flags-on-unwrapped-markupmultiline" test="empty(m:flag|m:define-flag) or not(@as-type='markup-multiline' and @in-xml='UNWRAPPED')">Multiline markup fields must have no flags, unless always used with a wrapper - put your flags on an assembly with an unwrapped multiline field.</sch:assert>
        </sch:rule>

        <sch:rule context="m:json-key">
            <sch:let name="json-key-flag-name" value="@flag-ref"/>
            <sch:let name="json-key-flag" value="../m:flag[@ref=$json-key-flag-name] |../m:define-flag[@name=$json-key-flag-name]"/>
            <sch:let name="parent-flag-names" value="../m:flag/@ref | ../m:define-flag/@name"/>
            <sch:assert test="exists($json-key-flag)" id="require-json-key-flag-is-a-flag">JSON key indicates no flag on this <sch:value-of select="substring-after(local-name(..),'define-')"/> 
                <sch:value-of select=".[exists($parent-flag-names)]/(' - @flag-ref should be (one of) ' || $parent-flag-names => string-join(', '))"/>
            </sch:assert>
        </sch:rule>
        
        <sch:rule context="m:json-value-key-flag">
            <sch:assert test="@flag-ref = (../m:flag/@ref|../m:define-flag/@name)" id="locate-json-key-name">flag '<sch:value-of select="@flag-ref"/>' not found for JSON value key</sch:assert>
        </sch:rule>
        
        <sch:rule context="m:allowed-values/m:enum">
            <sch:assert test="not(@value = preceding-sibling::*/@value)" id="require-distinct-enumeration">Allowed value '<sch:value-of select="@value"/>' may only be specified once for flag '<sch:value-of select="../../@name"/>'.</sch:assert>
            <sch:assert test="m:datatype-validate(@value,../../@as-type)" id="require-enumeration-to-conform-to-given-type">Value '<sch:value-of select="@value"/>' is not a valid token of type <sch:value-of select="../../@as-type"/></sch:assert>
        </sch:rule>
        
        <sch:rule context="m:index">
            <sch:assert test="count(key('index-by-name',@name,$composed-metaschema))=1" id="require-unique-index-name">Only one index or uniqueness assertion may be named '<sch:value-of select="@name"/>'</sch:assert>
        </sch:rule>
        
        <sch:rule context="m:index-has-key">
            <sch:assert test="count(key('index-by-name',@name,$composed-metaschema)/self::m:index)=1" id="require-index-for-index-key">No '<sch:value-of select="@name"/>' index is defined.</sch:assert>
        </sch:rule>
        
        <sch:rule context="m:key-field">
            <sch:report test="@target = preceding-sibling::*/@target" id="require-distinct-key-field">Index key field target '<sch:value-of select="@target"/>' is already declared.</sch:report>
        </sch:rule>
    </sch:pattern>
    
    <sch:pattern id="schema-docs">
        <sch:rule context="m:define-assembly | m:define-field | m:define-flag">
            <sch:assert role="warning" test="exists(m:formal-name)" id="expect-formal-name">Formal name missing from <sch:name/> named '<sch:value-of select="@name"/>'</sch:assert>
            <sch:assert role="warning" test="exists(m:description)" id="expect-description">Short description missing from <sch:name/> named '<sch:value-of select="@name"/>'</sch:assert>
        </sch:rule>
        
        <sch:rule context="m:p | m:li | m:pre">
            <sch:assert test="matches(.,'\S')" id="discourage-whitespace-only">Empty <name/> (is likely to distort rendition)</sch:assert>
        </sch:rule>

        <sch:rule context="m:description">
            <sch:assert role="warning" test="ends-with(.,'.')" id="description-ends-with-dot">Description should end with a period.</sch:assert>
            <sch:assert role="warning" test="string-length(.) gt 6" id="description-long-enough">Description is too short.</sch:assert>
        </sch:rule>
    </sch:pattern>
    
    
    
</sch:schema>