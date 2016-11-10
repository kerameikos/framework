<?xml version="1.0" encoding="UTF-8"?>
<!--
	XPL handling SPARQL queries from Fuseki	
-->
<p:config xmlns:p="http://www.orbeon.com/oxf/pipeline" xmlns:oxf="http://www.orbeon.com/oxf/processors" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">

	<p:param type="input" name="data"/>
	<p:param type="output" name="data"/>

	<p:processor name="oxf:request">
		<p:input name="config">
			<config>
				<include>/request</include>
			</config>
		</p:input>
		<p:output name="data" id="request"/>
	</p:processor>

	<p:processor name="oxf:pipeline">
		<p:input name="config" href="../rdf/get-id.xpl"/>
		<p:output name="data" id="rdf"/>
	</p:processor>

	<p:processor name="oxf:unsafe-xslt">
		<p:input name="data" href="#rdf"/>
		<p:input name="config">
			<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema"
				xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">

				<xsl:variable name="hasProductionPlaces" as="item()*">
					<classes>
						<class>crm:E4_Period</class>
						<class>crm:E57_Material</class>
						<class>crm:E40_Legal_Body</class>
						<class>foaf:Organization</class>						
						<class>foaf:Person</class>
						<class>kon:ProductionPlace</class>
						<class>kon:Shape</class>
						<class>kon:Style</class>
						<class>kon:Technique</class>
						<class>kon:Ware</class>
					</classes>
				</xsl:variable>

				<xsl:variable name="type" select="/rdf:RDF/*[1]/name()"/>


				<xsl:template match="/">
					<type>
						<xsl:attribute name="hasProductionPlaces">
							<xsl:choose>
								<xsl:when test="$hasProductionPlaces//class[text()=$type]">true</xsl:when>
								<xsl:otherwise>false</xsl:otherwise>
							</xsl:choose>
						</xsl:attribute>

						<xsl:value-of select="$type"/>
					</type>
				</xsl:template>

			</xsl:stylesheet>
		</p:input>
		<p:output name="data" id="type"/>
	</p:processor>

	<p:choose href="#type">
		<!-- check to see whether the ID is a mint or region, if so, process the coordinates or geoJSON polygon in the RDF into geoJSON -->
		<p:when test="type = 'kon:ProductionPlace'">
			<p:processor name="oxf:identity">
				<p:input name="data" href="#rdf"/>
				<p:output name="data" ref="data"/>
			</p:processor>
		</p:when>
		<!-- suppress any class of object for which we do not want to render a map -->
		<p:when test="type/@hasProductionPlaces = 'false'">
			<p:processor name="oxf:identity">
				<p:input name="data">
					<null/>
				</p:input>
				<p:output name="data" ref="data"/>
			</p:processor>
		</p:when>
		<!-- apply alternate SPARQL query to get mints associated with a Hoard -->
		<p:otherwise>
			<p:processor name="oxf:unsafe-xslt">
				<p:input name="request" href="#request"/>
				<p:input name="data" href="#type"/>
				<p:input name="config-xml" href=" ../../../config.xml"/>
				<p:input name="config">
					<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema"
						xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
						<xsl:param name="id" select="doc('input:request')/request/parameters/parameter[name='id']/value"/>
						<xsl:variable name="sparql_endpoint" select="doc('input:config-xml')/config/sparql/query"/>
						<xsl:variable name="type" select="/type"/>

						<xsl:variable name="prefixes">
							<![CDATA[PREFIX rdf:	<http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX dcterms:	<http://purl.org/dc/terms/>
PREFIX skos:	<http://www.w3.org/2004/02/skos/core#>
PREFIX owl:	<http://www.w3.org/2002/07/owl#>
PREFIX foaf:	<http://xmlns.com/foaf/0.1/>
PREFIX crm:	<http://www.cidoc-crm.org/cidoc-crm/>
PREFIX geo:	<http://www.w3.org/2003/01/geo/wgs84_pos#>
PREFIX kid:	<http://kerameikos.org/id/>
PREFIX kon:	<http://kerameikos.org/ontology#>
PREFIX osgeo:	<http://data.ordnancesurvey.co.uk/ontology/geometry/>
SELECT DISTINCT ?place ?label ?definition ?lat ?long ?poly WHERE {]]>
						</xsl:variable>
						<xsl:variable name="metadata">
							<![CDATA[?object crm:P108i_was_produced_by ?prod
{?prod crm:P7_took_place_at ?place }
UNION {?prod crm:P7_took_place_at ?relPlace .
?place skos:exactMatch ?relPlace }
?place geo:location ?loc .
{?loc geo:lat ?lat .
?loc geo:long ?long }
UNION {?loc osgeo:asGeoJSON ?poly }
?place skos:prefLabel ?label .
FILTER ( lang(?label) = "en" )
?place skos:definition ?definition .
FILTER ( lang(?definition) = "en" )}]]>
						</xsl:variable>
						
						<xsl:variable name="select">
							<xsl:choose>
								<xsl:when test="$type='crm:E4_Period'">
									<![CDATA[
{?object crm:P108i_was_produced_by ?prod .
?prod  crm:P10_falls_within kid:RDFID}
UNION {kid:RDFID skos:exactMatch ?matches .
?object crm:P10_falls_within ?prod .
?prod crm:P7_took_place_at ?matches}
UNION {?types skos:broader kid:RDFID .
?types skos:exactMatch ?matches .
?object crm:P10_falls_within ?matches}]]>
								</xsl:when>
								<xsl:when test="$type='crm:E57_Material'">
									<![CDATA[{?object crm:P45_consists_of kid:RDFID }
UNION {kid:RDFID skos:exactMatch ?matches .
?object crm:P45_consists_of ?matches}
UNION {?types skos:broader kid:RDFID .
?object crm:P45_consists_of ?types}
UNION {?types skos:broader kid:RDFID .
?types skos:exactMatch ?matches .
?object crm:P45_consists_of ?matches}]]>
								</xsl:when>
								<xsl:when test="$type='crm:E40_Legal_Body'">
									<![CDATA[?object crm:P50_has_current_keeper kid:RDFID .]]>
								</xsl:when>
								<xsl:when test="$type='kon:Shape'">
									<![CDATA[{?object kon:hasShape kid:RDFID }
UNION {kid:RDFID skos:exactMatch ?matches .
?object kon:hasShape ?matches}
UNION {?types skos:broader kid:RDFID .
?object kon:hasShape ?types}
UNION {?types skos:broader kid:RDFID .
?types skos:exactMatch ?matches .
?object kon:hasShape ?matches}]]>
								</xsl:when>
								<xsl:when test="$type='kon:Technique'">
									<![CDATA[{?object crm:P32_used_general_technique kid:RDFID }
UNION {kid:RDFID skos:exactMatch ?matches .
?object crm:P32_used_general_technique ?matches}
UNION {?types skos:broader kid:RDFID .
?object crm:P32_used_general_technique ?types}
UNION {?types skos:broader kid:RDFID .
?types skos:exactMatch ?matches .
?object crm:P32_used_general_technique ?matches}]]>
								</xsl:when>
								<!--<xsl:when test="$type='kon:Ware'">
					<![CDATA[					{?object kon:hasShape kid:RDFID }
					UNION {kid:RDFID skos:exactMatch ?matches .
					?object kon:hasShape ?matches}
					UNION {?types skos:broader kid:RDFID .
					?object kon:hasShape ?types}
					UNION {?types skos:broader kid:RDFID .
					?types skos:exactMatch ?matches .
					?object kon:hasShape ?matches}]]>
					</xsl:when>-->
								<xsl:when test="$type='foaf:Person'">
									<![CDATA[{?object crm:P108i_was_produced_by ?prod .
?prod crm:P14_carried_out_by kid:RDFID}
UNION {kid:RDFID skos:exactMatch ?matches .
?object crm:P108i_was_produced_by ?prod .
?prod crm:P14_carried_out_by ?matches}]]>
								</xsl:when>
								<xsl:when test="$type='foaf:Organization'">
									<![CDATA[{?object crm:P108i_was_produced_by ?prod .
?prod crm:P14_carried_out_by kid:RDFID}
UNION {kid:RDFID skos:exactMatch ?matches .
?object crm:P108i_was_produced_by ?prod .
?prod crm:P14_carried_out_by ?matches}]]>
								</xsl:when>
							</xsl:choose>
						</xsl:variable>

						<xsl:template match="/">
							<xsl:variable name="query" select="concat($prefixes, replace($select, 'RDFID', $id), $metadata)"/>
							<xsl:variable name="service" select="concat($sparql_endpoint, '?query=', encode-for-uri(normalize-space(replace($query, 'RDFID', $id))), '&amp;output=xml')"/>

							<config>
								<url>
									<xsl:value-of select="$service"/>
								</url>
								<content-type>application/xml</content-type>
								<encoding>utf-8</encoding>
							</config>
						</xsl:template>

					</xsl:stylesheet>
				</p:input>
				<p:output name="data" id="url-generator-config"/>
			</p:processor>

			<p:processor name="oxf:url-generator">
				<p:input name="config" href="#url-generator-config"/>
				<p:output name="data" ref="data"/>
			</p:processor>
		</p:otherwise>
	</p:choose>
</p:config>
