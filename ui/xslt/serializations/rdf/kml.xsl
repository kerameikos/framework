<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:foaf="http://xmlns.com/foaf/0.1/" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
	xmlns:dbpedia-owl="http://dbpedia.org/ontology/" xmlns:skos="http://www.w3.org/2004/02/skos/core#" xmlns:owl="http://www.w3.org/2002/07/owl#" xmlns:ecrm="http://erlangen-crm.org/current/"
	xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:dcterms="http://purl.org/dc/terms/" xmlns:geo="http://www.w3.org/2003/01/geo/wgs84_pos#" xmlns:tei="http://www.tei-c.org/ns/1.0"
	xmlns:osgeo="http://data.ordnancesurvey.co.uk/ontology/geometry/" exclude-result-prefixes="#all" version="2.0">
	<xsl:variable name="id" select="substring-after(//rdf:RDF/*[1]/@rdf:about, 'id/')"/>
	<xsl:variable name="uri" select="concat(/content/config/url, 'id/', $id)"/>
	<xsl:variable name="definition" select="//skos:definition[@xml:lang='en']"/>

	<xsl:template match="/">
		<xsl:call-template name="kml"/>
	</xsl:template>

	<xsl:template name="kml">
		<xsl:variable name="type" select="/content/rdf:RDF/*/name()"/>
		<kml xmlns="http://earth.google.com/kml/2.0">
			<Document>
				<Style id="origin">
					<IconStyle>
						<scale>1</scale>
						<hotSpot x="0.5" y="0" xunits="fraction" yunits="fraction"/>
						<Icon>
							<href>http://maps.google.com/mapfiles/ms/micons/blue-dot.png</href>
						</Icon>
					</IconStyle>
				</Style>
				<Style id="polygon">
					<PolyStyle>
						<color>50F00014</color>
						<outline>1</outline>
					</PolyStyle>
				</Style>
				<xsl:if test="$type='ecrm:E53_Place'">
					<xsl:apply-templates select="descendant::geo:spatialThing"/>
				</xsl:if>
				<xsl:if test="$type='foaf:Person' and descendant::skos:exactMatch[contains(@rdf:resource, 'lgpn.ox.ac.uk')]">
					<xsl:call-template name="lgpn-birthplace">
						<xsl:with-param name="uri" select="descendant::skos:exactMatch[contains(@rdf:resource, 'lgpn.ox.ac.uk')]/@rdf:resource"/>
					</xsl:call-template>
				</xsl:if>
			</Document>
		</kml>
	</xsl:template>

	<xsl:template match="geo:spatialThing">
		<Placemark xmlns="http://earth.google.com/kml/2.0">
			<name>
				<xsl:value-of select="descendant::skos:prefLabel[@xml:lang='en']"/>
			</name>
			<description>
				<xsl:value-of select="$definition"/>
			</description>
			<xsl:choose>
				<xsl:when test="number(geo:lat) and number(geo:long)">
					<styleUrl>#origin</styleUrl>
					<Point>
						<coordinates>
							<xsl:value-of select="concat(geo:long, ',', geo:lat)"/>
						</coordinates>
					</Point>
				</xsl:when>
				<xsl:when test="string(osgeo:asGeoJSON)">
					<styleUrl>#polygon</styleUrl>
					<Polygon>
						<outerBoundaryIs>
							<LinearRing>
								<coordinates>
									<xsl:analyze-string regex="\[(\d[^\]]+)\]" select="osgeo:asGeoJSON">
										<xsl:matching-substring>
											<xsl:for-each select="regex-group(1)">
												<xsl:value-of select="normalize-space(tokenize(., ',')[1])"/>
												<xsl:text>, </xsl:text>
												<xsl:value-of select="normalize-space(tokenize(., ',')[2])"/>
												<xsl:text>, 0. </xsl:text>
											</xsl:for-each>
										</xsl:matching-substring>
									</xsl:analyze-string>
								</coordinates>
							</LinearRing>
						</outerBoundaryIs>
					</Polygon>
				</xsl:when>
			</xsl:choose>
			
		</Placemark>
	</xsl:template>

	<xsl:template name="lgpn-birthplace">
		<xsl:param name="uri"/>

		<xsl:variable name="lgpn-tei" as="item()*">
			<xsl:copy-of select="document(concat('http://clas-lgpn2.classics.ox.ac.uk/cgi-bin/lgpn_search.cgi?id=', substring-after($uri, 'id/'), ';style=xml'))/*"/>
		</xsl:variable>

		<Placemark xmlns="http://earth.google.com/kml/2.0">
			<name>Birth</name>
			<styleUrl>#origin</styleUrl>


			<xsl:if test="$lgpn-tei//tei:birth/tei:placeName[contains(@ref, 'pleiades')]">
				<xsl:variable name="pleiades-uri" select="concat('http://pleiades.stoa.org/places/', substring-after($lgpn-tei//tei:birth/tei:placeName[contains(@ref, 'pleiades')]/@ref, ':'))"/>
				<xsl:variable name="placeName" select="$lgpn-tei//tei:birth/tei:placeName"/>
				<xsl:variable name="pleiades-rdf" as="item()*">
					<xsl:copy-of select="document(concat($pleiades-uri, '/rdf'))/*"/>
				</xsl:variable>
				<xsl:variable name="description">
					<![CDATA[<p>Born: <a href="]]><xsl:value-of select="$pleiades-uri"/><![CDATA[">]]><xsl:value-of select="$placeName"/><![CDATA[</a></p>
				<p>]]><xsl:value-of select="$definition"/><![CDATA[</p>]]>
				</xsl:variable>
				<description>
					<xsl:value-of select="normalize-space($description)"/>
				</description>
				<!--<xsl:copy-of select="$pleiades-rdf"/>-->
				<xsl:if test="$pleiades-rdf//geo:lat and $pleiades-rdf//geo:long">
					<Point>
						<coordinates>
							<xsl:value-of select="concat($pleiades-rdf//geo:long, ',', $pleiades-rdf//geo:lat)"/>
						</coordinates>
					</Point>
				</xsl:if>
			</xsl:if>

			<xsl:choose>
				<xsl:when test="$lgpn-tei//tei:birth/@when">
					<TimeStamp>
						<when>
							<xsl:value-of select="$lgpn-tei//tei:birth/@when"/>
						</when>
					</TimeStamp>
				</xsl:when>
				<xsl:when test="$lgpn-tei//tei:birth/@notBefore or $lgpn-tei//tei:birth/@notAfter or $lgpn-tei//tei:birth/@from or $lgpn-tei//tei:birth/@to">
					<TimeSpan>
						<xsl:if test="$lgpn-tei//tei:birth/@notBefore or $lgpn-tei//tei:birth/@from">
							<begin>
								<xsl:value-of select="if ($lgpn-tei//tei:birth/@notBefore) then $lgpn-tei//tei:birth/@notBefore else $lgpn-tei//tei:birth/@from"/>
							</begin>
						</xsl:if>
						<xsl:if test="$lgpn-tei//tei:birth/@notAfter or $lgpn-tei//tei:birth/@to">
							<end>
								<xsl:value-of select="if ($lgpn-tei//tei:birth/@notAfter) then $lgpn-tei//tei:birth/@notAfter else $lgpn-tei//tei:birth/@to"/>
							</end>
						</xsl:if>
					</TimeSpan>
				</xsl:when>
			</xsl:choose>
		</Placemark>
	</xsl:template>
</xsl:stylesheet>
