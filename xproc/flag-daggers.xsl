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
	

	<!-- in "Addenda and Corrigenda" sections, some headings are flagged with a dagger to indicate that they are additional personalities -->
	<!-- This is not significant and is retained purely as a rend attribute on the heading -->
	<xsl:template match="tei:p[tei:hi[@rend='b'][starts-with(., '†') or starts-with(., '*')]]">
		<xsl:copy>
			<xsl:copy-of select="@*"/>
			<xsl:analyze-string select="." regex="^(†|\*)">
				<xsl:matching-substring>
					<xsl:attribute name="rend"><xsl:value-of select="."/></xsl:attribute>
				</xsl:matching-substring>
			</xsl:analyze-string>
			<xsl:apply-templates/>
		</xsl:copy>
	</xsl:template>
	
	<xsl:template match="tei:p/tei:hi[@rend='b']/text()[starts-with(., '†') or starts-with(., '*')]">
		<xsl:analyze-string select="." regex="^(†|\*) ?(.*)">
			<xsl:matching-substring>
				<xsl:value-of select="regex-group(2)"/>
			</xsl:matching-substring>
		</xsl:analyze-string>
	</xsl:template>
	
</xsl:stylesheet>
					
