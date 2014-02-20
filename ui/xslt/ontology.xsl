<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0">
	<xsl:include href="templates.xsl"/>

	<xsl:variable name="display_path"/>

	<xsl:template match="/">
		<html lang="en">
			<head>
				<title>Kerameikos.org: Ontology</title>
				<meta name="viewport" content="width=device-width, initial-scale=1"/>
				<script type="text/javascript" src="http://code.jquery.com/jquery-latest.min.js"/>
				<!-- bootstrap -->
				<link rel="stylesheet" href="http://netdna.bootstrapcdn.com/bootstrap/3.1.1/css/bootstrap.min.css"/>
				<script src="http://netdna.bootstrapcdn.com/bootstrap/3.1.1/js/bootstrap.min.js"/>
				<link rel="stylesheet" href="{$display_path}ui/css/style.css"/>

				<script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.6.4/jquery.min.js"/>
			</head>
			<body>
				<xsl:call-template name="header"/>
				<xsl:call-template name="body"/>
				<xsl:call-template name="footer"/>

			</body>
		</html>
	</xsl:template>

	<xsl:template name="body">
		<div class="container-fluid">
			<div class="row">
				<div class="col-md-12">
					<h1>Ontology</h1>
					<p>This page is the placeholder for the Kerameikos.org ceramic ontology. This page will eventually be generated dynamically from RDF.</p>
					<div>
						<div>
							<h2>Classes</h2>
							<a name="#Shape"/>
							<h3>Shape</h3>
							<p>Vessel shape; considered object types by the British Museum thesaurus.</p>
							<a name="#Technique"/>
							<h3>Technique</h3>
							<p>description</p>
							<a name="#Ware"/>
							<h3>Ware</h3>
							<p>description</p>
						</div>
						<div>
							<h2>Properties</h2>
						</div>
					</div>
				</div>				
			</div>
		</div>
	</xsl:template>

</xsl:stylesheet>
