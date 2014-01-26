<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:foaf="http://xmlns.com/foaf/0.1" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
	xmlns:dbpedia-owl="http://dbpedia.org/ontology/" xmlns:skos="http://www.w3.org/2004/02/skos/core#" xmlns:owl="http://www.w3.org/2002/07/owl#"
	xmlns:crm="http://erlangen-crm.org/current/" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:dcterms="http://purl.org/dc/terms/"
	exclude-result-prefixes="#all" version="2.0">
	<xsl:include href="templates.xsl"/>

	<xsl:variable name="display_path">../</xsl:variable>
	<xsl:variable name="id" select="substring-after(//@rdf:about, 'id/')"/>
	<xsl:variable name="request-url" select="doc('input:request')/request/request-url"/>

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
			crm: http://erlangen-crm.org/current/">
			<head>
				<title>Ceramic Project</title>
				<link rel="stylesheet" type="text/css" href="http://yui.yahooapis.com/3.8.0/build/cssgrids/grids-min.css"/>
				<link rel="stylesheet" href="{$display_path}ui/css/style.css"/>

				<script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.6.4/jquery.min.js"/>
				<!--<script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jqueryui/1.8.23/jquery-ui.min.js"/>-->
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
			<p>Download options: <a href="{$id}.rdf">RDF/XML</a> | <a href="http://www.w3.org/2012/pyRdfa/extract?uri={$request-url}&amp;format=ttl">TTL</a> |
					<a href="http://www.w3.org/2012/pyRdfa/extract?uri={$request-url}&amp;format=json">JSON-LD</a></p>
		</div>
		<div class="yui3-g">
			<div class="yui3-u-3-4">
				<div class="content">
					<xsl:apply-templates select="rdf:RDF/*"/>
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

	<xsl:template match="rdf:RDF/*">
		<div typeof="{name()}" about="{@rdf:about}">
			<h2>
				<xsl:value-of select="@rdf:about"/>
				<xsl:text> (</xsl:text>
				<xsl:value-of select="name()"/>
				<xsl:text>)</xsl:text>
			</h2>
			<dl>
				<xsl:apply-templates select="skos:prefLabel">
					<xsl:sort select="@xml:lang"/>
				</xsl:apply-templates>
				<xsl:apply-templates select="skos:definition">
					<xsl:sort select="@xml:lang"/>
				</xsl:apply-templates>
				<xsl:apply-templates select="rdf:type">
					<xsl:sort select="@rdf:resource"/>
				</xsl:apply-templates>
				<xsl:apply-templates select="owl:sameAs">
					<xsl:sort select="@rdf:resource"/>
				</xsl:apply-templates>
			</dl>
		</div>
	</xsl:template>

	<xsl:template match="skos:prefLabel|skos:definition|owl:sameAs|rdf:type">
		<dt>
			<xsl:value-of select="name()"/>
		</dt>
		<dd>
			<xsl:choose>
				<xsl:when test="string(.)">
					<span property="{name()}" xml:lang="{@xml:lang}">
						<xsl:value-of select="."/>
					</span>
					<span class="lang">
						<xsl:value-of select="concat(' (', @xml:lang, ')')"/>
					</span>
				</xsl:when>
				<xsl:when test="string(@rdf:resource)">
					<span>
						<a href="{@rdf:resource}" rel="{name()}" title="{@rdf:resource}">
							<xsl:value-of select="@rdf:resource"/>
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
