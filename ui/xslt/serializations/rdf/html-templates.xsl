<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:foaf="http://xmlns.com/foaf/0.1/" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
	xmlns:dbpedia-owl="http://dbpedia.org/ontology/" xmlns:skos="http://www.w3.org/2004/02/skos/core#" xmlns:owl="http://www.w3.org/2002/07/owl#" xmlns:crm="http://www.cidoc-crm.org/cidoc-crm/"
	xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:dcterms="http://purl.org/dc/terms/" xmlns:kid="http://kerameikos.org/id/" xmlns:kon="http://kerameikos.org/ontology#"
	xmlns:geo="http://www.w3.org/2003/01/geo/wgs84_pos#" xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:kerameikos="http://kerameikos.org/" xmlns:res="http://www.w3.org/2005/sparql-results#"
	exclude-result-prefixes="#all" version="2.0">

	<xsl:variable name="classes" as="node()*">
		<classes>
			<!--<class>
				<label>Collection</label>
				<type>crm:E78_Collection</type>
			</class>-->
			<class>
				<label>Institution</label>
				<type>crm:E40_Legal_Body</type>
			</class>
			<class>
				<label>Material</label>
				<type>crm:E57_Material</type>
			</class>
			<class>
				<label>Organization</label>
				<type>foaf:Organization</type>
			</class>
			<class>
				<label>Period</label>
				<type>crm:E4_Period</type>
			</class>
			<class>
				<label>Person</label>
				<type>foaf:Person</type>
			</class>
			<class>
				<label>Place</label>
				<type>kon:ProductionPlace</type>
			</class>
			<class>
				<label>Shape</label>
				<type>kon:Shape</type>
			</class>
			<class>
				<label>Technique</label>
				<type>kon:Technique</type>
			</class>
			<!--<class>
				<label>Ware</label>
				<type>kon:Ware</type>
			</class>-->
		</classes>
	</xsl:variable>

	<xsl:template name="associatedObjects">
		<xsl:param name="id"/>
		<xsl:param name="type"/>

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
{?object crm:P50_has_current_keeper ?kuri .
?kuri skos:prefLabel ?keeper .
FILTER ( lang(?keeper) = "en" )} 
OPTIONAL {?object foaf:thumbnail ?thumb} .
OPTIONAL {?object foaf:depiction ?ref}}]]>
		</xsl:variable>

		<xsl:variable name="select">
			<xsl:choose>
				<xsl:when test="$type='crm:E4_Period'">
					<![CDATA[SELECT ?object ?title ?id ?thumb ?ref ?keeper WHERE {
{?object crm:P108i_was_produced_by ?prod .
?prod  crm:P10_falls_within kid:RDFID}
UNION {kid:RDFID skos:exactMatch ?matches .
?object crm:P10_falls_within ?prod .
?prod crm:P7_took_place_at ?matches}
UNION {?types skos:broader kid:RDFID .
?types skos:exactMatch ?matches .
?object crm:P10_falls_within ?matches]]>
				</xsl:when>
				<xsl:when test="$type='crm:E57_Material'">
					<![CDATA[SELECT ?object ?title ?id ?thumb ?ref ?keeper WHERE {
{?object crm:P45_consists_of kid:RDFID }
UNION {kid:RDFID skos:exactMatch ?matches .
?object crm:P45_consists_of ?matches}
UNION {?types skos:broader kid:RDFID .
?object crm:P45_consists_of ?types}
UNION {?types skos:broader kid:RDFID .
?types skos:exactMatch ?matches .
?object crm:P45_consists_of ?matches}]]>
				</xsl:when>
				<xsl:when test="$type='kon:ProductionPlace'">
					<![CDATA[SELECT ?object ?title ?id ?thumb ?ref ?keeper WHERE {
{?object crm:P108i_was_produced_by ?prod .
?prod crm:P7_took_place_at kid:RDFID}
UNION {kid:RDFID skos:exactMatch ?matches .
?object crm:P108i_was_produced_by ?prod .
?prod crm:P7_took_place_at ?matches}
UNION {?types crm:P88i_forms_part_of kid:RDFID .
?types skos:exactMatch ?matches .
?object crm:P108i_was_produced_by ?prod .
?prod crm:P7_took_place_at ?matches}]]>
				</xsl:when>
				<xsl:when test="$type='crm:E40_Legal_Body'">
					<![CDATA[SELECT ?object ?title ?id ?thumb ?ref ?keeper WHERE {
?object crm:P50_has_current_keeper kid:RDFID .]]>
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
{?object crm:P32_used_general_technique kid:RDFID }
UNION {kid:RDFID skos:exactMatch ?matches .
?object crm:P32_used_general_technique ?matches}
UNION {?types skos:broader kid:RDFID .
?object crm:P32_used_general_technique ?types}
UNION {?types skos:broader kid:RDFID .
?types skos:exactMatch ?matches .
?object crm:P32_used_general_technique ?matches}]]>
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
{?object crm:P108i_was_produced_by ?prod .
?prod crm:P14_carried_out_by kid:RDFID}
UNION {kid:RDFID skos:exactMatch ?matches .
?object crm:P108i_was_produced_by ?prod .
?prod crm:P14_carried_out_by ?matches}]]>
				</xsl:when>
				<xsl:when test="$type='foaf:Organization'">
					<![CDATA[SELECT ?object ?title ?id ?thumb ?ref ?keeper WHERE {
{?object crm:P108i_was_produced_by ?prod .
?prod crm:P14_carried_out_by kid:RDFID}
UNION {kid:RDFID skos:exactMatch ?matches .
?object crm:P108i_was_produced_by ?prod .
?prod crm:P14_carried_out_by ?matches}]]>
				</xsl:when>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="query" select="concat($prefixes, replace($select, 'RDFID', $id), $metadata)"/>
		<xsl:variable name="service" select="concat(/content/config/sparql/query, '?query=', encode-for-uri(normalize-space($query)), '&amp;output=xml')"/>

		<xsl:if test="string-length($query) &gt; 0">
			<div class="row">
				<div class="col-md-12">
					<h2>Objects of this Typology</h2>
					<xsl:apply-templates select="document($service)/descendant::res:result" mode="display"/>
				</div>
			</div>
		</xsl:if>
	</xsl:template>

	<xsl:template match="res:result" mode="display">
		<xsl:variable name="title" select="concat(res:binding[@name='keeper']/res:literal, ': ', res:binding[@name='title']/res:literal, ' (' , res:binding[@name='id']/res:literal, ')')"/>

		<xsl:choose>
			<xsl:when test="string(res:binding[@name='ref']/res:uri)">
				<div class="col-md-2">
					<a href="{res:binding[@name='ref']/res:uri}" title="{$title}" rel="gallery" class="fancybox" id="{res:binding[@name='object']/res:uri}">
						<img src="{if (string(res:binding[@name='thumb']/res:uri)) then res:binding[@name='thumb']/res:uri else res:binding[@name='ref']/res:uri}" title="{$title}" class="thumb"/>
					</a>
				</div>
			</xsl:when>
			<xsl:when test="string(res:binding[@name='thumb']/res:uri)">
				<div class="col-md-2">
					<img src="{res:binding[@name='thumb']/res:uri}" title="{$title}" class="thumb"/>
				</div>
			</xsl:when>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="quant">
		<div class="row">
			<div class="col-md-12">
				<a name="quant"/>
				<h2>Quantitative Analysis</h2>

				<xsl:if test="string($category)">
					<xsl:call-template name="construct-table"/>
				</xsl:if>

				<form role="form" id="calculateForm" action="{$display_path}id/{$id}.html#quant" method="get">
					<p>Select a category below to generate a graph showing the quantitative distribution for this typology.</p>
					<div class="form-group">
						<label for="categorySelect">Category</label>
						<select name="category" class="form-control" id="categorySelect">
							<option value="">Select...</option>
							<xsl:for-each select="$classes//class[not(type=$type)]">
								<option value="{type}">
									<xsl:if test="$category = type">
										<xsl:attribute name="selected">selected</xsl:attribute>
									</xsl:if>
									<xsl:value-of select="label"/>
								</option>
							</xsl:for-each>
						</select>
					</div>
					<input type="submit" value="Generate" class="btn btn-default" id="visualize-submit"/>
				</form>
			</div>
		</div>
	</xsl:template>

	<xsl:template name="construct-table">
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
			<![CDATA[{?target skos:prefLabel ?label}
UNION {?kidm skos:exactMatch ?target .
?kidm skos:prefLabel ?label }
FILTER ( lang(?label) = "en" )
} GROUP BY ?label
ORDER BY ?label]]>
		</xsl:variable>
		<xsl:variable name="category-select">
			<xsl:choose>
				<xsl:when test="$category='crm:E4_Period'">
					<![CDATA[?object crm:P108i_was_produced_by ?prod .
?prod  crm:P10_falls_within ?target]]>
				</xsl:when>
				<xsl:when test="$category='crm:E57_Material'">
					<![CDATA[?object crm:P45_consists_of ?target]]>
				</xsl:when>
				<xsl:when test="$category='kon:ProductionPlace'">
					<![CDATA[?object crm:P108i_was_produced_by ?prod .
?prod crm:P7_took_place_at ?target]]>
				</xsl:when>
				<xsl:when test="$category='crm:E40_Legal_Body'">
					<![CDATA[?object crm:P50_has_current_keeper ?target]]>
				</xsl:when>
				<xsl:when test="$category='kon:Shape'">
					<![CDATA[?object kon:hasShape ?target ]]>
				</xsl:when>
				<xsl:when test="$category='kon:Technique'">
					<![CDATA[?object crm:P32_used_general_technique ?target]]>
				</xsl:when>
				<!--<xsl:when test="$category='kon:Ware'">
					<![CDATA[SELECT ?label (COUNT(?label) as ?count) WHERE {
					{?object kon:hasShape ?target }
					UNION {?target skos:exactMatch ?matches .
					?object kon:hasShape ?matches}
					UNION {?types skos:broader ?target .
					?object kon:hasShape ?types}
					UNION {?types skos:broader ?target .
					?types skos:exactMatch ?matches .
					?object kon:hasShape ?matches}]]>
					</xsl:when>-->
				<xsl:when test="$category='foaf:Person'">
					<![CDATA[?object crm:P108i_was_produced_by ?prod .
?prod crm:P14_carried_out_by ?target]]>
				</xsl:when>
				<xsl:when test="$category='foaf:Organization'">
					<![CDATA[?object crm:P108i_was_produced_by ?prod .
?prod crm:P14_carried_out_by ?target]]>
				</xsl:when>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="select">
			<xsl:choose>
				<xsl:when test="$type='crm:E4_Period'">
					<![CDATA[SELECT ?label (COUNT(?label) as ?count) WHERE {
{?object crm:P108i_was_produced_by ?prod .
?prod  crm:P10_falls_within kid:RDFID}
UNION {kid:RDFID skos:exactMatch ?matches .
?object crm:P10_falls_within ?prod .
?prod crm:P7_took_place_at ?matches}]]>
				</xsl:when>
				<xsl:when test="$type='crm:E57_Material'">
					<![CDATA[SELECT ?label (COUNT(?label) as ?count) WHERE {
{?object crm:P45_consists_of kid:RDFID }
UNION {kid:RDFID skos:exactMatch ?matches .
?object crm:P45_consists_of ?matches}]]>
				</xsl:when>
				<xsl:when test="$type='kon:ProductionPlace'">
					<![CDATA[SELECT ?label (COUNT(?label) as ?count) WHERE {
{?object crm:P108i_was_produced_by ?prod .
?prod crm:P7_took_place_at kid:RDFID}
UNION {kid:RDFID skos:exactMatch ?matches .
?object crm:P108i_was_produced_by ?prod .
?prod crm:P7_took_place_at ?matches}]]>
				</xsl:when>
				<xsl:when test="$type='crm:E40_Legal_Body'">
					<![CDATA[SELECT ?label (COUNT(?label) as ?count) WHERE {
?object crm:P50_has_current_keeper kid:RDFID]]>
				</xsl:when>
				<xsl:when test="$type='kon:Shape'">
					<![CDATA[SELECT ?label (COUNT(?label) as ?count) WHERE {
{?object kon:hasShape kid:RDFID }
UNION {kid:RDFID skos:exactMatch ?matches .
?object kon:hasShape ?matches}]]>
				</xsl:when>
				<xsl:when test="$type='kon:Technique'">
					<![CDATA[SELECT ?label (COUNT(?label) as ?count) WHERE {
{?object crm:P32_used_general_technique kid:RDFID }
UNION {kid:RDFID skos:exactMatch ?matches .
?object crm:P32_used_general_technique ?matches}]]>
				</xsl:when>
				<!--<xsl:when test="$type='kon:Ware'">
					<![CDATA[SELECT ?label (COUNT(?label) as ?count) WHERE {
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
					<![CDATA[SELECT ?label (COUNT(?label) as ?count) WHERE {
{?object crm:P108i_was_produced_by ?prod .
?prod crm:P14_carried_out_by kid:RDFID}
UNION {kid:RDFID skos:exactMatch ?matches .
?object crm:P108i_was_produced_by ?prod .
?prod crm:P14_carried_out_by ?matches}]]>
				</xsl:when>
				<xsl:when test="$type='foaf:Organization'">
					<![CDATA[SELECT ?label (COUNT(?label) as ?count) WHERE {
{?object crm:P108i_was_produced_by ?prod .
?prod crm:P14_carried_out_by kid:RDFID}
UNION {kid:RDFID skos:exactMatch ?matches .
?object crm:P108i_was_produced_by ?prod .
?prod crm:P14_carried_out_by ?matches}]]>
				</xsl:when>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="query" select="concat($prefixes, replace($select, 'RDFID', $id), $category-select, $metadata)"/>
		<xsl:variable name="service" select="concat(/content/config/sparql/query, '?query=', encode-for-uri(normalize-space($query)), '&amp;output=xml')"/>

		<xsl:apply-templates select="document($service)/descendant::res:results" mode="table"/>

	</xsl:template>

	<xsl:template match="res:results" mode="table">
		<div id="container" style="min-width: 310px; height: 400px; margin: 0 auto"/>
		<table class="table" id="calculate" style="display:none">
			<thead>
				<caption>Distribution of <xsl:value-of select="$category"/> for <xsl:value-of select="$title"/></caption>
				<th>
					<xsl:value-of select="$category"/>
				</th>
				<th>Count</th>
			</thead>
			<tbody>
				<xsl:apply-templates select="descendant::res:result" mode="table"/>
			</tbody>
		</table>
	</xsl:template>

	<xsl:template match="res:result" mode="table">
		<tr>
			<td>
				<xsl:value-of select="res:binding[@name='label']/res:literal"/>
			</td>
			<td>
				<xsl:value-of select="res:binding[@name='count']/res:literal"/>
			</td>
		</tr>
	</xsl:template>

</xsl:stylesheet>
