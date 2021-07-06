<?xml version="1.0" encoding="UTF-8"?>
<!-- Author: Ethan Gruber
	Date: May 2021
	Function: Serialize the RDF/XML from a SPARQL CONSTRUCT query for an object into HTML -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:foaf="http://xmlns.com/foaf/0.1/" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
	xmlns:dbpedia-owl="http://dbpedia.org/ontology/" xmlns:skos="http://www.w3.org/2004/02/skos/core#" xmlns:crm="http://www.cidoc-crm.org/cidoc-crm/"
	xmlns:crmsci="http://www.ics.forth.gr/isl/CRMsci/" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:dcterms="http://purl.org/dc/terms/"
	xmlns:kid="http://kerameikos.org/id/" xmlns:org="http://www.w3.org/ns/org#" xmlns:edm="http://www.europeana.eu/schemas/edm/"
	xmlns:kon="http://kerameikos.org/ontology#" xmlns:geo="http://www.w3.org/2003/01/geo/wgs84_pos#" xmlns:tei="http://www.tei-c.org/ns/1.0"
	xmlns:res="http://www.w3.org/2005/sparql-results#" xmlns:kerameikos="http://kerameikos.org/" xmlns:prov="http://www.w3.org/ns/prov#"
	xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#" exclude-result-prefixes="#all" version="2.0">
	<xsl:include href="../../templates.xsl"/>
	<xsl:include href="../../functions.xsl"/>
	<xsl:variable name="display_path">../</xsl:variable>

	<!-- request parameters -->
	<xsl:param name="uri" select="doc('input:request')/request/parameters/parameter[name = 'uri']/value"/>
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
	<xsl:param name="query" select="replace(doc('input:query'), '%URI%', $uri)"/>

	<!-- hasGeo variable evaluates whether there is a place in the production event or a mappable findspot -->
	<xsl:variable name="hasGeo" as="xs:boolean"
		select="
			(//crm:E12_Production[child::crm:P7_took_place_at] or //*[rdf:type/@rdf:resource = 'http://www.cidoc-crm.org/cidoc-crm/E12_Production'][child::crm:P7_took_place_at]) or
			//crmsci:O19i_was_object_found_by"/>

	<xsl:variable name="namespaces" as="node()*">
		<xsl:copy-of select="//config/namespaces"/>
	</xsl:variable>

	<xsl:template match="/">
		<html lang="en">
			<head>
				<title>Kerameikos.org: Object</title>
				<meta name="viewport" content="width=device-width, initial-scale=1"/>
				<link rel="icon" type="image/png" href="{$display_path}ui/images/favicon.png"/>
				<!-- bootstrap -->
				<script type="text/javascript" src="http://code.jquery.com/jquery-latest.min.js"/>
				<link rel="stylesheet" href="http://netdna.bootstrapcdn.com/bootstrap/3.3.5/css/bootstrap.min.css"/>
				<script src="http://netdna.bootstrapcdn.com/bootstrap/3.3.5/js/bootstrap.min.js"/>
				<link rel="stylesheet" href="{$display_path}ui/css/style.css"/>

				<!-- leaflet -->
				<link rel="stylesheet" href="http://cdn.leafletjs.com/leaflet/v1.0.3/leaflet.css"/>
				<script src="http://cdn.leafletjs.com/leaflet/v1.0.3/leaflet.js"/>
				<script type="text/javascript" src="{$display_path}ui/javascript/leaflet.ajax.min.js"/>

				<!-- mirador -->
				<xsl:if test="descendant::crm:P129i_is_subject_of">
					<script type="text/javascript" src="http://kerameikos.org/mirador/build/mirador/mirador.min.js"/>
				</xsl:if>

				<!-- leaflet IIIF -->
				<xsl:if
					test="
						//crm:E36_Visual_Item[dcterms:conformsTo/@rdf:resource = 'http://iiif.io/api/image']
						or //*[rdf:type/@rdf:resource = 'http://www.cidoc-crm.org/cidoc-crm/E36_Visual_Item'][dcterms:conformsTo/@rdf:resource = 'http://iiif.io/api/image']">
					<script type="text/javascript" src="{$display_path}ui/javascript/leaflet-iiif.js"/>
				</xsl:if>

				<script type="text/javascript" src="{$display_path}ui/javascript/object_functions.js"/>
				
				<!-- include metadata -->
				
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
				<div class="col-md-12">
					<xsl:apply-templates select="descendant::rdf:RDF"/>

					<!-- display links to download -->
					<ul class="list-inline text-right">
						<li>
							<strong>Download: </strong>
						</li>
						<li>
							<a href="../query?query={encode-for-uri($query)}&amp;output=xml">RDF/XML</a>
						</li>
						<li>
							<a href="../query?query={encode-for-uri($query)}&amp;output=text">Turtle</a>
						</li>
						<!--<li>
				<a href="../query?query={encode-for-uri($query)}&amp;output=json">JSON-LD</a>
			</li>-->
						<xsl:if test="$hasGeo = true()">
							<li>
								<a href="./geoJSON?uri={encode-for-uri($uri)}">GeoJSON</a>
							</li>				
						</xsl:if>
					</ul>

					<div class="hidden">
						<span id="mapboxKey">
							<xsl:value-of select="/content/config/mapboxKey"/>
						</span>

						<xsl:if test="descendant::crm:P129i_is_subject_of">
							<span id="collection">Collection</span>
							<span id="manifestURI">
								<xsl:value-of select="descendant::crm:P129i_is_subject_of/@rdf:resource"/>
							</span>
						</xsl:if>
						<xsl:if
							test="
								//crm:E36_Visual_Item[dcterms:conformsTo/@rdf:resource = 'http://iiif.io/api/image']
								or //*[rdf:type/@rdf:resource = 'http://www.cidoc-crm.org/cidoc-crm/E36_Visual_Item'][dcterms:conformsTo/@rdf:resource = 'http://iiif.io/api/image']">
							<span id="iiif-image">
								<xsl:value-of
									select="
										string-join(//crm:E36_Visual_Item[dcterms:conformsTo/@rdf:resource = 'http://iiif.io/api/image']/@rdf:about |
										//*[rdf:type/@rdf:resource = 'http://www.cidoc-crm.org/cidoc-crm/E36_Visual_Item'][dcterms:conformsTo/@rdf:resource = 'http://iiif.io/api/image']/@rdf:about, '|')"
								/>
							</span>
						</xsl:if>
					</div>
				</div>
			</div>
		</div>

	</xsl:template>

	<!-- SPARQL DESCRIBE/CONSTRUCT response -->
	<xsl:template match="rdf:RDF">
		<xsl:apply-templates select="crm:E22_Man-Made_Object | *[rdf:type/@rdf:resource = 'http://www.cidoc-crm.org/cidoc-crm/E22_Man-Made_Object']"/>
	</xsl:template>

	<!-- render the HMO into HTML -->
	<xsl:template match="crm:E22_Man-Made_Object | *[rdf:type/@rdf:resource = 'http://www.cidoc-crm.org/cidoc-crm/E22_Man-Made_Object']">
		<div>
			<xsl:if test="@rdf:about">
				<xsl:attribute name="about" select="@rdf:about"/>
				<xsl:attribute name="typeof" select="name()"/>
				<xsl:if test="contains(@rdf:about, '#this')">
					<xsl:attribute name="id">#this</xsl:attribute>
				</xsl:if>
			</xsl:if>

			<xsl:apply-templates select="crm:P1_is_identified_by" mode="title"/>

			<xsl:if test="@rdf:about">
				<p>
					<strong>Canonical URI: </strong>
					<code>
						<a href="{@rdf:about}" id="uri">
							<xsl:value-of select="@rdf:about"/>
						</a>
					</code>
				</p>
			</xsl:if>

			<xsl:if test="crm:P129i_is_subject_of">
				<p>
					<strong>Canonical IIIF Manifest: </strong>
					<code>
						<a href="{crm:P129i_is_subject_of/@rdf:resource}">
							<xsl:value-of select="crm:P129i_is_subject_of/@rdf:resource"/>
						</a>
					</code>
				</p>
			</xsl:if>

			<!-- images -->
			<xsl:choose>
				<!-- Mirador IIIF viewer is primary when there is a IIIF manifest URI -->
				<xsl:when test="descendant::crm:P129i_is_subject_of">
					<div class="row">
						<div class="col-md-12">
							<div style="width:100%;height:600px" id="mirador-div"/>
						</div>
					</div>
				</xsl:when>
				<xsl:when test="descendant::crm:P138i_has_representation">
					<!-- if there is at least one digital representation that conforms to IIIF, then display Leaflet -->
					<xsl:choose>
						<xsl:when
							test="
								//crm:E36_Visual_Item[dcterms:conformsTo/@rdf:resource = 'http://iiif.io/api/image']
								or //*[rdf:type/@rdf:resource = 'http://www.cidoc-crm.org/cidoc-crm/E36_Visual_Item'][dcterms:conformsTo/@rdf:resource = 'http://iiif.io/api/image']">
							<div id="iiif-container" style="width:100%;height:600px"/>
						</xsl:when>
						<xsl:when
							test="
								//crm:E36_Visual_Item[dcterms:format = 'image/jpeg']
								or //*[rdf:type/@rdf:resource = 'http://www.cidoc-crm.org/cidoc-crm/E36_Visual_Item'][dcterms:format = 'image/jpeg']">

							<xsl:variable name="images"
								select="
									//crm:E36_Visual_Item[dcterms:format = 'image/jpeg']/@rdf:about |
									//*[rdf:type/@rdf:resource = 'http://www.cidoc-crm.org/cidoc-crm/E36_Visual_Item'][dcterms:format = 'image/jpeg']/@rdf:about"/>

							<img src="{$images[1]}" alt="Primary Image"/>

						</xsl:when>
					</xsl:choose>


				</xsl:when>
			</xsl:choose>


			<!-- structure the metadata and map divs, if there are georeferenceable points -->
			<div class="row">
				<xsl:choose>
					<xsl:when test="$hasGeo = true()">
						<div class="col-md-6">
							<div class="content">
								<xsl:call-template name="metadata-container"/>
							</div>
						</div>
						<div class="col-md-6">
							<div class="content">
								<div id="mapcontainer" class="map-normal"/>
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
					</xsl:when>
					<xsl:otherwise>
						<div class="col-md-12">
							<div class="content">
								<xsl:call-template name="metadata-container"/>
							</div>
						</div>
					</xsl:otherwise>
				</xsl:choose>
			</div>
		</div>
	</xsl:template>

	<!-- metadata container -->
	<xsl:template name="metadata-container">
		<div>
			<h4>Typology</h4>

			<dl class="dl-horizontal">
				<xsl:apply-templates select="kon:hasShape"/>
				<xsl:apply-templates select="crm:P45_consists_of"/>
				<xsl:apply-templates select="crm:P108i_was_produced_by"/>
			</dl>
		</div>

		<xsl:if test="crm:P43_has_dimension">
			<div>
				<h4>Measurements</h4>

				<dl class="dl-horizontal">
					<xsl:apply-templates select="crm:P43_has_dimension"/>
				</dl>
			</div>
		</xsl:if>

		<div>
			<h4>Collection</h4>
			<dl class="dl-horizontal">
				<xsl:apply-templates select="crm:P50_has_current_keeper"/>
				<xsl:apply-templates select="crm:P1_is_identified_by" mode="id"/>
			</dl>
		</div>

		<xsl:if test="crmsci:O19i_was_object_found_by">
			<div>
				<h4>Provenance</h4>
				<dl class="dl-horizontal">
					<xsl:apply-templates select="crmsci:O19i_was_object_found_by"/>
				</dl>
			</div>
		</xsl:if>

	</xsl:template>

	<!-- parsing titles -->
	<xsl:template match="crm:P1_is_identified_by" mode="title">
		<xsl:choose>
			<xsl:when test="child::*">
				<xsl:if test="descendant::crm:P2_has_type/@rdf:resource = 'http://vocab.getty.edu/aat/300404670'">
					<h1>
						<xsl:value-of select="descendant::crm:P190_has_symbolic_content"/>
					</h1>
				</xsl:if>
			</xsl:when>
			<xsl:when test="@rdf:nodeID">
				<xsl:variable name="id" select="@rdf:nodeID"/>

				<xsl:apply-templates select="//*[@rdf:nodeID = $id][crm:P2_has_type/@rdf:resource = 'http://vocab.getty.edu/aat/300404670']" mode="title"/>
			</xsl:when>
			<xsl:when test="@rdf:resource">
				<xsl:variable name="id" select="@rdf:resource"/>

				<xsl:apply-templates select="//*[@rdf:about = $id][crm:P2_has_type/@rdf:resource = 'http://vocab.getty.edu/aat/300404670']" mode="title"/>
			</xsl:when>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="rdf:Description | crm:E33_E41_Linguistic_Appellation" mode="title">
		<h1>
			<xsl:value-of select="crm:P190_has_symbolic_content"/>
		</h1>
	</xsl:template>

	<!-- parsing identifier -->
	<xsl:template match="crm:P1_is_identified_by" mode="id">
		<xsl:choose>
			<xsl:when test="child::*">
				<xsl:if test="descendant::crm:P2_has_type/@rdf:resource = 'http://vocab.getty.edu/aat/300312355'">
					<dt>
						<xsl:value-of select="kerameikos:normalizeField('identifier', $lang)"/>
					</dt>
					<dd>
						<xsl:value-of select="crm:P190_has_symbolic_content"/>
					</dd>
				</xsl:if>
			</xsl:when>
			<xsl:when test="@rdf:nodeID">
				<xsl:variable name="id" select="@rdf:nodeID"/>

				<xsl:apply-templates select="//*[@rdf:nodeID = $id][crm:P2_has_type/@rdf:resource = 'http://vocab.getty.edu/aat/300312355']" mode="id"/>
			</xsl:when>
			<xsl:when test="@rdf:resource">
				<xsl:variable name="id" select="@rdf:resource"/>

				<xsl:apply-templates select="//*[@rdf:about = $id][crm:P2_has_type/@rdf:resource = 'http://vocab.getty.edu/aat/300312355']" mode="id"/>
			</xsl:when>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="rdf:Description | crm:E42_Identifier" mode="id">
		<dt>
			<xsl:value-of select="kerameikos:normalizeField('identifier', $lang)"/>
		</dt>
		<dd>
			<xsl:value-of select="crm:P190_has_symbolic_content"/>
		</dd>
	</xsl:template>

	<!-- parsing properties that point to a more complex node -->
	<xsl:template match="crm:P108i_was_produced_by | crm:P4_has_time-span | crm:P43_has_dimension | crmsci:O19i_was_object_found_by | crm:P89_falls_within | crm:P9_consists_of">
		<xsl:choose>
			<xsl:when test="child::*">
				<xsl:apply-templates select="child::*" mode="node"/>
			</xsl:when>
			<xsl:when test="@rdf:nodeID">
				<xsl:variable name="id" select="@rdf:nodeID"/>

				<xsl:apply-templates select="//*[@rdf:nodeID = $id]" mode="node"/>
			</xsl:when>
			<xsl:when test="@rdf:resource">
				<xsl:variable name="id" select="@rdf:resource"/>

				<xsl:apply-templates select="//*[@rdf:about = $id]" mode="node"/>
			</xsl:when>
		</xsl:choose>
	</xsl:template>

	<!-- evaluate nodes, which are likely blank, for Production, Find, Measurement, etc. -->
	<xsl:template match="*" mode="node">

		<xsl:choose>
			<xsl:when test="self::crm:E12_Production or rdf:type/@rdf:resource = 'http://www.cidoc-crm.org/cidoc-crm/E12_Production'">
				<xsl:apply-templates select="crm:P9_consists_of"/>
				<xsl:apply-templates select="crm:P14_carried_out_by"/>
				<xsl:apply-templates select="crm:P10_falls_within"/>
				<xsl:apply-templates select="crm:P7_took_place_at"/>
				<xsl:apply-templates select="crm:P32_used_general_technique"/>
				<xsl:apply-templates select="crm:P4_has_time-span"/>				
			</xsl:when>			
			<xsl:when test="self::crm:E52_Time-Span or rdf:type/@rdf:resource = 'http://www.cidoc-crm.org/cidoc-crm/E52_Time-Span'">
				<dt>
					<xsl:value-of select="kerameikos:normalizeCurie('crm:E52_Time-Span', $lang)"/>
				</dt>
				<dd>
					<xsl:value-of select="kerameikos:normalizeDate(crm:P82a_begin_of_the_begin)"/>
					<xsl:text> - </xsl:text>
					<xsl:value-of select="kerameikos:normalizeDate(crm:P82b_end_of_the_end)"/>
				</dd>
			</xsl:when>
			<xsl:when test="self::crmsci:S19_Encounter_Event or rdf:type/@rdf:resource = 'http://www.ics.forth.gr/isl/CRMsci/S19_Encounter_Event'">
				<xsl:apply-templates select="crm:P7_took_place_at" mode="findspot"/>
				<xsl:apply-templates select="crm:P4_has_time-span"/>
			</xsl:when>
			<xsl:when test="self::crm:E53_Place or rdf:type/@rdf:resource = 'http://www.cidoc-crm.org/cidoc-crm/E53_Place'">
				<xsl:variable name="parentURI" select="crm:P89_falls_within/@rdf:resource"/>

				<xsl:if test="rdfs:label">
					<xsl:choose>
						<xsl:when test="@rdf:about">
							<a href="{@rdf:about}" title="{rdfs:label}">
								<xsl:value-of select="rdfs:label"/>
							</a>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="rdfs:label"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:if>

				<!-- only display the comma separator if the immediate gazetteer node is present in the RDF data -->
				<xsl:if test="rdfs:label and //*[@rdf:about = $parentURI]">
					<xsl:text>, </xsl:text>
				</xsl:if>

				<xsl:apply-templates select="crm:P89_falls_within"/>

				<xsl:if test="skos:closeMatch">
					<br/>
					<i> Related URIs: </i>
					<xsl:for-each select="skos:closeMatch">
						<a href="{@rdf:resource}">
							<xsl:value-of select="@rdf:resource"/>
						</a>
						<xsl:if test="not(position() = last())">
							<xsl:text>, </xsl:text>
						</xsl:if>
					</xsl:for-each>
				</xsl:if>
			</xsl:when>
			<xsl:when test="self::crm:E54_Dimension or rdf:type/@rdf:resource = 'http://www.cidoc-crm.org/cidoc-crm/E54_Dimension'">
				<!-- evaluate the measurement type based on the AAT URI -->
				<xsl:variable name="type" select="crm:P2_has_type/@rdf:resource"/>

				<dt>
					<xsl:choose>
						<xsl:when test="$type = 'http://vocab.getty.edu/aat/300072633'">
							<xsl:value-of select="kerameikos:normalizeField('depth', $lang)"/>
						</xsl:when>
						<xsl:when test="$type = 'http://vocab.getty.edu/aat/300055647'">
							<xsl:value-of select="kerameikos:normalizeField('width', $lang)"/>
						</xsl:when>
						<xsl:when test="$type = 'http://vocab.getty.edu/aat/300055644'">
							<xsl:value-of select="kerameikos:normalizeField('height', $lang)"/>
						</xsl:when>
						<xsl:otherwise>Other</xsl:otherwise>
					</xsl:choose>
				</dt>
				<dd>
					<xsl:value-of select="crm:P90_has_value"/>
				</dd>

			</xsl:when>
		</xsl:choose>

	</xsl:template>

	<xsl:template match="crm:P7_took_place_at" mode="findspot">
		<dt>
			<xsl:value-of select="kerameikos:normalizeField('findspot', $lang)"/>
		</dt>
		<dd>
			<xsl:choose>
				<xsl:when test="child::*">
					<xsl:apply-templates select="child::*" mode="node"/>
				</xsl:when>
				<xsl:when test="@rdf:nodeID">
					<xsl:variable name="id" select="@rdf:nodeID"/>

					<xsl:apply-templates select="//*[@rdf:nodeID = $id]" mode="node"/>
				</xsl:when>
				<xsl:when test="@rdf:resource">
					<xsl:variable name="id" select="@rdf:resource"/>

					<xsl:apply-templates select="//*[@rdf:about = $id]" mode="node"/>
				</xsl:when>
			</xsl:choose>
		</dd>

	</xsl:template>

	<!-- render a simple triple into a definition list item -->
	<xsl:template
		match="kon:hasShape | crm:P45_consists_of | crm:P14_carried_out_by | crm:P10_falls_within | crm:P7_took_place_at | crm:P32_used_general_technique | crm:P50_has_current_keeper">
		<xsl:variable name="name" select="name()"/>

		<dt>
			<!--<a href="{concat(namespace-uri(), local-name())}" title="{name()}">
				<xsl:value-of select="kerameikos:normalizeCurie(name(), 'en')"/>
			</a>-->
			<xsl:value-of select="kerameikos:normalizeCurie(name(), $lang)"/>
		</dt>
		<dd>
			<xsl:choose>
				<xsl:when test="@rdf:resource">
					<xsl:variable name="href" select="@rdf:resource"/>

					<a href="{@rdf:resource}">
						<xsl:value-of select="kerameikos:getRDFLabel(doc('input:rdf')//*[@rdf:about = $href], $lang)"/>
					</a>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="."/>
				</xsl:otherwise>
			</xsl:choose>
		</dd>
	</xsl:template>



</xsl:stylesheet>
