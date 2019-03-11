<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:dcterms="http://purl.org/dc/terms/"
	xmlns:kid="http://kerameikos.org/id/" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
	xmlns:org="http://www.w3.org/ns/org#" xmlns:skos="http://www.w3.org/2004/02/skos/core#" xmlns:geo="http://www.w3.org/2003/01/geo/wgs84_pos#"
	xmlns:kon="http://kerameikos.org/ontology#" xmlns:foaf="http://xmlns.com/foaf/0.1/" exclude-result-prefixes="#all" version="2.0">
	<xsl:include href="solr-templates.xsl"/>

	<xsl:variable name="data_path" select="/content/config/data_path"/>

	<!-- definition of namespaces for turning in solr type field URIs into abbreviations -->
	<xsl:variable name="namespaces" as="item()*">
		<namespaces>
			<xsl:for-each select="//rdf:RDF/namespace::*[not(name() = 'xml')]">
				<namespace prefix="{name()}" uri="{.}"/>
			</xsl:for-each>
		</namespaces>
	</xsl:variable>

	<xsl:variable name="roles" as="element()*">
		<roles>
			<xsl:for-each select="distinct-values(descendant::org:role[contains(@rdf:resource, 'kerameikos.org')]/@rdf:resource)">
				<xsl:variable name="id" select="substring-after(., 'id/')"/>

				<role uri="{.}">
					<xsl:value-of select="document(concat($data_path, '/id/', $id, '.rdf'))//skos:prefLabel[@xml:lang = 'en']"/>
				</role>
			</xsl:for-each>
		</roles>
	</xsl:variable>

	<xsl:template match="/">
		<add>
			<xsl:for-each select="//rdf:RDF/*[rdf:type/@rdf:resource = 'http://www.w3.org/2004/02/skos/core#Concept' and skos:inScheme/@rdf:resource='http://kerameikos.org/id/'][not(child::dcterms:isReplacedBy)]">
				<xsl:variable name="uri" select="@rdf:about"/>
				
				<xsl:apply-templates select="self::node()" mode="generateDoc">
					<xsl:with-param name="provenance" select="following-sibling::dcterms:ProvenanceStatement[foaf:topic/@rdf:resource = $uri]" as="node()*"/>
				</xsl:apply-templates>
			</xsl:for-each>
		</add>
	</xsl:template>
</xsl:stylesheet>
