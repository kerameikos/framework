<?xml version="1.0" encoding="UTF-8"?>
<!--
	Author: Ethan Gruber
	Date: June 2019
	Function: Either perform identity processor for a crm:E53_Place or execute a SPARQL query for other types of concepts
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

	<p:processor name="oxf:pipeline">
		<p:input name="config" href="../rdf/get-id.xpl"/>
		<p:output name="data" id="rdf"/>
	</p:processor>

	<p:processor name="oxf:unsafe-xslt">
		<p:input name="data" href="#rdf"/>
		<p:input name="config">
			<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema"
				xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">

				<xsl:variable name="hasProductionPlaces" as="item()*">
					<classes>
						<class>crm:E4_Period</class>
						<class>crm:E57_Material</class>
						<class>crm:E40_Legal_Body</class>
						<class>crm:E74_Group</class>						
						<class>crm:E21_Person</class>
						<class>crm:E53_Place</class>
						<class>kon:Shape</class>
						<class>kon:Style</class>
						<class>kon:Technique</class>
						<class>kon:Ware</class>
					</classes>
				</xsl:variable>

				<xsl:variable name="type" select="/rdf:RDF/*[1]/name()"/>
				
				<xsl:template match="/">
					<type>
						<xsl:attribute name="hasProductionPlaces">
							<xsl:choose>
								<xsl:when test="$hasProductionPlaces//class[text()=$type]">true</xsl:when>
								<xsl:otherwise>false</xsl:otherwise>
							</xsl:choose>
						</xsl:attribute>

						<xsl:value-of select="$type"/>
					</type>
				</xsl:template>

			</xsl:stylesheet>
		</p:input>
		<p:output name="data" id="type"/>
	</p:processor>

	<p:choose href="#type">
		<!-- check to see whether the ID is a production place, if so, process the coordinates or geoJSON polygon in the RDF into geoJSON -->
		<p:when test="type = 'crm:E53_Place'">
			<p:processor name="oxf:identity">
				<p:input name="data" href="#rdf"/>
				<p:output name="data" ref="data"/>
			</p:processor>
		</p:when>
		<!-- suppress any class of object for which we do not want to render a map -->
		<p:when test="type/@hasProductionPlaces = 'false'">
			<p:processor name="oxf:identity">
				<p:input name="data">
					<null/>
				</p:input>
				<p:output name="data" ref="data"/>
			</p:processor>
		</p:when>
		<!-- apply alternate SPARQL query to get production places associated with the given type of Concept -->
		<p:otherwise>
			<!-- get query from a text file on disk -->
			<p:processor name="oxf:url-generator">
				<p:input name="config">
					<config>
						<url>oxf:/apps/kerameikos/ui/sparql/getProductionPlaces.sparql</url>
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
				<p:input name="data" href="#type"/>
				<p:input name="query" href="#query-document"/>
				<p:input name="config-xml" href=" ../../../config.xml"/>
				<p:input name="config">
					<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema"
						xmlns:kerameikos="http://kerameikos.org/" exclude-result-prefixes="#all">
						<xsl:include href="../../../ui/xslt/controllers/metamodel-templates.xsl"/>
						<xsl:include href="../../../ui/xslt/controllers/sparql-metamodel.xsl"/>
						
						<xsl:param name="id" select="doc('input:request')/request/parameters/parameter[name='id']/value"/>
						<xsl:variable name="sparql_endpoint" select="doc('input:config-xml')/config/sparql/query"/>
						<xsl:variable name="type" select="/type"/>

						<xsl:variable name="query" select="doc('input:query')"/>
						
						<xsl:variable name="statements" as="element()*">
							<xsl:call-template name="kerameikos:getProductionPlacesStatements">
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
		</p:otherwise>
	</p:choose>
</p:config>
