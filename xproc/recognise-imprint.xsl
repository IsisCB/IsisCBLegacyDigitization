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
	<!-- Preceding the imprint, there may be a book series title, in parentheses, which is also parsed here, unless it's italicised, in which case it is parsed in a subsequent step -->
	<!-- e.g.
	
	al-ḤAMDANI, Abu Muhammad al-Ḥasan ibn al-Ḥā'ik. The antiquities of South Arabia, being a translation from the Arabic with linguistic, geographic an dhistoric notes of the eighth Book of al-Hamdānī's “al-Iklīl”, reconstructed from al-Karmali's edition and a ms. in the Garrett collection, Princeton University Library, by Nabin Amin Faris. 119 p. (Princeton Oriental texts, 3) Princeton, N.J.: University Press, 1938.
	
	HAMEL, Hendrik. Verhaal van het vergaan van het jacht “De Sperwer” en van het wedervaren der schipbreukelingen op het eiland Quelpaert en het vasteland van Korea (1653–1666), met eene beschrijving van dat Rijk. [The story of the shipwreck of the yacht “De Sperwer” and of the adventures of its survivors on the island Quelpaert and the mainland of Korea (1653–1666), with a description of that country. (In Dutch)] Uitgegeven door B. Hoetink. liii, 165 p., 1 map, nll ill. (Lindschoten-Vereeniging, 18) 's-Gravenhage: M. Nijhoff, 1920. 
	
	ALLODI, Federico. Descrizione di un microscopio. In: Studi e ricerche sui microscopi galileiani del Museo di Storia della Scienza, fasc. 1, p. 1–19, 3 pl. (Istituto e Museo di Storia della Scienza, Biblioteca, 2) Firenze: Leo Olschki Editore, 1957, [CB 83/246]
	-->
	<xsl:template match="tei:bibl[@type=('book', 'bookChapter')]/text()
		[following-sibling::node()[1][self::tei:note | self::tei:ref] or 
		not(following-sibling::*)]">
		<!--  Berlin: Julius Springer, 1923. -->
		<xsl:variable name="book-series-regex">(\(([^\)]+)\))?</xsl:variable>
		<xsl:variable name="imprint-regex">(\p{Z}+)(([^):.]|\.\w)*)[\.]?(:\p{Z}+)(.*)(,\p{Z}+)?(\p{Nd}{4})([\.,])</xsl:variable>
		<xsl:analyze-string select="." regex="{$book-series-regex}{$imprint-regex}">
			<xsl:matching-substring>
				<xsl:variable name="book-series" select="regex-group(1)"/>
				<xsl:if test="$book-series">
					<xsl:element name="title">
						<xsl:attribute name="level">s</xsl:attribute><!-- series -->
						<xsl:value-of select="$book-series"/>
					</xsl:element>
				</xsl:if>
				<xsl:value-of select="regex-group(3)"/><!-- white space -->
				<xsl:element name="pubPlace"><xsl:value-of select="regex-group(4)"/></xsl:element>
				<xsl:value-of select="regex-group(6)"/><!-- colon, white space -->
				<!-- publisher is optional -->
				<xsl:variable name="publisher" select="regex-group(7)"/>
				<xsl:if test="$publisher">
					<xsl:element name="publisher"><xsl:value-of select="$publisher"/></xsl:element>
				</xsl:if>
				<xsl:value-of select="regex-group(8)"/><!-- comma, white space -->
				<xsl:element name="date"><xsl:value-of select="regex-group(9)"/></xsl:element>
				<xsl:value-of select="regex-group(10)"/><!-- full stop or comma -->
			</xsl:matching-substring>
			<xsl:non-matching-substring>
				<xsl:value-of select="."/>
			</xsl:non-matching-substring>
		</xsl:analyze-string>
	</xsl:template>
	
</xsl:stylesheet>
					
