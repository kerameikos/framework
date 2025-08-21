<?xml version="1.0" encoding="UTF-8"?>
<!--
	Author: Ethan Gruber
	Date: May 2021
	Function: Serialize RDF/XML from a SPARQL DESCRIBE query of a single object URI into a human-readable view
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
				<url>oxf:/apps/kerameikos/ui/sparql/getObject.sparql</url>
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
	
	<!-- read the LOD vocab URIs from the RDF/XML and execute API calls in order to generate one large RDF block -->
	<p:processor name="oxf:unsafe-xslt">
		<p:input name="data" href="#data"/>		
		<p:input name="config">
			<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema"
				xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
				
				<xsl:template match="/">
					<rdf:RDF xmlns:foaf="http://xmlns.com/foaf/0.1/" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:prov="http://www.w3.org/ns/prov#"
						xmlns:skos="http://www.w3.org/2004/02/skos/core#" xmlns:crm="http://www.cidoc-crm.org/cidoc-crm/"
						xmlns:edm="http://www.europeana.eu/schemas/edm/" xmlns:geo="http://www.w3.org/2003/01/geo/wgs84_pos#"
						xmlns:dcterms="http://purl.org/dc/terms/" xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#" xmlns:xsd="http://www.w3.org/2001/XMLSchema#"
						xmlns:kid="https://kerameikos.org/id/" xmlns:kon="https://kerameikos.org/ontology#" xmlns:org="http://www.w3.org/ns/org#"
						xmlns:un="http://www.owl-ontologies.com/Ontology1181490123.owl#" xmlns:osgeo="http://data.ordnancesurvey.co.uk/ontology/geometry/"
						xmlns:ontolex="http://www.w3.org/ns/lemon/ontolex#" xmlns:lexinfo="http://www.lexinfo.net/ontology/2.0/lexinfo#">
						
						<!-- aggregate distinct Nomisma URIs and perform an API lookup to get the RDF for all of them -->
						<xsl:variable name="id-param">
							<xsl:for-each
								select="
								distinct-values(descendant::*[contains(@rdf:resource, 'kerameikos.org')]/@rdf:resource)">
								<xsl:value-of select="substring-after(., 'id/')"/>
								<xsl:if test="not(position() = last())">
									<xsl:text>|</xsl:text>
								</xsl:if>
							</xsl:for-each>
						</xsl:variable>
						
						<xsl:variable name="id-url" select="concat('https://kerameikos.org/apis/getRdf?identifiers=', encode-for-uri($id-param))"/>
						
						<xsl:if test="doc-available($id-url)">
							<xsl:copy-of select="document($id-url)/rdf:RDF/*"/>
						</xsl:if>						
					</rdf:RDF>
				</xsl:template>
			</xsl:stylesheet>
		</p:input>
		<p:output name="data" id="rdf"/>
	</p:processor>
	
	
	<!-- serialize into HTML -->
	<p:processor name="oxf:unsafe-xslt">
		<p:input name="request" href="#request"/>
		<p:input name="query" href="#query-document"/>
		<p:input name="data" href="aggregate('content', #data, ../../../../config.xml)"/>		
		<p:input name="rdf" href="#rdf"/>
		<p:input name="config" href="../../../../ui/xslt/serializations/sparql/object-html.xsl"/>
		<p:output name="data" id="model"/>
	</p:processor>
	
	<p:processor name="oxf:html-converter">
		<p:input name="data" href="#model"/>
		<p:input name="config">
			<config>
				<version>5.0</version>
				<indent>true</indent>
				<content-type>text/html</content-type>
				<encoding>utf-8</encoding>
				<indent-amount>4</indent-amount>
			</config>
		</p:input>
		<p:output name="data" ref="data"/>
	</p:processor>
</p:config>
