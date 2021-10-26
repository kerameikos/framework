<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:foaf="http://xmlns.com/foaf/0.1/" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
	xmlns:dbpedia-owl="http://dbpedia.org/ontology/" xmlns:skos="http://www.w3.org/2004/02/skos/core#" xmlns:crm="http://www.cidoc-crm.org/cidoc-crm/"
	xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:dcterms="http://purl.org/dc/terms/" xmlns:kid="http://kerameikos.org/id/"
	xmlns:org="http://www.w3.org/ns/org#" xmlns:edm="http://www.europeana.eu/schemas/edm/" xmlns:kon="http://kerameikos.org/ontology#"
	xmlns:geo="http://www.w3.org/2003/01/geo/wgs84_pos#" xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:res="http://www.w3.org/2005/sparql-results#"
	xmlns:kerameikos="http://kerameikos.org/" xmlns:prov="http://www.w3.org/ns/prov#" exclude-result-prefixes="#all" version="2.0">
	<xsl:include href="../../templates.xsl"/>
	<xsl:include href="../../functions.xsl"/>
	<xsl:include href="../../vis-templates.xsl"/>
	<xsl:include href="html-templates.xsl"/>
	
	<!-- request parameters -->
	<xsl:param name="langParam" select="doc('input:request')/request/parameters/parameter[name = 'lang']/value"/>
	<xsl:param name="lang">
		<xsl:choose>
			<xsl:when test="string($langParam)">
				<xsl:value-of select="$langParam"/>
			</xsl:when>
			<xsl:when test="string(doc('input:request')/request//header[name[. = 'accept-language']]/value)">
				<xsl:value-of select="kerameikos:parseAcceptLanguage(doc('input:request')/request//header[name[. = 'accept-language']]/value)[1]"/>
			</xsl:when>
		</xsl:choose>
	</xsl:param>

	<!-- config and global variables -->
	<xsl:variable name="display_path">../</xsl:variable>
	<xsl:variable name="mode">record</xsl:variable>
	<xsl:variable name="base-query">
		<xsl:choose>
			<xsl:when test="$type = 'crm:E40_Legal_Body'">
				<xsl:value-of select="concat('keeper kid:', $id)"/>
			</xsl:when>
			<xsl:when test="$type = 'foaf:Person' or $type = 'foaf:Group'">
				<xsl:value-of select="concat('artist kid:', $id)"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of
					select="concat(concat(lower-case(substring(substring-after($type, ':'), 1, 1)), substring(substring-after($type, ':'), 2)), ' kid:', $id)"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="type" select="/content/rdf:RDF/*[1]/name()"/>
	<xsl:variable name="conceptURI" select="/content/rdf:RDF/*[1]/@rdf:about"/>
	<xsl:variable name="id"
		select="
			if ($type = 'skos:ConceptScheme') then
				tokenize($conceptURI, '/')[last() - 1]
			else
				tokenize($conceptURI, '/')[last()]"/>

	<xsl:variable name="scheme" select="
			if ($type = 'skos:ConceptScheme') then
				''
			else
				tokenize($conceptURI, '/')[last() - 1]"/>

	<xsl:variable name="title" select="/content/rdf:RDF/*[1]/skos:prefLabel[@xml:lang = 'en']"/>

	<!-- definition of namespaces for turning in solr type field URIs into abbreviations -->
	<xsl:variable name="namespaces" as="item()*">
		<namespaces>
			<xsl:for-each select="//rdf:RDF/namespace::*[not(name() = 'xml')]">
				<namespace prefix="{name()}" uri="{.}"/>
			</xsl:for-each>
		</namespaces>
	</xsl:variable>

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
				<label>Group</label>
				<type>foaf:Group</type>
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

	<xsl:variable name="prefix">
		<xsl:for-each select="$namespaces/namespace">
			<xsl:value-of select="concat(@prefix, ':', @uri)"/>
			<xsl:if test="not(position() = last())">
				<xsl:text> </xsl:text>
			</xsl:if>
		</xsl:for-each>
	</xsl:variable>

	<xsl:template match="/">
		<html lang="en" prefix="{$prefix}">
			<head>
				<title id="{$id}">Kerameikos.org: <xsl:value-of
						select="
							if (//skos:prefLabel[@xml:lang = 'en']) then
								//skos:prefLabel[@xml:lang = 'en']
							else
								$id"
					/></title>
				<meta name="viewport" content="width=device-width, initial-scale=1"/>
				<link rel="icon" type="image/png" href="{$display_path}ui/images/favicon.png"/>
				<script type="text/javascript" src="http://code.jquery.com/jquery-latest.min.js"/>
				<!-- bootstrap -->
				<link rel="stylesheet" href="http://netdna.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap.min.css"/>
				<script src="http://netdna.bootstrapcdn.com/bootstrap/3.3.6/js/bootstrap.min.js"/>
				<!-- fancybox -->
				<script type="text/javascript" src="{$display_path}ui/javascript/jquery.fancybox.pack.js"/>
				<link type="text/css" href="{$display_path}ui/css/jquery.fancybox.css" rel="stylesheet"/>

				<link rel="stylesheet" href="http://cdn.leafletjs.com/leaflet/v1.0.3/leaflet.css"/>
				<script src="http://cdn.leafletjs.com/leaflet/v1.0.3/leaflet.js"/>
				<script type="text/javascript" src="{$display_path}ui/javascript/leaflet.ajax.min.js"/>

				<!-- mapping -->
				<!--<script type="text/javascript" src="{$display_path}ui/javascript/heatmap.min.js"/>
					<script type="text/javascript" src="{$display_path}ui/javascript/leaflet-heatmap.js"/>-->
				<script type="text/javascript" src="{$display_path}ui/javascript/display_map_functions.js"/>

				<!-- distribution visualization -->
				<script type="text/javascript" src="{$display_path}ui/javascript/d3.min.js"/>
				<script type="text/javascript" src="{$display_path}ui/javascript/d3plus.min.js"/>
				<script type="text/javascript" src="{$display_path}ui/javascript/vis_functions.js"/>
				<script type="text/javascript" src="{$display_path}ui/javascript/leaflet-iiif.js"/>
				<!--<script type="text/javascript" src="{$display_path}ui/javascript/image_functions.js"/>-->

				<!-- 3D hop -->
				<!--STYLESHEET-->
				<link type="text/css" rel="stylesheet" href="{$display_path}ui/css/3dhop.css"/>
				<!--SPIDERGL-->
				<script type="text/javascript" src="{$display_path}ui/javascript/spidergl.js"/>
				<!--PRESENTER-->
				<script type="text/javascript" src="{$display_path}ui/javascript/presenter.js"/>
				<!--3D MODELS LOADING AND RENDERING-->
				<script type="text/javascript" src="{$display_path}ui/javascript/nexus.js"/>
				<script type="text/javascript" src="{$display_path}ui/javascript/ply.js"/>
				<!--TRACKBALLS-->
				<script type="text/javascript" src="{$display_path}ui/javascript/trackball_sphere.js"/>
				<script type="text/javascript" src="{$display_path}ui/javascript/trackball_turntable.js"/>
				<script type="text/javascript" src="{$display_path}ui/javascript/trackball_turntable_pan.js"/>
				<script type="text/javascript" src="{$display_path}ui/javascript/trackball_pantilt.js"/>
				<!--UTILITY-->
				<script type="text/javascript" src="{$display_path}ui/javascript/init.js"/>
				<script type="text/javascript" src="{$display_path}ui/javascript/display_functions.js"/>
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
			<xsl:choose>
				<xsl:when test="$scheme = 'id'">
					<!-- variables to determine whether the map should show when or whether the quantitative analysis functions should be included -->
					<xsl:variable name="hasGeo" as="xs:boolean"
						select="
							if (doc('input:hasProductionPlaces')//res:boolean = true() or doc('input:hasFindspots')//res:boolean = true()) then
								true()
							else
								false()"/>

					<xsl:variable name="hasObjects" as="xs:boolean"
						select="
							if (doc('input:hasObjects')//res:boolean = true()) then
								true()
							else
								false()"/>


					<!-- param passed in from record page -->
					<xsl:if test="$hasObjects = true() and position() = 1">
						<div class="subsection">
							<a href="#listObjects">Objects of this Typology</a>
							<xsl:text> | </xsl:text>
							<a href="#quant">Quantitative Analysis</a>
						</div>
					</xsl:if>

					<xsl:call-template name="rdf-display-structure"/>

					<xsl:if test="$hasGeo = true()">
						<div class="row">
							<div class="col-md-12 page-section">
								<div id="mapcontainer" class="map-normal">
									<div id="info"/>
								</div>
								<div style="margin:10px 0">
									<table>
										<tbody>
											<tr>
												<td style="background-color:#6992fd;border:2px solid black;width:50px;"/>
												<td style="width:100px;padding-left:6px;">
													<xsl:value-of select="kerameikos:normalizeCurie('kon:ProductionPlace', $lang)"/>
												</td>
												<td style="background-color:#d86458;border:2px solid black;width:50px;"/>
												<td style="width:100px;padding-left:6px;">
													<xsl:value-of select="kerameikos:normalizeField('findspot', $lang)"/>
												</td>
											</tr>
										</tbody>
									</table>
								</div>
							</div>
						</div>

					</xsl:if>
					<xsl:if test="$hasObjects = true()">
						<div id="iiif-window" style="width:800px;height:600px;display:none"/>

						<div class="row">
							<div class="col-md-12 page-section">
								<h2>
									<xsl:text>Objects of this Typology</xsl:text>
									<small>
										<a href="#" class="toggle-button" id="toggle-listObjects" title="Click to hide or show the analysis form">
											<span class="glyphicon glyphicon-triangle-bottom"/>
										</a>
									</small>
								</h2>
								<p>These objects are associated by artist signature or scholarly attribution by analyzing artistic similarities. Only those with
									images are shown below, but all objects related to this concept are queried for other visualizations and data downloads.</p>
								<div id="listObjects"/>
							</div>
						</div>

						<div class="row">
							<div class="col-md-12 page-section">
								<h2>
									<xsl:text>Quantitative Analysis</xsl:text>
									<small>
										<a href="#" class="toggle-button" id="toggle-quant" title="Click to hide or show the analysis form">
											<span class="glyphicon glyphicon-triangle-bottom"/>
										</a>
									</small>
								</h2>
								<xsl:call-template name="distribution-form">
									<xsl:with-param name="mode" select="$mode"/>
								</xsl:call-template>
							</div>
						</div>
					</xsl:if>
				</xsl:when>
				<xsl:when test="$scheme = 'editor'">

					<xsl:call-template name="rdf-display-structure"/>

					<xsl:if test="doc('input:id-count')//res:binding[@name = 'count']/res:literal &gt; 0">
						<xsl:variable name="count" select="doc('input:id-count')//res:binding[@name = 'count']/res:literal"/>
						<div class="row">
							<div class="col-md-12 page-section">
								<h2>Kerameikos Contributions</h2>
								<xsl:apply-templates select="doc('input:spreadsheet-list')/rdf:RDF[count(prov:Entity) &gt; 0]" mode="spreadsheets"/>
								<xsl:apply-templates select="doc('input:id-list')/res:sparql" mode="edited-ids">
									<xsl:with-param name="count" select="$count"/>
								</xsl:apply-templates>
							</div>
						</div>
					</xsl:if>
				</xsl:when>
				<xsl:otherwise>

					<xsl:call-template name="rdf-display-structure"/>

					<!-- context for ConceptSchemes -->
					<xsl:choose>
						<xsl:when test="$id = 'editor'">
							<xsl:apply-templates select="doc('input:editors')/res:sparql[count(descendant::res:result) &gt; 0]" mode="editors"/>
						</xsl:when>
					</xsl:choose>
				</xsl:otherwise>
			</xsl:choose>

			<div class="hidden">
				<span id="mapboxKey">
					<xsl:value-of select="/content/config/mapboxKey"/>
				</span>
				<span id="type">
					<xsl:value-of select="$type"/>
				</span>
				<span id="id">
					<xsl:value-of select="$id"/>
				</span>
				<span id="page">
					<xsl:value-of select="$mode"/>
				</span>
				<span id="base-query">
					<xsl:value-of select="$base-query"/>
				</span>
				<span id="manifest"/>
				<div class="iiif-container-template" style="width:100%;height:100%"/>
				<xsl:call-template name="field-template">
					<xsl:with-param name="template" as="xs:boolean">true</xsl:with-param>
				</xsl:call-template>

				<xsl:call-template name="compare-container-template">
					<xsl:with-param name="template" as="xs:boolean">true</xsl:with-param>
				</xsl:call-template>

				<xsl:call-template name="date-template">
					<xsl:with-param name="template" as="xs:boolean">true</xsl:with-param>
				</xsl:call-template>

				<xsl:call-template name="ajax-loader-template"/>

				<div id="sketchfab-window" style="width:640px;height:480px;display:none"/>
				<iframe id="model-iframe-template" width="640" height="480" frameborder="0" allowvr="true" allowfullscreen="true" mozallowfullscreen="true"
					webkitallowfullscreen="true" onmousewheel=""/>

				<div id="3dhop-window" style="display:none;width:650px;height:490px;">
					<div id="3dhop-template" class="tdhop" onmousedown="if (event.preventDefault) event.preventDefault()">
						<div id="toolbar">
							<img id="home" title="Home" src="{$display_path}ui/images/skins/dark/home.png"/>
							<br/>
							<img id="zoomin" title="Zoom In" src="{$display_path}ui/images/skins/dark/zoomin.png"/>
							<br/>
							<img id="zoomout" title="Zoom Out" src="{$display_path}ui/images/skins/dark/zoomout.png"/>
							<br/>
							<img id="light_on" title="Disable Light Control" src="{$display_path}ui/images/skins/dark/light_on.png"
								style="position:absolute; visibility:hidden;"/>
							<img id="light" title="Enable Light Control" src="{$display_path}ui/images/skins/dark/light.png"/>
							<br/>
							<img id="full_on" title="Exit Full Screen" src="{$display_path}ui/images/skins/dark/full_on.png"
								style="position:absolute; visibility:hidden;"/>
							<img id="full" title="Full Screen" src="{$display_path}ui/images/skins/dark/full.png"/>
						</div>
						<canvas id="draw-canvas" style="background-image: url({$display_path}ui/images/skins/backgrounds/dark.jpg)"/>
					</div>
				</div>
			</div>
		</div>
	</xsl:template>

	<xsl:template name="rdf-display-structure">

		<div class="row">
			<div class="col-md-12">
				<xsl:apply-templates select="/content/rdf:RDF/*[1]" mode="human-readable">
					<xsl:with-param name="mode">record</xsl:with-param>
				</xsl:apply-templates>

				<!-- ProvenanceStatement is hidden by default -->
				<xsl:if test="/content/rdf:RDF/dcterms:ProvenanceStatement">
					<h3>
						<xsl:text>Data Provenance</xsl:text>
						<small>
							<a href="#" class="toggle-button" id="toggle-provenance" title="Click to hide or show the provenance">
								<span class="glyphicon glyphicon-triangle-right"/>
							</a>
						</small>
					</h3>
					<div style="display:none" id="provenance">
						<xsl:apply-templates select="/content/rdf:RDF/*[name() = 'dcterms:ProvenanceStatement']" mode="type">
							<xsl:with-param name="hasObjects" select="false()" as="xs:boolean"/>
							<xsl:with-param name="mode">record</xsl:with-param>
						</xsl:apply-templates>
					</div>
				</xsl:if>
				<hr/>
			</div>
		</div>

		<xsl:if test="string($scheme)">
			<xsl:call-template name="data-export"/>
		</xsl:if>
	</xsl:template>

	<!-- Related ID and spreadsheet templates for enhancing context of /editor pages -->
	<xsl:template match="rdf:RDF" mode="spreadsheets">

		<!-- load SPARQL as text -->
		<xsl:variable name="query" select="doc('input:getSpreadsheets-query')"/>

		<h3>Spreadsheets</h3>
		<p>This editor has contributed Kerameikos IDs through the following spreadsheets (<a
				href="{$display_path}query?query={encode-for-uri(replace($query, '%URI%', $conceptURI))}&amp;output=json" title="Download list">
				<span class="glyphicon glyphicon-download"/> Download list</a>):</p>
		<table class="table table-striped">
			<thead>
				<tr>
					<th>Description</th>
					<th>Date</th>
				</tr>
			</thead>
			<tbody>
				<xsl:for-each select="prov:Entity">
					<xsl:sort select="prov:atTime[1]" order="descending"/>
					<tr>
						<td>
							<a href="{@rdf:about}">
								<xsl:value-of select="dcterms:description"/>
							</a>
						</td>
						<td>
							<xsl:value-of select="format-dateTime(prov:atTime[1], '[D] [MNn] [Y0001]')"/>
						</td>
					</tr>
				</xsl:for-each>
			</tbody>
		</table>
	</xsl:template>

	<xsl:template match="res:sparql" mode="edited-ids">
		<xsl:param name="count"/>

		<!-- load SPARQL as text -->
		<xsl:variable name="query" select="doc('input:getEditedIds-query')"/>

		<xsl:variable name="describe" select="replace(replace(replace($query, '%URI%', $conceptURI), ' %LIMIT%', ''), 'SELECT', 'DESCRIBE')"/>

		<h3>Concepts</h3>
		<xsl:choose>
			<xsl:when test="$count &gt; 25">
				<p>This is a partial list of <strong>25</strong> of <strong><xsl:value-of select="$count"/></strong> IDs created or updated by this editor (<a
						href="{$display_path}query?query={encode-for-uri(replace(replace($query, '%URI%', $conceptURI), ' %LIMIT%', ''))}&amp;output=csv"
						title="Download list">
						<span class="glyphicon glyphicon-download"/> Download list</a>):</p>
			</xsl:when>
			<xsl:otherwise>
				<p>This is a list of <strong><xsl:value-of select="$count"/></strong> IDs created or updated by this editor:</p>
			</xsl:otherwise>
		</xsl:choose>

		<p>
			<strong>Download as: </strong>
			<a href="{$display_path}query?query={encode-for-uri($describe)}&amp;output=xml" title="RDF/XML">RDF/XML</a>
			<xsl:text> | </xsl:text>
			<a href="{$display_path}query?query={encode-for-uri($describe)}&amp;output=text" title="Turtle">Turtle</a>
			<xsl:text> | </xsl:text>
			<a href="{$display_path}query?query={encode-for-uri($describe)}&amp;output=json" title="JSON-LD">JSON-LD</a>
		</p>

		<table class="table table-striped">
			<thead>
				<tr>
					<th>Label</th>
					<th>Spreadsheet</th>
					<th>Date</th>
				</tr>
			</thead>
			<tbody>
				<xsl:for-each select="descendant::res:result">
					<tr>
						<td>
							<a href="{res:binding[@name='concept']/res:uri}">
								<xsl:value-of select="res:binding[@name = 'label']/res:literal"/>
							</a>
						</td>
						<td>
							<xsl:if test="res:binding[@name = 'spreadsheet']">
								<a href="{res:binding[@name='spreadsheet']/res:uri}">
									<xsl:value-of select="res:binding[@name = 'desc']/res:literal"/>
								</a>
							</xsl:if>
						</td>
						<td>
							<xsl:value-of select="format-dateTime(res:binding[@name = 'date']/res:literal, '[D] [MNn] [Y0001]')"/>
						</td>
					</tr>
				</xsl:for-each>
			</tbody>
		</table>
	</xsl:template>

	<xsl:template match="res:sparql" mode="editors">
		<div class="row">
			<div class="col-md-12 page-section">
				<h2>Editors</h2>
				<table class="table table-striped">
					<thead>
						<tr>
							<th>Name</th>
							<th>Affiliation</th>
							<th>ORCID</th>
						</tr>
					</thead>
					<tbody>
						<xsl:for-each select="descendant::res:result">
							<tr>
								<td>
									<a href="{res:binding[@name='editor']/res:uri}">
										<xsl:value-of select="res:binding[@name = 'name']/res:literal"/>
									</a>
								</td>
								<td>
									<a href="{res:binding[@name='wikidata']/res:uri}">
										<xsl:value-of select="res:binding[@name = 'org']/res:literal"/>
									</a>
								</td>
								<td>
									<xsl:if test="res:binding[@name = 'orcid']">
										<a href="{res:binding[@name='orcid']/res:uri}">
											<xsl:value-of select="tokenize(res:binding[@name = 'orcid']/res:uri, '/')[last()]"/>
										</a>
									</xsl:if>
								</td>
							</tr>
						</xsl:for-each>
					</tbody>
				</table>
			</div>
		</div>
	</xsl:template>

	<xsl:template name="lgpn-bio">
		<xsl:param name="uri"/>

		<xsl:variable name="lgpn-tei" as="element()*">
			<xsl:copy-of
				select="document(concat('http://clas-lgpn2.classics.ox.ac.uk/cgi-bin/lgpn_search.cgi?id=', substring-after($uri, 'id/'), ';style=xml'))/*"/>
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
		<xsl:for-each select="@when | @notBefore | @notAfter | @from | @to">
			<xsl:value-of select="name()"/>
			<xsl:text>: </xsl:text>
			<xsl:value-of select="kerameikos:normalizeYear(.)"/>
			<xsl:if test="not(position() = last())">
				<xsl:text>, </xsl:text>
			</xsl:if>
		</xsl:for-each>
		<xsl:apply-templates select="tei:placeName" mode="lgpn"/>
	</xsl:template>

	<xsl:template match="tei:placeName" mode="lgpn">
		<xsl:text> (</xsl:text>
		<xsl:choose>
			<xsl:when test="contains(@ref, 'pleiades')">
				<a href="https://pleiades.stoa.org/places/{substring-after(@ref, ':')}">
					<xsl:value-of select="."/>
				</a>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="."/>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:text>)</xsl:text>
	</xsl:template>

	<xsl:template name="data-export">
		<div class="row">
			<div class="col-md-12">
				<div>
					<ul class="list-inline">
						<li>
							<strong>Data Export: </strong>
						</li>
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

				<!-- insert a DataCite XML link for an editor with IDs -->
				<xsl:if test="$scheme = 'editor'">
					<xsl:if test="doc('input:id-count')//res:binding[@name = 'count']/res:literal &gt; 0">
						<div>
							<a href="{$id}.xml" title="DataCite XML Metadata">
								<img src="{$display_path}ui/images/datacite-medium.png" alt="DataCite Logo: https://datacite.org/"/>
							</a>
							<br/>
							<a href="{$id}.xml">DataCite XML Metadata</a>
						</div>
					</xsl:if>
				</xsl:if>
				<hr/>
			</div>
		</div>
	</xsl:template>
</xsl:stylesheet>
