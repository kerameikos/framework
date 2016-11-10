<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:res="http://www.w3.org/2005/sparql-results#"
	xmlns:kerameikos="http://kerameikos.org/" exclude-result-prefixes="#all" version="2.0">
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
					<xsl:attribute name="label" select="kerameikos:parseFilter(normalize-space($filter))"/>
					<xsl:value-of select="normalize-space($filter)"/>
				</query>
			</xsl:if>
			<xsl:for-each select="$compare">
				<query>
					<xsl:attribute name="label" select="kerameikos:parseFilter(normalize-space(.))"/>
					<xsl:value-of select="."/>
				</query>
			</xsl:for-each>
		</queries>
	</xsl:variable>

	<xsl:template match="/">
		<xsl:choose>
			<xsl:when test="$format = 'csv'">
				<xsl:text>"subset","value","uri",</xsl:text>
				<xsl:if test="$dist = 'nmo:hasMint'">
					<xsl:text>"lat","long",</xsl:text>
				</xsl:if>
				<xsl:text>"</xsl:text>
				<xsl:value-of select="
						if ($type = 'count') then
							'count'
						else
							'percentage'"/>
				<xsl:text>"&#x0A;</xsl:text>
				<xsl:apply-templates select="descendant::res:sparql" mode="csv"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>[</xsl:text>
				<xsl:apply-templates select="descendant::res:sparql" mode="json"/>
				<xsl:text>]</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- ************** D3PLUS JSON TEMPLATES *************** -->
	<xsl:template match="res:sparql" mode="json">
		<xsl:variable name="position" select="position()"/>
		<xsl:variable name="query" select="$queries/query[$position]"/>
		<xsl:variable name="subset" select="$queries/query[$position]/@label"/>

		<xsl:variable name="total" select="sum(descendant::res:binding[@name = 'count']/res:literal)"/>

		<xsl:apply-templates select="descendant::res:result[res:binding[@name = 'label']/res:literal]" mode="json">
			<xsl:with-param name="query" select="$query"/>
			<xsl:with-param name="subset" select="$subset"/>
			<xsl:with-param name="total" select="$total"/>
		</xsl:apply-templates>

		<xsl:if test="not(position() = last())">
			<xsl:text>,</xsl:text>
		</xsl:if>
	</xsl:template>

	<xsl:template match="res:result" mode="json">
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
					<xsl:value-of select="concat('&#x022;', ., '&#x022;')"/>
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

	<!-- ************** CSV TEMPLATES *************** -->
	<xsl:template match="res:sparql" mode="csv">
		<xsl:variable name="position" select="position()"/>
		<xsl:variable name="query" select="$queries/query[$position]"/>


		<xsl:variable name="total" select="sum(descendant::res:binding[@name = 'count']/res:literal)"/>

		<xsl:apply-templates select="descendant::res:result[res:binding[@name = 'label']/res:literal]" mode="csv">
			<xsl:with-param name="query" select="$query"/>
			<xsl:with-param name="total" select="$total"/>
		</xsl:apply-templates>

		<xsl:if test="not(position() = last())">
			<xsl:text>&#x0A;</xsl:text>
		</xsl:if>
	</xsl:template>

	<xsl:template match="res:result" mode="csv">
		<xsl:param name="query"/>
		<xsl:param name="total"/>

		<xsl:variable name="object" as="element()*">
			<row>
				<xsl:element name="subset">
					<xsl:value-of select="kerameikos:parseFilter($query)"/>
				</xsl:element>
				<xsl:element name="{$dist}">
					<xsl:value-of select="res:binding[@name = 'label']/res:literal"/>
				</xsl:element>
				<xsl:element name="uri">
					<xsl:choose>
						<xsl:when test="res:binding[@name='match']">
							<xsl:value-of select="res:binding[@name = 'match']/res:uri"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="res:binding[@name = 'dist']/res:uri"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:element>
				<xsl:if test="$dist = 'nmo:hasMint'">
					<xsl:element name="lat">
						<xsl:value-of select="res:binding[@name = 'lat']/res:literal"/>
					</xsl:element>
					<xsl:element name="long">
						<xsl:value-of select="res:binding[@name = 'long']/res:literal"/>
					</xsl:element>
				</xsl:if>
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

		<xsl:for-each select="$object/*">
			<xsl:choose>
				<xsl:when test=". castable as xs:integer or . castable as xs:decimal">
					<xsl:value-of select="."/>
				</xsl:when>
				<xsl:when test="string-length(.) = 0"/>
				<xsl:otherwise>
					<xsl:value-of select="concat('&#x022;', ., '&#x022;')"/>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:if test="not(position() = last())">
				<xsl:text>,</xsl:text>
			</xsl:if>
		</xsl:for-each>
		<xsl:if test="not(position() = last())">
			<xsl:text>&#x0A;</xsl:text>
		</xsl:if>
	</xsl:template>

	<!-- ************** FUNCTIONS *************** -->
	<xsl:function name="kerameikos:parseFilter">
		<xsl:param name="query"/>

		<xsl:variable name="pieces" select="tokenize(normalize-space($query), ';')"/>
		<xsl:for-each select="$pieces">
			<xsl:choose>
				<xsl:when test="matches(normalize-space(.), '^from\s')">
					<xsl:analyze-string select="." regex="from\s(.*)">
						<xsl:matching-substring>
							<xsl:text>From Date: </xsl:text>
							<xsl:value-of select="kerameikos:normalizeYear(regex-group(1))"/>
						</xsl:matching-substring>
					</xsl:analyze-string>
				</xsl:when>
				<xsl:when test="matches(normalize-space(.), '^to\s')">
					<xsl:analyze-string select="." regex="to\s(.*)">
						<xsl:matching-substring>
							<xsl:text>To Date: </xsl:text>
							<xsl:value-of select="kerameikos:normalizeYear(regex-group(1))"/>
						</xsl:matching-substring>
					</xsl:analyze-string>
				</xsl:when>
				<xsl:otherwise>
					<xsl:analyze-string select="." regex="(.*)\s(kid:.*)">
						<xsl:matching-substring>
							<xsl:value-of select="regex-group(1)"/>
							<xsl:text>: </xsl:text>
							<xsl:value-of select="kerameikos:getLabel(regex-group(2))"/>
						</xsl:matching-substring>
					</xsl:analyze-string>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:if test="not(position() = last())">
				<xsl:text> &amp; </xsl:text>
			</xsl:if>
		</xsl:for-each>
	</xsl:function>
</xsl:stylesheet>
