<xsl:stylesheet version="2.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 	
	xmlns:tei="http://www.tei-c.org/ns/1.0" 
	xmlns="http://www.tei-c.org/ns/1.0" 
	xmlns:tite="http://www.tei-c.org/ns/tite/1.0" 
	exclude-result-prefixes="tei tite">
	
	<!-- recognises the italicised series title of a book -->
	<!-- relies on prior transforms having identified the imprint (publisher, pubPlace) -->
	<xsl:template match="*">
		<xsl:copy>
			<xsl:copy-of select="@*"/>
			<xsl:apply-templates/>
		</xsl:copy>
	</xsl:template>
	
	<!-- an italicised book series title is entirely enclosed in parentheses, and is followed by a pubPlace --> 
	<xsl:template match="
		tei:bibl[@type=('book', 'bookChapter')]
			/tei:hi
				[@rend='i']
				[matches(., '^\(.*\)$')]
				[following-sibling::node()[normalize-space()][1]/self::tei:pubPlace]
	">
		<xsl:element name="title">
			<xsl:copy-of select="@rend"/>
			<xsl:attribute name="level">s</xsl:attribute><!-- series -->
			<xsl:apply-templates/>
		</xsl:element>
	</xsl:template>
	
</xsl:stylesheet>
					
