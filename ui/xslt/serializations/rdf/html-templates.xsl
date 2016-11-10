<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:foaf="http://xmlns.com/foaf/0.1/" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
	xmlns:dbpedia-owl="http://dbpedia.org/ontology/" xmlns:skos="http://www.w3.org/2004/02/skos/core#" xmlns:owl="http://www.w3.org/2002/07/owl#" xmlns:crm="http://www.cidoc-crm.org/cidoc-crm/"
	xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:dcterms="http://purl.org/dc/terms/" xmlns:kid="http://kerameikos.org/id/" xmlns:kon="http://kerameikos.org/ontology#"
	xmlns:geo="http://www.w3.org/2003/01/geo/wgs84_pos#" xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:kerameikos="http://kerameikos.org/" xmlns:res="http://www.w3.org/2005/sparql-results#"
	exclude-result-prefixes="#all" version="2.0">

	<xsl:variable name="classes" as="node()*">
		<classes>
			<!--<class>
				<label>Collection</label>
				<type>crm:E78_Collection</type>
			</class>-->
			<class>
				<label>Institution</label>
				<type>crm:E40_Legal_Body</type>
			</class>
			<class>
				<label>Material</label>
				<type>crm:E57_Material</type>
			</class>
			<class>
				<label>Organization</label>
				<type>foaf:Organization</type>
			</class>
			<class>
				<label>Period</label>
				<type>crm:E4_Period</type>
			</class>
			<class>
				<label>Person</label>
				<type>foaf:Person</type>
			</class>
			<class>
				<label>Place</label>
				<type>kon:ProductionPlace</type>
			</class>
			<class>
				<label>Shape</label>
				<type>kon:Shape</type>
			</class>
			<class>
				<label>Technique</label>
				<type>kon:Technique</type>
			</class>
			<!--<class>
				<label>Ware</label>
				<type>kon:Ware</type>
			</class>-->
		</classes>
	</xsl:variable>	

	<xsl:template name="quant">
		<div class="row">
			<div class="col-md-12">
				<a name="quant"/>
				<h2>Quantitative Analysis</h2>

				<xsl:if test="string($category)">
					<xsl:call-template name="construct-table"/>
				</xsl:if>

				<form role="form" id="calculateForm" action="{$display_path}id/{$id}.html#quant" method="get">
					<p>Select a category below to generate a graph showing the quantitative distribution for this typology.</p>
					<div class="form-group">
						<label for="categorySelect">Category</label>
						<select name="category" class="form-control" id="categorySelect">
							<option value="">Select...</option>
							<xsl:for-each select="$classes//class[not(type=$type)]">
								<option value="{type}">
									<xsl:if test="$category = type">
										<xsl:attribute name="selected">selected</xsl:attribute>
									</xsl:if>
									<xsl:value-of select="label"/>
								</option>
							</xsl:for-each>
						</select>
					</div>
					<input type="submit" value="Generate" class="btn btn-default" id="visualize-submit"/>
				</form>
			</div>
		</div>
	</xsl:template>
	

</xsl:stylesheet>
