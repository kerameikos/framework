<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:foaf="http://xmlns.com/foaf/0.1" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
	xmlns:skos="http://www.w3.org/2004/02/skos/core#" xmlns:owl="http://www.w3.org/2002/07/owl#" xmlns:crm="http://erlangen-crm.org/current/" xmlns:xs="http://www.w3.org/2001/XMLSchema"
	exclude-result-prefixes="xsl" version="2.0">

	<xsl:variable name="display_path">../</xsl:variable>

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
			crm: http://erlangen-crm.org/current/">
			<head>
				<title>Ceramic Project</title>
				<link rel="stylesheet" type="text/css" href="http://yui.yahooapis.com/3.8.0/build/cssgrids/grids-min.css"/>
				<link rel="stylesheet" href="{$display_path}ui/css/style.css"/>

				<script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.6.4/jquery.min.js"/>
				<!--<script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jqueryui/1.8.23/jquery-ui.min.js"/>-->
			</head>
			<body>
				<!--<xsl:call-template name="header"/>-->
				<xsl:call-template name="body"/>
				<!--<xsl:call-template name="footer"/>-->
			</body>
		</html>
	</xsl:template>

	<xsl:template name="body">
		<div class="yui3-g">
			<div class="yui3-u-1">
				<div class="content">
					<xsl:apply-templates select="rdf:RDF/*"/>
				</div>
			</div>
		</div>
	</xsl:template>

	<xsl:template match="rdf:RDF/*">
		<div typeof="{name()}" about="{@rdf:about}">
			<h1>
				<xsl:value-of select="@rdf:about"/>
				<xsl:text> (</xsl:text>
				<xsl:value-of select="name()"/>
				<xsl:text>)</xsl:text>
			</h1>
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
					<xsl:value-of select="concat(' (', @xml:lang, ')')"/>
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

</xsl:stylesheet>
