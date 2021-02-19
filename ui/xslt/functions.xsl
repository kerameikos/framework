<?xml version="1.0" encoding="UTF-8"?>

<!-- kerameikos.org XSLT functions -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:kerameikos="http://kerameikos.org/" exclude-result-prefixes="#all" version="2.0">
	
	<!-- create a human readable date -->
	<xsl:function name="kerameikos:normalizeDate">
		<xsl:param name="date"/>
		
		<!--<xsl:if test="substring($date, 1, 1) != '-' and number(substring($date, 1, 4)) &lt; 500">
			<xsl:text>A.D. </xsl:text>
		</xsl:if>-->
		
		<xsl:choose>
			<xsl:when test="$date castable as xs:date">
				<xsl:value-of select="format-date($date, '[D] [MNn] [Y]')"/>
			</xsl:when>
			<xsl:when test="$date castable as xs:gYearMonth">
				<xsl:variable name="normalized" select="xs:date(concat($date, '-01'))"/>
				<xsl:value-of select="format-date($normalized, '[MNn] [Y]')"/>
			</xsl:when>
			<xsl:when test="$date castable as xs:gYear or $date castable as xs:integer">
				<xsl:value-of select="abs(number($date))"/>
			</xsl:when>
		</xsl:choose>
		
		
		
		<xsl:if test="substring($date, 1, 1) = '-'">
			<xsl:text> BCE</xsl:text>
		</xsl:if>
	</xsl:function>
	
	<!-- convert XSD compliant date datatypes into ISO 8601 dates (e.g., 1 B.C., "-0001"^^xsd:gYear = "0000" in ISO 8601) -->
	<xsl:function name="kerameikos:xsdToIso">
		<xsl:param name="date"/>
		
		<xsl:variable name="year" select="if (substring($date, 1, 1) = '-') then substring($date, 1, 5) else substring($date, 1, 4)"/>
		<xsl:choose>
			<xsl:when test="number($year) &lt; 0">
				<!-- convert the year to ISO -->
				<xsl:value-of select="format-number(number($year) + 1, '0000')"/>
				<!-- include month and/or day when applicable -->
				<xsl:if test="string-length($date) &gt; 5">
					<xsl:value-of select="substring($date, 5)"/>
				</xsl:if>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$date"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:function>
	
	<xsl:function name="kerameikos:normalizeYear">
		<xsl:param name="year"/>

		<xsl:choose>
			<xsl:when test="number($year) &lt;= 0">
				<xsl:value-of select="abs(number($year) - 1)"/>
				<xsl:text> BCE</xsl:text>
			</xsl:when>
			<xsl:otherwise>				
				<xsl:value-of select="number($year)"/>
				<xsl:if test="number($year) &lt;=400">
					<xsl:text> CE</xsl:text>
				</xsl:if>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:function>
	
	<xsl:function name="kerameikos:getLabel">
		<xsl:param name="uri"/>
		<xsl:param name="service"/>
		
		<xsl:variable name="service" select="concat($service, 'apis/getLabel?uri=', $uri)"/>
		
		<xsl:value-of select="document($service)/response"/>
	</xsl:function>
	
	<xsl:function name="kerameikos:parseFilter">
		<xsl:param name="query"/>
		<xsl:param name="service"/>
		
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
							<xsl:value-of select="normalize-space(regex-group(1))"/>
							<xsl:text>: </xsl:text>
							<xsl:value-of select="kerameikos:getLabel(regex-group(2), $service)"/>
						</xsl:matching-substring>
					</xsl:analyze-string>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:if test="not(position() = last())">
				<xsl:text> &amp; </xsl:text>
			</xsl:if>
		</xsl:for-each>
	</xsl:function>
	
	<!-- ***** Functions for linked.art JSON-LD serialization ***** -->
	<xsl:function name="kerameikos:expandDate">
		<xsl:param name="date"/>
		<xsl:param name="range"/>
		
		<!-- the data should be assumed to be XSD 1.0 compliant, which means that in order to make BC dates compliant to ISO 8601/XSD 1.1, 
			a year should be added mathematically so that 1 BC is "0000" in the JSON output -->
		<xsl:choose>
			<xsl:when test="substring($date, 1, 1) = '-'">
				
				<xsl:variable name="pieces" select="tokenize(substring($date, 2), '-')"/>				
				<xsl:variable name="new-year" select="format-number((number($pieces[1]) * -1) + 1, '0000')"/>
				
				<xsl:value-of select="$new-year"/>
				<xsl:if test="string($pieces[2])">
					<xsl:value-of select="concat('-', $pieces[2])"/>
				</xsl:if>
				<xsl:if test="string($pieces[3])">
					<xsl:value-of select="concat('-', $pieces[3])"/>
				</xsl:if>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$date"/>
			</xsl:otherwise>
		</xsl:choose>		
	</xsl:function>
	
	
	<!-- ********************************** TEMPLATES ************************************ -->
	<xsl:template name="kerameikos:evaluateDatatype">
		<xsl:param name="val"/>
		
		<xsl:choose>
			<!-- metadata fields must be a string -->
			<xsl:when test="ancestor::metadata or self::label">
				<xsl:value-of select="concat('&#x022;', replace($val, '&#x022;', '\\&#x022;'), '&#x022;')"/>
			</xsl:when>
			<xsl:when test="number($val)">
				<xsl:value-of select="$val"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="concat('&#x022;', replace($val, '&#x022;', '\\&#x022;'), '&#x022;')"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>
