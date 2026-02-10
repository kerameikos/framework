<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:res="http://www.w3.org/2005/sparql-results#"
	exclude-result-prefixes="#all" version="2.0">
	<xsl:include href="../../templates.xsl"/>
	<xsl:variable name="display_path"/>

	<xsl:variable name="datasets" as="element()*">
		<xsl:copy-of select="descendant::res:sparql"/>
	</xsl:variable>

	<xsl:template match="/">
		<html lang="en">
			<head>
				<title>Kerameikos.org: Datasets</title>
				<meta name="viewport" content="width=device-width, initial-scale=1"/>
				<link rel="icon" type="image/png" href="{$display_path}ui/images/favicon.png"/>
				<!-- bootstrap -->
				<script type="text/javascript" src="https://code.jquery.com/jquery-latest.min.js"/>
				<script type="text/javascript" src="{$display_path}ui/javascript/result_functions.js"/>
				<link rel="stylesheet" href="https://netdna.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap.min.css"/>
				<script src="https://netdna.bootstrapcdn.com/bootstrap/3.3.6/js/bootstrap.min.js"/>
				<link rel="stylesheet" href="{$display_path}ui/css/style.css"/>
				<xsl:call-template name="wordpress-css"/>
				<!-- google analytics -->
				<xsl:if test="string(//config/google_analytics)">
					<script type="text/javascript">
						<xsl:value-of select="//config/google_analytics"/>
					</script>
				</xsl:if>
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
					<xsl:apply-templates select="descendant::res:sparql"/>
				</div>
			</div>
		</div>
	</xsl:template>

	<xsl:template match="res:sparql">
		<!-- evaluate the type of response to handle ASK and SELECT -->
		<xsl:choose>
			<xsl:when test="res:results">
				<h1>Datasets</h1>
				
				<h3>Kerameikos.org Data Exports</h3>
				<div class="row">					
					<div class="col-md-4">
						<h4>Kerameikos Linked Data</h4>
						<ul>
							<li>
								<a href="kerameikos.org.rdf">RDF/XML</a>
							</li>
							<li>
								<a href="kerameikos.org.ttl">Turtle</a>
							</li>
							<li>
								<a href="kerameikos.org.jsonld">JSON-LD</a>
							</li>
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
						<a href="feed/" title="Atom Feed">
							<img src="{$display_path}ui/images/atom-large.png" alt="Atom Logo"/>
						</a>
					</div>
				</div>

				<div class="col-md-12">
					<h3>Contributors</h3>
					<p>Below are downloadable datasets from Kerameikos.org contributors of ceramics into the Linked Open Data Cloud.</p>
					<xsl:choose>
						<xsl:when test="count(descendant::res:result) &gt; 0">
							<table class="table table-striped">
								<thead>
									<tr>
										<th>Dataset</th>
										<th>Description</th>
										<th>Publisher</th>
										<th class="text-center">Rights/License</th>
										<th class="text-center">Count</th>
										<th class="text-center">Data Dump</th>
									</tr>
								</thead>
								<tbody>
									<xsl:for-each select="distinct-values(descendant::res:result/res:binding[@name = 'dataset']/res:uri)">
										<xsl:variable name="uri" select="."/>
										<xsl:variable name="result" as="element()*">
											<xsl:copy-of select="$datasets//res:result[res:binding[@name = 'dataset']/res:uri = $uri][1]"/>
										</xsl:variable>

										<xsl:apply-templates select="$result">
											<xsl:with-param name="dumps"
												select="$datasets//res:result[res:binding[@name = 'dataset']/res:uri = $uri]/res:binding[@name = 'dump']/res:uri"/>
										</xsl:apply-templates>
									</xsl:for-each>
								</tbody>
							</table>
						</xsl:when>
						<xsl:otherwise>
							<p>No datasets available in the SPARQL endpoint.</p>
						</xsl:otherwise>
					</xsl:choose>
				</div>
			</xsl:when>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="res:result">
		<xsl:param name="dumps"/>

		<tr>
			<td>
				<a href="{res:binding[@name='dataset']/res:uri}">
					<xsl:value-of select="res:binding[@name = 'title']/res:literal"/>
				</a>
			</td>
			<td>
				<xsl:value-of select="res:binding[@name = 'description']/res:literal"/>
			</td>
			<td>
				<xsl:value-of select="res:binding[@name = 'publisher']/res:literal"/>
			</td>
			<td class="text-center">
				<xsl:choose>
					<xsl:when test="res:binding[@name = 'license']">
						<a href="{res:binding[@name='license']/res:uri}">
							<xsl:variable name="license" select="res:binding[@name = 'license']/res:uri"/>
							<xsl:choose>
								<xsl:when test="contains($license, 'http://opendatacommons.org/licenses/odbl/')">ODC-ODbL</xsl:when>
								<xsl:when test="contains($license, 'http://opendatacommons.org/licenses/by/')">ODC-by</xsl:when>
								<xsl:when test="contains($license, 'http://opendatacommons.org/licenses/pddl/')">ODC-PDDL</xsl:when>
								<xsl:when test="contains($license, 'http://creativecommons.org/licenses/by/')">
									<img src="http://i.creativecommons.org/l/by/3.0/88x31.png" alt="CC BY" title="CC BY"/>
								</xsl:when>
								<xsl:when test="contains($license, 'http://creativecommons.org/licenses/by-nd/')">
									<img src="http://i.creativecommons.org/l/by-nd/3.0/88x31.png" alt="CC BY-ND" title="CC BY-ND"/>
								</xsl:when>
								<xsl:when test="contains($license, 'http://creativecommons.org/licenses/by-nc-sa/')">
									<img src="http://i.creativecommons.org/l/by-nc-sa/3.0/88x31.png" alt="CC BY-NC-SA" title="CC BY-NC-SA"/>
								</xsl:when>
								<xsl:when test="contains($license, 'http://creativecommons.org/licenses/by-sa/')">
									<img src="http://i.creativecommons.org/l/by-sa/3.0/88x31.png" alt="CC BY-SA" title="CC BY-SA"/>
								</xsl:when>
								<xsl:when test="contains($license, 'http://creativecommons.org/licenses/by-nc/')">
									<img src="http://i.creativecommons.org/l/by-nc/3.0/88x31.png" alt="CC BY-NC" title="CC BY-NC"/>
								</xsl:when>
								<xsl:when test="contains($license, 'http://creativecommons.org/licenses/by-nc-nd/')">
									<img src="http://i.creativecommons.org/l/by-nc-nd/3.0/88x31.png" alt="CC BY-NC-ND" title="CC BY-NC-ND"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="res:binding[@name = 'license']/res:uri"/>
								</xsl:otherwise>
							</xsl:choose>
						</a>
					</xsl:when>
					<xsl:when test="res:binding[@name = 'rights']">
						<a href="{res:binding[@name='rights']/res:uri}">
							<xsl:value-of select="res:binding[@name = 'rights']/res:uri"/>
						</a>
					</xsl:when>
				</xsl:choose>
			</td>
			<td class="text-center">
				<xsl:value-of select="res:binding[@name = 'count']/res:literal"/>
			</td>
			<td class="text-center">
				<xsl:for-each select="$dumps">
					<a href="{.}" title="{.}">
						<span class="glyphicon glyphicon-download-alt"/>
					</a>
				</xsl:for-each>
			</td>
		</tr>
	</xsl:template>
</xsl:stylesheet>
