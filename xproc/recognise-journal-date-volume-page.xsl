<xsl:stylesheet version="2.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 	
	xmlns:tei="http://www.tei-c.org/ns/1.0" 
	xmlns="http://www.tei-c.org/ns/1.0" 
	xmlns:tite="http://www.tei-c.org/ns/tite/1.0" 
	exclude-result-prefixes="tei tite">
	
	<xsl:template match="*">
		<xsl:copy>
			<xsl:copy-of select="@*"/>
			<xsl:apply-templates/>
		</xsl:copy>
	</xsl:template>
	
	<xsl:variable name="journal-volume-page-regex">((\p{Nd}+)(:\p{Z}+))?((no.\s?)?(\p{Nd}+)(,\s+))?((\p{Nd}+[–-]\p{Nd}+)|(\p{Nd}+))([,;\.])?</xsl:variable>
	
	<!-- in the book review section of volume 7, the text node following the journal title contains just the date -->
	<xsl:template match="tei:bibl[@type='review' and @subtype='book-review-section']/text()[preceding-sibling::*[1]/self::tei:title/@level='j']">
		<xsl:analyze-string select="." regex="([0-9]{{4}})(.*)">
			<xsl:matching-substring>
				<xsl:element name="date">
					<xsl:value-of select="regex-group(1)"/>
				</xsl:element>
				<xsl:value-of select="regex-group(2)"/><!-- any remainder -->
			</xsl:matching-substring>
			<xsl:non-matching-substring>
				<xsl:value-of select="."/>
			</xsl:non-matching-substring>
		</xsl:analyze-string>
	</xsl:template>
	<!-- in the book review section of vol 7, an italicised text node that's numeric (with optional trailing colon) is a volume number -->
	<xsl:template match="tei:bibl[@type='review' and @subtype='book-review-section']/tei:hi[@rend='i'][matches(., '[0-9]*:?')]">
		<xsl:variable name="volume" select="substring-before(concat(., ':'), ':')"/>
		<xsl:element name="biblScope">
			<xsl:copy-of select="@*"/>
			<xsl:attribute name="unit">volume</xsl:attribute>
			<xsl:attribute name="from"><xsl:value-of select="$volume"/></xsl:attribute>
			<xsl:value-of select="."/>
		</xsl:element>
	</xsl:template>
	<!-- in the book review section of vol 7, a text node that follows italicised text node that's numeric (with optional trailing colon) is a page range -->
	<xsl:variable name="book-review-page-regex">^(\(([0-9]+)\))?(:)?(([0-9]+)(–([0-9]*))?)</xsl:variable>
	<xsl:template match="
		tei:bibl[@type='review' and @subtype='book-review-section']
			/text()[
				preceding-sibling::*[1]/self::tei:hi[@rend='i'][matches(., '[0-9]*:?')]
			]
	">
		<xsl:analyze-string select="." regex="{$book-review-page-regex}">
			<xsl:matching-substring>
				<xsl:variable name="parenthetical-issue-number" select="regex-group(1)"/><!-- (4) -->
				<xsl:variable name="issue-number" select="regex-group(2)"/><!-- 4 -->
				<xsl:variable name="colon" select="regex-group(3)"/>
				<xsl:variable name="page-range" select="regex-group(4)"/>
				<xsl:variable name="start-page" select="regex-group(5)"/>
				<xsl:variable name="end-page" select="regex-group(7)"/>
				<xsl:if test="$issue-number">
					<xsl:element name="biblScope">
						<xsl:attribute name="unit">issue</xsl:attribute>
						<xsl:attribute name="from"><xsl:value-of select="$issue-number"/></xsl:attribute>
						<xsl:value-of select="$parenthetical-issue-number"/>
					</xsl:element>
				</xsl:if>
				<xsl:value-of select="$colon"/>
				<xsl:element name="biblScope">
					<xsl:attribute name="unit">page</xsl:attribute>
					<xsl:attribute name="from"><xsl:value-of select="$start-page"/></xsl:attribute>
					<xsl:if test="$end-page">
						<xsl:attribute name="to">
							<xsl:value-of select="
								concat(
									substring($start-page, 1, string-length($start-page) - string-length($end-page)),
									$end-page
								)
							"/>
						</xsl:attribute><!-- "2" + "12" = "212" -->
					</xsl:if>
					<xsl:value-of select="$page-range"/>
				</xsl:element>				
			</xsl:matching-substring>
			<xsl:non-matching-substring>
				<xsl:value-of select="."/>
			</xsl:non-matching-substring>
		</xsl:analyze-string>
	</xsl:template>	
	
	<!-- text following a journal title contains publication metadata; date, volume number, pages -->
	<xsl:template match="tei:bibl[not(@type='review' and @subtype='book-review-section')]/text()[preceding-sibling::*[1]/self::tei:title/@level='j']">
		<!-- 4 numeric digits, comma, any whitespace, any other characters -->
		<xsl:analyze-string select="." regex="(\p{{Nd}}{{4}})(,\p{{Z}}*)(.*)">
			<xsl:matching-substring>
				<xsl:element name="date">
					<xsl:value-of select="regex-group(1)"/>
				</xsl:element>
				<xsl:value-of select="regex-group(2)"/><!-- comma and whitespace -->
				<xsl:analyze-string select="regex-group(3)" regex="^{$journal-volume-page-regex}">
					<!-- volume, colon and any whitespace, page range or single page number, finally comma or full stop -->
					<!-- volume number may be preceded with "no." or "no. " -->
					<!-- NB if comma, then what follows are extents (e.g. "8 fig.") -->
					<xsl:matching-substring>
						<xsl:variable name="volume-and-suffix" select="regex-group(1)"/>
						<xsl:variable name="volume" select="regex-group(2)"/>
						<xsl:variable name="volume-colon-space-suffix" select="regex-group(3)"/>
						<xsl:variable name="issue-number-including-prefix-and-comma" select="regex-group(4)"/>
						<xsl:variable name="issue-number-prefix" select="regex-group(5)"/>
						<xsl:variable name="issue-number" select="regex-group(6)"/>
						<xsl:variable name="issue-number-comma" select="regex-group(7)"/>
						<xsl:variable name="page-or-range" select="regex-group(8)"/>
						<xsl:variable name="range" select="regex-group(9)"/>
						<xsl:variable name="page" select="regex-group(10)"/>
						<xsl:variable name="terminal-punctuation" select="regex-group(11)"/>
						<xsl:if test="$volume">
							<xsl:element name="biblScope">
								<xsl:attribute name="unit">volume</xsl:attribute>
								<xsl:attribute name="from"><xsl:value-of select="$volume"/></xsl:attribute>
								<xsl:value-of select="$volume-and-suffix"/>
							</xsl:element>
						</xsl:if>
						<xsl:if test="$issue-number-including-prefix-and-comma">
							<xsl:element name="biblScope">
								<xsl:attribute name="unit">issue</xsl:attribute>
								<xsl:attribute name="from"><xsl:value-of select="$issue-number"/></xsl:attribute>
								<xsl:value-of select="$issue-number-including-prefix-and-comma"/>
							</xsl:element>
						</xsl:if>
						<xsl:if test="$page-or-range">
							<xsl:element name="biblScope">
								<xsl:attribute name="unit">page</xsl:attribute>
								<xsl:choose>
									<xsl:when test="$range">
										<!-- potentially a variety of characters could have been used for a dash in a page range -->
										<xsl:variable name="dash" select="normalize-space(translate($range, '0123456789', ''))"/>
										<xsl:variable name="from"  select="substring-before($range, $dash)"/><!-- "210" -->
										<xsl:variable name="to" select="substring-after($range, $dash)"/><!-- "12" -->
										<xsl:attribute name="from"><xsl:value-of select="$from"/></xsl:attribute>
										<xsl:attribute name="to"><xsl:value-of select="
											concat(
												substring($from, 1, string-length($from) - string-length($to)),
												$to
											)
										"/></xsl:attribute><!-- "2" + "12" = "212" -->
									</xsl:when>
									<xsl:otherwise>
										<xsl:attribute name="from"><xsl:value-of select="$page"/></xsl:attribute>
									</xsl:otherwise>
								</xsl:choose>
								<xsl:value-of select="$page-or-range"/><!-- the element content -->
							</xsl:element>
						</xsl:if>
						<xsl:value-of select="$terminal-punctuation"/>
					</xsl:matching-substring>
					<xsl:non-matching-substring>
						<xsl:value-of select="."/>
					</xsl:non-matching-substring>
				</xsl:analyze-string>
			</xsl:matching-substring>
			<xsl:non-matching-substring>
				<xsl:value-of select="."/>
			</xsl:non-matching-substring>
		</xsl:analyze-string>
	</xsl:template>	
	
</xsl:stylesheet>
					
