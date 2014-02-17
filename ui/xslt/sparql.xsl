<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0">
	<xsl:include href="templates.xsl"/>

	<xsl:variable name="display_path"/>

	<xsl:template match="/">
		<html lang="en">
			<head>
				<title>Kerameikos.org: SPARQL</title>
				<meta name="viewport" content="width=device-width, initial-scale=1"/>
				<!-- bootstrap -->
				<link rel="stylesheet" href="http://netdna.bootstrapcdn.com/bootstrap/3.1.1/css/bootstrap.min.css"/>
				<script src="http://netdna.bootstrapcdn.com/bootstrap/3.1.1/js/bootstrap.min.js"/>
				<link rel="stylesheet" href="{$display_path}ui/css/style.css"/>

				<script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.6.4/jquery.min.js"/>
				<!--<script type="text/javascript">
					$(document).ready(function(){
						$('#toggle-examples').click(function(){
							$('#examples').toggle();
							return false;
						});
						
					});
				</script>-->
			</head>
			<body>
				<xsl:call-template name="header"/>
				<xsl:call-template name="body"/>
				<xsl:call-template name="footer"/>

			</body>
		</html>
	</xsl:template>

	<xsl:template name="body">
		<xsl:variable name="default-query">
<![CDATA[PREFIX rdf:	<http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX dcterms:	<http://purl.org/dc/terms/>
PREFIX skos:	<http://www.w3.org/2004/02/skos/core#>
PREFIX owl:	<http://www.w3.org/2002/07/owl#>
PREFIX foaf:	<http://xmlns.com/foaf/0.1/>
PREFIX ecrm:	<http://erlangen-crm.org/current/>
PREFIX geo:	<http://www.w3.org/2003/01/geo/wgs84_pos#>
PREFIX kid:	<http://kerameikos.org/id/>
PREFIX kon:	<http://kerameikos.org/ontology#>

SELECT * WHERE {
?s ?p ?o
}]]>
		</xsl:variable>

		<div class="container-fluid">
			<div class="row">
				<div class="col-md-12">
					<h1>SPARQL Query</h1>
					
					<form action="{$display_path}query" method="GET" accept-charset="UTF-8">
						<textarea name="query" rows="20" style="width:95%;margins:20px auto">
							<xsl:value-of select="$default-query"/>
						</textarea>
						<br/> Output: <select name="output">
							<option value="xml">XML</option>
							<option value="json">JSON</option>
							<!--<option value="text">Text</option>
								<option value="csv">CSV</option>
								<option value="tsv">TSV</option>-->
						</select>
						<!--<br/> XSLT style sheet (blank for none): <input name="stylesheet" size="20" value="/xml-to-html.xsl"/>-->
						<input type="submit" value="Get Results"/>
					</form>
				</div>
			</div>
		</div>
	</xsl:template>

</xsl:stylesheet>
