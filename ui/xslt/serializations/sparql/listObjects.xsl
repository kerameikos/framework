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
				<div class="col-lg-2 col-md-3 col-sm-6 col-xs-12">
					<xsl:choose>
						<xsl:when test="res:binding[@name = 'manifest']">
							<a href="#iiif-window" title="{$title}" class="iiif-image"
								id="{res:binding[@name='object']/res:uri}" manifest="{res:binding[@name = 'manifest']/res:uri}">
								<img
									src="{if (string(res:binding[@name='thumb']/res:uri)) then res:binding[@name='thumb']/res:uri else res:binding[@name='ref']/res:uri}"
									title="{$title}" class="thumb"/>
							</a>
						</xsl:when>
						<xsl:otherwise>
							<a href="{res:binding[@name='ref']/res:uri}" title="{$title}" rel="gallery" class="fancybox"
								id="{res:binding[@name='object']/res:uri}">
								<img
									src="{if (string(res:binding[@name='thumb']/res:uri)) then res:binding[@name='thumb']/res:uri else res:binding[@name='ref']/res:uri}"
									title="{$title}" class="thumb"/>
							</a>
						</xsl:otherwise>
					</xsl:choose>
				</div>
			</xsl:when>
			<xsl:when test="string(res:binding[@name = 'thumb']/res:uri)">
				<div class="col-lg-2 col-md-3 col-sm-6 col-xs-12">
					<img src="{res:binding[@name='thumb']/res:uri}" title="{$title}" class="thumb"/>
				</div>
			</xsl:when>
		</xsl:choose>
	</xsl:template>


</xsl:stylesheet>
