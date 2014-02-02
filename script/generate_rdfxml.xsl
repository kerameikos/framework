<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:foaf="http://xmlns.com/foaf/0.1/" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
	xmlns:dbpedia-owl="http://dbpedia.org/ontology/" xmlns:skos="http://www.w3.org/2004/02/skos/core#" xmlns:owl="http://www.w3.org/2002/07/owl#"
	xmlns:crm="http://erlangen-crm.org/current/" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:dcterms="http://purl.org/dc/terms/"
	xmlns:kid="http://kerameikos.org/id/" xmlns:kon="http://kerameikos.org/ontology#" version="2.0">
	<xsl:output encoding="UTF-8" indent="yes"/>

	<xsl:template match="/">
		<rdf:RDF xmlns:foaf="http://xmlns.com/foaf/0.1/" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
			xmlns:skos="http://www.w3.org/2004/02/skos/core#" xmlns:owl="http://www.w3.org/2002/07/owl#" xmlns:crm="http://erlangen-crm.org/current/"
			xmlns:geo="http://www.w3.org/2003/01/geo/wgs84_pos#" xmlns:dcterms="http://purl.org/dc/terms/" xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
			xmlns:xsd="http://www.w3.org/2001/XMLSchema#" xmlns:kid="http://kerameikos.org/id/" xmlns:kon="http://kerameikos.org/ontology#">
			<xsl:for-each select="collection('file:///usr/local/projects/ceramic-ids/id/?select=*.xml')">
				<xsl:copy-of select="document(document-uri(.))/rdf:RDF/*"/>
			</xsl:for-each>
		</rdf:RDF>
	</xsl:template>

</xsl:stylesheet>
