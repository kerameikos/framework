<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="#all" version="2.0">
	<xsl:include href="templates.xsl"/>

	<!-- request params -->
	<xsl:param name="q" select="doc('input:request')/request/parameters/parameter[name='q']/value"/>
	<xsl:param name="rows">100</xsl:param>
	<xsl:param name="sort">
		<xsl:if test="string(doc('input:request')/request/parameters/parameter[name='sort']/value)">
			<xsl:value-of select="doc('input:request')/request/parameters/parameter[name='sort']/value"/>
		</xsl:if>
	</xsl:param>
	<xsl:param name="start">
		<xsl:choose>
			<xsl:when test="string(doc('input:request')/request/parameters/parameter[name='start']/value)">
				<xsl:value-of select="doc('input:request')/request/parameters/parameter[name='start']/value"/>
			</xsl:when>
			<xsl:otherwise>0</xsl:otherwise>
		</xsl:choose>
	</xsl:param>

	<xsl:variable name="start_var" as="xs:integer">
		<xsl:choose>
			<xsl:when test="number($start)">
				<xsl:value-of select="$start"/>
			</xsl:when>
			<xsl:otherwise>0</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="tokenized_q" select="tokenize($q, ' AND ')"/>
	<xsl:variable name="numFound" select="//result[@name='response']/@numFound" as="xs:integer"/>
	<xsl:variable name="display_path">../</xsl:variable>
	
	<!-- definition of namespaces for turning in solr type field URIs into abbreviations -->
	<xsl:variable name="namespaces" as="item()*">
		<namespaces>
			<namespace prefix="ecrm" uri="http://erlangen-crm.org/current/"/>
			<namespace prefix="foaf" uri="http://xmlns.com/foaf/0.1/"/>
			<namespace prefix="kon" uri="http://kerameikos.org/ontology#"/>
			<namespace prefix="skos" uri="http://www.w3.org/2004/02/skos/core#"/>			
		</namespaces>
	</xsl:variable>

	<xsl:template match="/">
		<html lang="en">
			<head>
				<title>Kerameikos.org: Browse</title>
				<link rel="stylesheet" type="text/css" href="http://yui.yahooapis.com/3.8.0/build/cssgrids/grids-min.css"/>
				<!-- bootstrap -->
				<link rel="stylesheet" href="http://netdna.bootstrapcdn.com/bootstrap/3.1.1/css/bootstrap.min.css"/>
				<script src="http://netdna.bootstrapcdn.com/bootstrap/3.1.1/js/bootstrap.min.js"/>
				<link rel="stylesheet" href="{$display_path}ui/css/style.css"/>
				<link rel="alternate" type="application/atom+xml" href="feed/{if ($q = '*:*') then '' else concat('?q=', $q)}"/>
				<!-- opensearch compliance -->
				<link rel="search" type="application/opensearchdescription+xml" href="http://nomisma.org/opensearch.xml" title="Example Search"/>
				<meta name="totalResults" content="{$numFound}"/>
				<meta name="startIndex" content="{$start_var}"/>
				<meta name="itemsPerPage" content="{$rows}"/>
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
			<div class="yui3-u-1">
				<div class="content">
					<p class="desc">The id/ path is the URI defining the thesaurus namespace.</p>
					<!--<xsl:call-template name="filter"/>-->
					<h2>Results</h2>
					<xsl:choose>
						<xsl:when test="$numFound &gt; 0">
							<xsl:call-template name="paging"/>
							<xsl:value-of select="namespace-uri-from-QName(ecrm)"/>
							<xsl:apply-templates select="descendant::doc"/>
						</xsl:when>
						<xsl:otherwise>
							<p>No results found for this query. <a href="../id/">Clear search</a>.</p>
						</xsl:otherwise>
					</xsl:choose>
				</div>
			</div>
		</div>
	</xsl:template>

	<xsl:template match="doc">
		<xsl:variable name="style" select="if(position() mod 2 = 0) then 'even-row' else 'odd-row'"/>
		<div class="result-doc {$style}">
			<span class="doc-label">
				<a href="{str[@name='id']}" title="{if(string(str[@name='prefLabel'])) then str[@name='prefLabel'] else str[@name='id']}">
					<xsl:value-of select="if(string(str[@name='prefLabel'])) then str[@name='prefLabel'] else str[@name='id']"/>
				</a>
			</span>
			<xsl:if test="string(str[@name='definition']) or not(contains($q, 'type'))">
				<dl>
					<xsl:if test="string(str[@name='definition'])">
						<dt>Definition</dt>
						<dd>
							<xsl:value-of select="str[@name='definition']"/>
						</dd>
					</xsl:if>
					<xsl:if test="not(contains($q, 'type'))">
						<dt>Type</dt>
						<dd>
							<xsl:for-each select="arr[@name='type']/str">
								<xsl:variable name="uri" select="."/>
								
								<a href="{.}">
									<xsl:value-of select="replace($uri, $namespaces//namespace[contains($uri, @uri)]/@uri, concat($namespaces//namespace[contains($uri, @uri)]/@prefix, ':'))"/>
								</a>								
								<xsl:if test="not(position()=last())">
									<xsl:text>, </xsl:text>
								</xsl:if>
							</xsl:for-each>
						</dd>
					</xsl:if>
				</dl>
			</xsl:if>
		</div>
	</xsl:template>

	<xsl:template name="filter">
		<form action="." class="filter-form">
			<span>
				<b>Filter: </b>
			</span>
			<select id="search_filter">
				<option value="">Select Type...</option>
				<xsl:for-each select="descendant::lst[@name='type']/int">
					<xsl:variable name="value" select="concat('typeof:&#x022;', @name, '&#x022;')"/>
					<option value="{$value}">
						<xsl:if test="contains($q, $value)">
							<xsl:attribute name="selected">selected</xsl:attribute>
						</xsl:if>
						<xsl:value-of select="@name"/>
					</option>
				</xsl:for-each>
			</select>
			<span>
				<b>Keyword: </b>
			</span>
			<input type="text" id="search_text">
				<xsl:if test="$tokenized_q[not(contains(., 'type'))]">
					<xsl:attribute name="value" select="$tokenized_q[not(contains(., 'type'))]"/>
				</xsl:if>
			</input>
			<input name="q" type="hidden"/>
			<button id="search_button">Submit</button>
		</form>
		<xsl:if test="string($q)">
			<form action="../id/" class="filter-form">
				<button>Clear</button>
			</form>
		</xsl:if>
	</xsl:template>

	<xsl:template name="paging">
		<xsl:variable name="next">
			<xsl:value-of select="$start_var+$rows"/>
		</xsl:variable>

		<xsl:variable name="previous">
			<xsl:choose>
				<xsl:when test="$start_var &gt;= $rows">
					<xsl:value-of select="$start_var - $rows"/>
				</xsl:when>
				<xsl:otherwise>0</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="current" select="$start_var div $rows + 1"/>
		<xsl:variable name="total" select="ceiling($numFound div $rows)"/>

		<div class="paging_div">
			<div style="float:left;">
				<xsl:variable name="startRecord" select="$start_var + 1"/>
				<xsl:variable name="endRecord">
					<xsl:choose>
						<xsl:when test="$numFound &gt; ($start_var + $rows)">
							<xsl:value-of select="$start_var + $rows"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="$numFound"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>

				<span>
					<b>
						<xsl:value-of select="$startRecord"/>
					</b>
					<xsl:text> to </xsl:text>
					<b>
						<xsl:value-of select="$endRecord"/>
					</b>
					<text> of </text>
					<b>
						<xsl:value-of select="$numFound"/>
					</b>
					<xsl:text> total results.</xsl:text>
				</span>
			</div>

			<!-- paging functionality -->
			<div style="float:right;">
				<ul class="paging">
					<xsl:choose>
						<xsl:when test="$start_var &gt;= $rows">
							<li>
								<a class="pagingBtn"
									href="?q={encode-for-uri($q)}&amp;start={$previous}{if (string($sort)) then concat('&amp;sort=', $sort) else ''}">«</a>
							</li>

						</xsl:when>
						<xsl:otherwise>
							<li>«</li>
						</xsl:otherwise>
					</xsl:choose>

					<!-- always display links to the first two pages -->
					<xsl:if test="$start_var div $rows &gt;= 3">
						<li>
							<a class="pagingBtn" href="?q={encode-for-uri($q)}&amp;start=0{if (string($sort)) then concat('&amp;sort=', $sort) else ''}">
								<xsl:text>1</xsl:text>
							</a>
						</li>

					</xsl:if>
					<xsl:if test="$start_var div $rows &gt;= 4">
						<li>
							<a class="pagingBtn" href="?q={encode-for-uri($q)}&amp;start={$rows}{if (string($sort)) then concat('&amp;sort=', $sort) else ''}">
								<xsl:text>2</xsl:text>
							</a>
						</li>

					</xsl:if>

					<!-- display only if you are on page 6 or greater -->
					<xsl:if test="$start_var div $rows &gt;= 5">
						<li>...</li>
					</xsl:if>

					<!-- always display links to the previous two pages -->
					<xsl:if test="$start_var div $rows &gt;= 2">
						<li>
							<a class="pagingBtn"
								href="?q={encode-for-uri($q)}&amp;start={$start_var - ($rows * 2)}{if (string($sort)) then concat('&amp;sort=', $sort) else ''}">
								<xsl:value-of select="($start_var div $rows) -1"/>
							</a>
						</li>
					</xsl:if>
					<xsl:if test="$start_var div $rows &gt;= 1">
						<li>
							<a class="pagingBtn"
								href="?q={encode-for-uri($q)}&amp;start={$start_var - $rows}{if (string($sort)) then concat('&amp;sort=', $sort) else ''}">
								<xsl:value-of select="$start_var div $rows"/>
							</a>
						</li>
					</xsl:if>

					<li>
						<b>
							<xsl:value-of select="$current"/>
						</b>
					</li>

					<!-- next two pages -->
					<xsl:if test="($start_var div $rows) + 1 &lt; $total">
						<li>
							<a class="pagingBtn"
								href="?q={encode-for-uri($q)}&amp;start={$start_var + $rows}{if (string($sort)) then concat('&amp;sort=', $sort) else ''}">
								<xsl:value-of select="($start_var div $rows) +2"/>
							</a>
						</li>
					</xsl:if>
					<xsl:if test="($start_var div $rows) + 2 &lt; $total">
						<li>
							<a class="pagingBtn"
								href="?q={encode-for-uri($q)}&amp;start={$start_var + ($rows * 2)}{if (string($sort)) then concat('&amp;sort=', $sort) else ''}">
								<xsl:value-of select="($start_var div $rows) +3"/>
							</a>
						</li>
					</xsl:if>
					<xsl:if test="$start_var div $rows &lt;= $total - 6">
						<li>...</li>
					</xsl:if>

					<!-- last two pages -->
					<xsl:if test="$start_var div $rows &lt;= $total - 5">
						<li>
							<a class="pagingBtn"
								href="?q={encode-for-uri($q)}&amp;start={($total * $rows) - ($rows * 2)}{if (string($sort)) then concat('&amp;sort=', $sort) else ''}">
								<xsl:value-of select="$total - 1"/>
							</a>
						</li>
					</xsl:if>
					<xsl:if test="$start_var div $rows &lt;= $total - 4">
						<li>
							<a class="pagingBtn"
								href="?q={encode-for-uri($q)}&amp;start={($total * $rows) - $rows}{if (string($sort)) then concat('&amp;sort=', $sort) else ''}">
								<xsl:value-of select="$total"/>
							</a>
						</li>
					</xsl:if>

					<xsl:choose>
						<xsl:when test="$numFound - $start_var &gt; $rows">
							<li>
								<a class="pagingBtn"
									href="?q={encode-for-uri($q)}&amp;start={$next}{if (string($sort)) then concat('&amp;sort=', $sort) else ''}">»</a>
							</li>
						</xsl:when>
						<xsl:otherwise>
							<li>»</li>
						</xsl:otherwise>
					</xsl:choose>
				</ul>
			</div>
		</div>
	</xsl:template>

</xsl:stylesheet>
