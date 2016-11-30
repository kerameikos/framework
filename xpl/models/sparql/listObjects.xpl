<?xml version="1.0" encoding="UTF-8"?>
<!--
	XPL handling SPARQL queries from Fuseki.
	Function: get an HTML (text) response for related coin types to display via AJAX in a record page
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
	
	<p:processor name="oxf:unsafe-xslt">
		<p:input name="request" href="#request"/>		
		<p:input name="data" href=" ../../../config.xml"/>
		<p:input name="config">
			<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
				<xsl:param name="id" select="doc('input:request')/request/parameters/parameter[name='id']/value"/>
				<xsl:param name="type" select="doc('input:request')/request/parameters/parameter[name='type']/value"/>
				
				<xsl:variable name="sparql_endpoint" select="/config/sparql/query"/>
				
				<xsl:variable name="prefixes">
					<![CDATA[PREFIX rdf:	<http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX dcterms:	<http://purl.org/dc/terms/>
PREFIX skos:	<http://www.w3.org/2004/02/skos/core#>
PREFIX owl:	<http://www.w3.org/2002/07/owl#>
PREFIX foaf:	<http://xmlns.com/foaf/0.1/>
PREFIX crm:	<http://www.cidoc-crm.org/cidoc-crm/>
PREFIX geo:	<http://www.w3.org/2003/01/geo/wgs84_pos#>
PREFIX kid:	<http://kerameikos.org/id/>
PREFIX kon:	<http://kerameikos.org/ontology#>]]>
				</xsl:variable>
				
				<xsl:variable name="metadata">
					<![CDATA[?object dcterms:title ?title ;
dcterms:identifier ?id .
OPTIONAL {?object crm:P50_has_current_keeper ?kuri .
?kuri skos:prefLabel ?keeper FILTER ( lang(?keeper) = "en" )} 
OPTIONAL {?object foaf:thumbnail ?thumb} .
OPTIONAL {?object foaf:depiction ?ref
	OPTIONAL {?ref dcterms:isReferencedBy ?manifest}}}]]>
				</xsl:variable>
				
				<xsl:variable name="select">
					<xsl:choose>
						<xsl:when test="$type='crm:E4_Period'">
							<![CDATA[SELECT DISTINCT ?object ?title ?id ?thumb ?ref ?keeper ?manifest WHERE {
{SELECT ?m WHERE {
  {kid:RDFID skos:exactMatch ?m}
  UNION {?m a skos:Concept FILTER (?m = kid:RDFID)}
  UNION {?m skos:broader+ kid:RDFID}
  UNION {?narrower skos:broader+ kid:RDFID ; skos:exactMatch ?m}}}
?object crm:P108i_was_produced_by ?prod .
?prod  crm:P10_falls_within ?m.]]>
						</xsl:when>
						<xsl:when test="$type='crm:E57_Material'">
							<![CDATA[SELECT DISTINCT ?object ?title ?id ?thumb ?ref ?keeper ?manifest WHERE {
{SELECT ?m WHERE {
   {kid:RDFID skos:exactMatch ?m}
  UNION {?m a skos:Concept FILTER (?m = kid:RDFID)}
  UNION {?m skos:broader+ kid:RDFID}
  UNION {?narrower skos:broader+ kid:RDFID ; skos:exactMatch ?m}}}
?object crm:P45_consists_of ?m.]]>
						</xsl:when>
						<xsl:when test="$type='kon:ProductionPlace'">
							<![CDATA[SELECT DISTINCT ?object ?title ?id ?thumb ?ref ?keeper ?manifest WHERE {
{SELECT ?m WHERE {
  {kid:RDFID skos:exactMatch ?m}
  UNION {?m a skos:Concept FILTER (?m = kid:RDFID)}
  UNION {?m skos:broader+ kid:RDFID}
  UNION {?narrower skos:broader+ kid:RDFID ; skos:exactMatch ?m}}}
?object crm:P108i_was_produced_by ?prod .
?prod crm:P7_took_place_at ?m.]]>
						</xsl:when>
						<xsl:when test="$type='crm:E40_Legal_Body'">
							<![CDATA[SELECT DISTINCT ?object ?title ?id ?thumb ?ref ?keeper ?manifest WHERE {
?object crm:P50_has_current_keeper kid:RDFID .]]>
						</xsl:when>
						<xsl:when test="$type='kon:Shape'">
							<![CDATA[SELECT DISTINCT ?object ?title ?id ?thumb ?ref ?keeper ?manifest WHERE {
{SELECT ?m WHERE {
  {kid:RDFID skos:exactMatch ?m}
  UNION {?m a skos:Concept FILTER (?m = kid:RDFID)}
  UNION {?m skos:broader+ kid:RDFID}
  UNION {?narrower skos:broader+ kid:RDFID ; skos:exactMatch ?m}}}
?object kon:hasShape ?m.]]>
						</xsl:when>
						<xsl:when test="$type='kon:Technique'">
							<![CDATA[SELECT DISTINCT ?object ?title ?id ?thumb ?ref ?keeper ?manifest WHERE {
{SELECT ?m WHERE {
  {kid:RDFID skos:exactMatch ?m}
  UNION {?m a skos:Concept FILTER (?m = kid:RDFID)}
  UNION {?m skos:broader+ kid:RDFID}
  UNION {?narrower skos:broader+ kid:RDFID ; skos:exactMatch ?m}}}
?object crm:P32_used_general_technique ?m .]]>
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
							<![CDATA[SELECT ?object ?title ?id ?thumb ?ref ?keeper ?manifest WHERE {
{SELECT ?m WHERE {
  {kid:RDFID skos:exactMatch ?m} 
  UNION {?m a skos:Concept FILTER (?m = kid:RDFID)}}}
?object crm:P108i_was_produced_by ?prod .
?prod crm:P14_carried_out_by ?m .]]>
						</xsl:when>
						<xsl:when test="$type='foaf:Organization'">
							<![CDATA[SELECT ?object ?title ?id ?thumb ?ref ?keeper ?manifest WHERE {
{SELECT ?m WHERE {kid:RDFID skos:exactMatch ?m}}
?object crm:P108i_was_produced_by ?prod .
?prod crm:P14_carried_out_by ?m .]]>
						</xsl:when>
					</xsl:choose>
				</xsl:variable>
				
				<xsl:template match="/">
					<xsl:variable name="query" select="concat($prefixes, replace($select, 'RDFID', $id), $metadata)"/>
					<xsl:variable name="service" select="concat(/config/sparql/query, '?query=', encode-for-uri(normalize-space($query)), '&amp;output=xml')"/>
					
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
</p:config>
