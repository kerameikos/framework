<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xsl xs"
	xmlns:foaf="http://xmlns.com/foaf/0.1/" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:prov="http://www.w3.org/ns/prov#"
	xmlns:skos="http://www.w3.org/2004/02/skos/core#" xmlns:crm="http://www.cidoc-crm.org/cidoc-crm/" xmlns:geo="http://www.w3.org/2003/01/geo/wgs84_pos#"
	xmlns:dcterms="http://purl.org/dc/terms/" xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#" xmlns:xsd="http://www.w3.org/2001/XMLSchema#"
	xmlns:kid="http://kerameikos.org/id/" xmlns:kon="http://kerameikos.org/ontology#" xmlns:org="http://www.w3.org/ns/org#"
	xmlns:osgeo="http://data.ordnancesurvey.co.uk/ontology/geometry/" xmlns:un="http://www.owl-ontologies.com/Ontology1181490123.owl#" version="2.0">
	<xsl:variable name="data-path" select="/config/data_path"/>
	<xsl:param name="identifiers" select="doc('input:request')/request/parameters/parameter[name = 'identifiers']/value"/>

	<xsl:template match="/">
		<rdf:RDF>
			<xsl:for-each select="tokenize($identifiers, '\|')">
				<xsl:if test="doc-available(concat('file://', $data-path, '/id/', ., '.rdf'))">
					<xsl:copy-of select="document(concat('file://', $data-path, '/id/', ., '.rdf'))/rdf:RDF/*"/>
				</xsl:if>
			</xsl:for-each>
		</rdf:RDF>
	</xsl:template>

</xsl:stylesheet>
