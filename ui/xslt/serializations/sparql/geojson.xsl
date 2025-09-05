<?xml version="1.0" encoding="UTF-8"?>
<!-- Author: Ethan Gruber
	Date: September 2025
	Function: serialize RDF or SPARQL queries into GeoJSON with the JSON metamodel -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:kerameikos="https://kerameikos.org/" xmlns:res="http://www.w3.org/2005/sparql-results#"
	xmlns:skos="http://www.w3.org/2004/02/skos/core#" xmlns:osgeo="http://data.ordnancesurvey.co.uk/ontology/geometry/"
	xmlns:geo="http://www.w3.org/2003/01/geo/wgs84_pos#" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" exclude-result-prefixes="#all" version="2.0">
	<xsl:include href="../json/json-metamodel.xsl"/>
	<xsl:include href="../../functions.xsl"/>

	<xsl:param name="api" select="tokenize(doc('input:request')/request/request-url, '/')[last()]"/>
	<xsl:param name="pointType"
		select="
			if ($api = 'getProductionPlaces') then
				'productionPlace'
			else
				if ($api = 'getFindspots') then
					'find'
				else
					''"/>

	<xsl:template match="/">
		<xsl:variable name="model" as="element()*">
			<_object>
				<type>FeatureCollection</type>
				<features>
					<_array>
						<xsl:choose>
							<!-- GeoJSON serialization for a concept in the .geojson URL or content negotiation -->
							<xsl:when test="ignore">
								<xsl:apply-templates select="ignore"/>
							</xsl:when>
							<xsl:when test="*[namespace-uri() = 'http://www.w3.org/1999/02/22-rdf-syntax-ns#']">
								<xsl:choose>
									<xsl:when test="$api = 'query.json'">
										<xsl:if test="count(//*[geo:lat and geo:long]) &gt; 0">
											<!-- apply-templates only on those RDF objects that have coordinates -->
											<xsl:apply-templates select="//*[geo:lat and geo:long]" mode="describe"/>
										</xsl:if>
									</xsl:when>
									<xsl:otherwise>
										<xsl:choose>
											<xsl:when test="geo:SpatialThing/osgeo:asGeoJSON">
												<xsl:apply-templates select="geo:SpatialThing" mode="poly">
													<xsl:with-param name="uri" select="*[1]/@rdf:about"/>
													<xsl:with-param name="label" select="*[1]/skos:prefLabel[@xml:lang = 'en']"/>
												</xsl:apply-templates>
											</xsl:when>
											<xsl:when test="geo:SpatialThing/geo:lat and geo:SpatialThing/geo:long">
												<xsl:apply-templates select="geo:SpatialThing" mode="point">
													<xsl:with-param name="uri" select="*[1]/@rdf:about"/>
													<xsl:with-param name="label" select="*[1]/skos:prefLabel[@xml:lang = 'en']"/>
												</xsl:apply-templates>
											</xsl:when>
										</xsl:choose>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:when>
							<xsl:when test="*[namespace-uri() = 'http://www.w3.org/2005/sparql-results#']">
								<xsl:if test="count(descendant::res:result) &gt; 0">
									<!-- evaluate API and construct the attributes according to GeoJSON-T -->

									<xsl:choose>
										<xsl:when test="$api = 'getFindspots' or $api = 'getProductionPlaces'">
											<xsl:apply-templates select="descendant::res:result"/>
										</xsl:when>
										<xsl:when test="$api = 'query.json'">
											<xsl:variable name="query" select="doc('input:request')/request/parameters/parameter[name = 'query']/value"/>

											<!-- parse out the lat and long variables from the SPARQL query -->
											<xsl:variable name="latParam">
												<xsl:analyze-string select="$query" regex="geo:lat\s+\?([a-zA-Z0-9_]+)">
													<xsl:matching-substring>
														<xsl:value-of select="regex-group(1)"/>
													</xsl:matching-substring>
												</xsl:analyze-string>
											</xsl:variable>
											<xsl:variable name="longParam">
												<xsl:analyze-string select="$query" regex="geo:long\s+\?([a-zA-Z0-9_]+)">

													<xsl:matching-substring>
														<xsl:value-of select="regex-group(1)"/>
													</xsl:matching-substring>
												</xsl:analyze-string>
											</xsl:variable>

											<!-- if lat and long are available, then apply templates for results with coordinates -->
											<xsl:if test="string-length($latParam) &gt; 0 and string-length($longParam) &gt; 0">
												<xsl:apply-templates
													select="descendant::res:result[res:binding[@name = $latParam] and res:binding[@name = $longParam]]" mode="query">
													<xsl:with-param name="lat" select="$latParam"/>
													<xsl:with-param name="long" select="$longParam"/>
												</xsl:apply-templates>
											</xsl:if>
										</xsl:when>
										<xsl:when test="$api = 'geoJSON'">
											<!-- coordinates for object geoJSON serialization -->
											<xsl:apply-templates select="descendant::res:result" mode="object"/>
										</xsl:when>
									</xsl:choose>
								</xsl:if>
							</xsl:when>
						</xsl:choose>
					</_array>
				</features>
			</_object>
		</xsl:variable>

		<xsl:apply-templates select="$model"/>
		
	</xsl:template>
	
	<!-- ignore the RDF in the ignore root element, apply templates only to the three docs -->
	<xsl:template match="ignore">
		<xsl:apply-templates select="doc('input:productionPlaces')/*">
			<xsl:with-param name="type">productionPlace</xsl:with-param>
		</xsl:apply-templates>		
		<xsl:apply-templates select="doc('input:findspots')/res:sparql">
			<xsl:with-param name="type">find</xsl:with-param>
		</xsl:apply-templates>
	</xsl:template>
	
	<!-- RDF/XML template for productionPlace -->
	<xsl:template match="rdf:RDF">
		<xsl:choose>
			<xsl:when test="descendant::geo:SpatialThing/osgeo:asGeoJSON">
				<xsl:apply-templates select="descendant::geo:SpatialThing" mode="poly">
					<xsl:with-param name="uri" select="*[1]/@rdf:about"/>
					<xsl:with-param name="label" select="*[1]/skos:prefLabel[@xml:lang = 'en']"/>
				</xsl:apply-templates>
			</xsl:when>
			<xsl:when test="descendant::geo:SpatialThing[geo:lat and geo:long]">
				<xsl:apply-templates select="descendant::geo:SpatialThing" mode="point">
					<xsl:with-param name="uri" select="*[1]/@rdf:about"/>
					<xsl:with-param name="label" select="*[1]/skos:prefLabel[@xml:lang = 'en']"/>
				</xsl:apply-templates>
			</xsl:when>
		</xsl:choose>
	</xsl:template>

	<!-- generate GeoJSON for id/ responses -->
	<xsl:template match="geo:SpatialThing" mode="point">
		<xsl:param name="uri"/>
		<xsl:param name="label"/>

		<_object>
			<type>Feature</type>
			<label>
				<xsl:value-of select="$label"/>
			</label>
			<id>
				<xsl:value-of select="$uri"/>
			</id>
			<geometry>
				<_object>
					<type>Point</type>
					<coordinates>
						<_array>
							<_>
								<xsl:value-of select="geo:long"/>
							</_>
							<_>
								<xsl:value-of select="geo:lat"/>
							</_>
						</_array>
					</coordinates>
				</_object>
			</geometry>

			<properties>
				<_object>
					<toponym>
						<xsl:value-of select="$label"/>
					</toponym>
					<gazetteer_label>
						<xsl:value-of select="$label"/>
					</gazetteer_label>
					<type>productionPlace</type>
				</_object>
			</properties>
		</_object>
	</xsl:template>

	<xsl:template match="geo:SpatialThing" mode="poly">
		<xsl:param name="uri"/>
		<xsl:param name="label"/>

		<_object>
			<type>Feature</type>
			<label>
				<xsl:value-of select="$label"/>
			</label>
			<id>
				<xsl:value-of select="$uri"/>
			</id>
			<geometry datatype="osgeo:asGeoJSON">
				<xsl:value-of select="osgeo:asGeoJSON"/>
			</geometry>
			<properties>
				<_object>
					<toponym>
						<xsl:value-of select="$label"/>
					</toponym>
					<gazetteer_label>
						<xsl:value-of select="$label"/>
					</gazetteer_label>
					<type>productionPlace</type>
				</_object>
			</properties>
		</_object>
	</xsl:template>
	
	<!-- GeoJSON point(s) for production place and/or findspot for an object -->
	<xsl:template match="res:result" mode="object">
		
		<xsl:if test="res:binding[@name = 'place']">
			<_object>
				<type>Feature</type>
				<label>
					<xsl:value-of select="res:binding[@name = 'placeLabel']/res:literal"/>
				</label>
				<id>
					<xsl:value-of select="res:binding[@name = 'place']/res:uri"/>
				</id>
				
				<!-- include point coordinates or GeoJSON polygon -->
				<xsl:choose>
					<xsl:when test="res:binding[@name = 'long'] and res:binding[@name = 'lat']">
						<geometry>
							<_object>
								<type>Point</type>
								<coordinates>
									<_array>
										<_>
											<xsl:value-of select="res:binding[@name = 'long']/res:literal"/>
										</_>
										<_>
											<xsl:value-of select="res:binding[@name = 'lat']/res:literal"/>
										</_>
									</_array>
								</coordinates>
							</_object>
						</geometry>
					</xsl:when>
					<xsl:when test="res:binding[@name = 'poly']">
						<geometry datatype="osgeo:asGeoJSON">
							<xsl:value-of select="res:binding[@name = 'poly']/res:literal"/>
						</geometry>
					</xsl:when>
				</xsl:choose>
				
				<properties>
					<_object>
						<toponym>
							<xsl:value-of select="res:binding[@name = 'placeLabel']/res:literal"/>
						</toponym>
						<gazetteer_label>
							<xsl:value-of select="res:binding[@name = 'placeLabel']/res:literal"/>
						</gazetteer_label>
						<gazetteer_uri>
							<xsl:value-of select="res:binding[@name = 'place']/res:uri"/>
						</gazetteer_uri>
						<type>productionPlace</type>
					</_object>
				</properties>
			</_object>
		</xsl:if>
		
		<xsl:if test="res:binding[@name = 'findspot']">
			<_object>
				<type>Feature</type>
				<label>
					<xsl:value-of select="res:binding[@name = 'findspotLabel']/res:literal"/>
				</label>
				<id>
					<xsl:value-of select="res:binding[@name = 'findspot']/res:uri"/>
				</id>
				<geometry>
					<_object>
						<type>Point</type>
						<coordinates>
							<_array>
								<_>
									<xsl:value-of select="res:binding[@name = 'findspotLong']/res:literal"/>
								</_>
								<_>
									<xsl:value-of select="res:binding[@name = 'findspotLat']/res:literal"/>
								</_>
							</_array>
						</coordinates>
					</_object>
				</geometry>
				<properties>
					<_object>
						<toponym>
							<xsl:value-of select="res:binding[@name = 'findspotLabel']/res:literal"/>
						</toponym>
						<gazetteer_label>
							<xsl:value-of select="res:binding[@name = 'findspotLabel']/res:literal"/>
						</gazetteer_label>
						<gazetteer_uri>
							<xsl:value-of select="res:binding[@name = 'findspot']/res:uri"/>
						</gazetteer_uri>
						<type>find</type>
					</_object>
				</properties>
			</_object>
		</xsl:if>
		
	</xsl:template>

	<!-- GeoJSON result for general SELECT SPARQL query lat/long -->
	<xsl:template match="res:result" mode="query">
		<xsl:param name="lat"/>
		<xsl:param name="long"/>

		<xsl:variable name="label" select="res:binding[1]/res:*"/>

		<_object>
			<type>Feature</type>
			<label>
				<xsl:value-of select="$label"/>
			</label>
			<xsl:if test="matches($label, 'https?://')">
				<id>
					<xsl:value-of select="$label"/>
				</id>
			</xsl:if>
			<geometry>
				<_object>
					<type>Point</type>
					<coordinates>
						<_array>
							<_>
								<xsl:value-of select="res:binding[@name = $long]/res:literal"/>
							</_>
							<_>
								<xsl:value-of select="res:binding[@name = $lat]/res:literal"/>
							</_>
						</_array>
					</coordinates>
				</_object>
			</geometry>
		</_object>
	</xsl:template>

	<!-- other GeoJSON API responses -->
	<xsl:template match="res:sparql">
		<xsl:param name="type"/>
		
		<xsl:variable name="max" select="max(descendant::res:binding[@name = 'count']/res:literal)"/>
		<xsl:variable name="position" select="position()"/>
		
		<xsl:apply-templates select="descendant::res:result">
			<xsl:with-param name="pointType" select="$type"/>
			<xsl:with-param name="max" select="$max"/>
			<xsl:with-param name="position" select="$position"/>
		</xsl:apply-templates>
	</xsl:template>
	
	<xsl:template match="res:result">
		<xsl:param name="pointType"/>
		<xsl:param name="max"/>
		<xsl:param name="position"/>

		<xsl:choose>
			<xsl:when test="res:binding[@name = 'poly']">
				<_object>
					<type>Feature</type>
					<label>
						<xsl:value-of select="res:binding[@name = 'label']/res:literal"/>
					</label>

					<geometry datatype="osgeo:asGeoJSON">
						<xsl:value-of select="res:binding[@name = 'poly']/res:literal"/>
					</geometry>

					<properties>
						<_object>
							<toponym>
								<xsl:value-of select="res:binding[@name = 'label']/res:literal"/>
							</toponym>
							<gazetteer_label>
								<xsl:value-of select="res:binding[@name = 'label']/res:literal"/>
							</gazetteer_label>
							<gazetteer_uri>
								<xsl:value-of select="res:binding[@name = 'place']/res:uri"/>
							</gazetteer_uri>
							<type>
								<xsl:value-of select="$pointType"/>
							</type>
						</_object>
					</properties>
				</_object>
			</xsl:when>
			<xsl:otherwise>
				<_object>
					<type>Feature</type>
					<label>
						<xsl:value-of select="res:binding[@name = 'label']/res:literal"/>
					</label>

					<geometry>
						<_object>
							<type>Point</type>
							<coordinates>
								<_array>
									<_>
										<xsl:value-of select="res:binding[@name = 'long']/res:literal"/>
									</_>
									<_>
										<xsl:value-of select="res:binding[@name = 'lat']/res:literal"/>
									</_>
								</_array>
							</coordinates>
						</_object>
					</geometry>

					<properties>
						<_object>
							<toponym>
								<xsl:value-of select="res:binding[@name = 'label']/res:literal"/>
							</toponym>
							<gazetteer_label>
								<xsl:value-of select="res:binding[@name = 'label']/res:literal"/>
							</gazetteer_label>
							<gazetteer_uri>
								<xsl:value-of select="res:binding[@name = 'place']/res:uri"/>
							</gazetteer_uri>
							<type>
								<xsl:value-of select="$pointType"/>
							</type>
							<xsl:if test="res:binding[@name = 'count']">
								<count>
									<xsl:value-of select="res:binding[@name = 'count']/res:literal"/>
								</count>
								<radius>
									<xsl:value-of select="kerameikos:getGrade(res:binding[@name = 'count']/res:literal, $max)"/>
								</radius>
							</xsl:if>
						</_object>
					</properties>
				</_object>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:function name="kerameikos:getGrade">
		<xsl:param name="count"/>
		<xsl:param name="max"/>
		
		<xsl:variable name="grade" select="$max div 5"/>
		
		<xsl:choose>
			<xsl:when test="floor($grade) = 0">5</xsl:when>
			<xsl:when test="$count &lt; floor($grade)">5</xsl:when>
			<xsl:when test="$count &gt; floor($grade) and $count &lt; (floor($grade) * 2)">10</xsl:when>
			<xsl:when test="$count &gt; (floor($grade) * 2) and $count &lt; (floor($grade) * 3)">15</xsl:when>
			<xsl:when test="$count &gt; (floor($grade) * 3) and $count &lt; (floor($grade) * 4)">20</xsl:when>
			<xsl:when test="$count &gt; (floor($grade) * 4)">25</xsl:when>
			<xsl:otherwise>5</xsl:otherwise>
		</xsl:choose>
	</xsl:function>
</xsl:stylesheet>
