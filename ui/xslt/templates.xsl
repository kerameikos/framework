<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="#all" version="2.0">

	<xsl:template name="header">
		<!-- Static navbar -->
		<div class="navbar navbar-default navbar-custom navbar-static-top" role="navigation">
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
						<li class="dropdown">
							<a href="#" class="dropdown-toggle" data-toggle="dropdown">Research Tools <b class="caret"/></a>
							<ul class="dropdown-menu">
								<li>
									<a href="{$display_path}research/distribution">Typological Distribution</a>
								</li>
							</ul>
						</li>
						<li>
							<a href="{$display_path}ontology">Ontology</a>
						</li>
						<li>
							<a href="{$display_path}apis">APIs</a>
						</li>
						<li class="dropdown">
							<a href="#" class="dropdown-toggle" data-toggle="dropdown">Documentation <b class="caret"/></a>
							<ul class="dropdown-menu">
								<xsl:for-each select="//config/documentation/page">
									<li>
										<a href="{$display_path}documentation/{@stub}">
											<xsl:value-of select="@label"/>
										</a>
									</li>
								</xsl:for-each>
							</ul>
						</li>
						<li>
							<a href="{$display_path}sparql">SPARQL</a>
						</li>
						<li>
							<a href="{$display_path}datasets">Datasets</a>
						</li>
					</ul>
					<div class="col-sm-3 col-md-3 pull-right">
						<form class="navbar-form" role="search" action="{$display_path}browse/" method="get">
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
				<div class="col-md-6 text-left"> Kerameikos.org data are made available under the <a href="http://opendatacommons.org/licenses/odbl/1.0/">Open Database
						License</a>. See <a href="datasets">datasets</a> for image rights, respective to individual insitution. 
				</div>
				<div class="col-md-6 text-right">
					<a href="http://www.getty.edu/art/collection/objects/11743/">Banner image</a> made available courtesy of the J. Paul Getty Museum.
				</div>
			</div>
		</div>
	</xsl:template>

</xsl:stylesheet>
