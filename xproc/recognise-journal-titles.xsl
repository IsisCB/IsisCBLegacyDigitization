<xsl:stylesheet version="2.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 	
	xmlns:tei="http://www.tei-c.org/ns/1.0" 
	xmlns="http://www.tei-c.org/ns/1.0" 
	xmlns:tite="http://www.tei-c.org/ns/tite/1.0" 
	exclude-result-prefixes="tei tite">
	
	<!-- recognises the presence of a journal title in a bibl (they are italicised) -->
	<xsl:template match="*">
		<xsl:copy>
			<xsl:copy-of select="@*"/>
			<xsl:apply-templates/>
		</xsl:copy>
	</xsl:template>
	
	<!-- italicised phrase is a journal title -->
	<xsl:template match="tei:bibl[@type='journalArticle']/tei:hi[@rend='i']">
		<xsl:element name="title">
			<xsl:attribute name="level">j</xsl:attribute>
			<xsl:apply-templates/>
		</xsl:element>
	</xsl:template>
	
	<!-- text sandwiched between an author and an italicised phrase is a title -->
	<xsl:template match="tei:bibl[@type='journalArticle']/text()
		[normalize-space()]
		[following-sibling::*[1]/self::tei:hi/@rend='i']
		[preceding-sibling::*[1]/self::tei:author]
	">
		<xsl:element name="title">
			<xsl:value-of select="."/>
		</xsl:element>
	</xsl:template>	
	
</xsl:stylesheet>
					
