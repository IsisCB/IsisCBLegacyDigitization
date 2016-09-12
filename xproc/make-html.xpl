<p:declare-step version="1.0" 
	name="upconvert"
	type="isis:upconvert"
	xmlns:file="http://exproc.org/proposed/steps/file"
	xmlns:p="http://www.w3.org/ns/xproc" 
	xmlns:c="http://www.w3.org/ns/xproc-step" 
	xmlns:cx="http://xmlcalabash.com/ns/extensions"
	xmlns:fn="http://www.w3.org/2005/xpath-functions"
	xmlns:isis="tag:conaltuohy.com,2015:isis"
	xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
	xmlns:tei="http://www.tei-c.org/ns/1.0">
	<p:import href="http://xmlcalabash.com/extension/steps/library-1.0.xpl"/>
	<p:input port="parameters" kind="parameter"/>

	<file:mkdir href="../../build/html" fail-on-error="false"/>
	
	
	<p:directory-list path="../../build/upconverted" include-filter="^.*\.xml$"/>

	<p:for-each name="p5-file">
		<p:iteration-source select="/c:directory/c:file"/>
		<p:variable name="filename" select="encode-for-uri(/c:file/@name)"/>
		<p:variable name="base-filename" select="substring-before($filename, '.xml')"/>

		<p:load name="upconverted">
			<p:with-option name="href" select="concat('../../build/upconverted/', $filename)"/>
		</p:load>	
		
		<isis:transform xslt="tei-to-html.xsl"/>
		<p:store>
			<p:with-option name="href" select="concat('../../build/html/', $base-filename, '.html')"/>
		</p:store>
		
		<isis:transform xslt="make-sample.xsl">
			<p:input port="source">
				<p:pipe step="upconverted" port="result"/>
			</p:input>
		</isis:transform>
		<p:store>
			<p:with-option name="href" select="concat('../../build/upconverted/sample/', $filename)"/>
		</p:store>
		
		<isis:transform xslt="tei-bibls-to-table.xsl">
			<p:input port="source">
				<p:pipe step="upconverted" port="result"/>
			</p:input>
		</isis:transform>
		<isis:transform name="csv" xslt="tei-table-to-csv.xsl"/>
		<p:store method="text">
			<p:with-option name="href" select="concat('../../build/csv/', $base-filename, '.csv')"/>
		</p:store>		
		
		<isis:transform xslt="tei-unparsed-citation-italics-to-table.xsl">
			<p:input port="source">
				<p:pipe step="upconverted" port="result"/>
			</p:input>
		</isis:transform>
		<isis:transform xslt="tei-table-to-csv.xsl"/>
		<p:store method="text">
			<p:with-option name="href" select="concat('../../build/csv/', $base-filename, '-unparsed-italics.csv')"/>
		</p:store>		
		
		<isis:transform xslt="tei-headings-to-csv.xsl">
			<p:input port="source">
				<p:pipe step="upconverted" port="result"/>
			</p:input>
		</isis:transform>
		<p:store method="text">
			<p:with-option name="href" select="concat('../../build/csv/', $base-filename, '-headings.csv')"/>
		</p:store>	

		<isis:transform xslt="tei-unparsed-citation-italics-to-table.xsl">
			<p:input port="source">
				<p:pipe step="upconverted" port="result"/>
			</p:input>
		</isis:transform>
		<p:store>
			<p:with-option name="href" select="
				concat(
					'../../build/csv/', 
					substring-before($filename, '.xml'), 
					'-unparsed-italics.csv'
				)
			"/>
		</p:store>
	</p:for-each>
	
	<file:copy href="../css/proofing.css" target="../../build/html/proofing.css" xmlns:file="http://exproc.org/proposed/steps/file"/>
	
	<p:declare-step type="isis:transform" name="transform">
		
		<p:input port="source"/>
		<p:output port="result" primary="true"/>
		<p:input port="parameters" kind="parameter"/>
		
		<p:option name="xslt" required="true"/>
		
		<p:load name="load-stylesheet">
			<p:with-option name="href" select="$xslt"/>
		</p:load>
		
		<p:xslt name="execute-xslt">
			<p:input port="source">
				<p:pipe step="transform" port="source"/>
			</p:input>
			<p:input port="stylesheet">
				<p:pipe step="load-stylesheet" port="result"/>
			</p:input>
		</p:xslt>
	</p:declare-step>	
	
		
</p:declare-step>
	
