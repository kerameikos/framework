<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:foaf="http://xmlns.com/foaf/0.1/" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
	xmlns:dbpedia-owl="http://dbpedia.org/ontology/" xmlns:skos="http://www.w3.org/2004/02/skos/core#" xmlns:owl="http://www.w3.org/2002/07/owl#"
	xmlns:ecrm="http://erlangen-crm.org/current/" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:dcterms="http://purl.org/dc/terms/"
	xmlns:kid="http://kerameikos.org/id/" xmlns:kon="http://kerameikos.org/ontology#" xmlns:geo="http://www.w3.org/2003/01/geo/wgs84_pos#"
	exclude-result-prefixes="#all" version="2.0">
	<xsl:include href="templates.xsl"/>

	<xsl:variable name="display_path">../</xsl:variable>
	<xsl:variable name="id" select="substring-after(//@rdf:about, 'id/')"/>
	<xsl:variable name="html-uri" select="concat(/content/config/url, 'id/', $id, '.html')"/>
	<xsl:variable name="type" select="/content/rdf:RDF/*/name()"/>
	
	<!-- definition of namespaces for turning in solr type field URIs into abbreviations -->
	<xsl:variable name="namespaces" as="item()*">
		<namespaces>
			<namespace prefix="ecrm" uri="http://erlangen-crm.org/current/"/>
			<namespace prefix="foaf" uri="http://xmlns.com/foaf/0.1/"/>
			<namespace prefix="kon" uri="http://kerameikos.org/ontology#"/>
			<namespace prefix="skos" uri="http://www.w3.org/2004/02/skos/core#"/>			
		</namespaces>
	</xsl:variable>

	<xsl:template match="/">
		<html
			prefix="dcterms: http://purl.org/dc/terms/
			foaf: http://xmlns.com/foaf/0.1/
			geo:  http://www.w3.org/2003/01/geo/wgs84_pos#
			owl:  http://www.w3.org/2002/07/owl#
			rdfs: http://www.w3.org/2000/01/rdf-schema#
			rdfa: http://www.w3.org/ns/rdfa#
			rdf:  http://www.w3.org/1999/02/22-rdf-syntax-ns#
			skos: http://www.w3.org/2004/02/skos/core#
			dcterms: http://purl.org/dc/terms/
			ecrm: http://erlangen-crm.org/current/
			kid: http://kerameikos.org/id/
			kon: http://kerameikos.org/ontology#">
			<head>
				<title id="{$id}">Kerameikos.org: <xsl:value-of select="//@rdf:about"/></title>
				<link rel="stylesheet" type="text/css" href="http://yui.yahooapis.com/3.8.0/build/cssgrids/grids-min.css"/>
				<link rel="stylesheet" href="{$display_path}ui/css/style.css"/>

				<script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.6.4/jquery.min.js"/>
				<xsl:if test="$type='ecrm:E53_Place'">
					<script type="text/javascript" src="http://www.openlayers.org/api/OpenLayers.js"/>
					<script type="text/javascript" src="http://maps.google.com/maps/api/js?v=3.2&amp;sensor=false"/>
					<script type="text/javascript" src="{$display_path}ui/javascript/display_map_functions.js"/>
				</xsl:if>
			</head>
			<body>
				<xsl:call-template name="header"/>
				<xsl:call-template name="body"/>
				<xsl:call-template name="footer"/>
			</body>
		</html>
	</xsl:template>

	<xsl:template name="body">
		<div>
			<p>Download options: <a href="{$id}.rdf">RDF/XML</a> | <a href="http://www.w3.org/2012/pyRdfa/extract?uri={$html-uri}&amp;format=turtle">TTL</a> | <a
				href="http://www.w3.org/2012/pyRdfa/extract?uri={$html-uri}&amp;format=json">JSON-LD</a></p>
		</div>
		<div class="yui3-g">
			<div class="yui3-u-3-4">
				<div class="content">
					<xsl:apply-templates select="/content/rdf:RDF/*" mode="type"/>

					<xsl:if test="$type='ecrm:E53_Place'">
						<div id="mapcontainer"/>
					</xsl:if>

					<p class="desc">Below the RDF output, there can be maps showing the geographic distribution vases of this type or created by this person, as
						well as a simple interface to render a graph showing the distribution of particular typologies (e.g., shape types or iconographic
						motifs), generated from SPARQL</p>
				</div>
			</div>
			<div class="yui3-u-1-4">
				<div class="content">
					<p class="desc">The sidebar can show textual or visual information extracted from other LOD sources.</p>
					<xsl:if test="descendant::owl:sameAs[contains(@rdf:resource, 'dbpedia.org')]">
						<xsl:call-template name="dbpedia-abstract">
							<xsl:with-param name="uri" select="descendant::owl:sameAs[contains(@rdf:resource, 'dbpedia.org')]/@rdf:resource"/>
						</xsl:call-template>
					</xsl:if>
				</div>
			</div>
		</div>
	</xsl:template>

	<xsl:template match="*" mode="type">
		<div typeof="{name()}" about="{@rdf:about}">
			<h2>
				<xsl:value-of select="@rdf:about"/>
				<xsl:text> (</xsl:text>
				<a href="{concat(namespace-uri(.), local-name())}">
					<xsl:value-of select="name()"/>
				</a>
				<xsl:text>)</xsl:text>
			</h2>
			<dl>
				<xsl:apply-templates select="skos:prefLabel" mode="list-item">
					<xsl:sort select="@xml:lang"/>
				</xsl:apply-templates>
				<xsl:apply-templates select="skos:definition" mode="list-item">
					<xsl:sort select="@xml:lang"/>
				</xsl:apply-templates>
				<xsl:apply-templates select="*[not(name()='skos:prefLabel') and not(name()='skos:definition')]" mode="list-item">
					<xsl:sort select="name()"/>
					<xsl:sort select="@rdf:resource"/>
				</xsl:apply-templates>
			</dl>
		</div>
	</xsl:template>

	<xsl:template match="*" mode="list-item">
		<dt>
			<xsl:value-of select="name()"/>
		</dt>
		<dd>
			<xsl:choose>
				<xsl:when test="string(.)">
					<span property="{name()}" xml:lang="{@xml:lang}">
						<xsl:value-of select="."/>
					</span>
					<xsl:if test="string(@xml:lang)">
						<span class="lang">
							<xsl:value-of select="concat(' (', @xml:lang, ')')"/>
						</span>
					</xsl:if>
				</xsl:when>
				<xsl:when test="string(@rdf:resource)">
					<span>
						<a href="{@rdf:resource}" rel="{name()}" title="{@rdf:resource}">
							<xsl:choose>
								<xsl:when test="name()='rdf:type'">
									<xsl:variable name="uri" select="@rdf:resource"/>
									<xsl:value-of select="replace($uri, $namespaces//namespace[contains($uri, @uri)]/@uri, concat($namespaces//namespace[contains($uri, @uri)]/@prefix, ':'))"/>							
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="@rdf:resource"/>
								</xsl:otherwise>
							</xsl:choose>
						</a>
					</span>
				</xsl:when>
			</xsl:choose>
		</dd>
	</xsl:template>

	<xsl:template name="dbpedia-abstract">
		<xsl:param name="uri"/>

		<xsl:variable name="dbpedia-rdf" as="item()*">
			<xsl:copy-of select="document(concat('http://dbpedia.org/data/', substring-after($uri, 'resource/'), '.rdf'))/*"/>
		</xsl:variable>
		<h3>Abstract (dbpedia)</h3>
		<xsl:value-of select="$dbpedia-rdf//dbpedia-owl:abstract[@xml:lang='en']"/>
	</xsl:template>


</xsl:stylesheet>
