<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="#all" version="2.0">

	<xsl:template name="header">
		<!-- Static navbar -->
		<div class="navbar navbar-default navbar-static-top" role="navigation">
			<div class="container-fluid">
				<div class="navbar-header">
					<button type="button" class="navbar-toggle" data-toggle="collapse" data-target=".navbar-collapse">
						<span class="sr-only">Toggle navigation</span>
						<span class="icon-bar"/>
						<span class="icon-bar"/>
						<span class="icon-bar"/>
					</button>
					<a class="navbar-brand" href="{$display_path}./">Kerameikos.org</a>
				</div>
				<div class="navbar-collapse collapse">
					<ul class="nav navbar-nav">
						<li>
							<a href="{$display_path}browse/">Browse</a>
						</li>
						<li>
							<a href="{$display_path}ontology">Ontology</a>
						</li>
						<li>
							<a href="{$display_path}apis">APIs</a>
						</li>
						<li>
							<a href="{$display_path}sparql">SPARQL</a>
						</li>
					</ul>
					<div class="col-sm-3 col-md-3 pull-right">
						<form class="navbar-form" role="search" action="{$display_path}id/" method="get">
							<div class="input-group">
								<input type="text" class="form-control" placeholder="Search" name="q" id="srch-term"/>
								<div class="input-group-btn">
									<button class="btn btn-default" type="submit">
										<i class="glyphicon glyphicon-search"/>
									</button>
								</div>
							</div>
						</form>
					</div>
				</div>
				<!--/.nav-collapse -->
			</div>
		</div>
	</xsl:template>

	<xsl:template name="footer">
		<div class="container-fluid" id="footer">
			<div class="row">
				<div class="col-md-12">
					<p class="text-muted">Kerameikos.org data are made available under the <a href="http://opendatacommons.org/licenses/odbl/1.0/">Open Database License</a>. Any
						rights in individual contents of the database are licensed under the <a href="http://opendatacommons.org/licenses/dbcl/1.0/">Database Contents
							License</a></p>
				</div>
			</div>			
		</div>
	</xsl:template>

</xsl:stylesheet>
