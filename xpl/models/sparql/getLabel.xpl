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

	<!-- generator config for URL generator -->
	<p:processor name="oxf:unsafe-xslt">
		<p:input name="request" href="#request"/>
		<p:input name="data" href="../../../config.xml"/>
		<p:input name="config">
			<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema">
				<!-- request parameters -->
				<xsl:param name="uri" select="doc('input:request')/request/parameters/parameter[name='uri']/value"/>
				<xsl:param name="lang" select="doc('input:request')/request/parameters/parameter[name='lang']/value"/>
				<xsl:variable name="langStr" select="if (string($lang)) then $lang else 'en'"/>

				<!-- config variables -->
				<xsl:variable name="sparql_endpoint" select="/config/sparql/query"/>

				<xsl:variable name="query"><![CDATA[
PREFIX rdf:      <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX kid:	<https://kerameikos.org/id/>
PREFIX kon:	<https://kerameikos.org/ontology#>
PREFIX skos:      <http://www.w3.org/2004/02/skos/core#>						
SELECT ?label WHERE {
%URI% skos:prefLabel ?label FILTER(langMatches(lang(?label), "LANG"))}]]></xsl:variable>

				<xsl:variable name="service">
					<xsl:choose>
						<xsl:when test="matches($uri, 'https?://')">
							<xsl:value-of
								select="concat($sparql_endpoint, '?query=', encode-for-uri(normalize-space(replace(replace($query, 'LANG', $langStr), '%URI%', concat('&lt;', $uri, '&gt;')))), '&amp;output=xml')"
							/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of
								select="concat($sparql_endpoint, '?query=', encode-for-uri(normalize-space(replace(replace($query, 'LANG', $langStr), '%URI%', $uri))), '&amp;output=xml')"
							/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>

				<xsl:template match="/">
					<config>
						<url>
							<xsl:value-of select="$service"/>
						</url>
						<content-type>application/xml</content-type>
						<encoding>utf-8</encoding>
					</config>
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
