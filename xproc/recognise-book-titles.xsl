<xsl:stylesheet version="2.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 	
	xmlns:tei="http://www.tei-c.org/ns/1.0" 
	xmlns="http://www.tei-c.org/ns/1.0" 
	xmlns:tite="http://www.tei-c.org/ns/tite/1.0" 
	exclude-result-prefixes="tei tite">
	
	<!-- recognises the title of a book -->
	<!-- relies on prior transforms having identified the "extents" and the "author" -->
	<xsl:template match="*">
		<xsl:copy>
			<xsl:copy-of select="@*"/>
			<xsl:apply-templates/>
		</xsl:copy>
	</xsl:template>
	
	<!-- Where an entire book is cited, the book's title is sandwiched between the book's author and an "extent" (number of pages, etc) -->
	<xsl:template match="tei:bibl[@type='book']/text()
		[preceding-sibling::node()[1]/self::tei:author]
		[following-sibling::node()[1]/self::tei:extent]">
		<xsl:element name="title">
			<xsl:copy-of select="."/>
		</xsl:element>
	</xsl:template>
	
	<!-- Where a chapter in a book is cited, the book's title is sandwiched between the chapter's title and a biblScope giving number of pages, if any, or imprint -->
	<!-- and is preceded by the text '. In: ' -->
	<xsl:template match="tei:bibl[@type='bookChapter']/text()
		[starts-with(., '. In: ')]
		[preceding-sibling::node()[1]/self::tei:biblScope/@unit='chapter']">
		<xsl:text>. In: </xsl:text>
		<xsl:element name="title">
			<xsl:value-of select="substring-after(., ' In: ')"/>
		</xsl:element>
	</xsl:template>
	
</xsl:stylesheet>
					
