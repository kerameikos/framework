<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0">

	<xsl:variable name="display_path"/>

	<xsl:template match="/">
		<html>
			<head>
				<title>Ceramic Project</title>
				<link rel="stylesheet" type="text/css" href="http://yui.yahooapis.com/3.8.0/build/cssgrids/grids-min.css"/>
				<link rel="stylesheet" href="{$display_path}ui/css/style.css"/>

				<script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.6.4/jquery.min.js"/>
				<!--<script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jqueryui/1.8.23/jquery-ui.min.js"/>-->
			</head>
			<body>
				<!--<xsl:call-template name="header"/>-->
				<xsl:call-template name="index"/>
				<!--<xsl:call-template name="footer"/>-->
			</body>
		</html>
	</xsl:template>

	<xsl:template name="index">
		<div class="yui3-g">
			<div class="yui3-u-1">
				<div class="content">
					<xsl:copy-of select="//index/*"/>
				</div>
			</div>
		</div>
	</xsl:template>

</xsl:stylesheet>
