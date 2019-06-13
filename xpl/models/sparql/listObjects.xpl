<?xml version="1.0" encoding="UTF-8"?>
<!--
	Author: Ethan Gruber
	Date: June 2019
	Function: Generate an XML metamodel to execute the SPARQL query for the object list of vases associated with a particular SKOS concept
-->
<p:config xmlns:p="http://www.orbeon.com/oxf/pipeline" xmlns:oxf="http://www.orbeon.com/oxf/processors" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">

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
				<url>oxf:/apps/kerameikos/ui/sparql/listObjects.sparql</url>
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

	<p:processor name="oxf:unsafe-xslt">
		<p:input name="request" href="#request"/>
		<p:input name="query" href="#query-document"/>
		<p:input name="data" href=" ../../../config.xml"/>
		<p:input name="config">
			<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema"
				xmlns:kerameikos="http://kerameikos.org/" exclude-result-prefixes="#all">
				<xsl:include href="../../../ui/xslt/controllers/metamodel-templates.xsl"/>
				<xsl:include href="../../../ui/xslt/controllers/sparql-metamodel.xsl"/>
				
				<xsl:param name="id" select="doc('input:request')/request/parameters/parameter[name='id']/value"/>
				<xsl:param name="type" select="doc('input:request')/request/parameters/parameter[name='type']/value"/>

				<xsl:variable name="sparql_endpoint" select="/config/sparql/query"/>

				<xsl:variable name="query" select="doc('input:query')"/>

				<xsl:variable name="statements" as="element()*">
					<xsl:call-template name="kerameikos:listObjectsStatements">
						<xsl:with-param name="type" select="$type"/>
						<xsl:with-param name="id" select="$id"/>
					</xsl:call-template>
				</xsl:variable>

				<xsl:variable name="statementsSPARQL">
					<xsl:apply-templates select="$statements/*"/>
				</xsl:variable>

				<xsl:variable name="service"
					select="concat($sparql_endpoint, '?query=', encode-for-uri(replace($query, '%STATEMENTS%', $statementsSPARQL)), '&amp;output=xml')"/> 

				<xsl:template match="/">
					<config>
						<url>
							<xsl:value-of select="$service"/>
						</url>
						<content-type>application/xml</content-type>
						<encoding>utf-8</encoding>
					</config>
				</xsl:template>
			</xsl:stylesheet>
		</p:input>
		<p:output name="data" id="url-generator-config"/>
	</p:processor>

	<p:processor name="oxf:url-generator">
		<p:input name="config" href="#url-generator-config"/>
		<p:output name="data" ref="data"/>
	</p:processor>
</p:config>
