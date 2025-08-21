<?xml version="1.0" encoding="UTF-8"?>
<!-- Author: Ethan Gruber
	Date Modified: August 2020
	Function: Construct HTTP headers for content negotiation
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema"
	xmlns:numishare="https://github.com/ewg118/numishare" exclude-result-prefixes="#all" version="2.0">
	<xsl:include href="../functions.xsl"/>
	
	<xsl:variable name="pipeline">
		<xsl:choose>
			<xsl:when test="tokenize(doc('input:request')/request/request-url, '/')[last()] = 'browse'">browse</xsl:when>
			<xsl:otherwise>rdf</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	
	<xsl:template match="/">
		<config>
			<status-code>200</status-code>
			<content-type>text/html</content-type>
			
			<!-- output language, if enabled. otherwise the default is 'en' -->
			<header>
				<name>Content-Language</name>
				<value>en</value>
			</header>	
			
			<xsl:choose>				
				<!-- create a Link header for all possible serializations and profiles -->
				<xsl:when test="$pipeline = 'rdf'">
					<xsl:variable name="scheme" select="tokenize(doc('input:request')/request/request-url, '/')[last() -1]"/>
					<xsl:variable name="id" select="tokenize(doc('input:request')/request/request-url, '/')[last()]"/>					
					<xsl:variable name="objectURI" select="concat(/config/url, $scheme, '/', $id)"/>
					
					<header>
						<name>Link</name>
						<value>
							<xsl:text>&lt;</xsl:text>
							<xsl:value-of select="$objectURI"/>
							<xsl:text>&gt;; rel="canonical"; type="text/html", </xsl:text>
							<xsl:text>&lt;</xsl:text>
							<xsl:value-of select="$objectURI"/>
							<xsl:text>&gt;; rel="alternate"; type="text/turtle"; profile="https://kerameikos.org/ontology#", </xsl:text>
							<xsl:text>&lt;</xsl:text>
							<xsl:value-of select="$objectURI"/>
							<xsl:text>&gt;; rel="alternate"; type="application/rdf+xml"; profile="https://kerameikos.org/ontology#", </xsl:text>
							<xsl:text>&lt;</xsl:text>
							<xsl:value-of select="$objectURI"/>
							<xsl:text>&gt;; rel="alternate"; type="application/ld+json"; profile="https://kerameikos.org/ontology#"</xsl:text>
							<xsl:text>&lt;</xsl:text>
							<xsl:value-of select="$objectURI"/>
							<xsl:text>&gt;; rel="alternate"; type="application/ld+json"; profile="https://linked.art/ns/v1/linked-art.json", </xsl:text>
						</value>
					</header>
				</xsl:when>
				<xsl:when test="$pipeline = 'browse'">
					<xsl:variable name="uri" select="concat(/config/url, 'browse')"/>
					
					<header>
						<name>Link</name>
						<value>
							<xsl:text>&lt;</xsl:text>
							<xsl:value-of select="$uri"/>
							<xsl:text>&gt;; rel="canonical"; type="text/html", </xsl:text>
							<xsl:text>&lt;</xsl:text>
							<xsl:value-of select="$uri"/>
							<xsl:text>&gt;; rel="alternate"; type="application/atom+xml", </xsl:text>
							<xsl:text>&lt;</xsl:text>
							<xsl:value-of select="$uri"/>
							<xsl:text>&gt;; rel="alternate"; type="application/xml"</xsl:text>
						</value>
					</header>
				</xsl:when>
			</xsl:choose>
		</config>
	</xsl:template>

</xsl:stylesheet>
