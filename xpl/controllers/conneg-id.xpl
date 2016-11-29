<?xml version="1.0" encoding="UTF-8"?>
<p:pipeline xmlns:p="http://www.orbeon.com/oxf/pipeline" xmlns:oxf="http://www.orbeon.com/oxf/processors">

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
	
	<!-- read request header for content-type -->
	<p:processor name="oxf:unsafe-xslt">
		<p:input name="data" href="#request"/>
		<p:input name="config">
			<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
				<xsl:output indent="yes"/>
				
				<xsl:variable name="content-type" select="//header[name[.='accept']]/value"/>
				
				<xsl:template match="/">
					<content-type>
						<xsl:choose>
							<xsl:when test="$content-type='application/ld+json'">json-ld</xsl:when>
							<xsl:when test="$content-type='application/vnd.google-earth.kml+xml'">kml</xsl:when>
							<xsl:when test="$content-type='application/rdf+xml'">xml</xsl:when>
							<xsl:when test="$content-type='text/turtle'">turtle</xsl:when>
							<xsl:when test="$content-type='text/html'">html</xsl:when>
							<xsl:when test="not(string($content-type)) or $content-type='*/*' or contains($content-type, 'text/html')">
								<xsl:text>html</xsl:text>
								<!--<xsl:variable name="pieces" select="tokenize(/request/request-url, '/')"/>
								<xsl:choose>
									<xsl:when test="string-length($pieces[last()]) &gt; 0">303</xsl:when>
									<xsl:otherwise>html</xsl:otherwise>
								</xsl:choose>-->
							</xsl:when>
							<xsl:otherwise>error</xsl:otherwise>
						</xsl:choose>
					</content-type>
				</xsl:template>
			</xsl:stylesheet>
		</p:input>
		<p:output name="data" id="conneg-config"/>
	</p:processor>
	
	<p:choose href="#conneg-config">
		<p:when test="content-type='xml'">
			<p:processor name="oxf:identity">
				<p:input name="data" href="#data"/>		
				<p:output name="data" ref="data"/>
			</p:processor>
		</p:when>
		<p:when test="content-type='json-ld'">
			<p:processor name="oxf:pipeline">
				<p:input name="config" href="../views/serializations/rdf/json-ld.xpl"/>	
				<p:input name="data" href="#data"/>				
				<p:output name="data" ref="data"/>
			</p:processor>
		</p:when>
		<p:when test="content-type='turtle'">
			<p:processor name="oxf:pipeline">
				<p:input name="config" href="../views/serializations/rdf/ttl.xpl"/>
				<p:input name="data" href="#data"/>				
				<p:output name="data" ref="data"/>
			</p:processor>
		</p:when>
		<p:when test="content-type='kml'">
			<p:processor name="oxf:pipeline">
				<p:input name="config" href="../views/serializations/rdf/kml.xpl"/>
				<p:input name="data" href="#data"/>		
				<p:output name="data" ref="data"/>
			</p:processor>
		</p:when>
		<p:when test="content-type='html'">
			<p:processor name="oxf:pipeline">
				<p:input name="config" href="../views/serializations/rdf/html.xpl"/>
				<p:input name="data" href="#data"/>		
				<p:output name="data" ref="data"/>
			</p:processor>
		</p:when>
		<p:when test="content-type='303'">
			<p:processor name="oxf:pipeline">
				<p:input name="data" href="#data"/>
				<p:input name="config" href="303-redirect.xpl"/>		
				<p:output name="data" ref="data"/>
			</p:processor>
		</p:when>
		<p:otherwise>
			<p:processor name="oxf:pipeline">
				<p:input name="data" href="#data"/>
				<p:input name="config" href="406-not-acceptable.xpl"/>		
				<p:output name="data" ref="data"/>
			</p:processor>
		</p:otherwise>
	</p:choose>
</p:pipeline>
