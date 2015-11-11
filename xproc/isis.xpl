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
	xmlns:xs="http://www.w3.org/2001/XMLSchema">
	<p:import href="http://xmlcalabash.com/extension/steps/library-1.0.xpl"/>
	<p:input port="parameters" kind="parameter"/>

	<file:mkdir href="../../build" fail-on-error="false"/>
	<file:mkdir href="../../build/report" fail-on-error="false"/>
	<file:mkdir href="../../build/p5" fail-on-error="false"/>
	<file:mkdir href="../../build/upconverted" fail-on-error="false"/>
	<file:mkdir href="../../build/sample" fail-on-error="false"/>
	
	<p:directory-list path="../tite" include-filter="^.*\.xml$"/>
	<p:for-each name="file">
		<p:iteration-source select="/c:directory/c:file"/>
		<p:variable name="filename" select="encode-for-uri(/c:file/@name)"/>
		<p:load name="tite">
			<p:with-option name="href" select="concat('../tite/', $filename)"/>
		</p:load>	
		
		<p:try name="validate-tite-assumptions">
			<p:group name="check-assertions">
				<p:validate-with-schematron>
					<p:input port="schema">
						<p:document href="../schema/tite.sch"/>
					</p:input>
				</p:validate-with-schematron>
			</p:group>
			<p:catch name="report-on-failed-assertions">
				<p:validate-with-schematron name="schematron-report" assert-valid="false">
					<p:input port="schema">
						<p:document href="../schema/tite.sch"/>
					</p:input>
				</p:validate-with-schematron>
				<p:wrap-sequence name="reports" wrapper="reports">
					<p:input port="source">
						<p:pipe step="schematron-report" port="report"/>
					</p:input>
				</p:wrap-sequence>
				<!--
				<p:delete match="svrl:fired-rule"/>
				-->
				<isis:transform name="to-html" xslt="svrl-to-html.xsl"/>
				<p:store>
					<p:with-option name="href" select="concat('../../build/report/', substring-before($filename, '.xml'), '.html')"/>
				</p:store>
				<p:store>
					<p:with-option name="href" select="concat('../../build/report/', $filename)"/>
					<p:input port="source">
						<p:pipe step="reports" port="result"/>
					</p:input>
				</p:store>
				<p:identity>
					<p:input port="source">
						<p:pipe step="schematron-report" port="result"/>
					</p:input>
				</p:identity>
			</p:catch>
		</p:try>		
		
		<isis:transform name="p5" xslt="tite-to-p5.xsl"/>
		<isis:transform xslt="group-citations.xsl"/>
		<isis:transform xslt="make-bibl.xsl"/>
		
		<p:store>
			<p:with-option name="href" select="concat('../../build/upconverted/', $filename)"/>
		</p:store>
		
		<p:store>
			<p:with-option name="href" select="concat('../../build/p5/', $filename)"/>
			<p:input port="source">
				<p:pipe step="p5" port="result"/>
			</p:input>
		</p:store>
		
		<isis:transform xslt="make-sample.xsl">
			<p:input port="source">
				<p:pipe step="p5" port="result"/>
			</p:input>
		</isis:transform>
		<p:store>
			<p:with-option name="href" select="concat('../../build/sample/', $filename)"/>
		</p:store>
		
	</p:for-each>
	
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
	
