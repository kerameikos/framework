<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0">
	<xsl:include href="../templates.xsl"/>
	<xsl:variable name="display_path">./</xsl:variable>

	<xsl:template match="/">
		<html lang="en">
			<head>
				<title>Kerameikos.org</title>
				<meta name="viewport" content="width=device-width, initial-scale=1"/>
				<script type="text/javascript" src="http://code.jquery.com/jquery-latest.min.js"/>
				<!-- bootstrap -->
				<link rel="stylesheet" href="http://netdna.bootstrapcdn.com/bootstrap/3.3.5/css/bootstrap.min.css"/>
				<script type="text/javascript" src="http://netdna.bootstrapcdn.com/bootstrap/3.3.5/js/bootstrap.min.js"/>
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
		<div class="jumbotron visible-xs visible-sm">
			<div class="container">
				<div class="row text-center">					
					<div class="col-md-12">
						<h1>κεραμεικος</h1>
					</div>
				</div>
			</div>
		</div>
		<div class="container-fluid banner hidden-xs hidden-sm">			
			<div class="row">
				<div class="col-md-6 col-md-offset-6">
					<div class="row banner-background text-right">						
						<div class="col-md-12">
							<h1>κεραμεικος</h1>
						</div>
					</div>					
				</div>
			</div>
		</div>
		<div class="container-fluid content">
			<div class="row">
<!--				<img src="http://numismatics.org:8080/orbeon/themes/ocre/images/banner.jpg" style="width:100%">-->
				<div class="col-md-8">
					<xsl:copy-of select="//index/*"/>
					<div>
						<h3>Data Export</h3>
						<div class="col-md-4">
							<h4>Kerameikos Linked Data</h4>
							<ul>
								<li>
									<a href="kerameikos.org.rdf">RDF/XML</a>
								</li>
								<!--	<li>
									<a href="kerameikos.org.ttl">Turtle</a>
								</li>
								<li>
									<a href="kerameikos.org.jsonld">JSON-LD</a>
								</li>-->
							</ul>				
						</div>
						<div class="col-md-4">
							<h4>Pelagios Annotations</h4>
							<table class="table-dl">
								<tr>
									<td>
										<a href="http://commons.pelagios.org/">
											<img src="{$display_path}ui/images/pelagios.png"/>
										</a>
									</td>
									<td>
										<strong>VoID for Concepts: </strong>
										<a href="pelagios.void.rdf">RDF/XML</a>
										<br/>
										<strong>VoID for Partner Objects: </strong>
										<a href="pelagios-objects.void.rdf">RDF/XML</a>
									</td>
								</tr>
							</table>
						</div>
						<div class="col-md-4">
							<h4>Atom Feed</h4>
							<a href="feed/">
								<img src="{$display_path}ui/images/atom-large.png"/>
							</a>
						</div>
					</div>					
				</div>
				<div class="col-md-4">
					<h3>Collaborators</h3>
					<p>logos go here</p>
				</div>
			</div>
		</div>
	</xsl:template>
</xsl:stylesheet>
