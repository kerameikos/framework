<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0">
	<xsl:include href="../templates.xsl"/>
	<xsl:variable name="display_path">./</xsl:variable>

	<xsl:template match="/">
		<html lang="en">
			<head>
				<title>Kerameikos.org: APIs</title>
				<meta name="viewport" content="width=device-width, initial-scale=1"/>
				<link rel="icon" type="image/png" href="{$display_path}ui/images/favicon.png"/>
				<script type="text/javascript" src="//code.jquery.com/jquery-latest.min.js"/>
				<!-- bootstrap -->
				<link rel="stylesheet" href="//netdna.bootstrapcdn.com/bootstrap/3.3.5/css/bootstrap.min.css"/>
				<script type="text/javascript" src="//netdna.bootstrapcdn.com/bootstrap/3.3.5/js/bootstrap.min.js"/>
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
		<div class="container-fluid content">
			<div class="row">
				<div class="col-md-12">
					<xsl:copy-of select="/content/content/apis/*"/>					
				</div>
			</div>
		</div>
	</xsl:template>
</xsl:stylesheet>
