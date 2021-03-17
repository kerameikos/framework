<?xml version="1.0" encoding="UTF-8"?>
<!-- Author: Ethan Gruber
    Date: March 2021
    Function: XSLT templates that construct the XML metamodel used in various contexts for SPARQL queries. 
    The sparql-metamodel.xsl stylesheet converts this XML model into text for the SPARQL endpoint
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:kerameikos="http://kerameikos.org/"
    exclude-result-prefixes="#all" version="2.0">

    <!-- convert the $filter params (simple, semi-colon separated fragments) for the metrical and distribution analysis interfaces 
    into an XML meta-model that reflects complex SPARQL queries-->
    <xsl:template name="kerameikos:filterToMetamodel">
        <xsl:param name="subject"/>
        <xsl:param name="filter"/>

        <xsl:for-each select="tokenize($filter, ';')">
            <xsl:variable name="property" select="substring-before(normalize-space(.), ' ')"/>
            <xsl:variable name="object" select="substring-after(normalize-space(.), ' ')"/>
            <xsl:choose>
                <xsl:when test="$property = 'keeper'">
                    <triple s="{$subject}" p="crm:P50_has_current_keeper" o="{$object}"/>
                </xsl:when>
                <xsl:when test="$property = 'material'">
                    <triple s="{$subject}" p="crm:P45_consists_of" o="{$object}"/>
                </xsl:when>
                <xsl:when test="$property = 'period'">
                    <triple s="{$subject}" p="crm:P108i_was_produced_by" o="?prod"/>
                    <triple s="?prod" p="crm:P10_falls_within" o="{$object}"/>
                </xsl:when>
                <xsl:when test="$property = 'person' or $property = 'workshop'">
                    <triple s="{$subject}" p="crm:P108i_was_produced_by" o="?prod"/>
                    <union>
                        <triple s="?prod" p="crm:P14_carried_out_by" o="{$object}"/>
                        <triple s="?prod" p="crm:P9_consists_of/crm:P14_carried_out_by" o="{$object}"/>
                    </union>
                </xsl:when>
                <xsl:when test="$property = 'productionPlace'">

                    <select variables="?broader">
                        <triple s="{$object}" p="^skos:broader+" o="?broader"/>
                    </select>
                    
                    <triple s="{$subject}" p="crm:P108i_was_produced_by" o="?prod"/>
                    <union>
                        <triple s="?prod" p="crm:P7_took_place_at" o="{$object}"/>
                        <triple s="?prod" p="crm:P7_took_place_at" o="?broader"/>
                    </union>
                    
                </xsl:when>
                <xsl:when test="$property = 'shape'">
                    <triple s="{$subject}" p="kon:hasShape" o="{$object}"/>
                </xsl:when>
                <xsl:when test="$property = 'technique'">
                    <triple s="{$subject}" p="crm:P108i_was_produced_by" o="?prod"/>
                    <triple s="?prod" p="crm:P32_used_general_technique" o="{$object}"/>
                </xsl:when>
                <!--<xsl:when test="$property = 'from'">
                    <xsl:if test="$object castable as xs:integer">
                        <xsl:variable name="gYear" select="format-number(number($object), '0000')"/>

                        <triple s="?vase" p="nmo:hasStartDate" o="?startDate">
                            <xsl:attribute name="filter">
                                <xsl:text>(?startDate >= "</xsl:text>
                                <xsl:value-of select="$gYear"/>
                                <xsl:text>"^^xsd:gYear)</xsl:text>
                            </xsl:attribute>
                        </triple>
                    </xsl:if>
                </xsl:when>
                <xsl:when test="$property = 'to'">
                    <xsl:if test="$object castable as xs:integer">
                        <xsl:variable name="gYear" select="format-number(number($object), '0000')"/>

                        <triple s="?vase" p="nmo:hasEndDate" o="?endDate">
                            <xsl:attribute name="filter">
                                <xsl:text>(?endDate &lt;= "</xsl:text>
                                <xsl:value-of select="$gYear"/>
                                <xsl:text>"^^xsd:gYear)</xsl:text>
                            </xsl:attribute>
                        </triple>
                    </xsl:if>
                </xsl:when>-->
            </xsl:choose>
        </xsl:for-each>
    </xsl:template>

    <!-- extract the $dist for distribution queries or the $facet for the SPARQL-based facet drop down menu. The prefLabel portion of the query is embedded in the SPARQL -->
    <xsl:template name="kerameikos:distToMetamodel">
        <xsl:param name="object"/>
        <xsl:param name="dist"/>

        <xsl:choose>
            <xsl:when test="$dist = 'keeper'">
                <triple s="?object" p="crm:P50_has_current_keeper" o="{$object}"/>
            </xsl:when>
            <xsl:when test="$dist = 'material'">
                <triple s="?object" p="crm:P45_consists_of" o="{$object}"/>
            </xsl:when>
            <xsl:when test="$dist = 'period'">
                <triple s="?prod" p="crm:P10_falls_within" o="{$object}"/>
            </xsl:when>
            <xsl:when test="$dist = 'person' or $dist = 'workshop'">
                <union>
                    <triple s="?prod" p="crm:P14_carried_out_by" o="{$object}"/>
                    <triple s="?prod" p="crm:P9_consists_of/crm:P14_carried_out_by" o="{$object}"/>
                </union>
            </xsl:when>
            <xsl:when test="$dist = 'productionPlace'">
                <triple s="?prod" p="crm:P7_took_place_at" o="{$object}"/>
            </xsl:when>
            <xsl:when test="$dist = 'shape'">
                <triple s="?object" p="kon:hasShape" o="{$object}"/>
            </xsl:when>
            <xsl:when test="$dist = 'technique'">
                <triple s="?prod" p="crm:P32_used_general_technique" o="{$object}"/>
            </xsl:when>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="kerameikos:getFindspotsStatements">
        <xsl:param name="type"/>
        <xsl:param name="id"/>

        <statements>
            <xsl:choose>
                <xsl:when test="$type = 'crm:E4_Period'">
                    <xsl:call-template name="kerameikos:matchingConcepts">
                        <xsl:with-param name="id" select="$id"/>
                        <xsl:with-param name="type" select="$type"/>
                    </xsl:call-template>

                    <triple s="?object" p="crm:P108i_was_produced_by" o="?prod"/>
                    <triple s="?prod" p="crm:P10_falls_within" o="?m"/>

                    <xsl:call-template name="kerameikos:findspotLocations"/>
                </xsl:when>
                <xsl:when test="$type = 'crm:E57_Material'">
                    <xsl:call-template name="kerameikos:matchingConcepts">
                        <xsl:with-param name="id" select="$id"/>
                        <xsl:with-param name="type" select="$type"/>
                    </xsl:call-template>

                    <triple s="?object" p="crm:P45_consists_of" o="?m"/>

                    <xsl:call-template name="kerameikos:findspotLocations"/>
                </xsl:when>
                <xsl:when test="$type = 'kon:ProductionPlace'">
                    <xsl:call-template name="kerameikos:matchingConcepts">
                        <xsl:with-param name="id" select="$id"/>
                        <xsl:with-param name="type" select="$type"/>
                    </xsl:call-template>

                    <triple s="?object" p="crm:P108i_was_produced_by" o="?prod"/>
                    <triple s="?prod" p="crm:P7_took_place_at" o="?m"/>

                    <xsl:call-template name="kerameikos:findspotLocations"/>
                </xsl:when>
                <xsl:when test="$type = 'crm:E40_Legal_Body'">
                    <triple s="?object" p="crm:P50_has_current_keeper" o="kid:{$id}"/>

                    <xsl:call-template name="kerameikos:findspotLocations"/>
                </xsl:when>
                <xsl:when test="$type = 'kon:Shape'">
                    <xsl:call-template name="kerameikos:matchingConcepts">
                        <xsl:with-param name="id" select="$id"/>
                        <xsl:with-param name="type" select="$type"/>
                    </xsl:call-template>

                    <triple s="?object" p="kon:hasShape" o="?m"/>

                    <xsl:call-template name="kerameikos:findspotLocations"/>
                </xsl:when>
                <xsl:when test="$type = 'kon:Technique'">
                    <xsl:call-template name="kerameikos:matchingConcepts">
                        <xsl:with-param name="id" select="$id"/>
                        <xsl:with-param name="type" select="$type"/>
                    </xsl:call-template>


                    <triple s="?object" p="crm:P108i_was_produced_by" o="?prod"/>
                    <triple s="?prod" p="crm:P32_used_general_technique" o="?m"/>

                    <xsl:call-template name="kerameikos:findspotLocations"/>
                </xsl:when>

                <xsl:when test="$type = 'foaf:Person' or $type = 'foaf:Group'">
                    <xsl:call-template name="kerameikos:matchingConcepts">
                        <xsl:with-param name="id" select="$id"/>
                        <xsl:with-param name="type" select="$type"/>
                    </xsl:call-template>

                    <triple s="?object" p="crm:P108i_was_produced_by" o="?prod"/>
                    <union>
                        <triple s="?prod" p="crm:P14_carried_out_by" o="?m"/>
                        <triple s="?prod" p="crm:P9_consists_of/crm:P14_carried_out_by" o="?m"/>
                    </union>

                    <xsl:call-template name="kerameikos:findspotLocations"/>
                </xsl:when>
            </xsl:choose>
        </statements>
    </xsl:template>

    <xsl:template name="kerameikos:findspotLocations">
        <triple s="?object" p="crmsci:O19i_was_object_found_by" o="?encounter"/>
        <triple s="?encounter" p="rdf:type" o="crmsci:S19_Encounter_Event"/>
        <triple s="?encounter" p="crm:P7_took_place_at/crm:P89_falls_within" o="?place"/>
    </xsl:template>

    <xsl:template name="kerameikos:getProductionPlacesStatements">
        <xsl:param name="type"/>
        <xsl:param name="id"/>

        <statements>
            <xsl:choose>
                <xsl:when test="$type = 'crm:E4_Period'">
                    <xsl:call-template name="kerameikos:matchingConcepts">
                        <xsl:with-param name="id" select="$id"/>
                        <xsl:with-param name="type" select="$type"/>
                    </xsl:call-template>

                    <triple s="?object" p="crm:P108i_was_produced_by" o="?prod"/>
                    <triple s="?prod" p="crm:P10_falls_within" o="?m"/>

                    <xsl:call-template name="kerameikos:matchingPlaces"/>

                    <triple s="?place" p="geo:location" o="?loc"/>
                </xsl:when>
                <xsl:when test="$type = 'crm:E57_Material'">
                    <xsl:call-template name="kerameikos:matchingConcepts">
                        <xsl:with-param name="id" select="$id"/>
                        <xsl:with-param name="type" select="$type"/>
                    </xsl:call-template>

                    <triple s="?object" p="crm:P45_consists_of" o="?m"/>
                    <triple s="?object" p="crm:P108i_was_produced_by" o="?prod"/>

                    <xsl:call-template name="kerameikos:matchingPlaces"/>

                    <triple s="?place" p="geo:location" o="?loc"/>
                </xsl:when>
                <xsl:when test="$type = 'kon:ProductionPlace'">
                    <union>
                        <group>
                            <triple s="kid:{$id}" p="geo:location" o="?loc"/>
                        </group>
                        <group>
                            <triple s="?place" p="skos:broader+" o="kid:{$id}"/>
                            <triple s="?place" p="geo:location" o="?loc"/>
                        </group>
                    </union>
                </xsl:when>
                <xsl:when test="$type = 'crm:E40_Legal_Body'">
                    <triple s="?object" p="crm:P50_has_current_keeper" o="kid:{$id}"/>
                    <triple s="?object" p="crm:P108i_was_produced_by" o="?prod"/>

                    <xsl:call-template name="kerameikos:matchingPlaces"/>

                    <triple s="?place" p="geo:location" o="?loc"/>
                </xsl:when>
                <xsl:when test="$type = 'kon:Shape'">
                    <xsl:call-template name="kerameikos:matchingConcepts">
                        <xsl:with-param name="id" select="$id"/>
                        <xsl:with-param name="type" select="$type"/>
                    </xsl:call-template>

                    <triple s="?object" p="kon:hasShape" o="?m"/>
                    <triple s="?object" p="crm:P108i_was_produced_by" o="?prod"/>

                    <xsl:call-template name="kerameikos:matchingPlaces"/>

                    <triple s="?place" p="geo:location" o="?loc"/>
                </xsl:when>
                <xsl:when test="$type = 'kon:Technique'">
                    <xsl:call-template name="kerameikos:matchingConcepts">
                        <xsl:with-param name="id" select="$id"/>
                        <xsl:with-param name="type" select="$type"/>
                    </xsl:call-template>

                    <triple s="?object" p="crm:P108i_was_produced_by" o="?prod"/>
                    <triple s="?prod" p="crm:P32_used_general_technique" o="?m"/>

                    <xsl:call-template name="kerameikos:matchingPlaces"/>

                    <triple s="?place" p="geo:location" o="?loc"/>
                </xsl:when>

                <xsl:when test="$type = 'foaf:Person' or $type = 'foaf:Group'">
                    <xsl:call-template name="kerameikos:matchingConcepts">
                        <xsl:with-param name="id" select="$id"/>
                        <xsl:with-param name="type" select="$type"/>
                    </xsl:call-template>

                    <triple s="?object" p="crm:P108i_was_produced_by" o="?prod"/>
                    <union>
                        <triple s="?prod" p="crm:P14_carried_out_by" o="?m"/>
                        <triple s="?prod" p="crm:P9_consists_of/crm:P14_carried_out_by" o="?m"/>
                    </union>

                    <xsl:call-template name="kerameikos:matchingPlaces"/>

                    <triple s="?place" p="geo:location" o="?loc"/>
                </xsl:when>
            </xsl:choose>
        </statements>
    </xsl:template>

    <xsl:template name="kerameikos:matchingPlaces">
        <union>
            <group>
                <triple s="?prod" p="crm:P7_took_place_at" o="?place"/>
            </group>
            <group>
                <triple s="?prod" p="crm:P7_took_place_at" o="?relPlace"/>
                <triple s="?place" p="skos:exactMatch" o="?relPlace"/>
            </group>
        </union>
    </xsl:template>

    <xsl:template name="kerameikos:listObjectsStatements">
        <xsl:param name="type"/>
        <xsl:param name="id"/>

        <statements>
            <xsl:choose>
                <xsl:when test="$type = 'crm:E4_Period'">
                    <xsl:call-template name="kerameikos:matchingConcepts">
                        <xsl:with-param name="id" select="$id"/>
                        <xsl:with-param name="type" select="$type"/>
                    </xsl:call-template>

                    <triple s="?object" p="crm:P108i_was_produced_by" o="?prod"/>
                    <triple s="?prod" p="crm:P10_falls_within" o="?m"/>
                </xsl:when>
                <xsl:when test="$type = 'crm:E57_Material'">
                    <xsl:call-template name="kerameikos:matchingConcepts">
                        <xsl:with-param name="id" select="$id"/>
                        <xsl:with-param name="type" select="$type"/>
                    </xsl:call-template>

                    <triple s="?object" p="crm:P45_consists_of" o="?m"/>
                </xsl:when>
                <xsl:when test="$type = 'kon:ProductionPlace'">
                    <xsl:call-template name="kerameikos:matchingConcepts">
                        <xsl:with-param name="id" select="$id"/>
                        <xsl:with-param name="type" select="$type"/>
                    </xsl:call-template>

                    <triple s="?object" p="crm:P108i_was_produced_by" o="?prod"/>
                    <triple s="?prod" p="crm:P7_took_place_at" o="?m"/>
                </xsl:when>
                <xsl:when test="$type = 'crm:E40_Legal_Body'">
                    <triple s="?object" p="crm:P50_has_current_keeper" o="kid:{$id}"/>
                </xsl:when>
                <xsl:when test="$type = 'kon:Shape'">
                    <xsl:call-template name="kerameikos:matchingConcepts">
                        <xsl:with-param name="id" select="$id"/>
                        <xsl:with-param name="type" select="$type"/>
                    </xsl:call-template>

                    <triple s="?object" p="kon:hasShape" o="?m"/>
                </xsl:when>
                <xsl:when test="$type = 'kon:Technique'">
                    <xsl:call-template name="kerameikos:matchingConcepts">
                        <xsl:with-param name="id" select="$id"/>
                        <xsl:with-param name="type" select="$type"/>
                    </xsl:call-template>

                    <triple s="?object" p="crm:P108i_was_produced_by" o="?prod"/>
                    <triple s="?prod" p="crm:P32_used_general_technique" o="?m"/>
                </xsl:when>

                <xsl:when test="$type = 'foaf:Person' or $type = 'foaf:Group'">
                    <xsl:call-template name="kerameikos:matchingConcepts">
                        <xsl:with-param name="id" select="$id"/>
                        <xsl:with-param name="type" select="$type"/>
                    </xsl:call-template>

                    <triple s="?object" p="crm:P108i_was_produced_by" o="?prod"/>
                    <union>
                        <triple s="?prod" p="crm:P14_carried_out_by" o="?m"/>
                        <triple s="?prod" p="crm:P9_consists_of/crm:P14_carried_out_by" o="?m"/>
                    </union>
                    
                </xsl:when>
            </xsl:choose>
        </statements>
    </xsl:template>

    <!-- template for gathering matching terms and subtypes -->
    <xsl:template name="kerameikos:matchingConcepts">
        <xsl:param name="id"/>
        <xsl:param name="type"/>

        <select variables="?m">
            <union>
                <group>
                    <triple s="kid:{$id}" p="skos:exactMatch" o="?m"/>
                </group>
                <group>
                    <triple s="?m" p="rdf:type" o="skos:Concept" filter="(?m = kid:{$id})"/>
                </group>
                <!-- don't look for narrower concepts for people -->
                <xsl:if test="not($type = 'foaf:Person')">
                    <group>
                        <triple s="kid:{$id}" p="^skos:broader+" o="?m"/>
                    </group>
                    <group>
                        <triple s="kid:{$id}" p="^skos:broader+" o="?narrower"/>
                        <triple s="?narrower" p="skos:exactMatch" o="?m"/>
                    </group>
                </xsl:if>
            </union>
        </select>
    </xsl:template>

</xsl:stylesheet>
