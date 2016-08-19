<xsl:stylesheet version="2.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 	
	xmlns:tei="http://www.tei-c.org/ns/1.0" 
	xmlns="http://www.tei-c.org/ns/1.0" 
	xmlns:tite="http://www.tei-c.org/ns/tite/1.0" 
	exclude-result-prefixes="tei tite">
	
	<!-- distinguishes citations of journals from those of books -->
	<xsl:template match="*">
		<xsl:copy>
			<xsl:copy-of select="@*"/>
			<xsl:apply-templates/>
		</xsl:copy>
	</xsl:template>
	

	<xsl:variable name="roman-number-regex">(c{0,3})((xc)|(xl)|(l?)(x{0,3}))(ix)?((iv)|((v)?(i{0,3})))</xsl:variable>	
	<xsl:variable name="book-series-regex">(\(([^\)]+)\))?</xsl:variable><!-- probably not sufficiently discriminatory to use -->
	<xsl:variable name="imprint-regex">(\p{Z}+)(([^):.]|\.\w)*)[\.]?(:\p{Z}+)([^,]*)(,\p{Z}+)(\p{Nd}{4})([\.,])</xsl:variable>
	
	<xsl:variable name="book-or-chapter-regex" select="concat($book-series-regex, $imprint-regex)"/>
	<xsl:variable name="book-extents-regex" select="concat(
		'( (',
		$roman-number-regex,
		'),)?( (\d+) pp?\.)(, front\.)?(, (\d* )?pl\.)?(, (\d* )?fig\.)?(, (\d* )?ill\.)?(, (\d* )?illus\.)?(, (\d* )?portr\.)?(, (\d* )?bibliogr\.)?(, (\d* )?bibl\.)?(, (\d* )?index\.)?'
	)"/>
	<xsl:variable name="journal-article-extents-regex">(, (\d* )?pl\.)|(, (\d* )?fig\.)|(, (\d* )?ill\.)|(, (\d* )?portr\.)|(, (\d* )?bibliogr\.)|(, (\d* )?illus\.)|(, (\d* )?bibl\.)|(, (\d* )?maps)</xsl:variable>
	<xsl:variable name="journal-date-volume-page-regex">(no.\s?)?(\p{Nd}*)(:\p{Z}*)((\p{Nd}*–\p{Nd}*)|(\p{Nd}*))([,\.])</xsl:variable>
	<xsl:variable name="book-chapter-page-range-regex" select="concat(
		'(p\. )(',
		$roman-number-regex,
		'([-–])',
		$roman-number-regex,
		'}, )?(\p{Nd}*([-–])\p{Nd}*)'
	)"/>
	
	<!-- match untyped bibl elements and assign them a type -->
	<xsl:template match="tei:bibl[not(@type)]">
		<xsl:copy>
			<xsl:copy-of select="@*"/>
			<xsl:attribute name="type">
				<xsl:choose>
					<!-- a bibl in a note in another bibl is a citation of a review of the containing bibl -->
					<xsl:when test="parent::tei:note/parent::tei:bibl">review</xsl:when>
					<!-- e.g. OSLER, William. William Beaumont. In: Selected writings of Sir William Osler, 12 July 1849 to 29 December 1919. Ed. by Alfred White Franklin with an introduction by G.L. Keynes. London: Oxford University Press, 1951. [CB 78/154] -->
					<xsl:when test="contains(., '. In: ')">bookChapter</xsl:when>
					<xsl:otherwise>
						<xsl:variable name="book-or-chapter" select="matches(., $book-or-chapter-regex)"/>
						<xsl:variable name="book-extents" select="matches(., $book-extents-regex)"/>
						<xsl:variable name="journal-article-extents" select="matches(., $journal-article-extents-regex)"/>
						<xsl:variable name="journal-date-volume-page" select="matches(., $journal-date-volume-page-regex)"/>
						<xsl:variable name="book-chapter-page-range" select="matches(., $book-chapter-page-range-regex)"/>
						<xsl:variable name="book-score" select="
							(if ($book-or-chapter) then 1 else 0) + 
							(if ($book-extents) then 1 else 0)
						"/>
						<xsl:variable name="journal-score" select="
							(if ($journal-article-extents) then 1 else 0) +
							(if ($journal-date-volume-page) then 1 else 0)
						"/>
						<xsl:variable name="book-chapter-score" select="
							(if ($book-chapter-page-range) then 1 else 0) +
							$book-score
						"/>
						<xsl:choose>
							<xsl:when test="$book-chapter-score &gt; $journal-score">
								<xsl:choose>
									<xsl:when test="$book-chapter-score &gt; $book-score">bookChapter</xsl:when>
									<xsl:otherwise>book</xsl:otherwise>
								</xsl:choose>
							</xsl:when>
							<xsl:otherwise>journalArticle</xsl:otherwise>
						</xsl:choose>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
			<xsl:apply-templates/>
		</xsl:copy>
	</xsl:template>
	
</xsl:stylesheet>
					
