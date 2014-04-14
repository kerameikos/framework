<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:foaf="http://xmlns.com/foaf/0.1/" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
	xmlns:dbpedia-owl="http://dbpedia.org/ontology/" xmlns:skos="http://www.w3.org/2004/02/skos/core#" xmlns:owl="http://www.w3.org/2002/07/owl#"
	xmlns:ecrm="http://erlangen-crm.org/current/" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:dcterms="http://purl.org/dc/terms/" xmlns:kid="http://kerameikos.org/id/"
	xmlns:kon="http://kerameikos.org/ontology#" xmlns:geo="http://www.w3.org/2003/01/geo/wgs84_pos#" xmlns:tei="http://www.tei-c.org/ns/1.0"
	xmlns:kerameikos="http://kerameikos.org/" xmlns:res="http://www.w3.org/2005/sparql-results#" exclude-result-prefixes="#all" version="2.0">
	
	<xsl:template name="associatedObjects">
		<xsl:param name="id"/>
		<xsl:param name="type"/>
		
		<xsl:variable name="prefixes">
			<![CDATA[PREFIX rdf:	<http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX dcterms:	<http://purl.org/dc/terms/>
PREFIX skos:	<http://www.w3.org/2004/02/skos/core#>
PREFIX owl:	<http://www.w3.org/2002/07/owl#>
PREFIX foaf:	<http://xmlns.com/foaf/0.1/>
PREFIX ecrm:	<http://erlangen-crm.org/current/>
PREFIX geo:	<http://www.w3.org/2003/01/geo/wgs84_pos#>
PREFIX kid:	<http://kerameikos.org/id/>
PREFIX kon:	<http://kerameikos.org/ontology#>]]>
		</xsl:variable>
		<xsl:variable name="metadata">
			<![CDATA[?object dcterms:title ?title ;
dcterms:identifier ?id .
{?object ecrm:P50_has_current_keeper ?kuri .
?kuri skos:prefLabel ?keeper .
FILTER ( lang(?keeper) = "en" )} 
?object foaf:thumbnail ?thumb .
OPTIONAL {?object foaf:depiction ?ref}}]]>
		</xsl:variable>
		
		<xsl:variable name="select">
			<xsl:choose>
				<xsl:when test="$type='ecrm:E4_Period'">
					<![CDATA[SELECT ?object ?title ?id ?thumb ?ref ?keeper WHERE {
{?object ecrm:P108i_was_produced_by ?prod .
?prod  ecrm:P10_falls_within kid:RDFID}
UNION {kid:RDFID skos:exactMatch ?matches .
?object ecrm:P10_falls_within ?prod .
?prod ecrm:P7_took_place_at ?matches}
UNION {?types skos:broader kid:RDFID .
?types skos:exactMatch ?matches .
?object ecrm:P10_falls_within ?matches]]>
				</xsl:when>	
				<xsl:when test="$type='ecrm:E57_Material'">
					<![CDATA[SELECT ?object ?title ?id ?thumb ?ref ?keeper WHERE {
{?object ecrm:P45_consists_of kid:RDFID }
UNION {kid:RDFID skos:exactMatch ?matches .
?object ecrm:P45_consists_of ?matches}
UNION {?types skos:broader kid:RDFID .
?object ecrm:P45_consists_of ?types}
UNION {?types skos:broader kid:RDFID .
?types skos:exactMatch ?matches .
?object ecrm:P45_consists_of ?matches}]]>
				</xsl:when>
				<xsl:when test="$type='ecrm:E53_Place'">
					<![CDATA[SELECT ?object ?title ?id ?thumb ?ref ?keeper WHERE {
{?object ecrm:P108i_was_produced_by ?prod .
?prod ecrm:P7_took_place_at kid:RDFID}
UNION {kid:RDFID skos:exactMatch ?matches .
?object ecrm:P108i_was_produced_by ?prod .
?prod ecrm:P7_took_place_at ?matches}
UNION {?types ecrm:P88i_forms_part_of kid:RDFID .
?types skos:exactMatch ?matches .
?object ecrm:P108i_was_produced_by ?prod .
?prod ecrm:P7_took_place_at ?matches}]]>
				</xsl:when>
				<xsl:when test="$type='ecrm:E40_Legal_Body'">
					<![CDATA[SELECT ?object ?title ?id ?thumb ?ref ?keeper WHERE {
?object ecrm:P50_has_current_keeper kid:RDFID .]]>
				</xsl:when>
				<xsl:when test="$type='kon:Shape'">
					<![CDATA[SELECT ?object ?title ?id ?thumb ?ref ?keeper WHERE {
{?object kon:hasShape kid:RDFID }
UNION {kid:RDFID skos:exactMatch ?matches .
?object kon:hasShape ?matches}
UNION {?types skos:broader kid:RDFID .
?object kon:hasShape ?types}
UNION {?types skos:broader kid:RDFID .
?types skos:exactMatch ?matches .
?object kon:hasShape ?matches}]]>
				</xsl:when>
				<xsl:when test="$type='kon:Technique'">
					<![CDATA[SELECT ?object ?title ?id ?thumb ?ref ?keeper WHERE {
{?object ecrm:P32_used_general_technique kid:RDFID }
UNION {kid:RDFID skos:exactMatch ?matches .
?object ecrm:P32_used_general_technique ?matches}
UNION {?types skos:broader kid:RDFID .
?object ecrm:P32_used_general_technique ?types}
UNION {?types skos:broader kid:RDFID .
?types skos:exactMatch ?matches .
?object ecrm:P32_used_general_technique ?matches}]]>
				</xsl:when>
				<!--<xsl:when test="$type='kon:Ware'">
					<![CDATA[SELECT ?object ?title ?id ?thumb ?ref ?keeper WHERE {
{?object kon:hasShape kid:RDFID }
UNION {kid:RDFID skos:exactMatch ?matches .
?object kon:hasShape ?matches}
UNION {?types skos:broader kid:RDFID .
?object kon:hasShape ?types}
UNION {?types skos:broader kid:RDFID .
?types skos:exactMatch ?matches .
?object kon:hasShape ?matches}]]>
				</xsl:when>-->
				<xsl:when test="$type='foaf:Person'">
					<![CDATA[SELECT ?object ?title ?id ?thumb ?ref ?keeper WHERE {
{?object ecrm:P108i_was_produced_by ?prod .
?prod ecrm:P14_carried_out_by kid:RDFID}
UNION {kid:RDFID skos:exactMatch ?matches .
?object ecrm:P108i_was_produced_by ?prod .
?prod ecrm:P14_carried_out_by ?matches}]]>
				</xsl:when>
				<xsl:when test="$type='foaf:Organization'">
					<![CDATA[SELECT ?object ?title ?id ?thumb ?ref ?keeper WHERE {
{?object ecrm:P108i_was_produced_by ?prod .
?prod ecrm:P14_carried_out_by kid:RDFID}
UNION {kid:RDFID skos:exactMatch ?matches .
?object ecrm:P108i_was_produced_by ?prod .
?prod ecrm:P14_carried_out_by ?matches}]]>
				</xsl:when>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:variable name="query" select="concat($prefixes, replace($select, 'RDFID', $id), $metadata)"/> 
		<xsl:variable name="service" select="concat(/content/config/sparql, '?query=', encode-for-uri(normalize-space($query)), '&amp;output=xml')"/>
		
		<xsl:if test="string-length($query) &gt; 0">
			<div class="row">
				<xsl:apply-templates select="document($service)/descendant::res:result" mode="display"/>
			</div>
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="res:result" mode="display">
		<xsl:variable name="title" select="concat(res:binding[@name='keeper']/res:literal, ': ', res:binding[@name='title']/res:literal, ' (' , res:binding[@name='id']/res:literal, ')')"/>
		<div class="col-md-2">
			<xsl:choose>
				<xsl:when test="res:binding[@name='ref']/res:uri">
					<a href="{res:binding[@name='ref']/res:uri}" title="{$title}" rel="gallery" class="fancybox" id="{res:binding[@name='object']/res:uri}">
						<img src="{res:binding[@name='thumb']/res:uri}" title="{$title}" class="thumb"/>
					</a>
				</xsl:when>
				<xsl:otherwise>
					<img src="{res:binding[@name='thumb']/res:uri}" title="{$title}" class="thumb"/>
				</xsl:otherwise>
			</xsl:choose>
		</div>
	</xsl:template>
	
</xsl:stylesheet>
