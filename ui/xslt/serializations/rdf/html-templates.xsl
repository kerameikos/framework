<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:foaf="http://xmlns.com/foaf/0.1/" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
	xmlns:dbpedia-owl="http://dbpedia.org/ontology/" xmlns:skos="http://www.w3.org/2004/02/skos/core#" xmlns:owl="http://www.w3.org/2002/07/owl#"
	xmlns:crm="http://www.cidoc-crm.org/cidoc-crm/" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:dcterms="http://purl.org/dc/terms/"
	xmlns:kid="https://kerameikos.org/id/" xmlns:kon="https://kerameikos.org/ontology#" xmlns:geo="http://www.w3.org/2003/01/geo/wgs84_pos#"
	xmlns:edm="http://www.europeana.eu/schemas/edm/" xmlns:org="http://www.w3.org/ns/org#" xmlns:tei="http://www.tei-c.org/ns/1.0"
	xmlns:kerameikos="https://kerameikos.org/" xmlns:osgeo="http://data.ordnancesurvey.co.uk/ontology/geometry/"
	xmlns:res="http://www.w3.org/2005/sparql-results#" xmlns:prov="http://www.w3.org/ns/prov#" xmlns:ontolex="http://www.w3.org/ns/lemon/ontolex#"
	xmlns:crmgeo="http://www.ics.forth.gr/isl/CRMgeo/" exclude-result-prefixes="#all" version="2.0">

	<!-- human readable templates for ID or other concept scheme RDF serializations. mode="type" is for general output from SPARQL CONSTRUCT or DESCRIBE -->
	<xsl:template match="*" mode="human-readable">
		<xsl:param name="mode"/>

		<div>
			<xsl:if test="@rdf:about">
				<xsl:attribute name="about" select="@rdf:about"/>
				<xsl:attribute name="typeof" select="name()"/>
				<xsl:if test="contains(@rdf:about, '#this')">
					<xsl:attribute name="id">#this</xsl:attribute>
				</xsl:if>
			</xsl:if>

			<xsl:element
				name="{if (name()='prov:Activity') then 'h4' else if (name() = 'dcterms:ProvenanceStatement') then 'h3' else if (not(parent::rdf:RDF)) then 'h3' else if(position()=1) then 'h2' else 'h3'}">
				<!-- display a label based on the URI if there is an @rdf:about, otherwise formulate a blank node label -->

				<xsl:choose>
					<xsl:when test="@rdf:about">
						<xsl:choose>
							<xsl:when test="contains(@rdf:about, '#')">
								<xsl:value-of select="concat('#', substring-after(@rdf:about, '#'))"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="skos:prefLabel[@xml:lang = 'en']"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:otherwise>[blank node]</xsl:otherwise>
				</xsl:choose>


				<small>
					<xsl:text> (</xsl:text>
					<a href="{concat(namespace-uri(.), local-name())}" title="{name()}">
						<xsl:value-of select="kerameikos:normalizeCurie(name(), 'en')"/>
					</a>
					<xsl:if test="rdf:type">
						<xsl:text>, </xsl:text>
						<xsl:apply-templates select="rdf:type" mode="normalize-class"/>
					</xsl:if>
					<xsl:text>)</xsl:text>
				</small>
			</xsl:element>

			<xsl:if test="@rdf:about">
				<p>
					<strong>Canonical URI: </strong>
					<code>
						<a href="{@rdf:about}">
							<xsl:value-of select="@rdf:about"/>
						</a>
					</code>
				</p>
			</xsl:if>


			<xsl:if test="skos:prefLabel">
				<div class="section">
					<h4>Labels</h4>
					<dl class="dl-horizontal">
						<dt>
							<a href="{concat($namespaces//namespace[@prefix='skos']/@uri, 'prefLabel')}" title="skos:prefLabel">
								<xsl:value-of select="kerameikos:normalizeCurie('skos:prefLabel', 'en')"/>
							</a>
						</dt>
						<dd>
							<xsl:apply-templates select="skos:prefLabel[lang('en') or lang('fr') or lang('de') or lang('el') or lang('it')]" mode="prefLabel"/>

							<!-- additional labels -->
							<xsl:if test="skos:prefLabel[not(lang('en') or lang('fr') or lang('de') or lang('el') or lang('it'))]">
								<span style="margin-left:20px">
									<i>Additional labels</i>
									<a href="#" class="toggle-button" id="toggle-prefLabels" title="Click to hide or show additional labels">
										<span class="glyphicon glyphicon-triangle-right"/>
									</a>
								</span>
							</xsl:if>
							<div style="display:none" id="prefLabels">
								<xsl:apply-templates select="skos:prefLabel[not(lang('en') or lang('fr') or lang('de') or lang('el') or lang('it'))]"
									mode="prefLabel">
									<xsl:sort select="@xml:lang"/>
								</xsl:apply-templates>
							</div>
						</dd>



						<xsl:apply-templates select="skos:altLabel" mode="human-readable">
							<xsl:sort select="@xml:lang"/>
						</xsl:apply-templates>


						<xsl:if test="ontolex:otherForm">
							<dt>
								<a href="{concat($namespaces//namespace[@prefix='lexinfo']/@uri, 'plural')}" title="lexinfo:plural">
									<xsl:value-of select="kerameikos:normalizeCurie('lexinfo:plural', 'en')"/>
								</a>
							</dt>
							<dd>
								<xsl:apply-templates select="ontolex:otherForm/ontolex:Form/ontolex:writtenRep" mode="prefLabel">
									<xsl:sort select="@xml:lang"/>
								</xsl:apply-templates>
							</dd>
						</xsl:if>
					</dl>
				</div>

			</xsl:if>

			<xsl:if test="skos:definition">
				<div class="section">
					<h4>Definitions</h4>

					<dl class="dl-horizontal">
						<xsl:apply-templates select="skos:definition" mode="human-readable"/>

					</dl>

				</div>
			</xsl:if>

			<xsl:if test="crm:P4_has_time-span">
				<div class="section">
					<h4>Time Span</h4>

					<dl class="dl-horizontal">
						<xsl:apply-templates select="crm:P4_has_time-span" mode="human-readable"/>
					</dl>
				</div>
			</xsl:if>

			<xsl:apply-templates select="geo:location" mode="human-readable"/>

			<xsl:if test="org:hasMembership">
				<div class="section">
					<h4>Roles</h4>

					<xsl:for-each select="org:hasMembership">
						<xsl:variable name="uri" select="@rdf:resource"/>
						<xsl:apply-templates select="//org:Membership[@rdf:about = $uri]" mode="human-readable"/>
					</xsl:for-each>
				</div>
			</xsl:if>

			<xsl:if test="skos:exactMatch or skos:closeMatch or skos:related or skos:broader">
				<div class="section">
					<h4>Relations</h4>

					<dl class="dl-horizontal">
						<xsl:apply-templates select="skos:exactMatch | skos:broader | skos:closeMatch | skos:related | dcterms:isPartOf | dcterms:source"
							mode="human-readable">
							<xsl:sort select="local-name()"/>
							<xsl:sort select="@rdf:resource"/>
						</xsl:apply-templates>
					</dl>
				</div>
			</xsl:if>

			<!-- TODO: location, miscellaneous -->
		</div>
	</xsl:template>

	<xsl:template match="crm:P4_has_time-span" mode="human-readable">
		<dt>
			<a href="{concat(namespace-uri(), local-name())}" title="{name()}">Date</a>
		</dt>
		<dd>
			<span property="crm:E52_Time-Span">
				<xsl:apply-templates select="crm:E52_Time-Span/crm:P82a_begin_of_the_begin" mode="human-readable"/>
				<xsl:text> - </xsl:text>
				<xsl:apply-templates select="crm:E52_Time-Span/crm:P82b_end_of_the_end" mode="human-readable"/>
			</span>
		</dd>
	</xsl:template>

	<!-- date rendering -->
	<xsl:template match="edm:begin | edm:end | crm:P82a_begin_of_the_begin | crm:P82b_end_of_the_end" mode="human-readable">
		<span property="{name()}" content="{.}" datatype="xsd:gYear">
			<xsl:value-of select="kerameikos:normalizeYear(.)"/>
		</span>
	</xsl:template>

	<xsl:template match="geo:location" mode="human-readable">
		<xsl:variable name="uri" select="@rdf:resource"/>

		<xsl:apply-templates select="//geo:SpatialThing[@rdf:about = $uri]" mode="human-readable"/>
	</xsl:template>

	<xsl:template match="geo:SpatialThing" mode="human-readable">
		<div class="section">
			<h4>Geospatial Data</h4>
			<dl class="dl-horizontal">
				<xsl:apply-templates select="geo:lat | geo:long | osgeo:asGeoJSON | dcterms:isPartOf | crmgeo:asWKT" mode="human-readable"/>
			</dl>
		</div>
	</xsl:template>

	<xsl:template match="org:Membership" mode="human-readable">
		<dl class="dl-horizontal">
			<xsl:apply-templates select="*" mode="human-readable"/>
		</dl>
	</xsl:template>

	<xsl:template match="skos:prefLabel | ontolex:writtenRep" mode="prefLabel">
		<span property="{name()}" xml:lang="{@xml:lang}">
			<xsl:value-of select="."/>
		</span>
		<xsl:if test="string(@xml:lang)">
			<span class="lang">
				<xsl:value-of select="concat(' (', @xml:lang, ')')"/>
			</span>
		</xsl:if>
		<xsl:if test="not(position() = last())">
			<xsl:text>, </xsl:text>
		</xsl:if>
	</xsl:template>

	<xsl:template match="skos:definition" mode="human-readable">
		<dt>
			<xsl:value-of select="@xml:lang"/>
		</dt>
		<dd property="{name()}" lang="{@xml:lang}">
			<xsl:value-of select="."/>
		</dd>
	</xsl:template>

	<xsl:template match="osgeo:asGeoJSON | crmgeo:asWKT" mode="human-readable">
		<dt>
			<a href="{concat(namespace-uri(), local-name())}" title="{name()}">
				<xsl:value-of select="kerameikos:normalizeCurie(name(), 'en')"/>
			</a>
		</dt>
		<dd>
			<xsl:call-template name="render_geojson"/>
		</dd>
	</xsl:template>

	<xsl:template match="edm:begin | edm:end" mode="human-readable"> </xsl:template>

	<xsl:template match="skos:* | dcterms:source | dcterms:isPartOf | org:role | org:organization | geo:lat | geo:long" mode="human-readable">
		<dt>
			<a href="{concat(namespace-uri(), local-name())}" title="{name()}">
				<xsl:value-of select="kerameikos:normalizeCurie(name(), 'en')"/>
			</a>
		</dt>
		<dd property="{name()}">
			<xsl:if test="@xml:lang">
				<xsl:attribute name="lang" select="@xml:lang"/>
			</xsl:if>

			<xsl:choose>
				<xsl:when test="@rdf:resource">
					<a href="{@rdf:resource}">
						<xsl:value-of select="@rdf:resource"/>
					</a>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="."/>
				</xsl:otherwise>
			</xsl:choose>

			<xsl:if test="string(@xml:lang)">
				<span class="lang">
					<xsl:value-of select="concat(' (', @xml:lang, ')')"/>
				</span>
			</xsl:if>
		</dd>
	</xsl:template>

	<xsl:template match="*" mode="type">
		<xsl:param name="mode"/>

		<div>
			<xsl:if test="@rdf:about">
				<xsl:attribute name="about" select="@rdf:about"/>
				<xsl:attribute name="typeof" select="name()"/>
				<xsl:if test="contains(@rdf:about, '#this')">
					<xsl:attribute name="id">#this</xsl:attribute>
				</xsl:if>
			</xsl:if>

			<xsl:element
				name="{if (name()='prov:Activity') then 'h4' else if (name() = 'dcterms:ProvenanceStatement') then 'h3' else if (not(parent::rdf:RDF)) then 'h3' else if(position()=1) then 'h2' else 'h3'}">
				<!-- display a label based on the URI if there is an @rdf:about, otherwise formulate a blank node label -->
				<xsl:choose>
					<xsl:when test="@rdf:about">
						<!-- display the full URI if the template is called from the SPARQL HTML results page -->
						<a href="{@rdf:about}">
							<xsl:value-of select="@rdf:about"/>
						</a>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>[blank node]</xsl:text>
					</xsl:otherwise>
				</xsl:choose>

				<small>
					<xsl:text> (</xsl:text>
					<a href="{concat(namespace-uri(.), local-name())}">
						<xsl:value-of select="kerameikos:normalizeCurie(name(), 'en')"/>
					</a>
					<xsl:if test="rdf:type">
						<xsl:text>, </xsl:text>
						<xsl:apply-templates select="rdf:type" mode="normalize-class"/>
					</xsl:if>
					<xsl:text>)</xsl:text>
				</small>
			</xsl:element>

			<xsl:if test="@rdf:about">
				<p>
					<strong>Canonical URI: </strong>
					<code>
						<a href="{@rdf:about}">
							<xsl:value-of select="@rdf:about"/>
						</a>
					</code>
				</p>
			</xsl:if>


			<dl class="dl-horizontal">


				<!-- choose the method of sorting -->
				<xsl:choose>
					<xsl:when test="name() = 'dcterms:ProvenanceStatement'">
						<xsl:apply-templates mode="list-item">
							<xsl:sort select="xs:dateTime(prov:Activity/prov:atTime)"/>
						</xsl:apply-templates>
					</xsl:when>
					<xsl:otherwise>
						<!-- display all properties sorted in order in the SPARQL HTML page, otherwise display other properties after the prefLabels and definitions -->
						<xsl:apply-templates mode="list-item">
							<xsl:sort select="name()"/>
							<xsl:sort select="@rdf:resource"/>
							<xsl:sort select="@xml:lang"/>
						</xsl:apply-templates>
					</xsl:otherwise>
				</xsl:choose>
			</dl>
		</div>
	</xsl:template>

	<!-- additional RDF types do not need to be displayed -->
	<xsl:template match="rdf:type" mode="list-item"/>

	<xsl:template match="rdf:type" mode="normalize-class">
		<xsl:variable name="uri" select="@rdf:resource"/>
		<xsl:variable name="curie"
			select="replace($uri, $namespaces//namespace[contains($uri, @uri)]/@uri, concat($namespaces//namespace[contains($uri, @uri)]/@prefix, ':'))"/>

		<a href="{@rdf:resource}" title="{$curie}">
			<xsl:value-of select="kerameikos:normalizeCurie($curie, 'en')"/>
		</a>

		<xsl:if test="not(position() = last())">
			<xsl:text>, </xsl:text>
		</xsl:if>
	</xsl:template>

	<xsl:template match="*" mode="list-item">
		<xsl:variable name="name" select="name()"/>
		<dt>
			<a href="{concat($namespaces//namespace[@prefix=substring-before($name, ':')]/@uri, substring-after($name, ':'))}">
				<xsl:value-of select="name()"/>
			</a>
		</dt>
		<dd>
			<xsl:choose>
				<xsl:when test="child::*">
					<!-- handle nested blank nodes (applies to provenance) -->
					<xsl:apply-templates select="child::*" mode="type"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:choose>
						<xsl:when test="string(.)">
							<xsl:choose>
								<xsl:when test="name() = 'osgeo:asGeoJSON' and string-length(.) &gt; 100">
									<xsl:call-template name="render_geojson"/>
								</xsl:when>
								<xsl:otherwise>
									<span property="{name()}" xml:lang="{@xml:lang}">
										<xsl:value-of select="."/>
									</span>
									<xsl:if test="string(@xml:lang)">
										<span class="lang">
											<xsl:value-of select="concat(' (', @xml:lang, ')')"/>
										</span>
									</xsl:if>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:when>
						<xsl:when test="string(@rdf:resource)">
							<span>
								<a href="{@rdf:resource}" rel="{name()}" title="{@rdf:resource}">
									<xsl:value-of select="@rdf:resource"/>
								</a>
							</span>
						</xsl:when>
					</xsl:choose>
				</xsl:otherwise>
			</xsl:choose>
		</dd>
	</xsl:template>

	<xsl:template name="render_geojson">
		<xsl:choose>
			<xsl:when test="string-length(.) &lt;= 100">
				<xsl:value-of select="."/>
			</xsl:when>
			<xsl:otherwise>
				<div id="geoJSON-fragment">
					<xsl:value-of select="substring(., 1, 100)"/>
					<xsl:text>...</xsl:text>
					<a href="#" class="toggle-geoJSON">[more]</a>
				</div>
				<div id="geoJSON-full" style="display:none">
					<span property="{name()}" xml:lang="{@xml:lang}">
						<xsl:value-of select="."/>
					</span>
					<a href="#" class="toggle-geoJSON">[less]</a>
				</div>
			</xsl:otherwise>
		</xsl:choose>		
	</xsl:template>

	<!-- hide the ontolex:otherFrom from the HTML output: plural displayed after prefLabel -->
	<!--<xsl:template match="ontolex:otherForm" mode="list-item"/>-->

</xsl:stylesheet>
