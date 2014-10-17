<?xml version="1.0" encoding="UTF-8"?>
<p:pipeline xmlns:p="http://www.orbeon.com/oxf/pipeline"
	xmlns:oxf="http://www.orbeon.com/oxf/processors">
	
	<p:param type="input" name="file"/>
	<p:param type="output" name="data"/>
	
	<p:processor name="oxf:url-generator">
		<p:input name="config" href="#file"/>		
		<p:output name="data" id="model"/>
	</p:processor>
	
	<p:processor name="oxf:exception-catcher">
		<p:input name="data" href="#model"/>
		<p:output name="data" id="url-data-checked"/>
	</p:processor>
	
	<!-- Check whether we had an exception -->
	<p:choose href="#url-data-checked">
		<p:when test="/exceptions">
			<!-- Extract the message -->
			<p:processor name="oxf:xslt">
				<p:input name="data" href="#url-data-checked"/>
				<p:input name="config">
					<message xsl:version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
						<xsl:value-of select="/exceptions/exception/message"/>
					</message>
				</p:input>
				<p:output name="data" ref="data"/>
			</p:processor>
		</p:when>
		<p:otherwise>
			<!-- Just return the document -->
			<p:processor name="oxf:identity">
				<p:input name="data" href="#url-data-checked"/>
				<p:output name="data" ref="data"/>
			</p:processor>
		</p:otherwise>
	</p:choose>
</p:pipeline>

