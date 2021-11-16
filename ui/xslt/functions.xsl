<?xml version="1.0" encoding="UTF-8"?>

<!-- kerameikos.org XSLT functions -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:kerameikos="http://kerameikos.org/"
	xmlns:skos="http://www.w3.org/2004/02/skos/core#" exclude-result-prefixes="#all" version="2.0">

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

		<xsl:variable name="year" select="
				if (substring($date, 1, 1) = '-') then
					substring($date, 1, 5)
				else
					substring($date, 1, 4)"/>
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
				<xsl:value-of select="abs(number($year))"/>
				<xsl:text> BCE</xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="number($year)"/>
				<xsl:if test="number($year) &lt;= 400">
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

	<!-- turn rdf properties into human-readable labels. If a label for a particular label is not translated, the function will re-run in English -->
	<xsl:function name="kerameikos:normalizeCurie">
		<xsl:param name="curie"/>
		<xsl:param name="lang"/>

		<xsl:choose>
			<xsl:when test="$lang = 'fr'">
				<xsl:choose>

					<!-- properties -->
					<xsl:when test="$curie = 'kon:hasShape'">Forme</xsl:when>

					<xsl:otherwise>
						<xsl:value-of select="kerameikos:normalizeCurie($curie, 'en')"/>
					</xsl:otherwise>
				</xsl:choose>

			</xsl:when>
			<xsl:otherwise>
				<xsl:choose>
					<!-- classes -->
					<xsl:when test="$curie = 'crm:E52_Time-Span'">Time Span</xsl:when>
					<xsl:when test="$curie = 'crm:E53_Place'">Production Place</xsl:when>

					<!-- properties -->
					<xsl:when test="$curie = 'crm:P4_has_time-span'">Time Span</xsl:when>
					<xsl:when test="$curie = 'crm:P7_took_place_at'">Production Place</xsl:when>
					<xsl:when test="$curie = 'crm:P10_falls_within'">Period</xsl:when>
					<xsl:when test="$curie = 'crm:P14_carried_out_by'">Artist</xsl:when>
					<xsl:when test="$curie = 'crm:P32_used_general_technique'">Technique</xsl:when>
					<xsl:when test="$curie = 'crm:P45_consists_of'">Material</xsl:when>
					<xsl:when test="$curie = 'crm:P50_has_current_keeper'">Current Keeper</xsl:when>
					<xsl:when test="$curie = 'edm:begin'">Begin</xsl:when>
					<xsl:when test="$curie = 'edm:end'">End</xsl:when>
					<xsl:when test="$curie = 'geo:lat'">Latitude</xsl:when>
					<xsl:when test="$curie = 'geo:long'">Longitude</xsl:when>
					<xsl:when test="$curie = 'dcterms:isPartOf'">Part Of</xsl:when>
					<xsl:when test="$curie = 'dcterms:source'">Reference</xsl:when>
					<xsl:when test="$curie = 'kon:hasShape'">Shape</xsl:when>
					<xsl:when test="$curie = 'lexinfo:plural'">Plural Form</xsl:when>
					<xsl:when test="$curie = 'org:role'">Role</xsl:when>
					<xsl:when test="$curie = 'osgeo:asGeoJSON'">GeoJSON</xsl:when>
					<xsl:when test="$curie = 'org:organization'">Organization</xsl:when>
					<xsl:when test="$curie = 'skos:prefLabel'">Preferred Label</xsl:when>
					<xsl:when test="$curie = 'skos:altLabel'">Alternate Label</xsl:when>
					<xsl:when test="$curie = 'skos:broader'">Broader Concept</xsl:when>
					<xsl:when test="$curie = 'skos:changeNote'">Change Note</xsl:when>
					<xsl:when test="$curie = 'skos:closeMatch'">Close Match</xsl:when>
					<xsl:when test="$curie = 'skos:exactMatch'">Exact Match</xsl:when>
					<xsl:when test="$curie = 'skos:related'">Related Entity</xsl:when>

					<xsl:otherwise>
						<xsl:variable name="localName" select="substring-after($curie, ':')"/>

						<xsl:value-of select="concat(upper-case(substring($localName, 1, 1)), substring($localName, 2))"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:function>
	
	<!-- normalize user interface keys and field names into multilingual labels -->
	<xsl:function name="kerameikos:normalizeField">
		<xsl:param name="field"/>
		<xsl:param name="lang"/>
		
		<xsl:choose>
			<xsl:when test="$lang = 'fr'">
				<xsl:choose>
					<xsl:when test="$field = 'depth'">Profondeur</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="kerameikos:normalizeField($field, 'en')"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>
				<xsl:choose>
					<xsl:when test="$field = 'depth'">Depth</xsl:when>
					<xsl:when test="$field = 'height'">Height</xsl:when>
					<xsl:when test="$field = 'identifier'">Identifier</xsl:when>
					<xsl:when test="$field = 'weight'">Weight</xsl:when>
					<xsl:when test="$field = 'width'">Width</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="concat(upper-case(substring($field, 1, 1)), substring($field, 2))"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
		
	</xsl:function>

	<!-- ************** PARSE ACCEPT-LANGUAGE FROM HTTP HEADER ************** -->
	<xsl:function name="kerameikos:parseAcceptLanguage">
		<xsl:param name="lang"/>

		<xsl:variable name="languages" as="item()*">
			<xsl:choose>
				<xsl:when test="contains($lang, 'q=')">
					<xsl:analyze-string select="$lang" regex="([^;]+);q=[0-1]\.[0-9],?">
						<xsl:matching-substring>
							<xsl:for-each select="regex-group(1)">
								<xsl:for-each select="tokenize(., ',')">
									<xsl:value-of
										select="
											if (contains(., '-')) then
												substring-before(., '-')
											else
												."/>
								</xsl:for-each>
							</xsl:for-each>
						</xsl:matching-substring>
					</xsl:analyze-string>
				</xsl:when>
				<xsl:when test="string-length($lang) &gt; 0">
					<xsl:for-each select="tokenize($lang, ',')">
						<xsl:value-of select="
								if (contains(., '-')) then
									substring-before(., '-')
								else
									."/>
					</xsl:for-each>
				</xsl:when>
			</xsl:choose>

		</xsl:variable>

		<xsl:sequence select="distinct-values($languages)"/>
	</xsl:function>

	<!-- get the Kerameikos preferred label from the $rdf variable, depending on the languaged passed by HTTP header or URL param -->
	<xsl:function name="kerameikos:getRDFLabel">
		<xsl:param name="rdf" as="element()*"/>
		<xsl:param name="lang"/>
		<xsl:choose>
			<xsl:when test="string($lang)">
				<xsl:choose>
					<xsl:when test="$rdf/skos:prefLabel[@xml:lang = $lang][1]">
						<xsl:value-of select="$rdf/skos:prefLabel[@xml:lang = $lang][1]"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="$rdf/skos:prefLabel[@xml:lang = 'en'][1]"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$rdf/skos:prefLabel[@xml:lang = 'en']"/>
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
