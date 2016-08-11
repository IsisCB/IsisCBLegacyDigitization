<xsl:stylesheet version="2.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 	
	xmlns:tei="http://www.tei-c.org/ns/1.0" 
	exclude-result-prefixes="tei">
	
	<xsl:template match="/"><csv><xsl:apply-templates/></csv></xsl:template>
	
	<xsl:template match="tei:head">
		<xsl:text>"</xsl:text>
		<xsl:for-each select="ancestor::tei:div[parent::tei:div]">___</xsl:for-each>
		<xsl:value-of select="replace(., $quote, concat($quote, $quote))"/>
		<xsl:text>", </xsl:text>
		<xsl:value-of select="parent::tei:div/@type"/>
		<xsl:text>&#xA;</xsl:text>
	</xsl:template>
	
	<xsl:template match="*">
		<xsl:apply-templates select="*"/>
	</xsl:template>
	
	<xsl:variable name="quote" select="codepoints-to-string(34)"/> 	
     
</xsl:stylesheet>
					
