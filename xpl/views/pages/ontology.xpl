<?xml version="1.0" encoding="UTF-8"?>
<!--
	Copyright (C) 2010 Ethan Gruber
	EADitor: http://code.google.com/p/eaditor/
	Apache License 2.0: http://code.google.com/p/eaditor/
	
-->
<p:config xmlns:p="http://www.orbeon.com/oxf/pipeline"
	xmlns:oxf="http://www.orbeon.com/oxf/processors">

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
				
				<xsl:variable name="content-type" select="//header[name[.='content-type']]/value"/>
				
				<xsl:template match="/">
					<content-type>
						<xsl:choose>
							<xsl:when test="$content-type='application/rdf+xml' or $content-type='application/xml' or $content-type='text/xml'">xml</xsl:when>
							<xsl:when test="$content-type='text/turtle'">turtle</xsl:when>
							<xsl:when test="$content-type='ld+json'">json-ld</xsl:when>
							<xsl:otherwise>html</xsl:otherwise>
						</xsl:choose>
					</content-type>
				</xsl:template>
			</xsl:stylesheet>
		</p:input>
		<p:output name="data" id="conneg-config"/>
	</p:processor>
	
	<p:choose href="#conneg-config">
		<p:when test="content-type='xml'">
			<p:processor name="oxf:pipeline">
				<p:input name="config" href="../../models/get-ontology.xpl"/>		
				<p:output name="data" ref="data"/>
			</p:processor>
		</p:when>
		<p:when test="content-type='turtle'">
			<p:processor name="oxf:pipeline">
				<p:input name="config" href="../../serializations/rdf/ttl.xpl"/>	
				<p:input name="data" href="#data"/>				
				<p:output name="data" ref="data"/>
			</p:processor>
		</p:when>
		<p:when test="content-type='json-ld'">
			<p:processor name="oxf:pipeline">
				<p:input name="config" href="../../serializations/rdf/json-ld.xpl"/>	
				<p:input name="data" href="#data"/>				
				<p:output name="data" ref="data"/>
			</p:processor>
		</p:when>
		<p:otherwise>
			<p:processor name="oxf:unsafe-xslt">
				<p:input name="data" href="aggregate('content', #data, ../../../config.xml)"/>		
				<p:input name="config" href="../../../ui/xslt/pages/ontology.xsl"/>
				<p:output name="data" ref="data"/>
			</p:processor>
		</p:otherwise>
	</p:choose>
	
	
	

</p:config>
