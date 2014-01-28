<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="#all" version="2.0">

	<xsl:template name="header">
		<div id="hd">
			<span>
				<b>Ceramic Prototype Site</b>
			</span>
			<xsl:text> | </xsl:text>
			<a href="{$display_path}">Home</a>
			<xsl:text> | </xsl:text>
			<a href="{$display_path}id/" >Browse</a>
			<xsl:text> | </xsl:text>
			<a href="{$display_path}sparql/">SPARQL</a>
			<!--<xsl:text> | </xsl:text>
			<a href="{$display_path}apis/">APIs</a>-->
		</div>
	</xsl:template>

	<xsl:template name="footer">
		<div id="ft"> This {DATA(BASE)-NAME} is made available under the <a href="http://opendatacommons.org/licenses/odbl/1.0/">Open Database License</a>. Any
			rights in individual contents of the database are licensed under the <a href="http://opendatacommons.org/licenses/dbcl/1.0/">Database Contents
				License</a></div>
	</xsl:template>

</xsl:stylesheet>
