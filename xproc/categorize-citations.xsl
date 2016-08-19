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
	
	<!-- match untyped bibl elements and assign them a type -->
	<xsl:template match="tei:bibl[not(@type)]">
		<xsl:copy>
			<xsl:copy-of select="@*"/>
			<xsl:attribute name="type">
				<xsl:choose>
					<!-- a bibl in a note in another bibl is a citation of a review of the containing bibl -->
					<xsl:when test="parent::tei:note/parent::tei:bibl">review</xsl:when>
					<xsl:otherwise>
						<!-- a journal article citation will contain an italicised abbreviation of the journal's name -->
						<!-- check the last italicised phrase against the full list of journal abbreviations -->
						<xsl:variable name="last-italicised-phrase" select="tei:hi[@rend='i'][not(following-sibling::tei:hi/@rend='i')]"/>
						<xsl:variable name="possible-abbreviation" select="
							normalize-space(
								translate(
									replace(
										normalize-unicode($last-italicised-phrase, 'NFD'), 
										'\p{IsCombiningDiacriticalMarks}', 
										''
									), 
									',. ', 
									''
								)
							)
						"/>
						<xsl:choose>
							<!-- if the italicised text matches one of the journal title abbreviations, then the citation is of a journal article -->
							<!--
							<xsl:when test="/tei:TEI/tei:teiHeader/tei:fileDesc/tei:notesStmt//tei:term[
								normalize-space(
									translate(
										replace(
											normalize-unicode(., 'NFD'), 
											'\p{IsCombiningDiacriticalMarks}', 
											''
										), 
										',. ', 
										''
									)
								)
								=$possible-abbreviation
							]">journalArticle</xsl:when>
							-->
							<!-- if the italicised phrase is followed by a date, volume number, and page number or range of page numbers, then
							it'll be the title of a journal, and this is a journalArticle citation -->
							<!-- <p>BENAKIS, L. Michael Psellos' Kritik an Aristoteles und seine eigene Lehre zur Physis- und Materie-Form-Problematik. <hi rend="i">Byzantische Z.,</hi> 1963, 56: 213–27.</p>
							NB Regular expression matches a string containing:
								exactly four decimal digits, 
								followed by a comma, 
								some whitespace, 
								one or more decimal digits (the issue number), 
								optionally followed by a numeric expression in parentheses
								followed by a colon, 
								optionally followed by more white space,
								followed by a decimal digit (start of page specification)
							-->							
							<xsl:when test="
								$last-italicised-phrase/following-sibling::node()[1]/self::text()[
									matches(., '\p{Nd}{4},\p{Z}*\p{Nd}*(\(\p{Nd}*\))?:\p{Z}?\p{Nd}')
								]
							">journalArticle</xsl:when>
							<!-- e.g. "2010, 4: 3" -->
							<xsl:otherwise>
								<!-- the citation is either of a book, or just a chapter within a book -->
								<xsl:choose>
									<!-- e.g. OSLER, William. William Beaumont. In: Selected writings of Sir William Osler, 12 July 1849 to 29 December 1919. Ed. by Alfred White Franklin with an introduction by G.L. Keynes. London: Oxford University Press, 1951. [CB 78/154] -->
									<xsl:when test="contains(., '. In: ')">bookChapter</xsl:when>
									<xsl:otherwise>book</xsl:otherwise>
								</xsl:choose>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
			<xsl:apply-templates/>
		</xsl:copy>
	</xsl:template>
	
</xsl:stylesheet>
					
