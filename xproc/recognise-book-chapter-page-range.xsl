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
		<xsl:analyze-string select="." regex="(p\. )({$roman-number-regex}([-–]){$roman-number-regex}, )?(\p{{Nd}}*([-–])\p{{Nd}}*)">
			<xsl:matching-substring>
				<xsl:variable name="roman-number-groups" select="12"/>
				<xsl:variable name="roman-range" select="regex-group(2)"/>
				<xsl:if test="$roman-range">
					<xsl:element name="biblScope">
						<xsl:attribute name="unit">prefatory-page</xsl:attribute>
						<xsl:variable name="dash" select="regex-group($roman-number-groups + 3)"/>
						<xsl:attribute name="from"  select="substring-before($roman-range, $dash)"/><!-- "lii" -->
						<xsl:attribute name="to" select="substring-after($roman-range, $dash)"/><!-- "lxvii" -->
						<xsl:value-of select="regex-group(1)"/>
						<xsl:value-of select="$roman-range"/>
					</xsl:element>
				</xsl:if>
				<xsl:variable name="range" select="regex-group(2 * $roman-number-groups + 2 + 2)"/>
				<xsl:element name="biblScope">
					<xsl:attribute name="unit">page</xsl:attribute>
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
					<xsl:if test="not($roman-range)">
						<xsl:value-of select="regex-group(1)"/>
					</xsl:if>
					<xsl:value-of select="$range"/>
				</xsl:element>
			</xsl:matching-substring>
			<xsl:non-matching-substring>
				<xsl:value-of select="."/>
			</xsl:non-matching-substring>
		</xsl:analyze-string>
	</xsl:template>
	
	<!-- recognise roman numbers from 1 to 399 (d, m, etc not supported) -->
	<xsl:variable name="roman-number-regex">(c{0,3})((xc)|(xl)|(l?)(x{0,3}))(ix)?((iv)|((v)?(i{0,3})))</xsl:variable>
	
</xsl:stylesheet>
					
