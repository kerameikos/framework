<?xml version="1.0" encoding="UTF-8"?>
<p:config xmlns:p="http://www.orbeon.com/oxf/pipeline" xmlns:oxf="http://www.orbeon.com/oxf/processors" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
	xmlns:res="http://www.w3.org/2005/sparql-results#">

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

	<!-- get the namespace/concept scheme of the RDF file -->
	<p:processor name="oxf:unsafe-xslt">
		<p:input name="data" href="#request"/>

		<p:input name="config">
			<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema"
				xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">

				<xsl:template match="/">
					<scheme>
						<xsl:value-of select="tokenize(/request/request-url, '/')[last() - 1]"/>
					</scheme>
				</xsl:template>

			</xsl:stylesheet>
		</p:input>
		<p:output name="data" id="scheme"/>
	</p:processor>

	<!-- evaluate editor vs. id concept scheme -->
	<p:choose href="#scheme">
		<p:when test="/scheme = 'editor'">

			<!-- get the type of the RDF fragment in the editor namespace -->
			<p:processor name="oxf:unsafe-xslt">
				<p:input name="data" href="#data"/>

				<p:input name="config">
					<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema"
						xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">

						<xsl:template match="/">
							<type>
								<xsl:value-of select="/rdf:RDF/*[1]/name()"/>
							</type>
						</xsl:template>

					</xsl:stylesheet>
				</p:input>
				<p:output name="data" id="type"/>
			</p:processor>

			<p:choose href="#type">
				<p:when test="/type = 'skos:ConceptScheme'">
					<!-- execute SPARQL query to get list of editors -->
					<p:processor name="oxf:pipeline">
						<p:input name="data" href="#data"/>
						<p:input name="config" href="../../../models/sparql/getEditors.xpl"/>
						<p:output name="data" id="editors"/>
					</p:processor>
					
					<!-- aggregate models and serialize into HTML -->
					<p:processor name="oxf:unsafe-xslt">
						<p:input name="request" href="#request"/>
						<p:input name="editors" href="#editors"/>
						<p:input name="data" href="aggregate('content', #data, ../../../../config.xml)"/>
						<p:input name="config" href="../../../../ui/xslt/serializations/rdf/html.xsl"/>
						<p:output name="data" id="model"/>
					</p:processor>
				</p:when>
				<p:when test="/type = 'foaf:Person'">
					<!-- execute SPARQL query to get total count of contributed IDs -->
					<p:processor name="oxf:pipeline">
						<p:input name="data" href="#data"/>
						<p:input name="config" href="../../../models/sparql/countEditedIds.xpl"/>
						<p:output name="data" id="id-count"/>
					</p:processor>

					<!-- if there are more than 0, then initiate the next two SPARQL queries to generate lists of spreadsheets and IDs -->
					<p:choose href="#id-count">
						<p:when test="number(//res:binding[@name='count']/res:literal) &gt; 0">
							<!-- get the SPARQL queries for edited IDs and spreadsheets to pass into the HTML serialization -->
							<p:processor name="oxf:url-generator">
								<p:input name="config">
									<config>
										<url>oxf:/apps/kerameikos/ui/sparql/getEditedIds.sparql</url>
										<content-type>text/plain</content-type>
										<encoding>utf-8</encoding>
									</config>
								</p:input>
								<p:output name="data" id="getEditedIds-query"/>
							</p:processor>

							<p:processor name="oxf:text-converter">
								<p:input name="data" href="#getEditedIds-query"/>
								<p:input name="config">
									<config/>
								</p:input>
								<p:output name="data" id="getEditedIds-query-document"/>
							</p:processor>

							<p:processor name="oxf:url-generator">
								<p:input name="config">
									<config>
										<url>oxf:/apps/kerameikos/ui/sparql/getSpreadsheets.sparql</url>
										<content-type>text/plain</content-type>
										<encoding>utf-8</encoding>
									</config>
								</p:input>
								<p:output name="data" id="getSpreadsheets-query"/>
							</p:processor>

							<p:processor name="oxf:text-converter">
								<p:input name="data" href="#getSpreadsheets-query"/>
								<p:input name="config">
									<config/>
								</p:input>
								<p:output name="data" id="getSpreadsheets-query-document"/>
							</p:processor>

							<!-- execute SPARQL query to get a list of spreadsheets -->
							<p:processor name="oxf:pipeline">
								<p:input name="data" href="#data"/>
								<p:input name="config" href="../../../models/sparql/getSpreadsheets.xpl"/>
								<p:output name="data" id="spreadsheet-list"/>
							</p:processor>

							<!-- execute SPARQL query to get a sample list of 100 created/edited IDs by the kerameikos editor -->
							<p:processor name="oxf:pipeline">
								<p:input name="data" href="#data"/>
								<p:input name="config" href="../../../models/sparql/getEditedIds.xpl"/>
								<p:output name="data" id="id-list"/>
							</p:processor>

							<!-- aggregate models and serialize into HTML -->
							<p:processor name="oxf:unsafe-xslt">
								<p:input name="request" href="#request"/>
								<p:input name="id-count" href="#id-count"/>
								<p:input name="id-list" href="#id-list"/>
								<p:input name="getSpreadsheets-query" href="#getSpreadsheets-query-document"/>
								<p:input name="getEditedIds-query" href="#getEditedIds-query-document"/>
								<p:input name="spreadsheet-list" href="#spreadsheet-list"/>
								<p:input name="data" href="aggregate('content', #data, ../../../../config.xml)"/>
								<p:input name="config" href="../../../../ui/xslt/serializations/rdf/html.xsl"/>
								<p:output name="data" id="model"/>
							</p:processor>
						</p:when>
						<p:otherwise>
							<p:processor name="oxf:unsafe-xslt">
								<p:input name="request" href="#request"/>
								<p:input name="id-count" href="#id-count"/>
								<p:input name="data" href="aggregate('content', #data, ../../../../config.xml)"/>
								<p:input name="config" href="../../../../ui/xslt/serializations/rdf/html.xsl"/>
								<p:output name="data" id="model"/>
							</p:processor>
						</p:otherwise>
					</p:choose>
				</p:when>
			</p:choose>
		</p:when>
		<p:when test="/scheme = 'id'">
			<p:processor name="oxf:unsafe-xslt">
				<p:input name="data" href="#data"/>
				<p:input name="config">
					<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema"
						xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">

						<xsl:variable name="hasProductionPlaces" as="item()*">
							<classes>
								<class>crm:E4_Period</class>
								<class>crm:E57_Material</class>
								<class>crm:E40_Legal_Body</class>
								<class>foaf:Organization</class>
								<class>foaf:Person</class>
								<class>kon:ProductionPlace</class>
								<class>kon:Shape</class>
								<!--<class>kon:Style</class>-->
								<class>kon:Technique</class>
								<class>kon:Ware</class>
							</classes>
						</xsl:variable>

						<xsl:variable name="hasObjects" as="item()*">
							<classes>
								<class>crm:E4_Period</class>
								<class>crm:E57_Material</class>
								<class>crm:E40_Legal_Body</class>
								<class>foaf:Organization</class>
								<class>foaf:Person</class>
								<class>kon:ProductionPlace</class>
								<class>kon:Shape</class>
								<!--<class>kon:Style</class>-->
								<class>kon:Technique</class>
								<class>kon:Ware</class>
							</classes>
						</xsl:variable>

						<xsl:variable name="type" select="/rdf:RDF/*[1]/name()"/>
						<xsl:variable name="id" select="tokenize(/rdf:RDF/*[1]/@rdf:about, '/')[last()]"/>

						<xsl:template match="/">
							<type>
								<xsl:attribute name="id" select="$id"/>
								<xsl:attribute name="hasProductionPlaces">
									<xsl:choose>
										<xsl:when test="$hasProductionPlaces//class[text()=$type]">true</xsl:when>
										<xsl:otherwise>false</xsl:otherwise>
									</xsl:choose>
								</xsl:attribute>
								<xsl:attribute name="hasObjects">
									<xsl:choose>
										<xsl:when test="$hasObjects//class[text()=$type]">true</xsl:when>
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

			<!-- ASK whether there are geographic coordinates for in order to generate a conditional for the map -->
			<p:choose href="#type">
				<!-- suppress any class of object for which we do not want to render a map -->
				<p:when test="type/@hasProductionPlaces = 'false'">
					<p:processor name="oxf:identity">
						<p:input name="data">
							<sparql xmlns="http://www.w3.org/2005/sparql-results#">
								<head/>
								<boolean>false</boolean>
							</sparql>
						</p:input>
						<p:output name="data" id="hasProductionPlaces"/>
					</p:processor>
				</p:when>
				<!-- apply alternate SPARQL query to get mints associated with a Hoard -->
				<p:otherwise>
					<p:processor name="oxf:unsafe-xslt">
						<p:input name="request" href="#request"/>
						<p:input name="data" href="#type"/>
						<p:input name="config-xml" href=" ../../../../config.xml"/>
						<p:input name="config">
							<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema"
								xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
								<xsl:variable name="id" select="/type/@id"/>
								<xsl:variable name="type" select="/type"/>
								<xsl:variable name="sparql_endpoint" select="doc('input:config-xml')/config/sparql/query"/>

								<xsl:variable name="prefixes">
									<![CDATA[PREFIX rdf:	<http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX dcterms:	<http://purl.org/dc/terms/>
PREFIX skos:	<http://www.w3.org/2004/02/skos/core#>
PREFIX owl:	<http://www.w3.org/2002/07/owl#>
PREFIX foaf:	<http://xmlns.com/foaf/0.1/>
PREFIX crm:	<http://www.cidoc-crm.org/cidoc-crm/>
PREFIX geo:	<http://www.w3.org/2003/01/geo/wgs84_pos#>
PREFIX kid:	<http://kerameikos.org/id/>
PREFIX kon:	<http://kerameikos.org/ontology#>
PREFIX osgeo:	<http://data.ordnancesurvey.co.uk/ontology/geometry/>
ASK {]]>
								</xsl:variable>

								<xsl:variable name="metadata">
									<![CDATA[?object crm:P108i_was_produced_by ?prod
{?prod crm:P7_took_place_at ?place }
UNION {?prod crm:P7_took_place_at ?relPlace .
?place skos:exactMatch ?relPlace }
?place geo:location ?loc }]]>
								</xsl:variable>

								<xsl:variable name="select">
									<xsl:choose>
										<xsl:when test="$type='crm:E4_Period'">
											<![CDATA[
{?object crm:P108i_was_produced_by ?prod .
?prod  crm:P10_falls_within kid:RDFID}
UNION {kid:RDFID skos:exactMatch ?matches .
?object crm:P10_falls_within ?prod .
?prod crm:P7_took_place_at ?matches}
UNION {?types skos:broader kid:RDFID .
?types skos:exactMatch ?matches .
?object crm:P10_falls_within ?matches}]]>
										</xsl:when>
										<xsl:when test="$type='crm:E57_Material'">
											<![CDATA[{?object crm:P45_consists_of kid:RDFID }
UNION {kid:RDFID skos:exactMatch ?matches .
?object crm:P45_consists_of ?matches}
UNION {?types skos:broader kid:RDFID .
?object crm:P45_consists_of ?types}
UNION {?types skos:broader kid:RDFID .
?types skos:exactMatch ?matches .
?object crm:P45_consists_of ?matches}]]>
										</xsl:when>
										<xsl:when test="$type='crm:E40_Legal_Body'">
											<![CDATA[?object crm:P50_has_current_keeper kid:RDFID .]]>
										</xsl:when>
										<xsl:when test="$type='kon:Shape'">
											<![CDATA[{?object kon:hasShape kid:RDFID }
UNION {kid:RDFID skos:exactMatch ?matches .
?object kon:hasShape ?matches}
UNION {?types skos:broader kid:RDFID .
?object kon:hasShape ?types}
UNION {?types skos:broader kid:RDFID .
?types skos:exactMatch ?matches .
?object kon:hasShape ?matches}]]>
										</xsl:when>
										<xsl:when test="$type='kon:Technique'">
											<![CDATA[{?object crm:P32_used_general_technique kid:RDFID }
UNION {kid:RDFID skos:exactMatch ?matches .
?object crm:P32_used_general_technique ?matches}
UNION {?types skos:broader kid:RDFID .
?object crm:P32_used_general_technique ?types}
UNION {?types skos:broader kid:RDFID .
?types skos:exactMatch ?matches .
?object crm:P32_used_general_technique ?matches}]]>
										</xsl:when>
										<!--<xsl:when test="$type='kon:Ware'">
					<![CDATA[					{?object kon:hasShape kid:RDFID }
					UNION {kid:RDFID skos:exactMatch ?matches .
					?object kon:hasShape ?matches}
					UNION {?types skos:broader kid:RDFID .
					?object kon:hasShape ?types}
					UNION {?types skos:broader kid:RDFID .
					?types skos:exactMatch ?matches .
					?object kon:hasShape ?matches}]]>
					</xsl:when>-->
										<xsl:when test="$type='foaf:Person'">
											<![CDATA[{?object crm:P108i_was_produced_by ?prod .
?prod crm:P14_carried_out_by kid:RDFID}
UNION {kid:RDFID skos:exactMatch ?matches .
?object crm:P108i_was_produced_by ?prod .
?prod crm:P14_carried_out_by ?matches}]]>
										</xsl:when>
										<xsl:when test="$type='foaf:Organization'">
											<![CDATA[{?object crm:P108i_was_produced_by ?prod .
?prod crm:P14_carried_out_by kid:RDFID}
UNION {kid:RDFID skos:exactMatch ?matches .
?object crm:P108i_was_produced_by ?prod .
?prod crm:P14_carried_out_by ?matches}]]>
										</xsl:when>
									</xsl:choose>
								</xsl:variable>

								<xsl:template match="/">
									<xsl:variable name="query" select="concat($prefixes, replace($select, 'RDFID', $id), $metadata)"/>
									<xsl:variable name="service"
										select="concat($sparql_endpoint, '?query=', encode-for-uri(normalize-space(replace($query, 'RDFID', $id))), '&amp;output=xml')"/>

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
						<p:output name="data" id="hasProductionPlaces-url-generator-config"/>
					</p:processor>

					<p:processor name="oxf:url-generator">
						<p:input name="config" href="#hasProductionPlaces-url-generator-config"/>
						<p:output name="data" id="place-url-data"/>
					</p:processor>

					<p:processor name="oxf:exception-catcher">
						<p:input name="data" href="#place-url-data"/>
						<p:output name="data" id="place-url-data-checked"/>
					</p:processor>

					<!-- Check whether we had an exception -->
					<p:choose href="#place-url-data-checked">
						<p:when test="/exceptions">
							<!-- Extract the message -->
							<p:processor name="oxf:identity">
								<p:input name="data">
									<sparql xmlns="http://www.w3.org/2005/sparql-results#">
										<head/>
										<boolean>false</boolean>
									</sparql>
								</p:input>
								<p:output name="data" id="hasProductionPlaces"/>
							</p:processor>
						</p:when>
						<p:otherwise>
							<!-- Just return the document -->
							<p:processor name="oxf:identity">
								<p:input name="data" href="#place-url-data-checked"/>
								<p:output name="data" id="hasProductionPlaces"/>
							</p:processor>
						</p:otherwise>
					</p:choose>
				</p:otherwise>
			</p:choose>

			<!-- ASK whether are objects for displaying or distribution analysis -->
			<p:choose href="#type">
				<!-- suppress any class of object for which we do not want to render a map -->
				<p:when test="type/@hasObjects = 'false'">
					<p:processor name="oxf:identity">
						<p:input name="data">
							<sparql xmlns="http://www.w3.org/2005/sparql-results#">
								<head/>
								<boolean>false</boolean>
							</sparql>
						</p:input>
						<p:output name="data" id="hasObjects"/>
					</p:processor>
				</p:when>
				<!-- apply alternate SPARQL query to get mints associated with a Hoard -->
				<p:otherwise>
					<p:processor name="oxf:unsafe-xslt">
						<p:input name="request" href="#request"/>
						<p:input name="data" href="#type"/>
						<p:input name="config-xml" href=" ../../../../config.xml"/>
						<p:input name="config">
							<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema"
								xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
								<xsl:variable name="id" select="/type/@id"/>
								<xsl:variable name="type" select="/type"/>
								<xsl:variable name="sparql_endpoint" select="doc('input:config-xml')/config/sparql/query"/>

								<xsl:variable name="prefixes">
									<![CDATA[PREFIX rdf:	<http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX dcterms:	<http://purl.org/dc/terms/>
PREFIX skos:	<http://www.w3.org/2004/02/skos/core#>
PREFIX owl:	<http://www.w3.org/2002/07/owl#>
PREFIX foaf:	<http://xmlns.com/foaf/0.1/>
PREFIX crm:	<http://www.cidoc-crm.org/cidoc-crm/>
PREFIX geo:	<http://www.w3.org/2003/01/geo/wgs84_pos#>
PREFIX kid:	<http://kerameikos.org/id/>
PREFIX kon:	<http://kerameikos.org/ontology#>
PREFIX osgeo:	<http://data.ordnancesurvey.co.uk/ontology/geometry/>
ASK {]]>
								</xsl:variable>

								<xsl:variable name="select">
									<xsl:choose>
										<xsl:when test="$type='crm:E4_Period'">
											<![CDATA[
{?object crm:P108i_was_produced_by ?prod .
?prod  crm:P10_falls_within kid:RDFID}
UNION {kid:RDFID skos:exactMatch ?matches .
?object crm:P10_falls_within ?prod .
?prod crm:P7_took_place_at ?matches}
UNION {?types skos:broader kid:RDFID .
?types skos:exactMatch ?matches .
?object crm:P10_falls_within ?matches}]]>
										</xsl:when>
										<xsl:when test="$type='crm:E57_Material'">
											<![CDATA[{?object crm:P45_consists_of kid:RDFID }
UNION {kid:RDFID skos:exactMatch ?matches .
?object crm:P45_consists_of ?matches}
UNION {?types skos:broader kid:RDFID .
?object crm:P45_consists_of ?types}
UNION {?types skos:broader kid:RDFID .
?types skos:exactMatch ?matches .
?object crm:P45_consists_of ?matches}]]>
										</xsl:when>
										<xsl:when test="$type='crm:E40_Legal_Body'">
											<![CDATA[?object crm:P50_has_current_keeper kid:RDFID .]]>
										</xsl:when>
										<xsl:when test="$type='kon:Shape'">
											<![CDATA[{?object kon:hasShape kid:RDFID }
UNION {kid:RDFID skos:exactMatch ?matches .
?object kon:hasShape ?matches}
UNION {?types skos:broader kid:RDFID .
?object kon:hasShape ?types}
UNION {?types skos:broader kid:RDFID .
?types skos:exactMatch ?matches .
?object kon:hasShape ?matches}]]>
										</xsl:when>
										<xsl:when test="$type='kon:Technique'">
											<![CDATA[{?object crm:P32_used_general_technique kid:RDFID }
UNION {kid:RDFID skos:exactMatch ?matches .
?object crm:P32_used_general_technique ?matches}
UNION {?types skos:broader kid:RDFID .
?object crm:P32_used_general_technique ?types}
UNION {?types skos:broader kid:RDFID .
?types skos:exactMatch ?matches .
?object crm:P32_used_general_technique ?matches}]]>
										</xsl:when>
										<!--<xsl:when test="$type='kon:Ware'">
					<![CDATA[					{?object kon:hasShape kid:RDFID }
					UNION {kid:RDFID skos:exactMatch ?matches .
					?object kon:hasShape ?matches}
					UNION {?types skos:broader kid:RDFID .
					?object kon:hasShape ?types}
					UNION {?types skos:broader kid:RDFID .
					?types skos:exactMatch ?matches .
					?object kon:hasShape ?matches}]]>
					</xsl:when>-->
										<xsl:when test="$type='foaf:Person'">
											<![CDATA[{?object crm:P108i_was_produced_by ?prod .
?prod crm:P14_carried_out_by kid:RDFID}
UNION {kid:RDFID skos:exactMatch ?matches .
?object crm:P108i_was_produced_by ?prod .
?prod crm:P14_carried_out_by ?matches}]]>
										</xsl:when>
										<xsl:when test="$type='foaf:Organization'">
											<![CDATA[{?object crm:P108i_was_produced_by ?prod .
?prod crm:P14_carried_out_by kid:RDFID}
UNION {kid:RDFID skos:exactMatch ?matches .
?object crm:P108i_was_produced_by ?prod .
?prod crm:P14_carried_out_by ?matches}]]>
										</xsl:when>
									</xsl:choose>
								</xsl:variable>

								<xsl:template match="/">
									<xsl:variable name="query" select="concat($prefixes, replace($select, 'RDFID', $id), '}')"/>
									<xsl:variable name="service"
										select="concat($sparql_endpoint, '?query=', encode-for-uri(normalize-space(replace($query, 'RDFID', $id))), '&amp;output=xml')"/>

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
						<p:output name="data" id="hasObjects-url-generator-config"/>
					</p:processor>

					<p:processor name="oxf:url-generator">
						<p:input name="config" href="#hasObjects-url-generator-config"/>
						<p:output name="data" id="place-url-data"/>
					</p:processor>

					<p:processor name="oxf:exception-catcher">
						<p:input name="data" href="#place-url-data"/>
						<p:output name="data" id="place-url-data-checked"/>
					</p:processor>

					<!-- Check whether we had an exception -->
					<p:choose href="#place-url-data-checked">
						<p:when test="/exceptions">
							<!-- Extract the message -->
							<p:processor name="oxf:identity">
								<p:input name="data">
									<sparql xmlns="http://www.w3.org/2005/sparql-results#">
										<head/>
										<boolean>false</boolean>
									</sparql>
								</p:input>
								<p:output name="data" id="hasObjects"/>
							</p:processor>
						</p:when>
						<p:otherwise>
							<!-- Just return the document -->
							<p:processor name="oxf:identity">
								<p:input name="data" href="#place-url-data-checked"/>
								<p:output name="data" id="hasObjects"/>
							</p:processor>
						</p:otherwise>
					</p:choose>
				</p:otherwise>
			</p:choose>

			<p:processor name="oxf:unsafe-xslt">
				<p:input name="request" href="#request"/>
				<p:input name="data" href="aggregate('content', #data, #hasProductionPlaces, #hasObjects, ../../../../config.xml)"/>
				<p:input name="config" href="../../../../ui/xslt/serializations/rdf/html.xsl"/>
				<p:output name="data" id="model"/>
			</p:processor>
		</p:when>
	</p:choose>

	<!-- serialize to HTML 5 -->
	<p:processor name="oxf:html-converter">
		<p:input name="data" href="#model"/>
		<p:input name="config">
			<config>
				<version>5.0</version>
				<indent>true</indent>
				<content-type>text/html</content-type>
				<encoding>utf-8</encoding>
				<indent-amount>4</indent-amount>
			</config>
		</p:input>
		<p:output name="data" ref="data"/>
	</p:processor>
</p:config>
