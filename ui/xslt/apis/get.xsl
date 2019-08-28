<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:skos="http://www.w3.org/2004/02/skos/core#" 
	xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:xlink="http://www.w3.org/1999/xlink"
	xmlns:osgeo="http://data.ordnancesurvey.co.uk/ontology/geometry/" xmlns:geo="http://www.w3.org/2003/01/geo/wgs84_pos#"
	xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:foaf="http://xmlns.com/foaf/0.1/" xmlns:spatial="http://geovocab.org/spatial#"
	xmlns:kml="http://earth.google.com/kml/2.0" exclude-result-prefixes="#all" version="2.0">
	<xsl:include href="templates-timemap.xsl"/>
	<xsl:include href="../functions.xsl"/>
	<xsl:output name="default" method="xml"/>

	<!-- url params -->
	<xsl:param name="id" select="doc('input:request')/request/parameters/parameter[name='id']/value"/>
	<xsl:param name="format" select="doc('input:request')/request/parameters/parameter[name='format']/value"/>
	<xsl:param name="mode" select="doc('input:request')/request/parameters/parameter[name='mode']/value"/>
	<xsl:param name="model" select="doc('input:request')/request/parameters/parameter[name='model']/value"/>

	<!-- config variables -->
	<xsl:variable name="geonames-url">http://api.geonames.org</xsl:variable>
	<xsl:variable name="geonames_api_key" select="/content/config/geonames_api_key"/>
	<xsl:variable name="url" select="/content/config/url"/>

	<xsl:template match="/">
		<!-- determine templates to call -->
		<xsl:choose>
			<xsl:when test="$format='json'">
				<xsl:call-template name="timemap"/>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>
