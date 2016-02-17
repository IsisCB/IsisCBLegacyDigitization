<xsl:stylesheet version="2.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 	
	xmlns:tei="http://www.tei-c.org/ns/1.0" 
	xmlns="http://www.tei-c.org/ns/1.0" 
	xmlns:tite="http://www.tei-c.org/ns/tite/1.0" 
	exclude-result-prefixes="tei tite">
	
	<xsl:template match="*">
		<xsl:copy>
			<xsl:copy-of select="@*"/>
			<xsl:apply-templates/>
		</xsl:copy>
	</xsl:template>
	
	<!-- text following a journal title contains publication metadata; date, volume number, pages -->
	<xsl:template match="tei:bibl/text()[preceding-sibling::*[1]/self::tei:title/@level='j']">
		<!-- 4 numeric digits, comma, any whitespace, any other characters -->
		<xsl:analyze-string select="." regex="(\p{{Nd}}{{4}})(,\p{{Z}}*)(.*)">
			<xsl:matching-substring>
				<xsl:element name="date">
					<xsl:value-of select="regex-group(1)"/>
				</xsl:element>
				<xsl:value-of select="regex-group(2)"/><!-- comma and whitespace -->
				<xsl:analyze-string select="regex-group(3)" regex="(\p{{Nd}}*)(:\p{{Z}}*)(\p{{Nd}}*–\p{{Nd}}*)([,\.])">
					<!-- date, colon and any whitespace, page range, finally hyphen or full stop -->
					<!-- NB if hyphen, then what follows are extents (e.g. "8 fig.") -->
					<xsl:matching-substring>
						<xsl:element name="biblScope">
							<xsl:attribute name="unit">volume</xsl:attribute>
							<xsl:value-of select="regex-group(1)"/>
						</xsl:element>
						<xsl:value-of select="regex-group(2)"/><!-- colon and whitespace -->			
						<xsl:element name="biblScope">
							<xsl:attribute name="unit">pp</xsl:attribute>
							<xsl:value-of select="regex-group(3)"/><!-- numeric range -->
						</xsl:element>
						<xsl:value-of select="regex-group(4)"/><!-- terminal punctuation -->
					</xsl:matching-substring>
					<xsl:non-matching-substring>
						<xsl:value-of select="."/>
					</xsl:non-matching-substring>
				</xsl:analyze-string>
			</xsl:matching-substring>
			<xsl:non-matching-substring>
				<xsl:value-of select="."/>
			</xsl:non-matching-substring>
		</xsl:analyze-string>
	</xsl:template>	
	
</xsl:stylesheet>
					
