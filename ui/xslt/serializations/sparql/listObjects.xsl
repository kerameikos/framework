<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:foaf="http://xmlns.com/foaf/0.1/" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
	xmlns:skos="http://www.w3.org/2004/02/skos/core#" xmlns:crm="http://www.cidoc-crm.org/cidoc-crm/" xmlns:xs="http://www.w3.org/2001/XMLSchema"
	xmlns:dcterms="http://purl.org/dc/terms/" xmlns:kid="http://kerameikos.org/id/" xmlns:kon="http://kerameikos.org/ontology#"
	xmlns:geo="http://www.w3.org/2003/01/geo/wgs84_pos#" xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:res="http://www.w3.org/2005/sparql-results#"
	xmlns:kerameikos="http://kerameikos.org/" xmlns:prov="http://www.w3.org/ns/prov#" xmlns:digest="org.apache.commons.codec.digest.DigestUtils"
	exclude-result-prefixes="#all" version="2.0">
	<xsl:include href="../../functions.xsl"/>

	<xsl:param name="id" select="doc('input:request')/request/parameters/parameter[name = 'id']/value"/>
	<xsl:param name="type" select="doc('input:request')/request/parameters/parameter[name = 'type']/value"/>

	<xsl:variable name="display_path">../</xsl:variable>

	<xsl:template match="/">
		<xsl:apply-templates select="descendant::crm:E22_Man-Made_Object"/>
	</xsl:template>

	<xsl:template match="crm:E22_Man-Made_Object">
		<xsl:variable name="uri" select="@rdf:about"/>
		<xsl:variable name="title" select="concat(dcterms:publisher, ': ', dcterms:title, ' (', dcterms:identifier, ')')"/>

		<xsl:if test="count(crm:P138i_has_representation) &gt; 0">
			<xsl:variable name="image">
				<xsl:choose>
					<xsl:when test="crm:P138i_has_representation[descendant::dcterms:conformsTo/@rdf:resource = 'http://iiif.io/api/image']">
						<xsl:value-of
							select="concat(crm:P138i_has_representation[descendant::dcterms:conformsTo/@rdf:resource = 'http://iiif.io/api/image'][1]/*/@rdf:about, '/full/800,/0/default.jpg')"
						/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="crm:P138i_has_representation[descendant::dcterms:format = 'image/jpeg'][1]/*/@rdf:about"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>

			<div style="background-image: url('{$image}')">
				<xsl:choose>

					<!-- when there's a IIIF manifest, display IIIF Leaflet viewer -->
					<xsl:when test="crm:P129i_is_subject_of">
						<xsl:attribute name="class">col-lg-2 col-md-3 col-sm-6 col-xs-12 obj-container iiif-image</xsl:attribute>
						<xsl:attribute name="href">#iiif-window</xsl:attribute>
						<xsl:attribute name="manifest" select="crm:P129i_is_subject_of/@rdf:resource"/>
						<xsl:attribute name="uri" select="$uri"/>
						<xsl:attribute name="title" select="$title"/>
						<span class="glyphicon glyphicon-zoom-in iiif-zoom-glyph" title="Click image(s) to zoom" style="display:none"/>

						<!-- include 3D model link -->
						<xsl:apply-templates
							select="crm:P138i_has_representation[descendant::dcterms:format = 'application/octet-stream' or descendant::dcterms:format/@rdf:resource = 'http://vocab.getty.edu/aat/300379693']">
							<xsl:with-param name="uri" select="$uri"/>
							<xsl:with-param name="title" select="$title"/>
						</xsl:apply-templates>

					</xsl:when>
					<xsl:otherwise>
						<xsl:variable name="rel" select="concat(digest:md5Hex(string($uri)), '-gallery')"/>
						
						<xsl:attribute name="class">col-lg-2 col-md-3 col-sm-6 col-xs-12 obj-container</xsl:attribute>

						<a href="{$image}" class="fancybox" title="{$title}" uri="{$uri}" rel="{$rel}"/>						

						<!-- create gallery for multiple images per vase -->
						<xsl:if
							test="count(crm:P138i_has_representation[descendant::dcterms:conformsTo/@rdf:resource = 'http://iiif.io/api/image' or descendant::dcterms:format = 'image/jpeg']) &gt; 1">
							<div class="hidden">
								<xsl:apply-templates
									select="crm:P138i_has_representation[descendant::dcterms:conformsTo/@rdf:resource = 'http://iiif.io/api/image' or descendant::dcterms:format = 'image/jpeg'][position() &gt; 1]">
									<xsl:with-param name="rel" select="$rel"/>
									<xsl:with-param name="uri" select="$uri"/>
									<xsl:with-param name="title" select="$title"/>
								</xsl:apply-templates>
							</div>
						</xsl:if>

						<!-- include 3D model link -->
						<xsl:apply-templates
							select="crm:P138i_has_representation[descendant::dcterms:format = 'application/octet-stream' or descendant::dcterms:format/@rdf:resource = 'http://vocab.getty.edu/aat/300379693']">
							<xsl:with-param name="uri" select="$uri"/>
							<xsl:with-param name="title" select="$title"/>
						</xsl:apply-templates>
					</xsl:otherwise>
				</xsl:choose>
			</div>
		</xsl:if>
	</xsl:template>

	<xsl:template match="crm:P138i_has_representation">
		<xsl:param name="uri"/>
		<xsl:param name="title"/>
		<xsl:param name="rel"/>

		<xsl:choose>
			<xsl:when test="descendant::dcterms:conformsTo/@rdf:resource = 'http://iiif.io/api/image'">
				<a href="{concat(*/@rdf:about, '/full/800,/0/default.jpg')}" rel="{$rel}" uri="{$uri}" title="{$title}" class="fancybox">
					<img src="{concat(*/@rdf:about, '/full/800,/0/default.jpg')}"/>
				</a>
			</xsl:when>
			<xsl:when test="descendant::dcterms:format = 'image/jpeg'">
				<a href="{*/@rdf:about}" rel="{$rel}" uri="{$uri}" title="{$title}" class="fancybox">
					<img src="{*/@rdf:about}"/>
				</a>
			</xsl:when>
			<xsl:when
				test="descendant::dcterms:format = 'application/octet-stream' or descendant::dcterms:format/@rdf:resource = 'http://vocab.getty.edu/aat/300379693'">
				<xsl:variable name="modelURI" select="*/@rdf:about"/>

				<span object-url="{$uri}" content="{$title}" class="glyphicon glyphicon-modal-window model-button" title="Click to view 3D model"
					model-url="{$modelURI}">
					<xsl:attribute name="href">
						<xsl:choose>
							<xsl:when test="contains($modelURI, 'sketchfab')">#sketchfab-window</xsl:when>
							<xsl:when test="contains($modelURI, '.ply')">#3dhop-window</xsl:when>
						</xsl:choose>
					</xsl:attribute>
					<xsl:if test="descendant::dcterms:format = 'application/octet-stream'">
						<xsl:attribute name="model-format">application/octet-stream</xsl:attribute>
					</xsl:if>
					<xsl:text> 3D Model</xsl:text>
				</span>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>
