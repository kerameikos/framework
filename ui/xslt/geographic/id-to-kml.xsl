<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:foaf="http://xmlns.com/foaf/0.1/" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
	xmlns:dbpedia-owl="http://dbpedia.org/ontology/" xmlns:skos="http://www.w3.org/2004/02/skos/core#" xmlns:owl="http://www.w3.org/2002/07/owl#"
	xmlns:ecrm="http://erlangen-crm.org/current/" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:dcterms="http://purl.org/dc/terms/"
	xmlns:geo="http://www.w3.org/2003/01/geo/wgs84_pos#" exclude-result-prefixes="#all" version="2.0">
	<xsl:variable name="id" select="substring-after(//@rdf:about, 'id/')"/>
	<xsl:variable name="uri" select="concat(/content/config/url, 'id/', $id)"/>

	<xsl:template match="/">
		<xsl:call-template name="kml"/>
	</xsl:template>

	<xsl:template name="kml">
		<xsl:variable name="type" select="/content/rdf:RDF/*/name()"/>
		<kml xmlns="http://earth.google.com/kml/2.0">
			<Document>
				<Style id="place">
					<IconStyle>
						<scale>1</scale>
						<hotSpot x="0.5" y="0" xunits="fraction" yunits="fraction"/>
						<Icon>
							<href>http://maps.google.com/mapfiles/ms/micons/green-dot.png</href>
						</Icon>
					</IconStyle>
				</Style>
				<xsl:if test="$type='ecrm:E53_Place'">
					<xsl:call-template name="place_placemark"/>
				</xsl:if>
			</Document>
		</kml>
	</xsl:template>

	<xsl:template name="place_placemark">
		<xsl:variable name="description">
			<![CDATA[
								<dl><dt>Latitude</dt><dd>]]><xsl:value-of select="descendant::geo:lat"/><![CDATA[</dd>
								<dt>Longitude</dt><dd>]]><xsl:value-of select="descendant::geo:long"/><![CDATA[</dd>
								<dt>URI</dt><dd><a href="]]><xsl:value-of select="$uri"/><![CDATA[">]]><xsl:value-of select="$uri"/><![CDATA[</a></dd></dl>]]>
		</xsl:variable>

		<Placemark xmlns="http://earth.google.com/kml/2.0">
			<name>
				<xsl:value-of select="descendant::skos:prefLabel[@xml:lang='en']"/>
			</name>
			<description>
				<xsl:value-of select="normalize-space($description)"/>
			</description>
			<styleUrl>#place</styleUrl>
			<Point>
				<coordinates>
					<xsl:value-of select="concat(descendant::geo:long, ',', descendant::geo:lat)"/>
				</coordinates>
			</Point>
		</Placemark>
	</xsl:template>
</xsl:stylesheet>
