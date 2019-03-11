<?xml version="1.0" encoding="UTF-8"?>
<!-- Author: Ethan Gruber
	Date: January 2019
	Function: Use the Orbeon directory-scanner processor to get a listing of all RDF files in the data_path (as of Orbeon 2018: oxf:/). Aggregate into one RDF/XML file
-->
<p:config xmlns:p="http://www.orbeon.com/oxf/pipeline" xmlns:oxf="http://www.orbeon.com/oxf/processors">

	<p:param type="input" name="data"/>
	<p:param type="output" name="data"/>

	<!-- create the directory scanner config -->
	<p:processor name="oxf:unsafe-xslt">
		<p:input name="data" href="../../../config.xml"/>
		<p:input name="config">
			<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
				<xsl:variable name="directory" select="/config/data_path"/>

				<xsl:template match="/">
					<config>
						<base-directory>
							<xsl:value-of select="$directory"/>
						</base-directory>
						<include>**/*.rdf</include>
						<case-sensitive>true</case-sensitive>
					</config>
				</xsl:template>
			</xsl:stylesheet>
		</p:input>
		<p:output name="data" id="directory-config"/>
	</p:processor>

	<p:processor name="oxf:directory-scanner">
		<p:input name="config" href="#directory-config"/>
		<p:output name="data" id="directory-scan"/>
	</p:processor>

	<p:processor name="oxf:unsafe-xslt">
		<p:input name="data" href="#directory-scan"/>
		<p:input name="config-xml" href="../../../config.xml"/>
		
		<p:input name="config">
			<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xsl xs p oxf"
				xmlns:foaf="http://xmlns.com/foaf/0.1/" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:prov="http://www.w3.org/ns/prov#"
				xmlns:skos="http://www.w3.org/2004/02/skos/core#" xmlns:crm="http://www.cidoc-crm.org/cidoc-crm/" xmlns:owl="http://www.w3.org/2002/07/owl#"
				xmlns:edm="http://www.europeana.eu/schemas/edm/" xmlns:geo="http://www.w3.org/2003/01/geo/wgs84_pos#" xmlns:dcterms="http://purl.org/dc/terms/"
				xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#" xmlns:xsd="http://www.w3.org/2001/XMLSchema#" xmlns:kid="http://kerameikos.org/id/"
				xmlns:kon="http://kerameikos.org/ontology#" xmlns:org="http://www.w3.org/ns/org#" xmlns:un="http://www.owl-ontologies.com/Ontology1181490123.owl#"
				xmlns:osgeo="http://data.ordnancesurvey.co.uk/ontology/geometry/" xmlns:ontolex="http://www.w3.org/ns/lemon/ontolex#"
				xmlns:lexinfo="http://www.lexinfo.net/ontology/2.0/lexinfo#" version="2.0">

				<xsl:variable name="data_path" select="doc('input:config-xml')/config/data_path"/>

				<xsl:template match="/">
					<rdf:RDF>
						<xsl:for-each select="descendant::file">
							<xsl:copy-of select="document(concat($data_path, '/', @path))/rdf:RDF/*"/>
						</xsl:for-each>
					</rdf:RDF>
				</xsl:template>
			</xsl:stylesheet>
		</p:input>
		<p:output name="data" ref="data"/>
	</p:processor>
</p:config>
