<?xml version="1.0" encoding="UTF-8"?>

<!-- kerameikos.org XSLT functions -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:kerameikos="http://kerameikos.org/" exclude-result-prefixes="#all" version="2.0">
	<xsl:function name="kerameikos:normalizeYear">
		<xsl:param name="year"/>

		<xsl:choose>
			<xsl:when test="number($year) &lt;= 0">
				<xsl:value-of select="abs(number($year) - 1)"/>
				<xsl:text> B.C.</xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:if test="number($year) &lt;=400">
					<xsl:text>A.D. </xsl:text>
				</xsl:if>
				<xsl:value-of select="number($year)"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:function>
</xsl:stylesheet>
