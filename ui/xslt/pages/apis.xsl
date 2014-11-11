<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0">
	<xsl:include href="../templates.xsl"/>
	<xsl:variable name="display_path">./</xsl:variable>

	<xsl:template match="/">
		<html lang="en">
			<head>
				<title>Kerameikos.org: APIs</title>
				<meta name="viewport" content="width=device-width, initial-scale=1"/>
				<script type="text/javascript" src="http://code.jquery.com/jquery-latest.min.js"/>
				<!-- bootstrap -->
				<link rel="stylesheet" href="http://netdna.bootstrapcdn.com/bootstrap/3.1.1/css/bootstrap.min.css"/>
				<script type="text/javascript" src="http://netdna.bootstrapcdn.com/bootstrap/3.1.1/js/bootstrap.min.js"/>
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
					<h1>Kerameikos Documentation</h1>
					<div>
						<h2>APIs</h2>
						<table class="table">
							<thead>
								<tr>
									<th style="width:50%">API</th>
									<th>XML</th>
									<th>JSON</th>
									<th>Turtle</th>
								</tr>
							</thead>
							<tbody>
								<!--<tr>
					<td>
						<a href="#getLabel">getLabel</a>
					</td>
					<td>
						<a href="api/getLabel?uri=http://Kerameikos.org/id/ar&amp;lang=fr">XML</a>
					</td>
					<td>
						<a href="api/getLabel?uri=http://Kerameikos.org/id/ar&amp;lang=fr&amp;format=json">JSON</a>
					</td>
					<td/>
				</tr>-->
								<tr>
									<td>
										<a href="#getRdf">getRdf</a>
									</td>
									<td>
										<a href="api/getRdf?identifiers=attica|black_figure|exekias">RDF/XML</a>
									</td>
									<td><a href="api/getRdf?identifiers=attica|black_figure|exekias&amp;format=json">JSON-LD</a></td>
									<td>
										<a href="api/getRdf?identifiers=attica|black_figure|exekias&amp;format=ttl">RDF/TTL</a>
									</td>
								</tr>
							</tbody>
						</table>
						<!--<div class="highlight">
			<a name="getLabel"/>
			<h2>Get Label</h2>
			<p>Get the label of a Kerameikos ID given its URI and language code.<br/>
				<b>Webservice Type</b> : REST<br/>
				<b>Url</b> : kerameikos.org/getLabel?<br/>
				<b>Parameters</b> : uri (of Kerameikos ID), lang (two-letter ISO language code), format ('json' or 'xml', default 'xml')<br/>
				<b>Result</b> : returns the label in given language, or English as default.<br/>
				<b>Examples</b>: <a href="api/getLabel?uri=http://kerameikos.org/id/ar&amp;lang=fr">api/getLabel?uri=http://kerameikos.org/id/ar&amp;lang=fr</a>
			</p>
		</div>-->
						<div class="highlight">
							<a name="getRdf"/>
							<h3>Get RDF</h3>
							<p>Aggregate RDF or JSON-LD for Kerameikos ids.<br/>
								<b>Webservice Type</b> : REST<br/>
								<b>Url</b> : kerameikos.org/getRdf?<br/>
								<b>Parameters</b> : identifiers (Kerameikos ids divided by a pipe '|'), format ('xml', 'ttl', 'json', default 'xml')<br/>
								<b>Result</b> : RDF/XML, RDF/TTL, JSON-LD.<br/>
								<b>Examples</b>: <a href="api/getRdf?identifiers=attica|black_figure|exekias">api/getRdf?identifiers=attica|black_figure|exekias</a>
							</p>
						</div>
					</div>
					<div>
						<h2>Data Access</h2>
						<div>
							<h3>Individual Records</h3>
							<p>Numishare supports delivery of individual records in a variety of models and serializations through both REST and content negotiation. Content negotiation (with the
								accept header) requests should be sent to the URI space <xsl:value-of select="concat(/content/config/url, 'id/')"/>. Requesting an unsupported content type will result
								in an HTTP 406: Not Acceptable error.</p>
							<table class="table">
								<thead>
									<tr>
										<th>Model</th>
										<th>REST</th>
										<th>Content Type</th>

									</tr>
								</thead>
								<tbody>
									<tr>
										<td>HTML</td>
										<td>
											<xsl:value-of select="concat(/content/config/url, 'id/{$id}')"/>
										</td>
										<td>
											<code>text/html</code>
										</td>
									</tr>
									<tr>
										<td>NUDS/XML</td>
										<td>
											<xsl:value-of select="concat(/content/config/url, 'id/{$id}.xml')"/>
										</td>
										<td>
											<code>application/xml</code>
										</td>
									</tr>
									<tr>
										<td>KML</td>
										<td>
											<xsl:value-of select="concat(/content/config/url, 'id/{$id}.kml')"/>
										</td>
										<td>
											<code>application/vnd.google-earth.kml+xml</code>
										</td>
									</tr>
									<tr>
										<td>RDF/XML</td>
										<td>
											<xsl:value-of select="concat(/content/config/url, 'id/{$id}.rdf')"/>
										</td>
										<td>
											<code>application/rdf+xml</code>
										</td>
									</tr>
									<tr>
										<td>Turtle</td>
										<td>
											<xsl:value-of select="concat(/content/config/url, 'id/{$id}.ttl')"/>
										</td>
										<td>
											<code>text/turtle</code>
										</td>
									</tr>
									<tr>
										<td>JSON-LD</td>
										<td>
											<xsl:value-of select="concat(/content/config/url, 'id/{$id}.jsonld')"/>
										</td>
										<td>
											<code>application/ld+json</code>
										</td>
									</tr>
								</tbody>
							</table>
						</div>

						<div>
							<h3>Search Results</h3>
							<p>Search results (the browse page) are returned in HTML5, but Numishare supports Atom and RSS via REST, as well as Atom and raw Solr XML via content negotiation of the
								browse page URL, <a href="{concat(/content/config/url, 'results')}"><xsl:value-of select="concat(/content/config/url, 'results')"/></a>. The REST-based Atom feed sorts
								by the Lucene syntax 'timestamp desc' by default, but the sort parameter may be provided manually to alter the default field and order.</p>
							<table class="table">
								<thead>
									<tr>
										<th>Model</th>
										<th>REST</th>
										<th>Content Type</th>

									</tr>
								</thead>
								<tbody>
									<tr>
										<td>HTML</td>
										<td>
											<a href="{concat(/content/config/url, 'results')}">
												<xsl:value-of select="concat(/content/config/url, 'results')"/>
											</a>
										</td>
										<td>
											<code>text/html</code>
										</td>
									</tr>
									<tr>
										<td>Atom</td>
										<td>
											<a href="{concat(/content/config/url, 'feed/')}">
												<xsl:value-of select="concat(/content/config/url, 'feed/')"/>
											</a>
										</td>
										<td>
											<code>application/atom+xml</code>
										</td>
									</tr>									
									<tr>
										<td>Solr/XML</td>
										<td>N/A</td>
										<td>
											<code>application/xml</code>
										</td>
									</tr>
								</tbody>
							</table>
						</div>
						<!--<div>
				<h3>Nomisma RDF Dump</h3>
				<p>Data dumps conforming to the <a href="http://nomisma.org">Nomisma</a> ontology are linked on the index page. At present, these files are only available in RDF/XML.</p>
				<ul>
					<li>
						<a href="nomisma.void.rdf">VoID RDF</a>
					</li>
					<li>
						<a href="nomisma.rdf">Dump RDF</a>
					</li>
				</ul>
			</div>
			<div>
				<h3>Pelagios RDF Dump</h3>
				<p>Data dumps conforming to the <a href="http://pelagios-project.blogspot.com/">Pelagios 3</a> model are linked on the index page. At present, these files are only available in RDF/XML.</p>
				<ul>
					<li>
						<a href="pelagios.void.rdf">VoID RDF</a>
					</li>
					<li>
						<a href="pelagios.rdf">Dump RDF</a>
					</li>
				</ul>
			</div>-->
					</div>
				</div>
			</div>
		</div>
	</xsl:template>
</xsl:stylesheet>
