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
	
	<xsl:template match="tei:div[tei:head[contains(., 'Abbreviations')]]">
		<xsl:copy>
			<xsl:copy-of select="@*"/>
			<xsl:attribute name="type">abbreviations</xsl:attribute>
			<xsl:apply-templates/>
		</xsl:copy>
	</xsl:template>

	<!-- paragraphs in the section of abbreviations containing highlighted text: the highlighted text is the abbreviation, the rest is the expansion -->
	<!-- in front matter of ISIS-01.xml and ISIS-03.xml -->
	<!-- TODO handle corrected entries listed in ISIS-02.xml (and elsewhere?) -->
	<xsl:template match="tei:div[tei:head[contains(., 'Abbreviations')]]/tei:p/tei:hi[@rend='i'][following-sibling::text()[normalize-space()]]">
		<xsl:element name="term">
			<xsl:copy-of select="@*"/>
			<xsl:attribute name="xml:id"><xsl:value-of select="concat('abbr-', encode-for-uri(.))"/></xsl:attribute>
			<xsl:apply-templates/>
		</xsl:element>
	</xsl:template>
	<!-- in an abbreviations section, non-whitespace text node following a highlight is a gloss for that highlight -->
	<xsl:template match="tei:div[tei:head[contains(., 'Abbreviations')]]/tei:p/text()[normalize-space()][preceding-sibling::node()[1]/self::tei:hi[@rend='i']]">
		<xsl:variable name="term-id" select="concat('#abbr-', encode-for-uri(preceding-sibling::tei:hi[@rend='i'][1]))"/>
		<xsl:analyze-string select="." regex="(\s)*(.+)">
			<xsl:matching-substring>
				<xsl:value-of select="regex-group(1)"/>
				<xsl:element name="gloss">
					<xsl:attribute name="target"><xsl:value-of select="$term-id"/></xsl:attribute>
					<xsl:value-of select="regex-group(2)"/>
				</xsl:element>
			</xsl:matching-substring>
		</xsl:analyze-string>
	</xsl:template>
	
</xsl:stylesheet>
					
