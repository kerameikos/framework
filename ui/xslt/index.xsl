<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0">
	<xsl:include href="templates.xsl"/>
	<xsl:variable name="display_path">./</xsl:variable>

	<xsl:template match="/">
		<html>
			<head>
				<title>Ceramic Project</title>
				<link rel="stylesheet" type="text/css" href="http://yui.yahooapis.com/3.8.0/build/cssgrids/grids-min.css"/>
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
		<div class="yui3-g">
			<div class="yui3-u-2-3">
				<div class="content">
					<xsl:copy-of select="//index/*"/>
				</div>
			</div>
			<div class="yui3-u-1-3">
				<div class="content">
					<h2>Sidebar</h2>
					<p class="desc">The sidebar will contain links to web services and downloads of data dumps.</p>
					<div>
						<h3>Search</h3>
						<form action="id/" method="GET">
							<input type="text" name="q"/>
							<input type="submit" value="Search"/>
						</form>
					</div>
					<div>
						<h3>Atom Feed</h3>
						<a href="feed/">
							<img src="{$display_path}ui/images/atom-large.png"/>
						</a>
					</div>
					<div>
						<h3>Data Download</h3>
						<a href="kerameikos.org.xml">RDF/XML</a>
					</div>
				</div>
			</div>
		</div>
	</xsl:template>

</xsl:stylesheet>
