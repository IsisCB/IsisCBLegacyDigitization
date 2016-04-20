<xsl:stylesheet version="2.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 	
	xmlns:tei="http://www.tei-c.org/ns/1.0" 
	xmlns="http://www.tei-c.org/ns/1.0" 
	xmlns:tite="http://www.tei-c.org/ns/tite/1.0" 
	exclude-result-prefixes="tei tite">
	
	<!-- generate taxonomy elements in the header from classification schemes in the back matter of the volumes -->
	<xsl:template match="*">
		<xsl:copy>
			<xsl:copy-of select="@*"/>
			<xsl:apply-templates/>
		</xsl:copy>
	</xsl:template>
	
	<!-- ISIS-03:  back//div with head="Form and Aspect Subdivisions", "Scientific Subject Fields", contents: head, pb, list -->
	<!-- ISIS-04: back//div with head="Civilizations and Periods", "Scientific Subject Fields", "Form and Aspect<lb/>Subdivisions", contents: head, pb, list -->
	<!-- ISIS-07: back//div with head="Period Classification", "Scientific Subject Fields", "Form and Aspect Subdivisions", contents: head, list -->
	
	<xsl:variable name="classification-sections" select="
		/tei:TEI/tei:text/tei:back//tei:div[
			tei:head[
				string-join(text(), ' ') = ('Form and Aspect Subdivisions', 'Scientific Subject Fields', 'Civilizations and Periods', 'Period Classification')
			]
		]
	"/>

	<!-- add any taxonomies in a classDesc in an encodingDesc after the fileDesc -->
	<xsl:template match="tei:fileDesc">
		<xsl:copy-of select="."/>
		<xsl:element name="encodingDesc">
			<xsl:element name="classDecl">
				<xsl:if test="not($classification-sections)">
					<xsl:element name="taxonomy">
						<xsl:element name="bibl">The citations are classified by taxonomies defined in other volumes</xsl:element>
					</xsl:element>
				</xsl:if>
				<xsl:for-each select="$classification-sections">
					<xsl:element name="taxonomy">
						<xsl:element name="desc"><xsl:value-of select="string-join(tei:head, ' ')"/></xsl:element>
						<xsl:apply-templates select="tei:list/tei:item[not(@rend)]" mode="taxonomy"/>
					</xsl:element>
				</xsl:for-each>
			</xsl:element>
		</xsl:element>
	</xsl:template>
	
	
	<!-- capture hierarchy using xsl:group-by -->
	<!-- Taxonomies appear in ISIS-03, ISIS-04, ISIS-07, with the hierarchy expressed by indentation of items (the item's labels are unindented) -->
	<xsl:template mode="taxonomy" match="tei:item">
		<xsl:element name="category">
			<xsl:element name="catDesc">
				<xsl:variable name="label" select="preceding-sibling::tei:label[1]"/>
				<xsl:attribute name="n"><xsl:value-of select="$label"/></xsl:attribute>
				<xsl:attribute name="xml:id"><xsl:value-of select="concat('cat-', $label)"/></xsl:attribute>
				<xsl:value-of select="."/>
			</xsl:element>
			<xsl:variable name="current-rend" select="@rend"/>
			<xsl:variable name="current-text" select="."/>
			<xsl:variable name="indent-level" select="number(substring-before(substring-after(concat(@rend, '0'), '('), ')'))"/>
			<!-- rend="indent(2)" → 2, rend="" → 0 -->
			<xsl:variable name="sub-items" select="
				following-sibling::tei:item
					[@rend=concat('indent(', string($indent-level + 1), ')')]
					[preceding-sibling::tei:item[@rend=$current-rend][1]=$current-text]
			"/>
			<xsl:apply-templates select="$sub-items"/>
		</xsl:element>
	</xsl:template>
	
</xsl:stylesheet>
					
