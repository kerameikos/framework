<?xml version="1.0" encoding="UTF-8"?>
<!-- Author: Ethan Gruber
	Date: August 2020
	Function: Transform Kerameikos RDF into Linked Art JSON-LD. Query broader concepts -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:kerameikos="http://kerameikos.org/"
	xmlns:dcterms="http://purl.org/dc/terms/" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
	xmlns:skos="http://www.w3.org/2004/02/skos/core#" xmlns:geo="http://www.w3.org/2003/01/geo/wgs84_pos#" xmlns:foaf="http://xmlns.com/foaf/0.1/"
	xmlns:res="http://www.w3.org/2005/sparql-results#" xmlns:org="http://www.w3.org/ns/org#" xmlns:kon="http://kerameikos.org/ontology#"
	xmlns:edm="http://www.europeana.eu/schemas/edm/" xmlns:crm="http://www.cidoc-crm.org/cidoc-crm/" xmlns:prov="http://www.w3.org/ns/prov#"
	xmlns:crmdig="http://www.ics.forth.gr/isl/CRMdig/" exclude-result-prefixes="#all" version="2.0">
	<xsl:include href="../json/json-metamodel.xsl"/>
	<xsl:include href="../../functions.xsl"/>

	<!-- config variables -->
	<xsl:variable name="type" select="/content/rdf:RDF/*[1]/name()"/>
	<!--<xsl:variable name="conceptURI" select="/content/rdf:RDF/*[1]/@rdf:about"/>-->

	<!-- get dynasty/organization and skos:broader RDF -->
	<xsl:variable name="rdf" as="element()*">
		<rdf:RDF xmlns:dcterms="http://purl.org/dc/terms/" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
			xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#" xmlns:skos="http://www.w3.org/2004/02/skos/core#"
			xmlns:geo="http://www.w3.org/2003/01/geo/wgs84_pos#" xmlns:foaf="http://xmlns.com/foaf/0.1/" xmlns:org="http://www.w3.org/ns/org#"
			xmlns:kon="http://kerameikos.org/ontology#" xmlns:edm="http://www.europeana.eu/schemas/edm/" xmlns:crm="http://www.cidoc-crm.org/cidoc-crm/"
			xmlns:crmdig="http://www.ics.forth.gr/isl/CRMdig/">
			<xsl:variable name="id-param">
				<xsl:for-each select="
						distinct-values(descendant::org:organization/@rdf:resource | descendant::skos:broader/@rdf:resource)">
					<xsl:value-of select="substring-after(., 'id/')"/>
					<xsl:if test="not(position() = last())">
						<xsl:text>|</xsl:text>
					</xsl:if>
				</xsl:for-each>
			</xsl:variable>

			<xsl:variable name="rdf_url" select="concat('http://kerameikos.org/apis/getRdf?identifiers=', encode-for-uri($id-param))"/>
			<xsl:copy-of select="document($rdf_url)/rdf:RDF/*"/>
		</rdf:RDF>
	</xsl:variable>

	<xsl:template match="/">
		<xsl:variable name="model" as="element()*">
			<_object>
				<xsl:apply-templates select="/content/rdf:RDF/*[1]" mode="concept"/>
			</_object>
		</xsl:variable>

		<xsl:apply-templates select="$model"/>
	</xsl:template>

	<xsl:template match="*" mode="concept">
		<__context>https://linked.art/ns/v1/linked-art.json</__context>
		<id>
			<xsl:value-of select="@rdf:about"/>
		</id>
		<type>
			<xsl:choose>
				<xsl:when test="$type = 'crm:E21_Person'">Person</xsl:when>
				<xsl:when test="$type = 'crm:E74_Group'">Group</xsl:when>
				<xsl:when test="$type = 'crm:E4_Period'">Period</xsl:when>
				<xsl:when test="$type = 'crm:E57_Material'">Material</xsl:when>
				<xsl:when test="$type = 'crm:E53_Place'">Place</xsl:when>
				<xsl:when test="$type = 'skos:ConceptScheme'">AuthorityDocument</xsl:when>
				<xsl:otherwise>Type</xsl:otherwise>
			</xsl:choose>
		</type>
		<_label>
			<xsl:value-of select="
				if (rdfs:label) then
				rdfs:label
				else
				skos:prefLabel[@xml:lang = 'en']"/>
		</_label>

		<!--<xsl:if test="$type = 'nmo:Mint' or $type = 'nmo:Region'">
			<classified_as>
				<_array>
					<_object>
						<xsl:choose>
							<xsl:when test="$type = 'nmo:Mint'">
								<id>http://nomisma.org/id/mint</id>
								<_label>Mint</_label>
							</xsl:when>
							<xsl:when test="$type = 'nmo:Region'">
								<id>http://vocab.getty.edu/aat/300182722</id>
								<_label>regions (geographic)</_label>
							</xsl:when>
						</xsl:choose>
					</_object>
				</_array>
			</classified_as>
		</xsl:if>-->

		<identified_by>
			<_array>
				<_object>
					<type>Name</type>
					<content>
						<xsl:value-of select="
								if (rdfs:label) then
									rdfs:label
								else
									skos:prefLabel[@xml:lang = 'en']"/>
					</content>
					<classified_as>
						<_array>
							<_object>
								<id>http://vocab.getty.edu/aat/300404670</id>
								<type>Type</type>
								<_label>Primary Name</_label>
							</_object>
						</_array>
					</classified_as>
				</_object>
			</_array>
		</identified_by>
		<!-- creation and dissolution for Groups -->
		<xsl:if test="$type = 'crm:E74_Group'">
			<xsl:if test="/content/rdf:RDF/org:Membership[edm:begin]">
				<xsl:variable name="dates">
					<xsl:for-each select="//edm:begin">
						<xsl:sort data-type="number" order="ascending"/>

						<xsl:value-of select="."/>
					</xsl:for-each>
				</xsl:variable>

				<formed_by>
					<_object>
						<type>Formation</type>
						<_label>Start Date</_label>
						<timespan>
							<_object>
								<type>TimeSpan</type>
								<begin_of_the_begin>
									<xsl:value-of select="kerameikos:expandDate($dates[1], 'begin')"/>
								</begin_of_the_begin>
								<end_of_the_end>
									<xsl:value-of select="kerameikos:expandDate($dates[1], 'end')"/>
								</end_of_the_end>
							</_object>
						</timespan>
					</_object>
				</formed_by>
			</xsl:if>

			<xsl:if test="/content/rdf:RDF/org:Membership[edm:end]">
				<xsl:variable name="dates">
					<xsl:for-each select="//edm:end">
						<xsl:sort data-type="number" order="ascending"/>

						<xsl:value-of select="."/>
					</xsl:for-each>
				</xsl:variable>

				<dissolved_by>
					<_object>
						<type>Dissolution</type>
						<_label>End Date</_label>
						<timespan>
							<_object>
								<type>TimeSpan</type>
								<begin_of_the_begin>
									<xsl:value-of select="kerameikos:expandDate($dates[last()], 'begin')"/>
								</begin_of_the_begin>
								<end_of_the_end>
									<xsl:value-of select="kerameikos:expandDate($dates[last()], 'end')"/>
								</end_of_the_end>
							</_object>
						</timespan>
					</_object>
				</dissolved_by>
			</xsl:if>
		</xsl:if>

		<!-- insert skos:definitions -->
		<xsl:if test="skos:definition or rdfs:comment">
			<referred_to_by>
				<_array>
					<xsl:apply-templates select="skos:definition | rdfs:comment"/>
				</_array>
			</referred_to_by>
		</xsl:if>

		<xsl:if test="skos:broader">
			<part_of>
				<_array>
					<xsl:apply-templates select="skos:broader"/>
				</_array>
			</part_of>
		</xsl:if>

		<xsl:if test="skos:exactMatch or skos:closeMatch">
			<exact_match>
				<_array>
					<xsl:apply-templates select="skos:exactMatch | skos:closeMatch"/>
				</_array>
			</exact_match>
		</xsl:if>

		<xsl:if test="/content/rdf:RDF/org:Membership[org:organization]">
			<member_of>
				<_array>
					<xsl:apply-templates select="//org:Membership[org:organization]"/>
				</_array>
			</member_of>
		</xsl:if>

		<!-- geographic coordinates for mints -->
		<xsl:apply-templates select="/content/rdf:RDF/geo:SpatialThing"/>
	</xsl:template>

	<!-- groups and dynasties -->
	<xsl:template match="org:Membership">
		<xsl:if test="not(org:organization/@rdf:resource = preceding::org:Membership/org:organization/@rdf:resource)">
			<xsl:variable name="uri" select="org:organization/@rdf:resource"/>

			<xsl:apply-templates select="$rdf//*[@rdf:about = $uri]" mode="membership"/>
		</xsl:if>
	</xsl:template>

	<xsl:template match="org:memberOf">
		<xsl:variable name="uri" select="@rdf:resource"/>

		<xsl:apply-templates select="$rdf//*[@rdf:about = $uri]" mode="membership"/>
	</xsl:template>

	<xsl:template match="*" mode="membership">
		<_object>
			<type>Group</type>
			<id>
				<xsl:value-of select="@rdf:about"/>
			</id>
			<_label>
				<xsl:value-of select="skos:prefLabel[@xml:lang = 'en']"/>
			</_label>
			<!--<classified_as>
				<_array>
					<_object>
						<type>Type</type>
						<xsl:choose>
							<xsl:when test="self::crm:E74_Group">
								<id>http://vocab.getty.edu/aat/300387353</id>
								<_label>groups of political entities</_label>
							</xsl:when>							
						</xsl:choose>
					</_object>
				</_array>
			</classified_as>-->
		</_object>
	</xsl:template>

	<!-- definitions as brief text statements -->
	<xsl:template match="skos:definition | rdfs:comment">
		<_object>
			<type>LinguisticObject</type>
			<content>
				<xsl:value-of select="normalize-space(.)"/>
			</content>
			<classified_as>
				<_array>
					<_object>
						<type>Type</type>
						<xsl:choose>
							<xsl:when test="$type = 'crm:E21_Person'">
								<id>http://vocab.getty.edu/aat/300435422</id>
								<_label>Biography Statement</_label>
							</xsl:when>
							<xsl:otherwise>
								<id>http://vocab.getty.edu/aat/300411780</id>
								<_label>Description</_label>
							</xsl:otherwise>
						</xsl:choose>

						<classified_as>
							<_array>
								<_object>
									<id>http://vocab.getty.edu/aat/300418049</id>
									<type>Type</type>
									<_label>Brief Text</_label>
								</_object>
							</_array>
						</classified_as>
					</_object>
				</_array>
			</classified_as>
		</_object>
	</xsl:template>

	<!-- matching terms as an array of URIs -->
	<xsl:template match="skos:exactMatch | skos:closeMatch">
		<_>
			<xsl:value-of select="@rdf:resource"/>
		</_>
	</xsl:template>

	<!-- broader concepts -->
	<xsl:template match="skos:broader">
		<xsl:variable name="uri" select="@rdf:resource"/>

		<xsl:apply-templates select="$rdf//*[@rdf:about = $uri]" mode="broader"/>
	</xsl:template>

	<xsl:template match="*" mode="broader">
		<_object>
			<id>
				<xsl:value-of select="@rdf:about"/>
			</id>
			<_label>
				<xsl:value-of select="skos:prefLabel[@xml:lang = 'en']"/>
			</_label>
			<type>
				<xsl:choose>
					<xsl:when test="self::crm:E53_Place">Place</xsl:when>
					<xsl:otherwise>Type</xsl:otherwise>
				</xsl:choose>
			</type>
		</_object>
	</xsl:template>

	<!-- geographic coordinates -->
	<xsl:template match="geo:SpatialThing">
		<xsl:choose>
			<xsl:when test="geo:lat and geo:long">
				<approximated_by>
					<_array>
						<_object>
							<id>
								<xsl:value-of select="@rdf:about"/>
							</id>
							<type>Place</type>
							<_label>Coordinates</_label>
							<defined_by>
								<xsl:value-of select="concat('POINT(', geo:long, ' ', geo:lat, ')')"/>
							</defined_by>
						</_object>
					</_array>
				</approximated_by>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>
