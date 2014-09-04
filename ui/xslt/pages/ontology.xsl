<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
	xmlns:skos="http://www.w3.org/2004/02/skos/core#" xmlns:foaf="http://xmlns.com/foaf/0.1/" xmlns:kon="http://kerameikos.org/ontology#" xmlns:owl="http://www.w3.org/2002/07/owl#"
	xmlns:dcterms="http://purl.org/dc/terms/" xmlns:xsd="http://www.w3.org/2001/XMLSchema#" xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#" exclude-result-prefixes="#all"
	version="2.0">
	<xsl:include href="../templates.xsl"/>

	<xsl:variable name="display_path"/>

	<xsl:template match="/">
		<html lang="en">
			<head>
				<title>Kerameikos.org: Ontology</title>
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
					<xsl:apply-templates select="descendant::owl:Ontology"/>
				</div>
			</div>
			<div class="row">
				<div class="col-md-3">
					<ul>
						<li>
							<h4>Classes</h4>
							<ul>

								<xsl:apply-templates select="descendant::owl:Class" mode="toc"/>
							</ul>
						</li>

						<li>
							<h4>Properties</h4>
							<ul>

								<xsl:apply-templates select="descendant::owl:ObjectProperty" mode="toc"/>
							</ul>
						</li>
						<li>
							<h4>Alternative Serializations</h4>
							<ul>
								<li>
									<a href="./ontology.rdf">RDF/XML</a>
								</li>
								<li>
									<a href="./ontology.ttl">TTL</a>
								</li>
							</ul>
						</li>
					</ul>
				</div>
				<div class="col-md-9">
					<div>
						<div>
							<h2>Classes</h2>
							<xsl:apply-templates select="descendant::owl:Class" mode="body"/>
						</div>
						<div>
							<h2>Properties</h2>
							<xsl:apply-templates select="descendant::owl:ObjectProperty" mode="body"/>
						</div>
					</div>
				</div>
			</div>
		</div>
	</xsl:template>

	<xsl:template match="owl:Ontology">
		<h1>
			<xsl:value-of select="rdfs:label[@xml:lang='en']"/>
		</h1>
		<p>
			<xsl:value-of select="rdfs:comment[@xml:lang='en']"/>
		</p>
	</xsl:template>

	<xsl:template match="owl:Class|owl:ObjectProperty" mode="toc">
		<li>
			<a href="#{substring-after(@rdf:about, '#')}">
				<xsl:value-of select="rdfs:label[@xml:lang='en']"/>
			</a>
		</li>
	</xsl:template>

	<xsl:template match="owl:Class|owl:ObjectProperty" mode="body">
		<h3 id="{substring-after(@rdf:about, '#')}">
			<xsl:value-of select="rdfs:label[@xml:lang='en']"/>
		</h3>
		<p>
			<xsl:value-of select="rdfs:comment[@xml:lang='en']"/>
		</p>
	</xsl:template>

</xsl:stylesheet>
