<xsl:stylesheet version="2.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 	
	xmlns:tei="http://www.tei-c.org/ns/1.0" 
	xmlns="http://www.tei-c.org/ns/1.0" 
	xmlns:tite="http://www.tei-c.org/ns/tite/1.0" 
	exclude-result-prefixes="tei tite">
	
	<!-- recognises the titles of book chapters cited -->
	
	<xsl:template match="*">
		<xsl:copy>
			<xsl:copy-of select="@*"/>
			<xsl:apply-templates/>
		</xsl:copy>
	</xsl:template>
	
	<xsl:template match="tei:bibl[@type='bookChapter']/text()[contains(., '. In: ')]">
		<xsl:variable name="chapter-title" select="substring-before(., '. In: ')"/>
		<xsl:element name="biblScope">
			<xsl:attribute name="unit">chapter</xsl:attribute>
			<xsl:element name="title">
				<xsl:value-of select="$chapter-title"/>
			</xsl:element>
		</xsl:element>
		<xsl:value-of select="substring-after(., $chapter-title)"/>
	</xsl:template>
	
	<xsl:template match="tei:bibl[@type='bookChapter']/text()[1][not(contains(., '. In: '))]">
		<xsl:analyze-string select="." regex="^(\s*)(.+)">
			<xsl:matching-substring>
				<xsl:value-of select="regex-group(1)"/><!-- leading white space -->
				<xsl:element name="biblScope">
					<xsl:attribute name="unit">chapter</xsl:attribute>
					<xsl:element name="title">
						<xsl:value-of select="regex-group(2)"/>
					</xsl:element>
				</xsl:element>
			</xsl:matching-substring>
			<xsl:non-matching-substring>
				<xsl:value-of select="."/>
			</xsl:non-matching-substring>
		</xsl:analyze-string>
	</xsl:template>	

</xsl:stylesheet>
					
