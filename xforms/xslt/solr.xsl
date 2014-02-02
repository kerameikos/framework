<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:datetime="http://exslt.org/dates-and-times"
	xmlns:foaf="http://xmlns.com/foaf/0.1" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:dbpedia-owl="http://dbpedia.org/ontology/"
	xmlns:skos="http://www.w3.org/2004/02/skos/core#" xmlns:owl="http://www.w3.org/2002/07/owl#" xmlns:crm="http://erlangen-crm.org/current/"
	xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:dcterms="http://purl.org/dc/terms/" exclude-result-prefixes="#all" version="2.0">
	
	<xsl:include href="solr-doc.xsl"/>

	<xsl:template match="/">
		<add>
			<xsl:apply-templates select="/rdf:RDF/*" mode="generateDoc"/>
		</add>
	</xsl:template>
</xsl:stylesheet>
