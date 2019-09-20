<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:res="http://www.w3.org/2005/sparql-results#"
	xmlns:void="http://rdfs.org/ns/void#" xmlns:pelagios="http://pelagios.github.io/vocab/terms#" xmlns:relations="http://pelagios.github.io/vocab/relations#"
	xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:dcterms="http://purl.org/dc/terms/" xmlns:edm="http://www.europeana.eu/schemas/edm/"
	xmlns:svcs="http://rdfs.org/sioc/services#" xmlns:doap="http://usefulinc.com/ns/doap#" xmlns:oa="http://www.w3.org/ns/oa#"
	xmlns:xsd="http://www.w3.org/2001/XMLSchema#" xmlns:foaf="http://xmlns.com/foaf/0.1/" xmlns:crm="http://www.cidoc-crm.org/cidoc-crm/"
	exclude-result-prefixes="#all" version="2.0">

	<xsl:variable name="url" select="/content/config/url"/>
	<xsl:param name="page" select="tokenize(tokenize(doc('input:request')/request/request-url, '/')[last()], '\.')[2]"/>

	<xsl:template match="/">
		<rdf:RDF xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:dcterms="http://purl.org/dc/terms/" xmlns:oa="http://www.w3.org/ns/oa#"
			xmlns:xsd="http://www.w3.org/2001/XMLSchema#" xmlns:foaf="http://xmlns.com/foaf/0.1/" xmlns:void="http://rdfs.org/ns/void#"
			xmlns:edm="http://www.europeana.eu/schemas/edm/" xmlns:svcs="http://rdfs.org/sioc/services#" xmlns:doap="http://usefulinc.com/ns/doap#">

			<!-- suppress agent from any page but the first -->
			<xsl:if test="xs:integer($page) = 0">
				<foaf:Organization rdf:about="{$url}pelagios-objects.rdf#agents/me">
					<foaf:name>
						<xsl:value-of select="/content/config/title"/>
					</foaf:name>
				</foaf:Organization>
			</xsl:if>

			<xsl:apply-templates select="descendant::crm:E22_Man-Made_Object"/>
		</rdf:RDF>
	</xsl:template>

	<xsl:template match="crm:E22_Man-Made_Object">
		<xsl:variable name="uri" select="@rdf:about"/>

		<pelagios:AnnotatedThing rdf:about="{$url}pelagios-objects.rdf#{encode-for-uri($uri)}">

			<xsl:copy-of select="dcterms:title"/>

			<foaf:homepage rdf:resource="{$uri}"/>
			<xsl:if test="edm:begin and edm:end">
				<dcterms:temporal>
					<xsl:text>start=</xsl:text>
					<xsl:value-of select="number(edm:begin)"/>
					<xsl:text>; end=</xsl:text>
					<xsl:value-of select="number(edm:end)"/>
				</dcterms:temporal>
			</xsl:if>

			<!-- 3D model is edm:isShownBy -->
			<xsl:if
				test="crm:P138i_has_representation[descendant::dcterms:format = 'application/octet-stream' or descendant::dcterms:format/@rdf:resource = 'http://vocab.getty.edu/aat/300379693']">
				<edm:isShownBy
					rdf:resource="{crm:P138i_has_representation[descendant::dcterms:format = 'application/octet-stream' or descendant::dcterms:format/@rdf:resource = 'http://vocab.getty.edu/aat/300379693']/*/@rdf:about}"
				/>
			</xsl:if>

			<!-- apply-templates for static images or IIIF services -->
			<xsl:apply-templates
				select="crm:P138i_has_representation[descendant::dcterms:conformsTo/@rdf:resource = 'http://iiif.io/api/image' or descendant::dcterms:format = 'image/jpeg']"
				mode="image"/>

			<xsl:copy-of select="void:inDataset"/>
		</pelagios:AnnotatedThing>

		<oa:Annotation rdf:about="{$url}pelagios-objects.rdf#{encode-for-uri($uri)}/annotations/01">
			<oa:hasBody rdf:resource="{dcterms:coverage/@rdf:resource}#this"/>
			<oa:hasTarget rdf:resource="{$url}pelagios-objects.rdf#{encode-for-uri($uri)}"/>
			<pelagios:relation rdf:resource="http://pelagios.github.io/vocab/relations#attestsTo"/>
			<oa:annotatedBy rdf:resource="{$url}pelagios-objects.rdf#agents/me"/>
			<oa:annotatedAt rdf:datatype="http://www.w3.org/2001/XMLSchema#dateTime">
				<xsl:value-of select="current-dateTime()"/>
			</oa:annotatedAt>
		</oa:Annotation>

		<!-- *** Web Resources *** -->
		<!-- IIIF service -->
		<xsl:apply-templates select="crm:P138i_has_representation[descendant::dcterms:conformsTo/@rdf:resource = 'http://iiif.io/api/image']"
			mode="web-resource"/>

		<!-- 3D model -->
		<xsl:apply-templates
			select="crm:P138i_has_representation[descendant::dcterms:format = 'application/octet-stream' or descendant::dcterms:format/@rdf:resource = 'http://vocab.getty.edu/aat/300379693']"
			mode="web-resource"/>
	</xsl:template>

	<xsl:template match="crm:P138i_has_representation" mode="image">
		<xsl:choose>
			<xsl:when test="descendant::dcterms:conformsTo/@rdf:resource = 'http://iiif.io/api/image'">
				<foaf:thumbnail rdf:resource="{concat(*/@rdf:about, '/full/120,/0/default.jpg')}"/>
				<foaf:depiction rdf:resource="{concat(*/@rdf:about, '/full/800,/0/default.jpg')}"/>
			</xsl:when>
			<xsl:when test="descendant::dcterms:format = 'image/jpeg'">
				<foaf:depiction rdf:resource="{*/@rdf:about}"/>
			</xsl:when>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="crm:P138i_has_representation" mode="web-resource">
		<xsl:choose>
			<xsl:when test="descendant::dcterms:conformsTo/@rdf:resource = 'http://iiif.io/api/image'">
				<edm:WebResource rdf:about="{concat(*/@rdf:about, '/full/800,/0/default.jpg')}">
					<dcterms:isReferencedBy rdf:resource="{parent::node()/crm:P129i_is_subject_of/@rdf:resource}"/>
					<svcs:has_service rdf:resource="{*/@rdf:about}"/>
				</edm:WebResource>
				<svcs:Service rdf:about="{*/@rdf:about}">
					<dcterms:conformsTo rdf:resource="http://iiif.io/api/image"/>
					<doap:implements rdf:resource="http://iiif.io/api/image/2/level1.json"/>
				</svcs:Service>
			</xsl:when>
			<xsl:when
				test="descendant::dcterms:format = 'application/octet-stream' or descendant::dcterms:format/@rdf:resource = 'http://vocab.getty.edu/aat/300379693'">
				<edm:WebResource rdf:about="{*/@rdf:about}">
					<xsl:copy-of select="descendant::dcterms:format"/>
				</edm:WebResource>
			</xsl:when>
		</xsl:choose>

	</xsl:template>

	<xsl:template match="res:binding" mode="image">
		<xsl:element name="{if (@name = 'thumb') then 'foaf:thumbnail' else 'foaf:depiction'}" namespace="http://xmlns.com/foaf/0.1/">
			<xsl:attribute name="rdf:resource" select="res:uri"/>
		</xsl:element>
	</xsl:template>
</xsl:stylesheet>
