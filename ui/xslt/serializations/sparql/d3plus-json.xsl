<?xml version="1.0" encoding="UTF-8"?>
<!-- Author: Ethan Gruber
	Modified: June 2019
	Function: Serialize SPARQL results for the distribution API into JSON for d3plus -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:res="http://www.w3.org/2005/sparql-results#"
	xmlns:kerameikos="https://kerameikos.org/" exclude-result-prefixes="#all" version="2.0">
	<xsl:include href="../../functions.xsl"/>

	<!-- URL parameters -->
	<xsl:param name="dist" select="doc('input:request')/request/parameters/parameter[name = 'dist']/value"/>
	<xsl:param name="compare" select="doc('input:request')/request/parameters/parameter[name = 'compare']/value"/>
	<xsl:param name="filter" select="doc('input:request')/request/parameters/parameter[name = 'filter']/value"/>
	<xsl:param name="type" select="doc('input:request')/request/parameters/parameter[name = 'type']/value"/>
	<xsl:param name="format" select="doc('input:request')/request/parameters/parameter[name = 'format']/value"/>

	<xsl:variable name="queries" as="element()*">
		<queries>
			<xsl:if test="string($filter)">
				<query>
					<xsl:attribute name="label" select="kerameikos:parseFilter(normalize-space($filter), doc('input:config-xml')/config/url)"/>
					<xsl:value-of select="normalize-space($filter)"/>
				</query>
			</xsl:if>
			<xsl:for-each select="$compare">
				<query>
					<xsl:attribute name="label" select="kerameikos:parseFilter(normalize-space(.), doc('input:config-xml')/config/url)"/>
					<xsl:value-of select="."/>
				</query>
			</xsl:for-each>
		</queries>
	</xsl:variable>

	<xsl:template match="/">
		<xsl:text>[</xsl:text>
		<xsl:apply-templates select="descendant::res:sparql"/>
		<xsl:text>]</xsl:text>
	</xsl:template>

	
	<xsl:template match="res:sparql">
		<xsl:variable name="position" select="position()"/>
		<xsl:variable name="query" select="$queries/query[$position]"/>
		<xsl:variable name="subset" select="$queries/query[$position]/@label"/>

		<xsl:variable name="total" select="sum(descendant::res:binding[@name = 'count']/res:literal)"/>

		<xsl:apply-templates select="descendant::res:result[res:binding[@name = 'label']/res:literal]">
			<xsl:with-param name="query" select="$query"/>
			<xsl:with-param name="subset" select="$subset"/>
			<xsl:with-param name="total" select="$total"/>
		</xsl:apply-templates>

		<xsl:if test="not(position() = last())">
			<xsl:text>,</xsl:text>
		</xsl:if>
	</xsl:template>

	<xsl:template match="res:result">
		<xsl:param name="query"/>
		<xsl:param name="subset"/>
		<xsl:param name="total"/>

		<xsl:variable name="object" as="element()*">
			<row>
				<xsl:element name="subset">
					<xsl:value-of select="$subset"/>
				</xsl:element>
				<xsl:element name="{$dist}">
					<xsl:value-of select="res:binding[@name = 'label']/res:literal"/>
				</xsl:element>
				<xsl:element name="{if ($type='count') then 'count' else 'percentage'}">
					<xsl:choose>
						<xsl:when test="$type = 'count'">
							<xsl:value-of select="res:binding[@name = 'count']/res:literal"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="format-number((res:binding[@name = 'count']/res:literal div $total) * 100, '0.0')"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:element>
			</row>
		</xsl:variable>

		<xsl:text>{</xsl:text>
		<xsl:for-each select="$object/*">
			<xsl:value-of select="concat('&#x022;', name(), '&#x022;')"/>
			<xsl:text>:</xsl:text>
			<xsl:choose>
				<xsl:when test=". castable as xs:integer or . castable as xs:decimal">
					<xsl:value-of select="."/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="concat('&#x022;', replace(., '&#x022;', '\\&#x022;'), '&#x022;')"/>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:if test="not(position() = last())">
				<xsl:text>, </xsl:text>
			</xsl:if>
		</xsl:for-each>
		<xsl:text>}</xsl:text>
		<xsl:if test="not(position() = last())">
			<xsl:text>, </xsl:text>
		</xsl:if>
	</xsl:template>
</xsl:stylesheet>
