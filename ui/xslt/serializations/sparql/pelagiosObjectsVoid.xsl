<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:res="http://www.w3.org/2005/sparql-results#"
	xmlns:pelagios="http://pelagios.github.io/vocab/terms#" xmlns:relations="http://pelagios.github.io/vocab/relations#" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
	xmlns:void="http://rdfs.org/ns/void#" xmlns:dcterms="http://purl.org/dc/terms/" xmlns:oa="http://www.w3.org/ns/oa#" xmlns:xsd="http://www.w3.org/2001/XMLSchema#"
	xmlns:foaf="http://xmlns.com/foaf/0.1/" exclude-result-prefixes="#all" version="2.0">

	<xsl:variable name="url" select="/content/config/url"/>
	<xsl:variable name="perPage" select="5000"/>

	<xsl:template match="/">
		<rdf:RDF xmlns:skos="http://www.w3.org/2004/02/skos/core#" xmlns:kid="https://kerameikos.org/id/" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
			xmlns:dcterms="http://purl.org/dc/terms/" xmlns:void="http://rdfs.org/ns/void#" xmlns:foaf="http://xmlns.com/foaf/0.1/" xmlns:oac="http://www.openannotation.org/ns/"
			xmlns:owl="http://www.w3.org/2002/07/owl#">
			<void:Dataset rdf:about="{$url}#objects">
				<dcterms:title>Kerameikos.org Partner Objects</dcterms:title>
				<dcterms:description>Pleiades annotations relating to ceramics of Kerameikos.org partners, made available through semantic reasoning between typologies, Kerameikos SKOS
					concepts, and Pleiades URIs. Organizations that directly contribute to Pelagios are supressed from this data dump.</dcterms:description>
				<dcterms:rights>Kerameikos integrates objects from archaeological and museum databases that have varying degrees of open licensing. See the dcterms:license within
					void:subsets for specific conditions.</dcterms:rights>
				<dcterms:subject rdf:resource="http://dbpedia.org/resource/Annotation"/>

				<xsl:apply-templates select="/content/res:sparql[1]/descendant::res:result" mode="void:subset"/>

				<xsl:call-template name="dumps">
					<xsl:with-param name="count" select="/content/res:sparql[2]//res:binding[@name = 'count']/res:literal"/>
				</xsl:call-template>
			</void:Dataset>

			<xsl:apply-templates select="/content/res:sparql[1]/descendant::res:result" mode="void:Dataset"/>


		</rdf:RDF>
	</xsl:template>

	<xsl:template match="res:result" mode="void:subset">
		<void:subset rdf:resource="{res:binding[@name='dataset']/res:uri}"/>
	</xsl:template>

	<xsl:template match="res:result" mode="void:Dataset">
		<void:Dataset rdf:about="{res:binding[@name='dataset']/res:uri}">
			<xsl:apply-templates
				select="res:binding[@name = 'title'] | res:binding[@name = 'description'] | res:binding[@name = 'publisher'] | res:binding[@name = 'license'] | res:binding[@name = 'rights']"
				mode="dcterms"/>
			<dcterms:isPartOf rdf:source="{$url}#objects"/>
		</void:Dataset>
	</xsl:template>

	<xsl:template match="res:binding" mode="dcterms">
		<xsl:element name="dcterms:{@name}" namespace="http://purl.org/dc/terms/">
			<xsl:choose>
				<xsl:when test="res:uri">
					<xsl:attribute name="rdf:resource" select="res:uri"/>
				</xsl:when>
				<xsl:when test="res:literal">
					<xsl:if test="res:literal/@xml:lang">
						<xsl:attribute name="xml:lang" select="res:literal/@xml:lang"/>
					</xsl:if>
					<xsl:value-of select="res:literal"/>
				</xsl:when>
			</xsl:choose>
		</xsl:element>
	</xsl:template>

	<xsl:template name="dumps">
		<xsl:param name="count"/>

		<xsl:variable name="max" select="xs:integer(floor($count div $perPage))"/>

		<void:documents>
			<xsl:value-of select="$count"/>
		</void:documents>
		<xsl:for-each select="0 to $max">
			<void:dataDump rdf:resource="{$url}pelagios-objects.{.}.rdf"/>
		</xsl:for-each>
	</xsl:template>


</xsl:stylesheet>
