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
	
	<!-- in a book citation in the book review section, the title includes everything between the last author and the next semantic element, whatever that is -->
	<!--<xsl:template match="tei:bibl[@type='book'][@subtype='book-review-section']">-->
	<xsl:template match="tei:bibl[not(@type=('review', 'journalArticle', 'bookChapter'))][ancestor::tei:text/@xml:id=('ISIS-06', 'ISIS-07')]">

		<xsl:copy>
			<xsl:copy-of select="@*"/>
			<xsl:variable name="last-author" select="tei:author[not(following-sibling::tei:author)]"/>
			<xsl:variable name="first-non-title" select="*[not(self::tei:author | self::tei:hi)][1]"/>
			<xsl:choose>
				<xsl:when test="$last-author">
					<xsl:copy-of select="node()[. &lt;&lt; $last-author] | $last-author"/>
					<xsl:element name="title">
						<xsl:copy-of select="$last-author/following-sibling::node()[. &lt;&lt; $first-non-title]"/>
					</xsl:element>
				</xsl:when>
				<xsl:otherwise>
					<xsl:element name="title">
						<xsl:copy-of select="node()[. &lt;&lt; $first-non-title]"/>
					</xsl:element>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:copy-of select="$first-non-title | $first-non-title/following-sibling::node()"/>
		</xsl:copy>
	</xsl:template>
	<!-- in bookChapter citations in vols 6 and 7, book titles are highlighted in italics following the word " in " -->
	<xsl:template priority="100" match="tei:bibl
		[@type='bookChapter']
		[ancestor::tei:text/@xml:id=('ISIS-06', 'ISIS-07')]
		/tei:hi[@rend='i'][not(preceding-sibling::tei:hi[@rend='i'])]
	">
		<xsl:element name="title">
			<xsl:copy-of select="@*"/>
			<xsl:apply-templates/>
		</xsl:element>	
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
		[preceding-sibling::node()[1]/self::tei:biblScope/@unit='chapter']
		[starts-with(., '. In: ')]
	">
		<xsl:text>. In: </xsl:text>
		<xsl:element name="title">
			<xsl:value-of select="substring-after(., ' In: ')"/>
		</xsl:element>
	</xsl:template>
	
	<!-- Except that chapters published in books which are conference proceedings and festschrifts have a different format; -->
	<!-- the chapter title is in plain text following the author name, and is immediately followed by the book title in italics, with no ' In: ' -->
	<xsl:template match="tei:bibl[@type='bookChapter']/tei:hi[@rend='i']
		[preceding-sibling::node()[1]/self::tei:biblScope/@unit='chapter']
	">
		<xsl:element name="title">
			<xsl:copy-of select="@*"/>
			<xsl:apply-templates/>
		</xsl:element>
	</xsl:template>
	

</xsl:stylesheet>
					
