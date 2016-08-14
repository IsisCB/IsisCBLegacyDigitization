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
				<xsl:analyze-string select="regex-group(3)" regex="(\p{{Nd}}*)(:\p{{Z}}*)((\p{{Nd}}*–\p{{Nd}}*)|(\p{{Nd}}*))([,\.])">
					<!-- date, colon and any whitespace, page range or single page number, finally comma or full stop -->
					<!-- NB if comma, then what follows are extents (e.g. "8 fig.") -->
					<xsl:matching-substring>
						<xsl:element name="biblScope">
							<xsl:attribute name="unit">volume</xsl:attribute>
							<xsl:value-of select="regex-group(1)"/>
						</xsl:element>
						<xsl:value-of select="regex-group(2)"/><!-- colon and whitespace -->
						<xsl:variable name="range-or-page-number" select="regex-group(3)"/>
						<xsl:variable name="range" select="regex-group(4)"/><!-- e.g. "210-12" -->
						<xsl:variable name="page-number" select="regex-group(5)"/><!-- e.g. "210" -->
						<xsl:element name="biblScope">
							<xsl:attribute name="unit">page</xsl:attribute>
							<xsl:choose>
								<xsl:when test="$range">
									<!-- potentially a variety of characters could have been used for a dash in a page range -->
									<xsl:variable name="dash" select="normalize-space(translate($range, '0123456789', ''))"/>
									<xsl:variable name="from"  select="substring-before($range, $dash)"/><!-- "210" -->
									<xsl:variable name="to" select="substring-after($range, $dash)"/><!-- "12" -->
									<xsl:attribute name="from"><xsl:value-of select="$from"/></xsl:attribute>
									<xsl:attribute name="to"><xsl:value-of select="
										concat(
											substring($from, 1, string-length($from) - string-length($to)),
											$to
										)
									"/></xsl:attribute><!-- "2" + "12" = "212" -->
								</xsl:when>
								<xsl:otherwise>
									<xsl:attribute name="from"><xsl:value-of select="$page-number"/></xsl:attribute>
									<xsl:attribute name="to"><xsl:value-of select="$page-number"/></xsl:attribute>
								</xsl:otherwise>
							</xsl:choose>
							<xsl:value-of select="$range-or-page-number"/><!-- the element content -->
						</xsl:element>
						<xsl:value-of select="regex-group(6)"/><!-- terminal punctuation -->
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
					
