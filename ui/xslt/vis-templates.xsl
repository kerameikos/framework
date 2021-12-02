<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:dcterms="http://purl.org/dc/terms/"
	xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#" xmlns:skos="http://www.w3.org/2004/02/skos/core#"
	xmlns:geo="http://www.w3.org/2003/01/geo/wgs84_pos#" xmlns:foaf="http://xmlns.com/foaf/0.1/" xmlns:res="http://www.w3.org/2005/sparql-results#"
	xmlns:org="http://www.w3.org/ns/org#" xmlns:kerameikos="http://kerameikos.org/" xmlns:kid="http://kerameikos.org/id/"
	xmlns:kon="http://kerameikos.org/ontology#" xmlns:crm="http://www.cidoc-crm.org/cidoc-crm/" exclude-result-prefixes="#all" version="2.0">

	<!-- URL parameters -->
	<xsl:param name="filter" select="doc('input:request')/request/parameters/parameter[name = 'filter']/value"/>
	<xsl:param name="dist" select="doc('input:request')/request/parameters/parameter[name = 'dist']/value"/>
	<xsl:param name="compare" select="doc('input:request')/request/parameters/parameter[name = 'compare']/value"/>
	<xsl:param name="numericType" select="doc('input:request')/request/parameters/parameter[name = 'type']/value"/>

	<!-- ********** VISUALIZATION TEMPLATES *********** -->
	<xsl:template name="distribution-form">
		<xsl:param name="mode"/>
		<div>
			<xsl:if test="$mode = 'record'">
				<xsl:attribute name="id">quant</xsl:attribute>
			</xsl:if>

			<!-- display chart div when applicable, with additional filtering options -->
			<xsl:choose>
				<xsl:when test="$mode = 'page'">
					<xsl:if test="string($dist) and count($compare) &gt; 0">
						<xsl:call-template name="dist-chart">
							<xsl:with-param name="hidden" select="false()" as="xs:boolean"/>
						</xsl:call-template>
					</xsl:if>
				</xsl:when>
				<xsl:when test="$mode = 'record'">
					<xsl:call-template name="dist-chart">
						<xsl:with-param name="hidden" select="true()" as="xs:boolean"/>
					</xsl:call-template>
				</xsl:when>
			</xsl:choose>

			<h3>Typological Distribution</h3>
			<form role="form" id="distributionForm" class="quant-form" method="get">
				<xsl:attribute name="action">
					<xsl:choose>
						<xsl:when test="$mode = 'page'">
							<xsl:value-of select="concat($display_path, 'research/distribution')"/>
						</xsl:when>
						<xsl:when test="$mode = 'record'">
							<xsl:value-of select="concat($display_path, 'id/', $id, '#quant')"/>
						</xsl:when>
					</xsl:choose>
				</xsl:attribute>

				<!-- only include filter in the ID page -->
				<xsl:if test="$mode = 'record'">
					<input type="hidden" name="filter">
						<xsl:if test="string($filter)">
							<xsl:attribute name="class" select="$filter"/>
						</xsl:if>
					</input>
				</xsl:if>

				<xsl:call-template name="dist-categories"/>

				<div class="form-group">
					<h4>Numeric response type</h4>
					<input type="radio" name="type" value="percentage">
						<xsl:if test="not(string($numericType)) or $numericType = 'percentage'">
							<xsl:attribute name="checked">checked</xsl:attribute>
						</xsl:if>
						<xsl:text>Percentage</xsl:text>
					</input>
					<br/>
					<input type="radio" name="type" value="count">
						<xsl:if test="$numericType = 'count'">
							<xsl:attribute name="checked">checked</xsl:attribute>
						</xsl:if>
						<xsl:text>Count</xsl:text>
					</input>
				</div>

				<xsl:if test="$mode = 'page'">
					<xsl:call-template name="dist-compare-template">
						<xsl:with-param name="mode" select="$mode"/>
					</xsl:call-template>
				</xsl:if>

				<xsl:if test="$mode = 'record'">
					<div class="form-inline">
						<h4>Additional Filters</h4>
						<p>Include additional filters to the basic distribution query for this concept. <a href="#" id="add-filter"><span
									class="glyphicon glyphicon-plus"/>Add one</a></p>
						<div id="filter-container">
							<div class="bg-danger duplicate-date-alert-box hidden">
								<span class="glyphicon glyphicon-exclamation-sign"/>
								<strong>Alert:</strong> There must not be more than one from or to date.</div>
							<!-- if there's a dist and filter, then break the filter query and insert preset filter templates -->
							<xsl:if test="$dist and $filter">
								<xsl:variable name="filterPieces" select="tokenize($filter, ';')"/>

								<xsl:for-each select="$filterPieces[not(normalize-space(.) = $base-query)]">
									<xsl:call-template name="field-template">
										<xsl:with-param name="query" select="normalize-space(.)"/>
									</xsl:call-template>
								</xsl:for-each>
							</xsl:if>
						</div>
					</div>
				</xsl:if>

				<xsl:if test="$mode = 'record'">
					<xsl:call-template name="dist-compare-template">
						<xsl:with-param name="mode" select="$mode"/>
					</xsl:call-template>
				</xsl:if>

				<input type="submit" value="Generate" class="btn btn-default" id="visualize-submit" disabled="disabled"/>
			</form>
		</div>
	</xsl:template>

	<xsl:template name="dist-chart">
		<xsl:param name="hidden"/>

		<div id="dist-chart-container">
			<xsl:if test="$hidden = true()">
				<xsl:attribute name="class">hidden</xsl:attribute>
			</xsl:if>
			<div id="chart"/>

			<!-- only display model-generated link when there are URL params (distribution page) -->
			<div style="margin-bottom:10px;" class="control-row text-center">
				<p>Result is limited to 100</p>

				<xsl:choose>
					<xsl:when test="$hidden = false()">
						<xsl:variable name="queryParams" as="element()*">
							<params>
								<param>
									<xsl:value-of select="concat('dist=', $dist)"/>
								</param>
								<xsl:if test="string($numericType)">
									<param>
										<xsl:value-of select="concat('type=', $numericType)"/>
									</param>
								</xsl:if>
								<param>
									<xsl:value-of select="concat('filter=', $filter)"/>
								</param>
								<xsl:for-each select="$compare">
									<param>
										<xsl:value-of select="concat('compare=', normalize-space(.))"/>
									</param>
								</xsl:for-each>
								<param>format=csv</param>
							</params>
						</xsl:variable>

						<a href="{$display_path}apis/getDistribution?{string-join($queryParams/*, '&amp;')}" title="Download CSV" class="btn btn-primary">
							<span class="glyphicon glyphicon-download"/>Download CSV</a>
					</xsl:when>
					<xsl:otherwise>
						<a href="#" title="Download" class="btn btn-primary">
							<span class="glyphicon glyphicon-download"/>Download CSV</a>
						<a href="#" title="Bookmark" class="btn btn-primary">
							<span class="glyphicon glyphicon-download"/>View in Separate Page</a>
					</xsl:otherwise>
				</xsl:choose>
			</div>
		</div>

	</xsl:template>

	<xsl:template name="dist-categories">

		<div class="form-group">
			<h4>Category</h4>

			<xsl:variable name="properties" as="element()*">
				<properties>
					<prop value="keeper" class="crm:E40_Legal_Body">Collection</prop>
					<prop value="material" class="crm:E57_Material">Material</prop>
					<prop value="painter" class="crm:E21_Person|crm:E74_Group">Painter</prop>
					<prop value="period" class="crm:E4_Period">Period</prop>
					<prop value="pottery" class="crm:E21_Person|crm:E74_Group">Potter</prop>					
					<prop value="productionPlace" class="crm:E53_Place">Production Place</prop>
					<prop value="shape" class="kon:Shape">Shape</prop>
					<prop value="technique" class="kon:Technique">Technique</prop>										
				</properties>
			</xsl:variable>

			<p>Select a category below to generate a graph showing the quantitative distribution for the following queries. The distribution is based vases aggregated into Kerameikos.org.</p>
			<select name="dist" class="form-control" id="categorySelect">
				<option value="">Select...</option>
				<xsl:choose>
					<xsl:when test="string($type)">
						<!-- when there is a RDF Class (ID page), exclude the distribution option from the class of the ID
						note: portrait and deity are always available -->
						<xsl:for-each select="$properties/prop[not(contains(@class, $type))]">
							<option value="{@value}">
								<xsl:if test="$dist = @value">
									<xsl:attribute name="selected">selected</xsl:attribute>
								</xsl:if>
								<xsl:value-of select="."/>
							</option>
						</xsl:for-each>
					</xsl:when>
					<xsl:otherwise>
						<xsl:for-each select="$properties/prop">
							<option value="{@value}">
								<xsl:if test="$dist = @value">
									<xsl:attribute name="selected">selected</xsl:attribute>
								</xsl:if>
								<xsl:value-of select="."/>
							</option>
						</xsl:for-each>
					</xsl:otherwise>
				</xsl:choose>
			</select>
		</div>
	</xsl:template>

	<xsl:template name="dist-compare-template">
		<xsl:param name="mode"/>
		<div class="form-inline">
			<h4>
				<xsl:choose>
					<xsl:when test="$mode = 'record'">Compare to Other Queries</xsl:when>
					<xsl:when test="$mode = 'page'">Compare Queries</xsl:when>
				</xsl:choose>
			</h4>
			<p>You can compare mutiple queries to generate a more complex chart depicting the distribution for the Category selected above. <a href="#"
					id="add-compare"><span class="glyphicon glyphicon-plus"/>Add query</a></p>
			<div id="compare-master-container">
				<xsl:for-each select="$compare">
					<xsl:call-template name="compare-container-template">
						<xsl:with-param name="template" as="xs:boolean">false</xsl:with-param>
						<xsl:with-param name="query" select="normalize-space(.)"/>
					</xsl:call-template>
				</xsl:for-each>
			</div>
		</div>
	</xsl:template>

	<xsl:template name="date-template">
		<xsl:param name="template"/>
		<xsl:param name="query"/>

		<xsl:variable name="year" select="substring-after($query, ' ')"/>

		<span>
			<xsl:if test="$template = true()">
				<xsl:attribute name="id">date-container-template</xsl:attribute>
			</xsl:if>
			<input type="number" class="form-control year" min="1" step="1" placeholder="Year">
				<xsl:if test="$year castable as xs:integer">
					<xsl:attribute name="value" select="abs(xs:integer($year))"/>
				</xsl:if>
			</input>
			<select class="form-control era">
				<option value="bc">
					<xsl:if test="$year castable as xs:integer">
						<xsl:if test="xs:integer($year) &lt; 0">
							<xsl:attribute name="selected">selected</xsl:attribute>
						</xsl:if>
					</xsl:if>
					<xsl:text>B.C.</xsl:text>
				</option>
				<option value="ad">
					<xsl:if test="$year castable as xs:integer">
						<xsl:if test="xs:integer($year) &gt; 0">
							<xsl:attribute name="selected">selected</xsl:attribute>
						</xsl:if>
					</xsl:if>
					<xsl:text>A.D.</xsl:text>
				</option>
			</select>
		</span>
	</xsl:template>

	<xsl:template name="compare-container-template">
		<xsl:param name="template"/>
		<xsl:param name="query"/>

		<div class="compare-container" style="padding-left:20px;margin-left:20px;border-left:1px solid gray">
			<xsl:if test="$template = true()">
				<xsl:attribute name="id">compare-container-template</xsl:attribute>
			</xsl:if>
			<h4>
				<xsl:text>Dataset</xsl:text>
				<small>
					<a href="#" title="Remove Dataset" class="remove-dataset">
						<span class="glyphicon glyphicon-remove"/>
					</a>
					<a href="#" class="add-compare-field" title="Add Query Field"><span class="glyphicon glyphicon-plus"/>Add Query Field</a>
				</small>
			</h4>
			<div class="bg-danger empty-query-alert-box hidden">
				<span class="glyphicon glyphicon-exclamation-sign"/>
				<strong>Alert:</strong> There must be at least one field in the dataset query.</div>
			<div class="bg-danger duplicate-date-alert-box hidden">
				<span class="glyphicon glyphicon-exclamation-sign"/>
				<strong>Alert:</strong> There must not be more than one from or to date.</div>
			<!-- if this xsl:template isn't an HTML template used by Javascript (generated in DOM from the compare request parameter), then pre-populate the query fields -->
			<xsl:if test="$template = false()">
				<xsl:for-each select="tokenize($query, ';')">
					<xsl:call-template name="field-template">
						<xsl:with-param name="template" as="xs:boolean">false</xsl:with-param>
						<xsl:with-param name="mode">compare</xsl:with-param>
						<xsl:with-param name="query" select="normalize-space(.)"/>
					</xsl:call-template>
				</xsl:for-each>
			</xsl:if>
		</div>
	</xsl:template>

	<xsl:template name="field-template">
		<xsl:param name="template"/>
		<xsl:param name="query"/>
		<xsl:param name="mode"/>

		<div class="form-group filter" style="display:block; margin-bottom:15px;">
			<xsl:if test="$template = true()">
				<xsl:attribute name="id">field-template</xsl:attribute>
			</xsl:if>
			<select class="form-control add-filter-prop">
				<xsl:call-template name="property-list">
					<xsl:with-param name="template" select="$template"/>
					<xsl:with-param name="query" select="$query"/>
					<xsl:with-param name="mode" select="$mode"/>
				</xsl:call-template>
			</select>

			<div class="prop-container">
				<xsl:if test="string($query)">
					<xsl:choose>
						<xsl:when test="substring-before($query, ' ') = 'from' or substring-before($query, ' ') = 'to'">
							<xsl:call-template name="date-template">
								<xsl:with-param name="query" select="$query"/>
								<xsl:with-param name="template" as="xs:boolean">false</xsl:with-param>
							</xsl:call-template>
						</xsl:when>
						<xsl:otherwise>
							<span class="hidden">
								<xsl:value-of select="$query"/>
							</span>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:if>
			</div>

			<div class="control-container">
				<span class="glyphicon glyphicon-exclamation-sign hidden" title="A selection is required"/>
				<a href="#" title="Remove Property-Object Pair" class="remove-query">
					<span class="glyphicon glyphicon-remove"/>
				</a>
			</div>
		</div>
	</xsl:template>

	<xsl:template name="ajax-loader-template">
		<span id="ajax-loader-template"><img src="{$display_path}ui/images/ajax-loader.gif" alt="loading"/> Loading</span>
	</xsl:template>

	<xsl:template name="property-list">
		<xsl:param name="query"/>
		<xsl:param name="mode"/>
		<xsl:param name="template"/>

		<xsl:variable name="properties" as="element()*">
			<properties>
				<prop value="artist" class="crm:E74_Group|crm:E21_Person">Artist</prop>
				<prop value="keeper" class="crm:E40_Legal_Body">Collection</prop>
			<!--	<prop value="from">Date, From</prop>
				<prop value="to">Date, To</prop>-->
				<prop value="material" class="crm:E57_Material">Material</prop>
				<prop value="painter" class="crm:E74_Group|crm:E21_Person">Painter</prop>
				<prop value="period" class="crm:E4_Period">Period</prop>
				<prop value="potter" class="crm:E74_Group|crm:E21_Person">Potter</prop>
				<prop value="productionPlace" class="crm:E53_Place">Production Place</prop>
				<prop value="shape" class="kon:Shape">Shape</prop>
				<prop value="technique" class="kon:Technique">Technique</prop>									
			</properties>			
		</xsl:variable>

		<option>Select...</option>
		<xsl:choose>
			<xsl:when test="$mode = 'compare' or $template = true()">
				<xsl:apply-templates select="$properties//prop">
					<xsl:with-param name="query" select="$query"/>
				</xsl:apply-templates>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="$properties//prop[not(contains(@class, $type))]">
					<xsl:with-param name="query" select="$query"/>
				</xsl:apply-templates>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="prop">
		<xsl:param name="query"/>
		<xsl:variable name="value" select="@value"/>

		<option value="{$value}" type="{@class}">
			<xsl:if test="substring-before($query, ' ') = $value">
				<xsl:attribute name="selected">selected</xsl:attribute>
			</xsl:if>
			<xsl:value-of select="."/>
		</option>
	</xsl:template>

</xsl:stylesheet>
