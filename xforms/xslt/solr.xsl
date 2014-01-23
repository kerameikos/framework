<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xhtml="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:datetime="http://exslt.org/dates-and-times"
	xmlns:foaf="http://xmlns.com/foaf/0.1" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:dbpedia-owl="http://dbpedia.org/ontology/"
	xmlns:skos="http://www.w3.org/2004/02/skos/core#" xmlns:owl="http://www.w3.org/2002/07/owl#" xmlns:crm="http://erlangen-crm.org/current/"
	xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:dcterms="http://purl.org/dc/terms/" exclude-result-prefixes="#all" version="2.0">
	<xsl:output method="xml" media-type="text/xml" encoding="UTF-8"/>

	<xsl:template match="/">
		<add>
			<xsl:apply-templates select="/rdf:RDF/*"/>
		</add>
	</xsl:template>

	<xsl:template match="/rdf:RDF/*">
		<doc>
			<xsl:variable name="id" select="substring-after(@rdf:about, 'id/')"/>
			<field name="id">
				<xsl:value-of select="$id"/>
			</field>
			<field name="prefLabel">
				<xsl:value-of select="skos:prefLabel[@xml:lang='en']"/>
			</field>
			<field name="definition">
				<xsl:value-of select="skos:definition[@xml:lang='en']"/>
			</field>
			<xsl:for-each select="skos:prefLabel|skos:altLabel">
				<field name="label">
					<xsl:value-of select="."/>
				</field>
			</xsl:for-each>
			<xsl:for-each select="owl:sameAs|skos:related">
				<field name="{local-name()}">
					<xsl:value-of select="@rdf:resource"/>
				</field>
				<xsl:if test="contains(@rdf:resource, 'pleiades.stoa.org')">
					<field name="pleiades_uri">
						<xsl:value-of select="@rdf:resource"/>
					</field>
				</xsl:if>
			</xsl:for-each>
			<field name="timestamp">
				<xsl:variable name="timestamp" select="datetime:dateTime()"/>
				<xsl:choose>
					<xsl:when test="contains($timestamp, 'Z')">
						<xsl:value-of select="$timestamp"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="concat($timestamp, 'Z')"/>
					</xsl:otherwise>
				</xsl:choose>
			</field>
			<field name="text">
				<xsl:value-of select="$id"/>
				<xsl:text> </xsl:text>
				<xsl:for-each select="descendant-or-self::node()">
					<xsl:value-of select="text()"/>
					<xsl:text> </xsl:text>
					<xsl:if test="string(@resource)">
						<xsl:value-of select="@resource"/>
						<xsl:text> </xsl:text>
					</xsl:if>
				</xsl:for-each>
			</field>
		</doc>
	</xsl:template>
</xsl:stylesheet>
