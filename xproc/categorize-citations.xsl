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
					<!-- bibl elements which contain a journal date, issue, and page numbers are journalArticles
					NB Regular expression matches a string containing:
						exactly four decimal digits, 
						followed by a comma, 
						some whitespace, 
						one or more decimal digits (the issue number), 
						followed by a comma, 
						followed by more white space,
						followed by a decimal digit (start of page specification)
					-->
					<!-- e.g. "2010, 4: 3" -->
					<xsl:when test="text()[matches(., '.*\p{Nd}{4},\p{Z}*\p{Nd}*:\p{Z}*\p{Nd}')]">journalArticle</xsl:when>
					<xsl:otherwise>book</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
			<xsl:apply-templates/>
		</xsl:copy>
	</xsl:template>
	
</xsl:stylesheet>
					