<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:res="http://www.w3.org/2005/sparql-results#"
	xmlns:nomisma="http://nomisma.org/" exclude-result-prefixes="#all" version="2.0">
	<xsl:include href="../../functions.xsl"/>

	<xsl:param name="id" select="doc('input:request')/request/parameters/parameter[name = 'id']/value"/>
	<xsl:param name="type" select="doc('input:request')/request/parameters/parameter[name = 'type']/value"/>

	<xsl:variable name="display_path">../</xsl:variable>

	<xsl:template match="/">
		<xsl:apply-templates select="descendant::res:result"/>
	</xsl:template>

	<xsl:template match="res:result">
		<xsl:variable name="title"
			select="concat(res:binding[@name = 'keeper']/res:literal, ': ', res:binding[@name = 'title']/res:literal, ' (', res:binding[@name = 'id']/res:literal, ')')"/>

		<xsl:choose>
			<xsl:when test="string(res:binding[@name = 'ref']/res:uri)">
				<div title="{$title}"
					style="background-image: url('{if (string(res:binding[@name='thumb']/res:uri)) then res:binding[@name='thumb']/res:uri else res:binding[@name='ref']/res:uri}')"
					id="{res:binding[@name='object']/res:uri}">
					<xsl:choose>
						<xsl:when test="res:binding[@name = 'manifest']">
							<xsl:attribute name="class">col-lg-2 col-md-3 col-sm-6 col-xs-12 obj-container iiif-image</xsl:attribute>
							<xsl:attribute name="href">#iiif-window</xsl:attribute>
							<xsl:attribute name="manifest" select="res:binding[@name = 'manifest']/res:uri"/>
							<span class="glyphicon glyphicon-zoom-in iiif-zoom-glyph" title="Click image(s) to zoom" style="display:none"/>
							<xsl:if test="res:binding[@name = '3dmodel']">
								<span object-url="{res:binding[@name='object']/res:uri}" content="{$title}"
									class="glyphicon glyphicon-modal-window model-button" title="Click to view 3D model" model-url="{res:binding[@name='3dmodel']/res:uri}">
									<xsl:attribute name="href">
										<xsl:choose>
											<xsl:when test="contains(res:binding[@name='3dmodel']/res:uri, 'sketchfab')">#sketchfab-window</xsl:when>
											<xsl:when test="contains(res:binding[@name='3dmodel']/res:uri, '.ply')">#3dhop-window</xsl:when>
										</xsl:choose>
									</xsl:attribute>
									<xsl:if test="res:binding[@name='format']">
										<xsl:attribute name="model-format" select="res:binding[@name='format']/res:literal"/>
									</xsl:if>
									<xsl:text> 3D Model</xsl:text>
								</span>
							</xsl:if>
						</xsl:when>
						<xsl:otherwise>
							<xsl:attribute name="class">col-lg-2 col-md-3 col-sm-6 col-xs-12 obj-container fancybox</xsl:attribute>
							<xsl:attribute name="href" select="res:binding[@name = 'ref']/res:uri"/>
							<xsl:attribute name="rel">gallery</xsl:attribute>
							<xsl:if test="res:binding[@name = '3dmodel']">
								<span object-url="{res:binding[@name='object']/res:uri}" content="{$title}"
									class="glyphicon glyphicon-modal-window model-button" title="Click to view 3D model" model-url="{res:binding[@name='3dmodel']/res:uri}">
									<xsl:attribute name="href">
										<xsl:choose>
											<xsl:when test="contains(res:binding[@name='3dmodel']/res:uri, 'sketchfab')">#sketchfab-window</xsl:when>
											<xsl:when test="contains(res:binding[@name='3dmodel']/res:uri, '.ply')">#3dhop-window</xsl:when>
										</xsl:choose>
									</xsl:attribute>
									<xsl:if test="res:binding[@name='format']">
										<xsl:attribute name="model-format" select="res:binding[@name='format']/res:literal"/>
									</xsl:if>
									<xsl:text> 3D Model</xsl:text>
								</span>
							</xsl:if>
						</xsl:otherwise>
					</xsl:choose>
				</div>
			</xsl:when>
			<xsl:when test="string(res:binding[@name = 'thumb']/res:uri)">
				<a href="{res:binding[@name='thumb']/res:uri}" title="{$title}" class="col-lg-2 col-md-3 col-sm-6 col-xs-12 obj-container fancybox"
					style="background-image: url('{res:binding[@name='thumb']/res:uri}')" id="{res:binding[@name='object']/res:uri}"/>
			</xsl:when>
		</xsl:choose>
	</xsl:template>


</xsl:stylesheet>
