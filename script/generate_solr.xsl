<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:foaf="http://xmlns.com/foaf/0.1/" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
	xmlns:dbpedia-owl="http://dbpedia.org/ontology/" xmlns:skos="http://www.w3.org/2004/02/skos/core#" xmlns:owl="http://www.w3.org/2002/07/owl#"
	xmlns:ecrm="http://erlangen-crm.org/current/" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:dcterms="http://purl.org/dc/terms/"
	xmlns:kid="http://kerameikos.org/id/" xmlns:kon="http://kerameikos.org/ontology#" version="2.0">
	<xsl:output encoding="UTF-8" indent="yes"/>

	<xsl:include href="../xforms/xslt/solr-doc.xsl"/>

	<xsl:template match="/">
		<add>
			<xsl:for-each select="collection('file:///usr/local/projects/ceramic-ids/id/?select=*.xml')">
				<xsl:apply-templates select="document(document-uri(.))/rdf:RDF/*" mode="generateDoc"/>
			</xsl:for-each>
		</add>
	</xsl:template>

</xsl:stylesheet>
