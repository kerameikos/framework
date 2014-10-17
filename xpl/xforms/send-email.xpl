<?xml version="1.0" encoding="UTF-8"?>
<p:pipeline xmlns:p="http://www.orbeon.com/oxf/pipeline"
	xmlns:oxf="http://www.orbeon.com/oxf/processors">
	
	<p:param type="input" name="email-input"/>
	<p:param type="output" name="data"/>
	
	<p:processor name="oxf:email">
		<p:input name="data" href="#email-input"/>
	</p:processor>
	
	<p:processor name="oxf:identity">
		<p:input name="data" href="#email-input"/>
		<p:output name="data" ref="data"/>
	</p:processor>
</p:pipeline>

