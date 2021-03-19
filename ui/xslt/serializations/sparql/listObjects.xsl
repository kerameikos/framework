<?xml version="1.0" encoding="UTF-8"?>
<!-- Author: Ethan Gruber
	Date: March 2021
	Function: render related objects into a grid pattern, linking to IIIF or 3D models as necessary. Pagination introduced in March 2021 -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:foaf="http://xmlns.com/foaf/0.1/" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
	xmlns:skos="http://www.w3.org/2004/02/skos/core#" xmlns:crm="http://www.cidoc-crm.org/cidoc-crm/" xmlns:xs="http://www.w3.org/2001/XMLSchema"
	xmlns:dcterms="http://purl.org/dc/terms/" xmlns:kid="http://kerameikos.org/id/" xmlns:kon="http://kerameikos.org/ontology#"
	xmlns:geo="http://www.w3.org/2003/01/geo/wgs84_pos#" xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:res="http://www.w3.org/2005/sparql-results#"
	xmlns:kerameikos="http://kerameikos.org/" xmlns:prov="http://www.w3.org/ns/prov#" xmlns:digest="org.apache.commons.codec.digest.DigestUtils"
	exclude-result-prefixes="#all" version="2.0">
	<xsl:include href="../../functions.xsl"/>

	<xsl:param name="id" select="doc('input:request')/request/parameters/parameter[name = 'id']/value"/>
	<xsl:param name="type" select="doc('input:request')/request/parameters/parameter[name = 'type']/value"/>
	<!-- pagination parameter for iterating through pages of physical specimens -->
	<xsl:param name="page" as="xs:integer">
		<xsl:choose>
			<xsl:when
				test="
					string-length(doc('input:request')/request/parameters/parameter[name = 'page']/value) &gt; 0 and doc('input:request')/request/parameters/parameter[name = 'page']/value castable
					as xs:integer and number(doc('input:request')/request/parameters/parameter[name = 'page']/value) > 0">
				<xsl:value-of select="doc('input:request')/request/parameters/parameter[name = 'page']/value"/>
			</xsl:when>
			<xsl:otherwise>1</xsl:otherwise>
		</xsl:choose>
	</xsl:param>

	<xsl:variable name="limit" select="48"/>
	<xsl:variable name="numFound" select="doc('input:specimenCount')/descendant::res:binding[@name = 'count']/res:literal" as="xs:integer"/>

	<xsl:variable name="display_path">../</xsl:variable>

	<xsl:template match="/">
		<xsl:if test="$numFound &gt; $limit">
			<xsl:call-template name="pagination">
				<xsl:with-param name="page" select="$page" as="xs:integer"/>
				<xsl:with-param name="numFound" select="$numFound" as="xs:integer"/>
				<xsl:with-param name="limit" select="$limit" as="xs:integer"/>
			</xsl:call-template>
		</xsl:if>

		<xsl:apply-templates select="descendant::res:result"/>
	</xsl:template>

	<xsl:template match="res:result">
		<xsl:variable name="uri" select="res:binding[@name = 'object']/res:uri"/>
		<xsl:variable name="title"
			select="concat(res:binding[@name = 'keeper']/res:literal, ': ', res:binding[@name = 'title']/res:literal, ' (', res:binding[@name = 'id']/res:literal, ')')"/>



		<xsl:variable name="images">
			<images>
				<xsl:choose>
					<xsl:when test="res:binding[@name = 'iiif_images']">
						<xsl:variable name="iiif" select="tokenize(res:binding[@name = 'iiif_images']/res:literal, '\|')"/>
						
						<xsl:for-each select="$iiif">
							<image type="iiif">
								<xsl:value-of select="."/>
							</image>
						</xsl:for-each>
						
					</xsl:when>
					<xsl:when test="res:binding[@name = 'static_images']">
						<xsl:variable name="static" select="tokenize(res:binding[@name = 'static_images']/res:literal, '\|')"/>
						
						<xsl:for-each select="$static">
							<image type="static">
								<xsl:value-of select="."/>
							</image>
						</xsl:for-each>
						
					</xsl:when>
				</xsl:choose>
			</images>
		</xsl:variable>
		
		<xsl:variable name="display-image">
			<xsl:choose>
				<xsl:when test="$images//image[@type = 'iiif']">
					<xsl:value-of select="concat($images//image[@type = 'iiif'][1], '/full/!800,/0/default.jpg')"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$images//image[1]"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<div style="background-image: url('{$display-image}')">
			<xsl:choose>					
					<!-- when there's a IIIF manifest, display IIIF Leaflet viewer -->
					<xsl:when test="res:binding[@name='manfiest']">
						<xsl:attribute name="class">col-lg-2 col-md-3 col-sm-6 col-xs-12 obj-container iiif-image</xsl:attribute>
						<xsl:attribute name="href">#iiif-window</xsl:attribute>
						<xsl:attribute name="manifest" select="res:binding[@name='manfiest']/res:uri"/>
						<xsl:attribute name="uri" select="$uri"/>
						<xsl:attribute name="title" select="$title"/>
						<span class="glyphicon glyphicon-zoom-in iiif-zoom-glyph" title="Click image(s) to zoom" style="display:none"/>
						
						<!-- include 3D model link -->
						<!--<xsl:apply-templates
							select="$images//crm:P138i_has_representation[descendant::dcterms:format = 'application/octet-stream' or descendant::dcterms:format/@rdf:resource = 'http://vocab.getty.edu/aat/300379693']">
							<xsl:with-param name="uri" select="$uri"/>
							<xsl:with-param name="title" select="$title"/>
						</xsl:apply-templates>-->
						
					</xsl:when>
					<xsl:otherwise>
						<xsl:variable name="rel" select="concat(digest:md5Hex(string($uri)), '-gallery')"/>
						
						<xsl:choose>
							<xsl:when test="$images//image[@type = 'iiif']">
								<xsl:attribute name="class">col-lg-2 col-md-3 col-sm-6 col-xs-12 obj-container</xsl:attribute>
								<a href="{$display-image}" class="fancybox" title="{$title}" uri="{$uri}" rel="{$rel}"/>
								
								<!-- uncomment this when the BM fixes CORS -->
								<!--<xsl:attribute name="class">col-lg-2 col-md-3 col-sm-6 col-xs-12 obj-container iiif-image</xsl:attribute>
								<xsl:attribute name="href">#iiif-window</xsl:attribute>
								<xsl:attribute name="manifest" select="$images//crm:P138i_has_representation[descendant::dcterms:conformsTo/@rdf:resource = 'http://iiif.io/api/image'][1]/*/@rdf:about"/>
								<xsl:attribute name="uri" select="$uri"/>
								<xsl:attribute name="title" select="$title"/>
								<span class="glyphicon glyphicon-zoom-in iiif-zoom-glyph" title="Click image(s) to zoom" style="display:none"/>-->
							</xsl:when>
							<xsl:otherwise>
								<xsl:attribute name="class">col-lg-2 col-md-3 col-sm-6 col-xs-12 obj-container</xsl:attribute>
								<a href="{$display-image}" class="fancybox" title="{$title}" uri="{$uri}" rel="{$rel}"/>
							</xsl:otherwise>
						</xsl:choose>
						
						
						
						<!-- create gallery for multiple images per vase -->
						<xsl:if test="count($images//image[@type = 'static']) &gt; 1">
							<div class="hidden">
								<xsl:apply-templates
									select="$images//image[@type = 'static'][position() &gt; 1]">
									<xsl:with-param name="rel" select="$rel"/>
									<xsl:with-param name="uri" select="$uri"/>
									<xsl:with-param name="title" select="$title"/>
								</xsl:apply-templates>
							</div>
						</xsl:if>
						
						<!-- include 3D model link -->
						
						<!-- redo -->
						<!--<xsl:apply-templates
							select="$images//crm:P138i_has_representation[descendant::dcterms:format = 'application/octet-stream' or descendant::dcterms:format/@rdf:resource = 'http://vocab.getty.edu/aat/300379693']">
							<xsl:with-param name="uri" select="$uri"/>
							<xsl:with-param name="title" select="$title"/>
						</xsl:apply-templates>-->
					</xsl:otherwise>				
			</xsl:choose>
		</div>
	</xsl:template>

	<xsl:template match="image">
		<xsl:param name="uri"/>
		<xsl:param name="title"/>
		<xsl:param name="rel"/>

		<xsl:choose>
			<xsl:when test="@type = 'iiif'">
				<a href="{concat(., '/full/800,/0/default.jpg')}" rel="{$rel}" uri="{$uri}" title="{$title}" class="fancybox">
					<img src="{concat(., '/full/800,/0/default.jpg')}"/>
				</a>
			</xsl:when>
			<xsl:when test="@type = 'static'">
				<a href="{.}" rel="{$rel}" uri="{$uri}" title="{$title}" class="fancybox">
					<img src="{.}"/>
				</a>
			</xsl:when>
			<!--<xsl:when
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
			</xsl:when>-->
		</xsl:choose>
	</xsl:template>

	<!-- pagination -->
	<xsl:template name="pagination">
		<xsl:param name="page" as="xs:integer"/>
		<xsl:param name="numFound" as="xs:integer"/>
		<xsl:param name="limit" as="xs:integer"/>

		<xsl:variable name="offset" select="($page - 1) * $limit" as="xs:integer"/>

		<xsl:variable name="previous" select="$page - 1"/>
		<xsl:variable name="current" select="$page"/>
		<xsl:variable name="next" select="$page + 1"/>
		<xsl:variable name="total" select="ceiling($numFound div $limit)"/>

		<div class="col-md-12 paging_div">
			<div class="col-md-6">
				<xsl:variable name="startRecord" select="$offset + 1"/>
				<xsl:variable name="endRecord">
					<xsl:choose>
						<xsl:when test="$numFound &gt; ($offset + $limit)">
							<xsl:value-of select="$offset + $limit"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="$numFound"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<p>Records <b><xsl:value-of select="$startRecord"/></b> to <b><xsl:value-of select="$endRecord"/></b> of <b><xsl:value-of select="$numFound"
						/></b></p>
			</div>
			<!-- paging functionality -->
			<div class="col-md-6 page-nos">
				<div class="btn-toolbar" role="toolbar">
					<div class="btn-group pull-right">
						<!-- first page -->
						<xsl:if test="$current &gt; 1">
							<a class="btn btn-default" role="button" title="First" href="?page=1">
								<span class="glyphicon glyphicon-fast-backward"/>
								<xsl:text> 1</xsl:text>
							</a>
							<a class="btn btn-default" role="button" title="Previous" href="?page={$current - 1}">
								<xsl:text>Previous </xsl:text>
								<span class="glyphicon glyphicon-backward"/>
							</a>
						</xsl:if>
						<xsl:if test="$current &gt; 5">
							<button type="button" class="btn btn-default disabled">
								<xsl:text>...</xsl:text>
							</button>
						</xsl:if>
						<xsl:if test="$current &gt; 4">
							<a class="btn btn-default" role="button" href="?page={$current - 3}">
								<xsl:value-of select="$current - 3"/>
								<xsl:text> </xsl:text>
							</a>
						</xsl:if>
						<xsl:if test="$current &gt; 3">
							<a class="btn btn-default" role="button" href="?page={$current - 2}">
								<xsl:value-of select="$current - 2"/>
								<xsl:text> </xsl:text>
							</a>
						</xsl:if>
						<xsl:if test="$current &gt; 2">
							<a class="btn btn-default" role="button" href="?page={$current - 1}">
								<xsl:value-of select="$current - 1"/>
								<xsl:text> </xsl:text>
							</a>
						</xsl:if>
						<!-- current page -->
						<button type="button" class="btn btn-default active">
							<b>
								<xsl:value-of select="$current"/>
							</b>
						</button>
						<xsl:if test="$total &gt; ($current + 1)">
							<a class="btn btn-default" role="button" title="Next" href="?page={$current + 1}">
								<xsl:value-of select="$current + 1"/>
							</a>
						</xsl:if>
						<xsl:if test="$total &gt; ($current + 2)">
							<a class="btn btn-default" role="button" title="Next" href="?page={$current + 2}">
								<xsl:value-of select="$current + 2"/>
							</a>
						</xsl:if>
						<xsl:if test="$total &gt; ($current + 3)">
							<a class="btn btn-default" role="button" title="Next" href="?page={$current + 3}">
								<xsl:value-of select="$current + 3"/>
							</a>
						</xsl:if>
						<xsl:if test="$total &gt; ($current + 4)">
							<button type="button" class="btn btn-default disabled">
								<xsl:text>...</xsl:text>
							</button>
						</xsl:if>
						<!-- last page -->
						<xsl:if test="$current &lt; $total">
							<a class="btn btn-default" role="button" title="Next" href="?page={$current + 1}">
								<xsl:text>Next </xsl:text>
								<span class="glyphicon glyphicon-forward"/>
							</a>
							<a class="btn btn-default" role="button" title="Last" href="?page={$total}">
								<xsl:value-of select="$total"/>
								<xsl:text> </xsl:text>
								<span class="glyphicon glyphicon-fast-forward"/>
							</a>
						</xsl:if>
					</div>
				</div>
			</div>

		</div>

	</xsl:template>
</xsl:stylesheet>
