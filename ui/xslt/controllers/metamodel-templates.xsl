<?xml version="1.0" encoding="UTF-8"?>
<!-- Author: Ethan Gruber
    Date: June 2019
    Function: XSLT templates that construct the XML metamodel used in various contexts for SPARQL queries. 
    The sparql-metamodel.xsl stylesheet converts this XML model into text for the SPARQL endpoint
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:kerameikos="http://kerameikos.org/"
    exclude-result-prefixes="#all" version="2.0">

    <!-- default properties associated with the various classes of RDF for Nomisma concepts -->
    <xsl:variable name="classes" as="item()*">
        <classes>
            <class prop="nmo:hasCollection">nmo:Collection</class>
            <class prop="nmo:hasDenomination">nmo:Denomination</class>
            <class prop="?prop">nmo:Ethnic</class>
            <class prop="?prop">rdac:Family</class>
            <class prop="?prop">foaf:Group</class>
            <class prop="dcterms:isPartOf">nmo:Hoard</class>
            <class prop="nmo:hasManufacture">nmo:Manufacture</class>
            <class prop="nmo:hasMaterial">nmo:Material</class>
            <class prop="nmo:hasMint">nmo:Mint</class>
            <class prop="?prop">foaf:Organization</class>
            <class prop="nmo:representsObjectType">nmo:ObjectType</class>
            <class prop="?prop">foaf:Person</class>
            <class prop="nmo:hasRegion">nmo:Region</class>
            <class prop="dcterms:source">nmo:TypeSeries</class>
        </classes>
    </xsl:variable>

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
                    <xsl:variable name="id" select="position()"/>

                    <select variables="?{$id}">
                        <triple s="{$object}" p="skos:exactMatch" o="?{$id}"/>
                    </select>
                    <triple s="{$subject}" p="crm:P45_consists_of" o="?{$id}"/>
                </xsl:when>
                <xsl:when test="$property = 'period'">
                    <xsl:variable name="id" select="position()"/>

                    <select variables="?{$id}">
                        <triple s="{$object}" p="skos:exactMatch" o="?{$id}"/>
                    </select>
                    <triple s="{$subject}" p="crm:P108i_was_produced_by" o="?prod"/>
                    <triple s="?prod" p="crm:P10_falls_within" o="?{$id}"/>
                </xsl:when>
                <xsl:when test="$property = 'person' or $property = 'workshop'">
                    <xsl:variable name="id" select="position()"/>

                    <select variables="?{$id}">
                        <triple s="{$object}" p="skos:exactMatch" o="?{$id}"/>
                    </select>
                    <triple s="{$subject}" p="crm:P108i_was_produced_by" o="?prod"/>
                    <triple s="?prod" p="crm:P14_carried_out_by" o="?{$id}"/>
                </xsl:when>
                <xsl:when test="$property = 'productionPlace'">
                    <xsl:variable name="id" select="position()"/>

                    <select variables="?{$id}">
                        <union>
                            <group>
                                <triple s="?{$id}" p="rdf:type" o="skos:Concept" filter="(?{$id} = {$object})"/>
                            </group>
                            <group>
                                <triple s="{$object}" p="skos:exactMatch" o="?{$id}"/>
                            </group>
                            <group>
                                <triple s="?broader" p="skos:broader" o="{$object}"/>
                                <triple s="?broader" p="skos:exactMatch" o="?{$id}"/>
                            </group>
                        </union>
                    </select>
                    <triple s="{$subject}" p="crm:P108i_was_produced_by" o="?prod"/>
                    <triple s="?prod" p="crm:P7_took_place_at" o="?{$id}"/>
                </xsl:when>
                <xsl:when test="$property = 'shape'">
                    <xsl:variable name="id" select="position()"/>

                    <select variables="?{$id}">
                        <union>
                            <triple s="?{$id}" p="rdf:type" o="skos:Concept" filter="(?{$id} = {$object})"/>
                            <triple s="{$object}" p="skos:exactMatch" o="?{$id}"/>
                        </union>
                    </select>
                    <triple s="{$subject}" p="kon:hasShape" o="?{$id}"/>
                </xsl:when>
                <xsl:when test="$property = 'technique'">
                    <xsl:variable name="id" select="position()"/>

                    <select variables="?{$id}">
                        <triple s="{$object}" p="skos:exactMatch" o="?{$id}"/>
                    </select>
                    <triple s="{$subject}" p="crm:P32_used_general_technique" o="?{$id}"/>
                </xsl:when>
                <!--<xsl:when test="$property = 'from'">
										<xsl:if test="$object castable as xs:integer">
											<xsl:variable name="gYear" select="format-number(number($object), '0000')"/>

											<triple s="?coinType" p="nmo:hasStartDate" o="?startDate">
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

											<triple s="?coinType" p="nmo:hasEndDate" o="?endDate">
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
            <xsl:when test="$dist='keeper'">
                <triple s="?object" p="crm:P50_has_current_keeper" o="{$object}"/>
            </xsl:when>
            <xsl:when test="$dist='material'">
                <triple s="?object" p="crm:P45_consists_of" o="{$object}"/>
            </xsl:when>
            <xsl:when test="$dist='period'">
                <triple s="?prod" p="crm:P10_falls_within" o="{$object}"/>
            </xsl:when>
            <xsl:when test="$dist='person' or $dist='workshop'">
                <triple s="?prod" p="crm:P14_carried_out_by" o="{$object}"/>
            </xsl:when>
            <xsl:when test="$dist='productionPlace'">
                <triple s="?prod" p="crm:P7_took_place_at" o="{$object}"/>
            </xsl:when>
            <xsl:when test="$dist='shape'">
                <triple s="?object" p="kon:hasShape" o="{$object}"/>
            </xsl:when>
            <xsl:when test="$dist='technique'">
                <triple s="?object" p="crm:P32_used_general_technique" o="{$object}"/>
            </xsl:when>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="kerameikos:getProductionPlaces">
        <xsl:param name="type"/>
        <xsl:param name="id"/>

        <statements>
            <xsl:choose>
                <xsl:when test="$type = 'nmo:Mint'">
                    <triple s="nm:{$id}" p="geo:location" o="?loc"/>
                </xsl:when>
                <xsl:when test="$type = 'nmo:Region'">
                    <union>
                        <group>
                            <triple s="nm:{$id}" p="geo:location" o="?loc"/>
                        </group>
                        <group>
                            <triple s="?mint" p="skos:broader+" o="nm:{$id}"/>
                            <triple s="?mint" p="geo:location" o="?loc"/>
                        </group>
                    </union>
                </xsl:when>
                <xsl:when test="$type = 'nmo:Hoard'">
                    <triple s="?coin" p="dcterms:isPartOf" o="nm:{$id}"/>
                    <triple s="?coin" p="a" o="nmo:NumismaticObject"/>
                    <union>
                        <group>
                            <triple s="?coin" p="nmo:hasTypeSeriesItem" o="?coinType"/>
                            <triple s="?coinType" p="nmo:hasMint" o="?place"/>
                        </group>
                        <group>
                            <triple s="?coin" p="nmo:hasMint" o="?place"/>
                        </group>
                    </union>
                    <triple s="?place" p="geo:location" o="?loc"/>
                </xsl:when>
                <xsl:when test="$type = 'nmo:Collection'">
                    <triple s="?coin" p="nmo:hasCollection" o="nm:{$id}"/>
                    <union>
                        <group>
                            <triple s="?coin" p="nmo:hasTypeSeriesItem" o="?coinType"/>
                            <triple s="?coinType" p="nmo:hasMint" o="?place"/>
                        </group>
                        <group>
                            <triple s="?coin" p="nmo:hasMint" o="?place"/>
                        </group>
                    </union>
                    <triple s="?place" p="geo:location" o="?loc"/>
                </xsl:when>
                <xsl:when test="$type = 'foaf:Person'">
                    <union>
                        <group>
                            <triple s="?coinType" p="?prop" o="nm:{$id}"/>
                        </group>
                        <group>
                            <triple s="?obv" p="?prop" o="nm:{$id}"/>
                            <triple s="?coinType" p="nmo:hasObverse" o="?obv"/>
                        </group>
                        <group>
                            <triple s="?rev" p="?prop" o="nm:{$id}"/>
                            <triple s="?coinType" p="nmo:hasReverse" o="?rev"/>
                        </group>
                        <group>
                            <triple s="nm:{$id}" p="org:hasMembership/org:organization" o="?place"/>
                        </group>
                    </union>
                    <triple s="?coinType" p="rdf:type" o="nmo:TypeSeriesItem"/>
                    <triple s="?coinType" p="nmo:hasMint" o="?place"/>
                    <minus>
                        <triple s="?coinType" p="dcterms:isReplacedBy" o="?replaced"/>
                    </minus>
                    <triple s="?place" p="geo:location" o="?loc"/>
                </xsl:when>
                <xsl:when test="$type = 'rdac:Family'">
                    <union>
                        <group>
                            <triple s="?coinType" p="?prop" o="nm:{$id}"/>
                        </group>
                        <group>
                            <triple s="?coinType" p="?prop" o="?person"/>
                            <triple s="?person" p="a" o="foaf:Person"/>
                            <triple s="?person" p="org:memberOf" o="nm:{$id}"/>
                        </group>
                    </union>
                    <triple s="?coinType" p="rdf:type" o="nmo:TypeSeriesItem"/>
                    <triple s="?coinType" p="nmo:hasMint" o="?place"/>
                    <minus>
                        <triple s="?coinType" p="dcterms:isReplacedBy" o="?replaced"/>
                    </minus>
                    <triple s="?place" p="geo:location" o="?loc"/>
                </xsl:when>
                <xsl:when test="$type = 'foaf:Organization' or $type = 'foaf:Group'">
                    <union>
                        <group>
                            <triple s="?coinType" p="nmo:hasAuthority" o="nm:{$id}"/>
                        </group>
                        <group>
                            <triple s="?coinType" p="nmo:hasAuthority" o="?person"/>
                            <triple s="?person" p="a" o="foaf:Person"/>
                            <triple s="?person" p="org:hasMembership/org:organization" o="nm:{$id}"/>
                        </group>
                    </union>
                    <triple s="?coinType" p="rdf:type" o="nmo:TypeSeriesItem"/>
                    <triple s="?coinType" p="nmo:hasMint" o="?place"/>
                    <minus>
                        <triple s="?coinType" p="dcterms:isReplacedBy" o="?replaced"/>
                    </minus>
                    <triple s="?place" p="geo:location" o="?loc"/>
                </xsl:when>
                <xsl:otherwise>
                    <triple s="?coinType" p="{$classes//class[text()=$type]/@prop}" o="nm:{$id}"/>
                    <triple s="?coinType" p="rdf:type" o="nmo:TypeSeriesItem"/>
                    <triple s="?coinType" p="nmo:hasMint" o="?place"/>
                    <minus>
                        <triple s="?coinType" p="dcterms:isReplacedBy" o="?replaced"/>
                    </minus>
                    <triple s="?place" p="geo:location" o="?loc"/>
                </xsl:otherwise>
            </xsl:choose>
        </statements>
    </xsl:template>

    <!--<xsl:template name="kerameikos:getFindspotsStatements">
        <xsl:param name="api"/>
        <xsl:param name="type"/>
        <xsl:param name="id"/>
        
        <statements>
            <xsl:choose>
                <xsl:when test="$type = 'foaf:Person'">
                    
                    <xsl:choose>
                        <xsl:when test="$api = 'getHoards' or $api = 'heatmap'">
                            <union>
                                <group>
                                    <xsl:call-template name="person-findspots">
                                        <xsl:with-param name="id" select="$id"/>
                                    </xsl:call-template>
                                    <triple s="?object" p="dcterms:isPartOf" o="?hoard"/>
                                    <xsl:if test="$api = 'heatmap'">
                                        <triple s="?hoard" p="nmo:hasFindspot" o="?place"/>
                                    </xsl:if>
                                </group>
                                <xsl:if test="$api = 'heatmap'">
                                    <group>
                                        <xsl:call-template name="person-findspots">
                                            <xsl:with-param name="id" select="$id"/>
                                        </xsl:call-template>
                                        <triple s="?object" p="nmo:hasFindspot" o="?place"/>
                                    </group>
                                </xsl:if>
                               <group>
                                   <xsl:call-template name="hoard-content-query">
                                       <xsl:with-param name="api" select="$api"/>
                                       <xsl:with-param name="id" select="$id"/>
                                       <xsl:with-param name="type" select="$type"/>
                                   </xsl:call-template>
                               </group>
                            </union>                           
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:call-template name="person-findspots">
                                <xsl:with-param name="id" select="$id"/>
                            </xsl:call-template>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>
                <xsl:when test="$type = 'rdac:Family'">
                    <xsl:choose>
                        <xsl:when test="$api = 'getHoards' or $api = 'heatmap'">
                            <union>
                                <group>
                                    <xsl:call-template name="dynasty-findspots">
                                        <xsl:with-param name="id" select="$id"/>
                                    </xsl:call-template>
                                    <triple s="?object" p="dcterms:isPartOf" o="?hoard"/>
                                    <xsl:if test="$api = 'heatmap'">
                                        <triple s="?hoard" p="nmo:hasFindspot" o="?place"/>
                                    </xsl:if>
                                </group>
                                <xsl:if test="$api = 'heatmap'">
                                    <group>
                                        <xsl:call-template name="dynasty-findspots">
                                            <xsl:with-param name="id" select="$id"/>
                                        </xsl:call-template>
                                        <triple s="?object" p="nmo:hasFindspot" o="?place"/>
                                    </group>
                                </xsl:if>
                                <group>
                                    <xsl:call-template name="hoard-content-query">
                                        <xsl:with-param name="api" select="$api"/>
                                        <xsl:with-param name="id" select="$id"/>
                                        <xsl:with-param name="type" select="$type"/>
                                    </xsl:call-template>
                                </group>
                            </union>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:call-template name="dynasty-findspots">
                                <xsl:with-param name="id" select="$id"/>
                            </xsl:call-template>
                        </xsl:otherwise>
                    </xsl:choose>                    
                </xsl:when>
                <xsl:when test="$type = 'foaf:Organization' or $type = 'foaf:Group'">
                    
                    <xsl:choose>
                        <xsl:when test="$api = 'getHoards' or $api = 'heatmap'">
                            <union>
                                <group>
                                    <xsl:call-template name="org-findspots">
                                        <xsl:with-param name="id" select="$id"/>
                                    </xsl:call-template>
                                    <triple s="?object" p="dcterms:isPartOf" o="?hoard"/>
                                    <xsl:if test="$api = 'heatmap'">
                                        <triple s="?hoard" p="nmo:hasFindspot" o="?place"/>
                                    </xsl:if>
                                </group>
                                <xsl:if test="$api = 'heatmap'">
                                    <group>
                                        <xsl:call-template name="org-findspots">
                                            <xsl:with-param name="id" select="$id"/>
                                        </xsl:call-template>
                                        <triple s="?object" p="nmo:hasFindspot" o="?place"/>
                                    </group>
                                </xsl:if>
                                <group>
                                    <xsl:call-template name="hoard-content-query">
                                        <xsl:with-param name="api" select="$api"/>
                                        <xsl:with-param name="id" select="$id"/>
                                        <xsl:with-param name="type" select="$type"/>
                                    </xsl:call-template>
                                </group>
                            </union>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:call-template name="org-findspots">
                                <xsl:with-param name="id" select="$id"/>
                            </xsl:call-template>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>
                <xsl:when test="$type = 'nmo:TypeSeriesItem'">    
                    <xsl:choose>
                        <xsl:when test="$api = 'getHoards' or $api = 'heatmap'">
                            <union>                                
                                <group>
                                    <triple s="?object" p="nmo:hasTypeSeriesItem" o="&lt;{$id}&gt;"/>
                                    <triple s="?object" p="rdf:type" o="nmo:NumismaticObject"/>
                                    <triple s="?object" p="dcterms:isPartOf" o="?hoard"/>
                                    <xsl:if test="$api = 'heatmap'">
                                        <triple s="?hoard" p="nmo:hasFindspot" o="?place"/>
                                    </xsl:if>
                                </group>
                                <xsl:if test="$api = 'heatmap'">
                                    <group>
                                        <triple s="?object" p="nmo:hasTypeSeriesItem" o="&lt;{$id}&gt;"/>
                                        <triple s="?object" p="rdf:type" o="nmo:NumismaticObject"/>
                                        <triple s="?object" p="nmo:hasFindspot" o="?place"/>
                                    </group>
                                </xsl:if>
                                <group>
                                    <triple s="?contents"  p="nmo:hasTypeSeriesItem" o="&lt;{$id}&gt;"/>
                                    <triple s="?contents" p="rdf:type" o="dcmitype:Collection"/>
                                    <triple s="?hoard" p="dcterms:tableOfContents" o="?contents"/>
                                    <xsl:if test="$api = 'heatmap'">
                                        <triple s="?hoard" p="nmo:hasFindspot" o="?place"/>
                                    </xsl:if>
                                </group>
                            </union>                            
                        </xsl:when>
                        <xsl:otherwise>
                            <triple s="?object" p="nmo:hasTypeSeriesItem" o="&lt;{$id}&gt;"/>
                            <triple s="?object" p="rdf:type" o="nmo:NumismaticObject"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>
                <xsl:when test="$type = 'nmo:Monogram'">  
                    <select variables="?side">
                        <triple s="?side" p="nmo:hasMonogram" o="&lt;{$id}&gt;"/>
                    </select>
                    
                    <xsl:choose>
                        <xsl:when test="$api = 'getHoards' or $api = 'heatmap'">
                            <union>
                                <group>
                                    <triple s="?coinType" p="?prop" o="?side"/>
                                    <triple s="?object" p="nmo:hasTypeSeriesItem" o="?coinType"/>
                                    <triple s="?object" p="rdf:type" o="nmo:NumismaticObject"/>
                                    <triple s="?object" p="dcterms:isPartOf" o="?hoard"/>
                                    <xsl:if test="$api = 'heatmap'">
                                        <triple s="?hoard" p="nmo:hasFindspot" o="?place"/>
                                    </xsl:if>
                                </group>
                                <xsl:if test="$api = 'heatmap'">
                                    <group>
                                        <triple s="?coinType" p="?prop" o="?side"/>
                                        <triple s="?object" p="nmo:hasTypeSeriesItem" o="?coinType"/>
                                        <triple s="?object" p="rdf:type" o="nmo:NumismaticObject"/>
                                        <triple s="?object" p="nmo:hasFindspot" o="?place"/>
                                    </group>
                                </xsl:if>
                                <group>
                                    <triple s="?coinType" p="?prop" o="?side"/>
                                    <triple s="?contents"  p="nmo:hasTypeSeriesItem" o="?coinType"/>
                                    <triple s="?contents" p="rdf:type" o="dcmitype:Collection"/>
                                    <triple s="?hoard" p="dcterms:tableOfContents" o="?contents"/>
                                    <xsl:if test="$api = 'heatmap'">
                                        <triple s="?hoard" p="nmo:hasFindspot" o="?place"/>
                                    </xsl:if>
                                </group>
                            </union>
                        </xsl:when>
                        <xsl:otherwise>
                            <triple s="?coinType" p="?prop" o="?side"/>
                            <triple s="?object" p="nmo:hasTypeSeriesItem" o="?coinType"/>
                            <triple s="?object" p="rdf:type" o="nmo:NumismaticObject"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>
                <xsl:otherwise>
                    <union>
                        <!-\- get coin types related to the concept -\->
                        <group>
                            <triple s="?coinType" p="{$classes//class[text()=$type]/@prop}" o="nm:{$id}"/>
                            <triple s="?coinType" p="rdf:type" o="nmo:TypeSeriesItem"/>
                            <triple s="?object" p="nmo:hasTypeSeriesItem" o="?coinType"/>  
                            <triple s="?object" p="rdf:type" o="nmo:NumismaticObject"/>
                            
                            <xsl:choose>
                                <xsl:when test="$api = 'getHoards'">
                                    <triple s="?object" p="dcterms:isPartOf" o="?hoard"/>
                                </xsl:when>
                                <xsl:when test="$api = 'heatmap'">
                                    <triple s="?object" p="nmo:hasFindspot" o="?place"/>
                                </xsl:when>
                            </xsl:choose>
                        </group>
                        <!-\- get physical coins connected to the concept -\->
                        <group>
                            <triple s="?object" p="{$classes//class[text()=$type]/@prop}" o="nm:{$id}"/>
                            <triple s="?object" p="rdf:type" o="nmo:NumismaticObject"/>
                            
                            <xsl:choose>
                                <xsl:when test="$api = 'getHoards'">
                                    <triple s="?object" p="dcterms:isPartOf" o="?hoard"/>
                                </xsl:when>
                                <xsl:when test="$api = 'heatmap'">
                                    <triple s="?object" p="nmo:hasFindspot" o="?place"/>
                                </xsl:when>
                            </xsl:choose>
                        </group>
                        
                        <xsl:if test="$api = 'heatmap'">
                            <!-\- in the heatmap API, combine the query for both hoards and findspots related to the concept -\->
                            <group>
                                <triple s="?coinType" p="{$classes//class[text()=$type]/@prop}" o="nm:{$id}"/>
                                <triple s="?coinType" p="rdf:type" o="nmo:TypeSeriesItem"/>
                                <triple s="?object" p="nmo:hasTypeSeriesItem" o="?coinType"/>  
                                <triple s="?object" p="rdf:type" o="nmo:NumismaticObject"/>
                                <triple s="?object" p="dcterms:isPartOf" o="?hoard"/> 
                                <triple s="?hoard" p="nmo:hasFindspot" o="?place"/>
                            </group>
                            <!-\- get physical coins connected to the concept -\->
                            <group>
                                <triple s="?object" p="{$classes//class[text()=$type]/@prop}" o="nm:{$id}"/>
                                <triple s="?object" p="rdf:type" o="nmo:NumismaticObject"/>
                                <triple s="?object" p="dcterms:isPartOf" o="?hoard"/>
                                <triple s="?hoard" p="nmo:hasFindspot" o="?place"/>
                            </group>
                        </xsl:if>
                        
                        <xsl:if test="$api = 'getHoards' or $api = 'heatmap'">
                            <xsl:call-template name="hoard-content-query">
                                <xsl:with-param name="api" select="$api"/>
                                <xsl:with-param name="id" select="$id"/>
                                <xsl:with-param name="type" select="$type"/>
                            </xsl:call-template>
                        </xsl:if>
                    </union>
                </xsl:otherwise>
            </xsl:choose>
            
            <!-\- evaluate whether the coin has a findspot for the getFindspots API or whether the coin/type is part of a hoard -\->
            <xsl:choose>
                <xsl:when test="$api = 'getHoards'">
                    <triple s="?hoard" p="nmo:hasFindspot" o="?place"/>
                </xsl:when>
                <xsl:when test="$api = 'getFindspots'">
                    <triple s="?object" p="nmo:hasFindspot" o="?place"/>
                </xsl:when>
            </xsl:choose>
            
        </statements>        
    </xsl:template>-->

    <!-- reusable templates for specific entities -->
    <xsl:template name="person-findspots">
        <xsl:param name="id"/>

        <union>
            <group>
                <triple s="?coinType" p="?prop" o="nm:{$id}"/>
            </group>
            <group>
                <triple s="?obv" p="?prop" o="nm:{$id}"/>
                <triple s="?coinType" p="nmo:hasObverse" o="?obv"/>
            </group>
            <group>
                <triple s="?rev" p="?prop" o="nm:{$id}"/>
                <triple s="?coinType" p="nmo:hasReverse" o="?rev"/>
            </group>
        </union>
        <triple s="?coinType" p="rdf:type" o="nmo:TypeSeriesItem"/>
        <triple s="?object" p="nmo:hasTypeSeriesItem" o="?coinType"/>
        <triple s="?object" p="rdf:type" o="nmo:NumismaticObject"/>
    </xsl:template>

    <xsl:template name="org-findspots">
        <xsl:param name="id"/>

        <union>
            <group>
                <triple s="?coinType" p="nmo:hasAuthority" o="nm:{$id}"/>
            </group>
            <group>
                <triple s="?coinType" p="nmo:hasAuthority" o="?person"/>
                <triple s="?person" p="a" o="foaf:Person"/>
                <triple s="?person" p="org:hasMembership/org:organization" o="nm:{$id}"/>
            </group>
        </union>
        <triple s="?coinType" p="rdf:type" o="nmo:TypeSeriesItem"/>
        <triple s="?object" p="nmo:hasTypeSeriesItem" o="?coinType"/>
        <triple s="?object" p="rdf:type" o="nmo:NumismaticObject"/>
    </xsl:template>

    <xsl:template name="kerameikos:listTypesStatements">
        <xsl:param name="type"/>
        <xsl:param name="id"/>

        <statements>
            <xsl:choose>
                <xsl:when test="$type = 'foaf:Person'">
                    <union>
                        <triple s="?coinType" p="?prop" o="nm:{$id}"/>
                        <triple s="?coinType" p="nmo:hasObverse/nmo:hasPortrait" o="nm:{$id}"/>
                        <triple s="?coinType" p="nmo:hasReverse/nmo:hasPortrait" o="nm:{$id}"/>
                    </union>
                </xsl:when>
                <xsl:when test="$type = 'rdac:Family'">
                    <union>
                        <group>
                            <triple s="?coinType" p="?prop" o="nm:{$id}"/>
                        </group>
                        <group>
                            <triple s="?coinType" p="nmo:hasAuthority" o="?person"/>
                            <triple s="?person" p="a" o="foaf:Person"/>
                            <triple s="?person" p="org:memberOf" o="nm:{$id}"/>
                        </group>
                    </union>
                </xsl:when>
                <xsl:when test="$type = 'foaf:Organization' or $type = 'foaf:Group' or $type = 'nmo:Ethnic'">
                    <union>
                        <group>
                            <triple s="?coinType" p="nmo:hasAuthority" o="nm:{$id}"/>
                        </group>
                        <group>
                            <triple s="?coinType" p="?prop" o="?person"/>
                            <triple s="?person" p="a" o="foaf:Person"/>
                            <triple s="?person" p="org:hasMembership/org:organization" o="nm:{$id}"/>
                        </group>
                    </union>
                </xsl:when>
                <xsl:when test="$type = 'nmo:Region'">
                    <union>
                        <group>
                            <triple s="?coinType" p="nmo:hasRegion" o="nm:{$id}"/>
                        </group>
                        <group>
                            <triple s="?coinType" p="nmo:hasMint" o="?mint"/>
                            <triple s="?mint" p="skos:broader+" o="nm:{$id}"/>
                        </group>
                    </union>
                </xsl:when>
                <xsl:otherwise>
                    <triple s="?coinType" p="{$classes//class[text()=$type]/@prop}" o="nm:{$id}"/>
                </xsl:otherwise>
            </xsl:choose>
            <triple s="?coinType" p="rdf:type" o="nmo:TypeSeriesItem"/>
        </statements>
    </xsl:template>

</xsl:stylesheet>
