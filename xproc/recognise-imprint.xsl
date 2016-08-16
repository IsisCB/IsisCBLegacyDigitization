<xsl:stylesheet version="2.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 	
	xmlns:tei="http://www.tei-c.org/ns/1.0" 
	xmlns="http://www.tei-c.org/ns/1.0" 
	xmlns:tite="http://www.tei-c.org/ns/tite/1.0" 
	exclude-result-prefixes="tei tite">
	
	<!-- recognises the imprint of a book -->
	<!-- relies on prior transforms having identified the "extents" -->
	<xsl:template match="*">
		<xsl:copy>
			<xsl:copy-of select="@*"/>
			<xsl:apply-templates/>
		</xsl:copy>
	</xsl:template>
	
	<!-- a book's imprint is the remainder after the last extent-->
	<!-- a book chapter's imprint is the remainder after the chapter page range (if any), or after the title -->
	<!--
	Division between a book title and the start of the imprint
	NB a bookChapter will have no extents (i.e. book statistics) but will have a biblScope (i.e. cited range of pages)
	-->
	<xsl:template match="tei:bibl[@type=('book', 'bookChapter')]/text()
		[following-sibling::node()[1][self::tei:note | self::tei:ref] or 
		not(following-sibling::*)]">
		<!--  Berlin: Julius Springer, 1923. -->
		<xsl:variable name="imprint-regex">([^:.]*[.]?)(:\p{Z}*)([^,]*)(,\p{Z}*)(\p{Nd}*)(\.)</xsl:variable>
		<xsl:analyze-string select="." regex="{$imprint-regex}">
			<xsl:matching-substring>
				<xsl:element name="pubPlace"><xsl:value-of select="regex-group(1)"/></xsl:element>
				<xsl:value-of select="regex-group(2)"/>
				<xsl:element name="publisher"><xsl:value-of select="regex-group(3)"/></xsl:element>
				<xsl:value-of select="regex-group(4)"/>
				<xsl:element name="date"><xsl:value-of select="regex-group(5)"/></xsl:element>
				<xsl:value-of select="regex-group(6)"/>
			</xsl:matching-substring>
			<xsl:non-matching-substring>
				<xsl:value-of select="."/>
			</xsl:non-matching-substring>
		</xsl:analyze-string>
	</xsl:template>
	
</xsl:stylesheet>
					
