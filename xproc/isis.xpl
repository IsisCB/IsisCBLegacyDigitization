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

	<file:mkdir href="../../build" fail-on-error="false"/>
	<file:mkdir href="../../build/normalized-tite" fail-on-error="false"/>
	<file:mkdir href="../../build/report" fail-on-error="false"/>
	<file:mkdir href="../../build/p5" fail-on-error="false"/>
	<file:mkdir href="../../build/csv" fail-on-error="false"/>
	<file:mkdir href="../../build/upconverted" fail-on-error="false"/>
	<file:mkdir href="../../build/sample" fail-on-error="false"/>
	
	<isis:test/>
	
	
	<p:directory-list path="../tite" include-filter="^.*\.xml$"/>
	<p:for-each name="file">
		<p:iteration-source select="/c:directory/c:file"/>
		<!--	
		<p:iteration-source select="/c:directory/c:file[@name='ISIS-03.xml']"/>
		-->

		<p:output port="result"/>
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
		
		<isis:transform xslt="normalize-tite.xsl">
			<p:input port="source">
				<p:pipe step="tite" port="result"/>
			</p:input>
		</isis:transform>
		<p:store>
			<p:with-option name="href" select="concat('../../build/normalized-tite/', $filename)"/>
		</p:store>
		
		<isis:transform xslt="tite-to-p5.xsl">
			<p:input port="source">
				<p:pipe step="tite" port="result"/>
			</p:input>
		</isis:transform>
		<p:add-attribute name="p5" match="/tei:TEI" attribute-name="xml:base">
			<p:with-option name="attribute-value" select="$filename"/>
		</p:add-attribute>
		<p:store>
			<p:with-option name="href" select="concat('../../build/p5/', $filename)"/>
		</p:store>
		
		<isis:transform xslt="make-sample.xsl">
			<p:input port="source">
				<p:pipe step="p5" port="result"/>
			</p:input>
		</isis:transform>
		<p:store>
			<p:with-option name="href" select="concat('../../build/sample/', $filename)"/>
		</p:store>	

		<!-- continue transformation of p5 by recognising abbreviations and taxonomies -->
		<isis:transform xslt="recognise-table-of-abbreviations.xsl">
			<p:input port="source">
				<p:pipe step="p5" port="result"/>
			</p:input>
		</isis:transform>
		<isis:transform xslt="generate-taxonomies.xsl"/>
			
	</p:for-each>
	
	<!-- extract all the classifications from all volumes into a single classDecl -->
	<isis:extract-classifications name="classifications"/>
	<isis:extract-abbreviations name="abbreviations">
		<p:input port="source">
			<p:pipe step="file" port="result"/>
		</p:input>
	</isis:extract-abbreviations>

	<p:for-each name="p5-file">
		<p:iteration-source>
			<p:pipe step="file" port="result"/><!-- p5 docs -->
		</p:iteration-source>
		
		<p:variable name="filename" select="replace(/tei:TEI/@xml:base, '.*/', '')"/><!-- trim leading path components -->
		<p:variable name="base-filename" select="substring-before($filename, '.xml')"/>
		
		<!-- replace each volume's classDecl with the global set of classifications -->
		<p:replace name="insert-classifications" match="/tei:TEI/tei:teiHeader/tei:encodingDesc/tei:classDecl">
			<p:input port="replacement">
				<p:pipe step="classifications" port="result"/>
			</p:input>
		</p:replace>
		
		<!-- insert the aggregated journal abbreviations -->
		<p:insert name="insert-abbreviations" position="before" match="/tei:TEI/tei:teiHeader/tei:fileDesc/tei:sourceDesc">
			<p:input port="insertion">
				<p:pipe step="abbreviations" port="result"/>
			</p:input>
		</p:insert>

		<isis:upconvert-document name="upconverted"/>
		
		<p:store>
			<p:with-option name="href" select="concat('../../build/upconverted/', $filename)"/>
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
	
	<p:declare-step type="isis:upconvert-document" name="upconvert-document">
		<p:input port="source"/>
		<p:output port="result"/>
		<p:input port="parameters" kind="parameter"/>
		<isis:transform xslt="group-by-initial-letter-headings.xsl"/>
		<isis:transform xslt="recognise-see-cross-reference.xsl"/>
		<isis:transform xslt="group-by-initial-letter-headings.xsl"/>
		<isis:transform xslt="group-by-top-level-subject.xsl"/>
		<isis:transform xslt="group-by-second-level-subject.xsl"/>
		<isis:transform xslt="group-by-third-level-subject.xsl"/>
		<isis:transform xslt="group-by-second-level-period.xsl"/>
		<isis:transform xslt="group-by-third-level-period.xsl"/>
		<isis:transform xslt="group-citations.xsl"/>
		<isis:transform xslt="make-bibl.xsl"/>
		<isis:transform xslt="recognise-citations-in-notes.xsl"/><!-- i.e. reviews -->
		<isis:transform xslt="assign-bibl-identifiers.xsl"/>
		<isis:transform xslt="categorize-citations.xsl"/><!-- into books, journal articles, and reviews -->
		<isis:transform xslt="recognise-authors.xsl"/>
		<isis:transform xslt="recognise-journal-titles.xsl"/>
		<isis:transform xslt="recognise-cb-references.xsl"/>
		<isis:transform xslt="recognise-journal-date-volume-page.xsl"/>
		<isis:transform xslt="recognise-book-extents.xsl"/>
		<isis:transform xslt="recognise-book-titles.xsl"/>
		<isis:transform xslt="recognise-imprint.xsl"/>
	</p:declare-step>
	
	<p:declare-step type="isis:test" name="test">
		<p:input port="parameters" kind="parameter"/>
		<p:load href="../test/citation-test.xml"/>
		<isis:upconvert-document/>
		<p:store href="../../build/citation-test.xml"/>
	</p:declare-step>
	
	<!-- extract and bundle all the taxonomies from a sequence of texts -->
	<p:declare-step type="isis:extract-classifications" name="extract-classifications">
		<p:input port="source" sequence="true"/>
		<p:output port="result"/>
		<p:wrap-sequence name="classifications" wrapper="classDecl" wrapper-namespace="http://www.tei-c.org/ns/1.0">
			<p:input port="source" select="/tei:TEI/tei:teiHeader/tei:encodingDesc/tei:classDecl/tei:taxonomy[tei:category]">
				<p:pipe step="extract-classifications" port="source"/>
			</p:input>
		</p:wrap-sequence>
	</p:declare-step>
	
	<!-- extract and bundle all the journal abbreviations / expansions from a sequence of texts -->
	<p:declare-step type="isis:extract-abbreviations" name="extract-abbreviations">
		<p:input port="source" sequence="true"/>
		<p:output port="result"/>
		<p:wrap-sequence name="abbreviations" wrapper="notesStmt" wrapper-namespace="http://www.tei-c.org/ns/1.0">
			<p:input port="source" select="//tei:div[@type='abbreviations']">
				<p:pipe step="extract-abbreviations" port="source"/>
			</p:input>
		</p:wrap-sequence>
		<p:xslt>
			<p:input port="stylesheet">
				<p:inline>
					<xsl:stylesheet version="2.0" 
						xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 	
						xmlns:tei="http://www.tei-c.org/ns/1.0" 
						xmlns="http://www.tei-c.org/ns/1.0" 
						exclude-result-prefixes="tei">
						<xsl:template match="tei:div">
							<note>
								<xsl:copy-of select="@*"/>
								<xsl:apply-templates/>
							</note>
						</xsl:template>
						<xsl:template match="tei:notesStmt">
							<xsl:copy>
								<xsl:copy-of select="@*"/>
								<xsl:apply-templates select="*"/>
							</xsl:copy>
						</xsl:template>
						<xsl:template match="*">
							<xsl:apply-templates select="*"/>
						</xsl:template>
						<xsl:template match="tei:term | tei:gloss">
							<xsl:copy-of select="."/>
						</xsl:template>
					</xsl:stylesheet>
				</p:inline>
			</p:input>
			<p:input port="parameters">
				<p:empty/>
			</p:input>
		</p:xslt>
	</p:declare-step>	
		
</p:declare-step>
	
