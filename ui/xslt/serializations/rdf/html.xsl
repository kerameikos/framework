<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:foaf="http://xmlns.com/foaf/0.1/" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
	xmlns:dbpedia-owl="http://dbpedia.org/ontology/" xmlns:skos="http://www.w3.org/2004/02/skos/core#" xmlns:owl="http://www.w3.org/2002/07/owl#"
	xmlns:ecrm="http://erlangen-crm.org/current/" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:dcterms="http://purl.org/dc/terms/" xmlns:kid="http://kerameikos.org/id/"
	xmlns:kon="http://kerameikos.org/ontology#" xmlns:geo="http://www.w3.org/2003/01/geo/wgs84_pos#" xmlns:tei="http://www.tei-c.org/ns/1.0"
	xmlns:kerameikos="http://kerameikos.org/" exclude-result-prefixes="#all" version="2.0">
	<xsl:include href="../../templates.xsl"/>
	<xsl:include href="../../functions.xsl"/>
	<xsl:include href="html-templates.xsl"/>

	<!-- URL parameters for generating charts -->
	<xsl:param name="category" select="doc('input:request')/request/parameters/parameter[name='category']/value"/>

	<!-- config and global variables -->
	<xsl:variable name="display_path">../</xsl:variable>
	<xsl:variable name="id" select="substring-after(/content/rdf:RDF/*[1]/@rdf:about, 'id/')"/>
	<xsl:variable name="html-uri" select="concat(/content/config/url, 'id/', $id, '.html')"/>
	<xsl:variable name="type" select="/content/rdf:RDF/*[1]/name()"/>
	<xsl:variable name="title" select="/content/rdf:RDF/*[1]/skos:prefLabel[@xml:lang='en']"/>

	<!-- definition of namespaces for turning in solr type field URIs into abbreviations -->
	<xsl:variable name="namespaces" as="item()*">
		<namespaces>
			<xsl:for-each select="//rdf:RDF/namespace::*[not(name()='xml')]">
				<namespace prefix="{name()}" uri="{.}"/>
			</xsl:for-each>
		</namespaces>
	</xsl:variable>

	<xsl:variable name="prefix">
		<xsl:for-each select="$namespaces/namespace">
			<xsl:value-of select="concat(@prefix, ':', @uri)"/>
			<xsl:if test="not(position()=last())">
				<xsl:text> </xsl:text>
			</xsl:if>
		</xsl:for-each>
	</xsl:variable>

	<xsl:template match="/">
		<html lang="en" prefix="{$prefix}">
			<head>
				<title id="{$id}">Kerameikos.org: <xsl:value-of select="//@rdf:about"/></title>
				<meta name="viewport" content="width=device-width, initial-scale=1"/>
				<script type="text/javascript" src="http://code.jquery.com/jquery-latest.min.js"/>
				<!-- bootstrap -->
				<link rel="stylesheet" href="http://netdna.bootstrapcdn.com/bootstrap/3.1.1/css/bootstrap.min.css"/>
				<script src="http://netdna.bootstrapcdn.com/bootstrap/3.1.1/js/bootstrap.min.js"/>
				<!-- fancybox -->
				<script type="text/javascript" src="{$display_path}ui/javascript/jquery.fancybox.pack.js"/>
				<link type="text/css" href="{$display_path}ui/css/jquery.fancybox.css" rel="stylesheet"/>
				<script type="text/javascript" src="{$display_path}ui/javascript/display_functions.js"/>
				<!-- mapping js -->
				<script type="text/javascript" src="http://www.openlayers.org/api/OpenLayers.js"/>
				<script type="text/javascript" src="http://maps.google.com/maps/api/js?v=3.2&amp;sensor=false"/>
				<script type="text/javascript" src="{$display_path}ui/javascript/timeline-2.3.0.js"/>
				<script type="text/javascript" src="{$display_path}ui/javascript/mxn.js"/>
				<script type="text/javascript" src="{$display_path}ui/javascript/timemap_full.pack.js"/>
				<script type="text/javascript" src="{$display_path}ui/javascript/display_map_functions.js"/>
				<script type="text/javascript" src="{$display_path}ui/javascript/param.js"/>
				<!-- timeline css -->
				<link type="text/css" href="{$display_path}ui/css/timeline-2.3.0.css" rel="stylesheet"/>
				<!-- highcharts -->
				<script type="text/javascript" src="{$display_path}ui/javascript/highcharts.js"/>
				<script type="text/javascript" src="{$display_path}ui/javascript/modules/data.js"/>
				<script type="text/javascript" src="{$display_path}ui/javascript/modules/exporting.js"/>
				<link rel="stylesheet" href="{$display_path}ui/css/style.css"/>
			</head>
			<body>
				<xsl:call-template name="header"/>
				<xsl:call-template name="body"/>
				<xsl:call-template name="footer"/>
			</body>
		</html>
	</xsl:template>

	<xsl:template name="body">
		<div class="container-fluid content">
			<div class="row">
				<div class="col-md-9">
					<xsl:apply-templates select="/content/rdf:RDF/*" mode="type"/>

					<div id="timemap">
						<div id="mapcontainer">
							<div id="map"/>
						</div>
						<div id="timelinecontainer">
							<div id="timeline"/>
						</div>
					</div>
					<xsl:call-template name="associatedObjects">
						<xsl:with-param name="id" select="$id"/>
						<xsl:with-param name="type" select="$type"/>
					</xsl:call-template>
					<xsl:call-template name="quant"/>
				</div>
				<div class="col-md-3">
					<div>
						<h3>Data Export</h3>
						<ul>
							<li>
								<a href="{$id}.rdf">RDF/XML</a>
							</li>
							<li>
								<a href="{$id}.ttl">TTL</a>
							</li>
							<li>
								<a href="{$id}.jsonld">JSON-LD</a>
							</li>
							<xsl:if test="/content/rdf:RDF/geo:SpatialThing">
								<li>
									<a href="{$id}.kml">KML</a>
								</li>
							</xsl:if>
						</ul>
					</div>
					<!--<xsl:if test="descendant::skos:exactMatch[contains(@rdf:resource, 'dbpedia.org')]">
						<xsl:call-template name="dbpedia-abstract">
							<xsl:with-param name="uri" select="descendant::skos:exactMatch[contains(@rdf:resource, 'dbpedia.org')]/@rdf:resource"/>
						</xsl:call-template>
					</xsl:if>-->
					<xsl:if test="descendant::skos:exactMatch[contains(@rdf:resource, 'lgpn.ox.ac.uk')]">
						<xsl:call-template name="lgpn-bio">
							<xsl:with-param name="uri" select="descendant::skos:exactMatch[contains(@rdf:resource, 'lgpn.ox.ac.uk')]/@rdf:resource"/>
						</xsl:call-template>
					</xsl:if>
				</div>
			</div>
		</div>
	</xsl:template>

	<xsl:template match="*" mode="type">
		<div typeof="{name()}" about="{@rdf:about}">
			<xsl:if test="contains(@rdf:resource, '#this')">
				<a name="#this"/>
			</xsl:if>
			<xsl:element name="{if(position()=1) then 'h2' else 'h3'}">
				<a href="{@rdf:about}">
					<xsl:choose>
						<xsl:when test="contains(@rdf:about, '#')">
							<xsl:value-of select="concat('#', substring-after(@rdf:about, '#'))"/>
						</xsl:when>
						<xsl:when test="contains(@rdf:about, 'geonames.org')">
							<xsl:value-of select="@rdf:about"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="$id"/>
						</xsl:otherwise>
					</xsl:choose>
				</a>
				<small>
					<xsl:text> (</xsl:text>
					<a href="{concat(namespace-uri(.), local-name())}">
						<xsl:value-of select="name()"/>
					</a>
					<xsl:text>)</xsl:text>
				</small>
			</xsl:element>
			<dl class="dl-horizontal">
				<xsl:if test="skos:prefLabel">
					<dt>
						<a href="{concat($namespaces//namespace[@prefix='skos']/@uri, 'prefLabel')}">skos:prefLabel</a>
					</dt>
					<dd>
						<xsl:apply-templates select="skos:prefLabel" mode="prefLabel">
							<xsl:sort select="@xml:lang"/>
						</xsl:apply-templates>
					</dd>
				</xsl:if>
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

	<xsl:template match="skos:prefLabel" mode="prefLabel">
		<span property="{name()}" xml:lang="{@xml:lang}">
			<xsl:value-of select="."/>
		</span>
		<xsl:if test="string(@xml:lang)">
			<span class="lang">
				<xsl:value-of select="concat(' (', @xml:lang, ')')"/>
			</span>
		</xsl:if>
		<xsl:if test="not(position()=last())">
			<xsl:text>, </xsl:text>
		</xsl:if>
	</xsl:template>

	<xsl:template match="*" mode="list-item">
		<xsl:variable name="name" select="name()"/>
		<dt>
			<a href="{concat($namespaces//namespace[@prefix=substring-before($name, ':')]/@uri, substring-after($name, ':'))}">
				<xsl:value-of select="name()"/>
			</a>
		</dt>
		<dd>
			<xsl:choose>
				<xsl:when test="string(.)">
					<xsl:choose>
						<xsl:when test="name()= 'osgeo:asGeoJSON' and string-length(.) &gt; 100">
							<div id="geoJSON-fragment">
								<xsl:value-of select="substring(., 1, 100)"/>
								<xsl:text>...</xsl:text>
								<a href="#" class="toggle-geoJSON">[more]</a>
							</div>
							<div id="geoJSON-full" style="display:none">
								<span property="{name()}" xml:lang="{@xml:lang}">
									<xsl:value-of select="."/>
								</span>
								<a href="#" class="toggle-geoJSON">[less]</a>
							</div>
						</xsl:when>
						<xsl:otherwise>
							<span property="{name()}" xml:lang="{@xml:lang}">
								<xsl:value-of select="."/>
							</span>
							<xsl:if test="string(@xml:lang)">
								<span class="lang">
									<xsl:value-of select="concat(' (', @xml:lang, ')')"/>
								</span>
							</xsl:if>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				<xsl:when test="string(@rdf:resource)">
					<span>
						<a href="{@rdf:resource}" rel="{name()}" title="{@rdf:resource}">
							<xsl:choose>
								<xsl:when test="name()='rdf:type'">
									<xsl:variable name="uri" select="@rdf:resource"/>
									<xsl:value-of
										select="replace($uri, $namespaces//namespace[contains($uri, @uri)]/@uri, concat($namespaces//namespace[contains($uri, @uri)]/@prefix, ':'))"
									/>
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
		<div>
			<h3>Abstract (dbpedia)</h3>
			<xsl:value-of select="$dbpedia-rdf//dbpedia-owl:abstract[@xml:lang='en']"/>
		</div>
	</xsl:template>

	<xsl:template name="lgpn-bio">
		<xsl:param name="uri"/>

		<xsl:variable name="lgpn-tei" as="element()*">
			<xsl:copy-of select="document(concat('http://clas-lgpn2.classics.ox.ac.uk/cgi-bin/lgpn_search.cgi?id=', substring-after($uri, 'id/'), ';style=xml'))/*"/>
		</xsl:variable>

		<xsl:if test="$lgpn-tei/descendant::tei:birth">
			<div>
				<h3>Biographical (LGPN)</h3>
				<xsl:apply-templates select="$lgpn-tei/descendant::tei:birth" mode="lgpn"/>
			</div>
		</xsl:if>

	</xsl:template>

	<xsl:template match="tei:birth" mode="lgpn">
		<b>Birth: </b>
		<xsl:for-each select="@when|@notBefore|@notAfter|@from|@to">
			<xsl:value-of select="name()"/>
			<xsl:text>: </xsl:text>
			<xsl:value-of select="kerameikos:normalizeYear(.)"/>
			<xsl:if test="not(position()=last())">
				<xsl:text>, </xsl:text>
			</xsl:if>
		</xsl:for-each>
		<xsl:apply-templates select="tei:placeName" mode="lgpn"/>
	</xsl:template>

	<xsl:template match="tei:placeName" mode="lgpn">
		<xsl:text> (</xsl:text>
		<xsl:choose>
			<xsl:when test="contains(@ref, 'pleiades')">
				<a href="http://pleiades.stoa.org/places/{substring-after(@ref, ':')}">
					<xsl:value-of select="."/>
				</a>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="."/>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:text>)</xsl:text>
	</xsl:template>

	<xsl:function name="kerameikos:normalize_date">
		<xsl:param name="date"/>

		<xsl:choose>
			<xsl:when test="number($date) &lt; 0">
				<xsl:value-of select="abs(number($date)) + 1"/>
				<xsl:text> B.C.</xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>A.D. </xsl:text>
				<xsl:value-of select="number($date)"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:function>
</xsl:stylesheet>
