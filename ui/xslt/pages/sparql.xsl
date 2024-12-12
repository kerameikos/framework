<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0">
	<xsl:include href="../templates.xsl"/>

	<xsl:variable name="display_path"/>

	<xsl:template match="/">
		<html lang="en">
			<head>
				<title>Kerameikos.org: SPARQL</title>
				<meta name="viewport" content="width=device-width, initial-scale=1"/>
				<link rel="icon" type="image/png" href="{$display_path}ui/images/favicon.png"/>
				<script type="text/javascript" src="https://code.jquery.com/jquery-latest.min.js"/>
				<!-- bootstrap -->
				<link rel="stylesheet" href="https://netdna.bootstrapcdn.com/bootstrap/3.3.5/css/bootstrap.min.css"/>
				<script type="text/javascript" src="https://netdna.bootstrapcdn.com/bootstrap/3.3.5/js/bootstrap.min.js"/>
				<script type="text/javascript" src="{$display_path}ui/javascript/codemirror.js"/>
				<script type="text/javascript" src="{$display_path}ui/javascript/matchbrackets.js"/>
				<script type="text/javascript" src="{$display_path}ui/javascript/sparql.js"/>
				<script type="text/javascript" src="{$display_path}ui/javascript/sparql_functions.js"/>
				<link rel="stylesheet" href="{$display_path}ui/css/codemirror.css"/>
				<link rel="stylesheet" href="{$display_path}ui/css/style.css"/>
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
			<xsl:variable name="select"><![CDATA[SELECT * WHERE {
  ?s ?p ?o
} LIMIT 100]]></xsl:variable>
			
			<xsl:apply-templates select="/config/namespaces/namespace[@default = true()]">
				<xsl:sort select="@prefix"/>
			</xsl:apply-templates>
			<xsl:text>&#x00a;</xsl:text>
			<xsl:value-of select="$select"/>
		</xsl:variable>

		<div class="container-fluid content">
			<div class="row">
				<div class="col-md-12">
					<h1>SPARQL Query</h1>
					<form role="form" id="sparqlForm" action="{$display_path}query" method="GET" accept-charset="UTF-8">
						<textarea name="query" rows="20" class="form-control" id="code">
							<xsl:value-of select="$default-query"/>
						</textarea>
						<br/>
						<div class="col-md-6">
							<div class="form-group">
							<h4>Additional prefixes</h4>
							<ul class="list-inline">
								<xsl:for-each select="/config/namespaces/namespace">
									<xsl:sort select="@prefix"/>
									
									<li>
										<xsl:if test="@default = true()">
											<xsl:attribute name="class">hidden</xsl:attribute>
										</xsl:if>
										<button class="prefix-button btn btn-default" title="{@uri}" uri="{@uri}">
											<xsl:value-of select="@prefix"/>
										</button>
									</li>
								</xsl:for-each>
							</ul>
						</div>
							<div class="form-group">
								<label for="output">Output</label>
								<select name="output" class="form-control">
									<option value="html">HTML</option>
									<option value="xml">SPARQL/XML</option>
									<option value="json">SPARQL/JSON</option>
									<option value="text">Text</option>
									<option value="csv">CSV</option>
								</select>
							</div>
							<button type="submit" class="btn btn-default">Submit</button>
						</div>
						<div class="col-md-6">
							<p class="text-info">This endpoint (<xsl:value-of select="concat(/config/url, 'query')"/>) supports content negotiation for the following content types:
								<i>text/html</i>, <i>text/csv</i>, <i>text/plain</i>, <i>application/sparql-results+json</i>, and <i>application/sparql-results+xml</i></p>
						</div>
					</form>
				</div>
			</div>
		</div>
	</xsl:template>
	
	<xsl:template match="namespace">
		<xsl:text>PREFIX </xsl:text>
		<xsl:value-of select="@prefix"/>
		<xsl:text>: &lt;</xsl:text>
		<xsl:value-of select="@uri"/>
		<xsl:text>&gt;&#x00a;</xsl:text>
	</xsl:template>

</xsl:stylesheet>
