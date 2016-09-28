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
	
	<xsl:template match="tei:bibl[@type='bookChapter']/text()[1][contains(., '. In: ')]">
		<xsl:variable name="chapter-title" select="substring-before(., '. In: ')"/>
		<xsl:element name="biblScope">
			<xsl:attribute name="unit">chapter</xsl:attribute>
			<xsl:element name="title">
				<xsl:value-of select="$chapter-title"/>
			</xsl:element>
		</xsl:element>
		<xsl:value-of select="substring-after(., $chapter-title)"/>
	</xsl:template>
	
	<xsl:template match="tei:bibl[@type='bookChapter']/text()[1][not(contains(., '. In: '))]">
		<xsl:analyze-string select="." regex="^(\s*)(.+)">
			<xsl:matching-substring>
				<xsl:value-of select="regex-group(1)"/><!-- leading white space -->
				<xsl:element name="biblScope">
					<xsl:attribute name="unit">chapter</xsl:attribute>
					<xsl:element name="title">
						<xsl:value-of select="regex-group(2)"/>
					</xsl:element>
				</xsl:element>
			</xsl:matching-substring>
			<xsl:non-matching-substring>
				<xsl:value-of select="."/>
			</xsl:non-matching-substring>
		</xsl:analyze-string>
	</xsl:template>

	<!-- book chapter titles in the final two volumes are formatted differently, e.g. -->
	<!-- NICOLAS, JEAN PAUL. L'abbé Cotté et ses papiers. Pp. 255–263 in <i>Comptes rendus du 91e Congrès National des Sociétés Savantes. Section des sciences, tome 1.</i> Paris: Gauthier-Villars, 1967.  -->
	<!-- <author>MOLINO, JEAN.</author> L'éducation vue à travers <hi rend="i">L'examen des esprits</hi> de docteur Huarte. Pp. 105–115 in <hi rend="i">Le XVII siècle et l'éducation: Colloque de Marseille.</hi> [Marseille: 1971]. --> 
	<!-- template matches bookChapters in vols 6 and 7 which contain a page range followed by ' in ' -->
	<xsl:template match="tei:bibl
		[@type='bookChapter']
		[ancestor::tei:text/@xml:id=('ISIS-06', 'ISIS-07')]
		[text()[matches(., ' Pp. ([\d]+)–([\d]+) in ')]]
	">
		<xsl:copy>
			<xsl:copy-of select="@*"/>
			<xsl:variable name="last-author" select="tei:author[not(following-sibling::tei:author)]"/>
			<xsl:variable name="page-range-regex"> Pp. ([\d]+)–([\d]+) in </xsl:variable>
			<!-- the fragment containing the last part of the title, the page range, and the word " in " -->
			<xsl:variable name="page-range-container-fragment" select="(text()[matches(., $page-range-regex)])[1]"/>
			<!-- anything up to the page range forms the end of the title -->
			<xsl:variable name="end-of-title" select="replace($page-range-container-fragment, $page-range-regex, '')"/>
			<!-- everything after the title is the page range -->
			<xsl:variable name="page-range" select="substring-after($page-range-container-fragment, $end-of-title)"/>
			<xsl:choose>
				<xsl:when test="$last-author">
					<xsl:copy-of select="node()[. &lt;&lt; $last-author] | $last-author"/>
					<xsl:element name="biblScope">
						<xsl:attribute name="unit">chapter</xsl:attribute>
						<xsl:element name="title">
							<xsl:copy-of select="$last-author/following-sibling::node()
								[. &lt;&lt; $page-range-container-fragment]"/>
							<xsl:value-of select="$end-of-title"/>
						</xsl:element>
					</xsl:element>
				</xsl:when>
				<xsl:otherwise>
					<xsl:element name="biblScope">
						<xsl:attribute name="unit">chapter</xsl:attribute>
						<xsl:element name="title">
							<xsl:copy-of select="node()[. &lt;&lt; $page-range-container-fragment]"/>
								<xsl:value-of select="$end-of-title"/>
						</xsl:element>
					</xsl:element>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:analyze-string select="$page-range" regex="{$page-range-regex}">
				<xsl:matching-substring>
					<xsl:element name="biblScope">
						<xsl:attribute name="unit">page</xsl:attribute>
						<xsl:variable name="from"  select="regex-group(1)"/><!-- "210" -->
						<xsl:variable name="to" select="regex-group(2)"/><!-- "12" -->
						<xsl:attribute name="from"><xsl:value-of select="$from"/></xsl:attribute>
						<xsl:attribute name="to"><xsl:value-of select="
							concat(
								substring($from, 1, string-length($from) - string-length($to)),
								$to
							)
						"/></xsl:attribute><!-- "2" + "12" = "212" -->
						<xsl:value-of select="substring-before(., ' in ')"/>
					</xsl:element>
					<xsl:text> in </xsl:text>
				</xsl:matching-substring>
				<xsl:non-matching-substring>
					<xsl:value-of select="."/>
				</xsl:non-matching-substring>
			</xsl:analyze-string>
			<xsl:copy-of select="$page-range-container-fragment/following-sibling::node()"/>
		</xsl:copy>

	</xsl:template>

</xsl:stylesheet>
					
