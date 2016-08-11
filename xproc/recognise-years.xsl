<!-- this "last resort" transform recognises an otherwise unparsed possible 4-digit year in a citation as a date -->
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
	
	<xsl:template match="tei:bibl/text()[matches(., '19\d\d')]">
		<!-- "19" followed by 2 digits -->
		<xsl:analyze-string select="." regex="19\d\d">
			<xsl:matching-substring>
				<!-- matching substrings are wrapped in a TEI date element -->
				<xsl:element name="date">
					<xsl:attribute name="type">year</xsl:attribute>
					<xsl:value-of select="."/>
				</xsl:element>
			</xsl:matching-substring>
			<xsl:non-matching-substring>
				<!-- non-matching substrings are left unmolested -->
				<xsl:value-of select="."/>
			</xsl:non-matching-substring>
		</xsl:analyze-string>
	</xsl:template>	
	
</xsl:stylesheet>
					
