<xsl:stylesheet version="2.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 	
	xmlns:tei="http://www.tei-c.org/ns/1.0" 
	exclude-result-prefixes="tei">
	
	<xsl:template match="tei:table">
		<xsl:copy>
			<xsl:apply-templates/>
		</xsl:copy>
	</xsl:template>
	
	<xsl:template match="tei:row">
		<xsl:copy>
			<xsl:for-each select="tei:cell">
				<xsl:if test="position() &gt; 1">,</xsl:if>
				<xsl:value-of select="concat($quote, replace(., $quote, concat($quote, $quote)), $quote)"/>
			</xsl:for-each>
		</xsl:copy>
		<xsl:text>&#xA;</xsl:text>
	</xsl:template>
	
     <xsl:variable name="quote" select="codepoints-to-string(34)"/> 	
     
</xsl:stylesheet>
					
