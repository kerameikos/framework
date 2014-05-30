<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:skos="http://www.w3.org/2004/02/skos/core#" xmlns:nm="http://nomisma.org/id/"
	xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:eac="urn:isbn:1-931666-33-4" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:res="http://www.w3.org/2005/sparql-results#"
	xmlns:osgeo="http://data.ordnancesurvey.co.uk/ontology/geometry/" xmlns:geo="http://www.w3.org/2003/01/geo/wgs84_pos#" xmlns:xs="http://www.w3.org/2001/XMLSchema"
	xmlns:foaf="http://xmlns.com/foaf/0.1/" xmlns:spatial="http://geovocab.org/spatial#" xmlns:kml="http://earth.google.com/kml/2.0" xmlns:saxon="http://saxon.sf.net/"
	xmlns:kerameikos="http://kerameikos.org/" exclude-result-prefixes="#all" version="2.0">

	<xsl:variable name="type" select="descendant::rdf:RDF/*/name()"/>

	<xsl:template name="timemap">
		<xsl:variable name="response">
			<xsl:text>[</xsl:text>
			<xsl:if test="descendant::geo:lat and descendant::geo:long">
				<xsl:call-template name="origin"/>
				<xsl:text>,</xsl:text>
			</xsl:if>
			<xsl:call-template name="production-places"/>
			<xsl:text>]</xsl:text>
		</xsl:variable>
		<xsl:value-of select="normalize-space($response)"/>
	</xsl:template>

	<xsl:template name="origin">
		<xsl:variable name="name" select="descendant::skos:prefLabel[@xml:lang='en']"/>
		<xsl:variable name="description" select="descendant::skos:definition[@xml:lang='en']"/>
		<xsl:variable name="theme">red</xsl:variable> { "point": {"lon": <xsl:value-of select="descendant::geo:long"/>,"lat": <xsl:value-of select="descendant::geo:lat"/>}, "title": "<xsl:value-of
			select="normalize-space(replace($name, '&#x022;', '\\&#x022;'))"/>", "options": { "theme": "<xsl:value-of select="$theme"/>"<xsl:if test="string($description)">, "description":
				"<xsl:value-of select="normalize-space(replace($description, '&#x022;', '\\&#x022;'))"/>"</xsl:if>, "href": "<xsl:value-of select="concat(/content/config/url, 'id/', $id)"/>" } } </xsl:template>

	<xsl:template name="production-places">
		<xsl:variable name="prefixes">
			<![CDATA[PREFIX rdf:	<http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX dcterms:	<http://purl.org/dc/terms/>
PREFIX skos:	<http://www.w3.org/2004/02/skos/core#>
PREFIX owl:	<http://www.w3.org/2002/07/owl#>
PREFIX foaf:	<http://xmlns.com/foaf/0.1/>
PREFIX ecrm:	<http://erlangen-crm.org/current/>
PREFIX geo:	<http://www.w3.org/2003/01/geo/wgs84_pos#>
PREFIX kid:	<http://kerameikos.org/id/>
PREFIX kon:	<http://kerameikos.org/ontology#>
PREFIX osgeo:	<http://data.ordnancesurvey.co.uk/ontology/geometry/>
SELECT DISTINCT ?object ?place ?label ?title ?lat ?long ?json ?fromDate ?toDate ?thumb ?id ?keeper ?kuri WHERE {]]>
		</xsl:variable>
		<xsl:variable name="metadata">
			<![CDATA[{ ?place geo:lat ?lat .
?place geo:long ?long }
UNION { ?place osgeo:asGeoJSON ?json }
?place skos:prefLabel ?label .
FILTER ( lang(?label) = "en" )
?object dcterms:title ?title .
?object dcterms:identifier ?id
{?object ecrm:P50_has_current_keeper ?kuri .
?kuri skos:prefLabel ?keeper .
FILTER ( lang(?keeper) = "en" )}
OPTIONAL {?object foaf:thumbnail ?thumb}}]]>
		</xsl:variable>

		<xsl:variable name="select">
			<xsl:choose>
				<xsl:when test="$type='ecrm:E4_Period'">
					<![CDATA[
{?object ecrm:P108i_was_produced_by ?prod .
?prod  ecrm:P10_falls_within kid:RDFID}
UNION {kid:RDFID skos:exactMatch ?matches .
?object ecrm:P10_falls_within ?prod .
?prod ecrm:P7_took_place_at ?matches}
UNION {?types skos:broader kid:RDFID .
?types skos:exactMatch ?matches .
?object ecrm:P10_falls_within ?matches .
?object ecrm:P108i_was_produced_by ?prod
OPTIONAL {?prod ecrm:P4_has_time-span ?dates .
?dates ecrm:P82a_begin_of_the_begin ?fromDate ; ecrm:P82b_end_of_the_end ?toDate }
{?prod ecrm:P7_took_place_at ?place }
UNION {?prod ecrm:P7_took_place_at ?relPlace .
?place skos:exactMatch ?relPlace }]]>
				</xsl:when>
				<xsl:when test="$type='ecrm:E57_Material'">
					<![CDATA[{?object ecrm:P45_consists_of kid:RDFID }
UNION {kid:RDFID skos:exactMatch ?matches .
?object ecrm:P45_consists_of ?matches}
UNION {?types skos:broader kid:RDFID .
?object ecrm:P45_consists_of ?types}
UNION {?types skos:broader kid:RDFID .
?types skos:exactMatch ?matches .
?object ecrm:P45_consists_of ?matches}
?object ecrm:P108i_was_produced_by ?prod
OPTIONAL {?prod ecrm:P4_has_time-span ?dates .
?dates ecrm:P82a_begin_of_the_begin ?fromDate ; ecrm:P82b_end_of_the_end ?toDate }
{?prod ecrm:P7_took_place_at ?place }
UNION {?prod ecrm:P7_took_place_at ?relPlace .
?place skos:exactMatch ?relPlace }]]>
				</xsl:when>
				<!--<xsl:when test="$type='ecrm:E53_Place'">
					<![CDATA[{?object ecrm:P108i_was_produced_by ?prod .
?prod ecrm:P7_took_place_at kid:RDFID}
UNION {kid:RDFID skos:exactMatch ?matches .
?object ecrm:P108i_was_produced_by ?prod .
?prod ecrm:P7_took_place_at ?matches}
UNION {?types ecrm:P88i_forms_part_of kid:RDFID .
?types skos:exactMatch ?matches .
?object ecrm:P108i_was_produced_by ?prod .
?prod ecrm:P7_took_place_at ?matches}]]>
				</xsl:when>-->
				<xsl:when test="$type='ecrm:E40_Legal_Body'">
					<![CDATA[?object ecrm:P50_has_current_keeper kid:RDFID .
?object ecrm:P108i_was_produced_by ?prod
OPTIONAL {?prod ecrm:P4_has_time-span ?dates .
?dates ecrm:P82a_begin_of_the_begin ?fromDate ; ecrm:P82b_end_of_the_end ?toDate }
{?prod ecrm:P7_took_place_at ?place }
UNION {?prod ecrm:P7_took_place_at ?relPlace .
?place skos:exactMatch ?relPlace }]]>
				</xsl:when>
				<xsl:when test="$type='kon:Shape'">
					<![CDATA[{?object kon:hasShape kid:RDFID }
UNION {kid:RDFID skos:exactMatch ?matches .
?object kon:hasShape ?matches}
UNION {?types skos:broader kid:RDFID .
?object kon:hasShape ?types}
UNION {?types skos:broader kid:RDFID .
?types skos:exactMatch ?matches .
?object kon:hasShape ?matches}
?object ecrm:P108i_was_produced_by ?prod
OPTIONAL {?prod ecrm:P4_has_time-span ?dates .
?dates ecrm:P82a_begin_of_the_begin ?fromDate ; ecrm:P82b_end_of_the_end ?toDate }
{?prod ecrm:P7_took_place_at ?place }
UNION {?prod ecrm:P7_took_place_at ?relPlace .
?place skos:exactMatch ?relPlace }]]>
				</xsl:when>
				<xsl:when test="$type='kon:Technique'">
					<![CDATA[{?object ecrm:P32_used_general_technique kid:RDFID }
UNION {kid:RDFID skos:exactMatch ?matches .
?object ecrm:P32_used_general_technique ?matches}
UNION {?types skos:broader kid:RDFID .
?object ecrm:P32_used_general_technique ?types}
UNION {?types skos:broader kid:RDFID .
?types skos:exactMatch ?matches .
?object ecrm:P32_used_general_technique ?matches}
?object ecrm:P108i_was_produced_by ?prod
OPTIONAL {?prod ecrm:P4_has_time-span ?dates .
?dates ecrm:P82a_begin_of_the_begin ?fromDate ; ecrm:P82b_end_of_the_end ?toDate }
{?prod ecrm:P7_took_place_at ?place }
UNION {?prod ecrm:P7_took_place_at ?relPlace .
?place skos:exactMatch ?relPlace }]]>
				</xsl:when>
				<!--<xsl:when test="$type='kon:Ware'">
					<![CDATA[					{?object kon:hasShape kid:RDFID }
					UNION {kid:RDFID skos:exactMatch ?matches .
					?object kon:hasShape ?matches}
					UNION {?types skos:broader kid:RDFID .
					?object kon:hasShape ?types}
					UNION {?types skos:broader kid:RDFID .
					?types skos:exactMatch ?matches .
					?object kon:hasShape ?matches}
					?object ecrm:P108i_was_produced_by ?prod
					{?prod ecrm:P7_took_place_at ?place }
					UNION {?prod ecrm:P7_took_place_at ?relPlace .
					?place skos:exactMatch ?relPlace }]]>
					</xsl:when>-->
				<xsl:when test="$type='foaf:Person'">
					<![CDATA[{?object ecrm:P108i_was_produced_by ?prod .
?prod ecrm:P14_carried_out_by kid:RDFID}
UNION {kid:RDFID skos:exactMatch ?matches .
?object ecrm:P108i_was_produced_by ?prod .
?prod ecrm:P14_carried_out_by ?matches}
?object ecrm:P108i_was_produced_by ?prod
OPTIONAL {?prod ecrm:P4_has_time-span ?dates .
?dates ecrm:P82a_begin_of_the_begin ?fromDate ; ecrm:P82b_end_of_the_end ?toDate }
{?prod ecrm:P7_took_place_at ?place }
UNION {?prod ecrm:P7_took_place_at ?relPlace .
?place skos:exactMatch ?relPlace }]]>
				</xsl:when>
				<xsl:when test="$type='foaf:Organization'">
					<![CDATA[{?object ecrm:P108i_was_produced_by ?prod .
?prod ecrm:P14_carried_out_by kid:RDFID}
UNION {kid:RDFID skos:exactMatch ?matches .
?object ecrm:P108i_was_produced_by ?prod .
?prod ecrm:P14_carried_out_by ?matches}
?object ecrm:P108i_was_produced_by ?prod
OPTIONAL {?prod ecrm:P4_has_time-span ?dates .
?dates ecrm:P82a_begin_of_the_begin ?fromDate ; ecrm:P82b_end_of_the_end ?toDate }
{?prod ecrm:P7_took_place_at ?place }
UNION {?prod ecrm:P7_took_place_at ?relPlace .
?place skos:exactMatch ?relPlace }]]>
				</xsl:when>
			</xsl:choose>
		</xsl:variable>

		<!--<xsl:variable name="select">
			<![CDATA[{?object kon:hasShape kid:lekythos }
UNION {kid:lekythos skos:exactMatch ?matches .
?object kon:hasShape ?matches}
?object ecrm:P108i_was_produced_by ?prod
{?prod ecrm:P7_took_place_at ?place }
UNION {?prod ecrm:P7_took_place_at ?relPlace .
?place skos:exactMatch ?relPlace }]]>
		</xsl:variable>-->

		<xsl:variable name="query" select="concat($prefixes, replace($select, 'RDFID', $id), $metadata)"/>
		<xsl:variable name="service" select="concat(/content/config/sparql/query, '?query=', encode-for-uri(normalize-space($query)), '&amp;output=xml')"/>

		<xsl:if test="string-length($select) &gt; 0">
			<xsl:apply-templates select="document($service)/descendant::res:result" mode="timemap"/>
		</xsl:if>
	</xsl:template>

	<xsl:template match="res:result" mode="timemap">
		<xsl:variable name="title" select="res:binding[@name='title']/res:literal"/>
		<xsl:variable name="description" as="node()*">
			<table>
				<tr>
					<xsl:if test="string(res:binding[@name='thumb'])">
						<td><img src="{res:binding[@name='thumb']/res:uri}" style="max-width:100px"/></td>
					</xsl:if>
					<td style="vertical-align:top">
						<ul>
							<li>
								<b>Accession: </b>
								<a href="{res:binding[@name='object']/res:uri}"><xsl:value-of select="res:binding[@name='id']/res:literal"/></a>
							</li>
							<li>
								<b>Keeper: </b>
								<a href="{res:binding[@name='kuri']/res:uri}"><xsl:value-of select="res:binding[@name='keeper']/res:literal"/></a>
							</li>
							<li>
								<b>Production Place: </b>
								<a href="{res:binding[@name='place']/res:uri}"><xsl:value-of select="res:binding[@name='label']/res:literal"/></a>
							</li>
							<xsl:if test="res:binding[@name='fromDate']/res:literal or res:binding[@name='toDate']/res:literal">
								<li>
									<b>Date: </b>
									<xsl:if test="string(res:binding[@name='fromDate']/res:literal)">
										<xsl:value-of select="kerameikos:normalizeYear(number(res:binding[@name='fromDate']/res:literal))"/>
									</xsl:if>
									<xsl:if test="string(res:binding[@name='fromDate']/res:literal) or res:binding[@name='toDate']/res:literal">
										<xsl:text>-</xsl:text>
									</xsl:if>
									<xsl:if test="string(res:binding[@name='toDate']/res:literal)">
										<xsl:value-of select="kerameikos:normalizeYear(number(res:binding[@name='toDate']/res:literal))"/>
									</xsl:if>
								</li>
							</xsl:if>
						</ul>
					</td>
				</tr>
			</table>
		</xsl:variable>
		<xsl:variable name="theme">blue</xsl:variable>
		<xsl:variable name="coords">
			<xsl:choose>
				<xsl:when test="res:binding[@name='long']/res:literal and res:binding[@name='lat']/res:literal">
					<xsl:text>"point": {"lon": </xsl:text><xsl:value-of select="res:binding[@name='long']/res:literal"/>, "lat": <xsl:value-of select="res:binding[@name='lat']/res:literal"
					/><xsl:text>}</xsl:text>
				</xsl:when>
				<xsl:when test="res:binding[@name='json']/res:literal">
					<xsl:text>"polygon" : [</xsl:text>
					<xsl:analyze-string select="res:binding[@name='json']/res:literal" regex="\[([0-9]+\.[0-9]+), ([0-9]+\.[0-9]+)\]">
						<xsl:matching-substring>
							<xsl:text>{"lat":</xsl:text>
							<xsl:value-of select="regex-group(2)"/>
							<xsl:text>,"lon":</xsl:text>
							<xsl:value-of select="regex-group(1)"/>
							<xsl:text>}</xsl:text>
							<xsl:if test="not(position()=last()-1)">
								<xsl:text>,</xsl:text>
							</xsl:if>
						</xsl:matching-substring>
					</xsl:analyze-string>
					<xsl:text>]</xsl:text>
				</xsl:when>
			</xsl:choose>
		</xsl:variable> {<xsl:value-of select="$coords"/>, "title": "<xsl:value-of select="normalize-space(replace($title, '&#x022;', '\\&#x022;'))"/>", <xsl:if
			test="string(res:binding[@name='fromDate']/res:literal)">"start": "<xsl:value-of select="res:binding[@name='fromDate']/res:literal"/>",</xsl:if>
		<xsl:if test="string(res:binding[@name='toDate']/res:literal)">"end": "<xsl:value-of select="res:binding[@name='toDate']/res:literal"/>",</xsl:if> "options": { "theme": "<xsl:value-of
			select="$theme"/>"<xsl:if test="string($description)">, "description": "<xsl:value-of select="normalize-space(replace(saxon:serialize($description, 'default'), '&#x022;', '\\&#x022;'))"
			/>"</xsl:if>, "href": "<xsl:value-of select="res:binding[@name='object']/res:uri"/>" }} <xsl:if test="not(position()=last())">
			<xsl:text>,</xsl:text>
		</xsl:if>
	</xsl:template>
</xsl:stylesheet>
