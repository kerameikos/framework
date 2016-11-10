<?xml version="1.0" encoding="UTF-8"?>
<!--
	XPL handling SPARQL queries from Fuseki	
-->
<p:config xmlns:p="http://www.orbeon.com/oxf/pipeline" xmlns:oxf="http://www.orbeon.com/oxf/processors">

	<p:param type="input" name="data"/>
	<p:param type="output" name="data"/>

	<p:processor name="oxf:request">
		<p:input name="config">
			<config>
				<include>/request</include>
			</config>
		</p:input>
		<p:output name="data" id="request"/>
	</p:processor>
	
	<!-- get query from a text file on disk -->
	<p:processor name="oxf:url-generator">
		<p:input name="config">
			<config>
				<url>oxf:/apps/kerameikos/ui/sparql/facets.sparql</url>
				<content-type>text/plain</content-type>
				<encoding>utf-8</encoding>
			</config>
		</p:input>
		<p:output name="data" id="query"/>
	</p:processor>
	
	<p:processor name="oxf:text-converter">		
		<p:input name="data" href="#query"/>
		<p:input name="config">
			<config/>
		</p:input>
		<p:output name="data" id="query-document"/>
	</p:processor>

	<!-- develop config for URL generator for the main SPARQL-based distribution query -->
	<p:processor name="oxf:unsafe-xslt">
		<p:input name="query" href="#query-document"/>
		<p:input name="request" href="#request"/>
		<p:input name="data" href="../../../config.xml"/>
		<p:input name="config">
			<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema">
				<!-- request parameters -->
				<xsl:param name="filter" select="doc('input:request')/request/parameters/parameter[name='filter']/value"/>
				<xsl:param name="facet" select="doc('input:request')/request/parameters/parameter[name='facet']/value"/>
				
				<!-- config variables -->
				<xsl:variable name="sparql_endpoint" select="/config/sparql/query"/>
				<xsl:variable name="query" select="doc('input:query')"/>

				<xsl:variable name="statements" as="element()*">
					<statements>
						<xsl:if
							test="(contains($filter,'period') or contains($filter,'workshop') or contains($filter,'person') or contains($filter,'productionPlace')) or ($facet = 'period' or $facet = 'workshop' or $facet='person' or $facet='productionPlace')">
							<triple s="?object" p="crm:P108i_was_produced_by" o="?prod"/>
						</xsl:if>
						
						<!-- parse filters -->
						<xsl:for-each select="tokenize($filter, ';')">
							<xsl:variable name="property" select="substring-before(normalize-space(.), ' ')"/>
							<xsl:variable name="object" select="substring-after(normalize-space(.), ' ')"/>
							<xsl:choose>
								<xsl:when test="$property = 'keeper'">
									<triple s="?object" p="crm:P50_has_current_keeper" o="{$object}"/>
								</xsl:when>
								<xsl:when test="$property = 'material'">
									<xsl:variable name="id" select="position()"/>
									
									<select id="{$id}">
										<triple s="{$object}" p="skos:exactMatch" o="?{$id}"/>
									</select>
									<triple s="?object" p="crm:P45_consists_of" o="?{$id}"/>
								</xsl:when>
								<xsl:when test="$property = 'period'">
									<xsl:variable name="id" select="position()"/>
									
									<select id="{$id}">
										<triple s="{$object}" p="skos:exactMatch" o="?{$id}"/>
									</select>
									<triple s="?prod" p="crm:P10_falls_within" o="?{$id}"/>
								</xsl:when>
								<xsl:when test="$property = 'person' or $property='workshop'">
									<xsl:variable name="id" select="position()"/>
									
									<select id="{$id}">
										<triple s="{$object}" p="skos:exactMatch" o="?{$id}"/>
									</select>
									<triple s="?prod" p="crm:P14_carried_out_by" o="?{$id}"/>
								</xsl:when>
								<xsl:when test="$property = 'productionPlace'">
									<xsl:variable name="id" select="position()"/>
									
									<select id="{$id}">
										<triple s="{$object}" p="skos:exactMatch" o="?{$id}"/>
									</select>
									<triple s="?prod" p="crm:P7_took_place_at" o="?{$id}"/>
								</xsl:when>
								<xsl:when test="$property = 'shape'">
									<xsl:variable name="id" select="position()"/>
									
									<select id="{$id}">
										<triple s="{$object}" p="skos:exactMatch" o="?{$id}"/>
									</select>
									<triple s="?object" p="kon:hasShape" o="?{$id}"/>
								</xsl:when>
								<xsl:when test="$property = 'technique'">
									<xsl:variable name="id" select="position()"/>
									
									<select id="{$id}">
										<triple s="{$object}" p="skos:exactMatch" o="?{$id}"/>
									</select>
									<triple s="?object" p="crm:P32_used_general_technique" o="?{$id}"/>
								</xsl:when>
								<xsl:when test="$property = 'from'">
									<xsl:if test="$object castable as xs:integer">
										<xsl:variable name="gYear" select="format-number(number($object), '0000')"/>
										
										<triple s="?coinType" p="nmo:hasStartDate" o="?startDate">
											<xsl:attribute name="filter">
												<xsl:text>(?startDate >= "</xsl:text>
												<xsl:value-of select="$gYear"/>
												<xsl:text>"^^xsd:gYear)</xsl:text>
											</xsl:attribute>
										</triple>
									</xsl:if>
								</xsl:when>
								<xsl:when test="$property = 'to'">
									<xsl:if test="$object castable as xs:integer">
										<xsl:variable name="gYear" select="format-number(number($object), '0000')"/>
										
										<triple s="?coinType" p="nmo:hasEndDate" o="?endDate">
											<xsl:attribute name="filter">
												<xsl:text>(?endDate &lt;= "</xsl:text>
												<xsl:value-of select="$gYear"/>
												<xsl:text>"^^xsd:gYear)</xsl:text>
											</xsl:attribute>
										</triple>
									</xsl:if>
								</xsl:when>
							</xsl:choose>
						</xsl:for-each>
						
						<!-- facet -->
						<xsl:choose>
							<xsl:when test="$facet='keeper'">
								<triple s="?object" p="crm:P50_has_current_keeper" o="?facet"/>
							</xsl:when>
							<xsl:when test="$facet='material'">
								<triple s="?object" p="crm:P45_consists_of" o="?facet"/>
							</xsl:when>
							<xsl:when test="$facet='period'">
								<triple s="?prod" p="crm:P10_falls_within" o="?facet"/>
							</xsl:when>
							<xsl:when test="$facet='person' or $facet='workshop'">
								<triple s="?prod" p="crm:P14_carried_out_by" o="?facet"/>
							</xsl:when>
							<xsl:when test="$facet='productionPlace'">
								<triple s="?prod" p="crm:P7_took_place_at" o="?facet"/>
							</xsl:when>
							<xsl:when test="$facet='shape'">
								<triple s="?object" p="kon:hasShape" o="?facet"/>
							</xsl:when>
							<xsl:when test="$facet='technique'">
								<triple s="?object" p="crm:P32_used_general_technique" o="?facet"/>
							</xsl:when>
						</xsl:choose>						
					</statements>
				</xsl:variable>
				
				<xsl:variable name="statementsSPARQL">
					<xsl:apply-templates select="$statements/*"/>
				</xsl:variable>

				<xsl:variable name="service">
					<xsl:value-of
						select="concat($sparql_endpoint, '?query=', encode-for-uri(replace($query, '%STATEMENTS%', $statementsSPARQL)), '&amp;output=xml')"
					/>
				</xsl:variable>

				<xsl:template match="/">
					<config>
						<url>
							<!--<xsl:copy-of select="$statementsSPARQL"/>-->
							<xsl:value-of select="$service"/>
						</url>
						<content-type>application/xml</content-type>
						<encoding>utf-8</encoding>
					</config>
				</xsl:template>
				
				<xsl:template match="select">
					<xsl:text>{ SELECT </xsl:text>
					<xsl:value-of select="concat('?', @id)"/>
					<xsl:text> WHERE { </xsl:text>
					<xsl:apply-templates select="triple|group"/>
					<xsl:text>}}&#x0A;</xsl:text>
				</xsl:template>
				
				<xsl:template match="triple">
					<xsl:value-of select="concat(@s, ' ', @p, ' ', @o, if (@filter) then concat(' FILTER ', @filter) else '', '.')"/>
					<xsl:if test="not(parent::union)">
						<xsl:text>&#x0A;</xsl:text>
					</xsl:if>
				</xsl:template>
				
				<xsl:template match="optional">
					<xsl:text>OPTIONAL {</xsl:text>
					<xsl:apply-templates select="triple"/>
					<xsl:text>}&#x0A;</xsl:text>
				</xsl:template>
				
				<xsl:template match="group">
					<xsl:apply-templates select="triple"/>
				</xsl:template>
				
				<xsl:template match="union">
					<xsl:for-each select="triple|group">
						<xsl:if test="position() &gt; 1">
							<xsl:text>UNION </xsl:text>
						</xsl:if>
						<xsl:text>{</xsl:text>
						<xsl:apply-templates select="self::node()"/>
						<xsl:text>}&#x0A;</xsl:text>
					</xsl:for-each>
				</xsl:template>
			</xsl:stylesheet>
		</p:input>
		<p:output name="data" id="url-generator-config"/>
	</p:processor>

	<!-- get the data from fuseki -->
	<p:processor name="oxf:url-generator">
		<p:input name="config" href="#url-generator-config"/>
		<p:output name="data" ref="data"/>
	</p:processor>
</p:config>
