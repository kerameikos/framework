<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:res="http://www.w3.org/2005/sparql-results#" exclude-result-prefixes="#all"
	version="2.0">
	<xsl:param name="query" select="doc('input:request')/request/parameters/parameter[name='query']/value"/>

	<xsl:template match="/">
		<select class="form-control add-filter-object">
			<option value="">Select...</option>
			<xsl:apply-templates select="descendant::res:result"/>
		</select>
	</xsl:template>

	<xsl:template match="res:result">		
		<xsl:variable name="curie">
			<xsl:choose>
				<xsl:when test="contains(res:binding[@name='uri']/res:uri, 'https://kerameikos.org/id/')">
					<xsl:value-of select="replace(res:binding[@name='uri']/res:uri, 'https://kerameikos.org/id/', 'kid:')"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="concat('&lt;', res:binding[@name='uri']/res:uri, '&gt;')"/>
				</xsl:otherwise>
			</xsl:choose>		
		</xsl:variable>
		
		<option value="{$curie}">
			<xsl:if test="substring-after($query, ' ') = $curie">
				<xsl:attribute name="selected">selected</xsl:attribute>
			</xsl:if>
			
			<xsl:value-of select="res:binding[@name='label']/res:literal"/>
		</option>
	</xsl:template>

</xsl:stylesheet>
