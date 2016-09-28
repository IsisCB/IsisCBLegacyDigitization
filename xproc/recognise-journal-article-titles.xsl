<xsl:stylesheet version="2.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 	
	xmlns:tei="http://www.tei-c.org/ns/1.0" 
	xmlns="http://www.tei-c.org/ns/1.0" 
	xmlns:tite="http://www.tei-c.org/ns/tite/1.0" 
	exclude-result-prefixes="tei tite">
	
	<!-- recognises the title of journal article titles -->
	<xsl:template match="*">
		<xsl:copy>
			<xsl:copy-of select="@*"/>
			<xsl:apply-templates/>
		</xsl:copy>
	</xsl:template>
	

	<!-- text sandwiched between an author and an italicised phrase is a title -->
	<!--
	<xsl:template match="tei:bibl[@type='journalArticle']/text()
		[normalize-space()]
		[following-sibling::*[1]/self::tei:hi/@rend='i']
		[preceding-sibling::*[1]/self::tei:author]
	">
		<xsl:element name="title">
			<xsl:attribute name="ana">between-author-and-italics</xsl:attribute>
			<xsl:value-of select="."/>
		</xsl:element>
	</xsl:template>	
	-->
	<!--
	<xsl:template priority="100" match="tei:bibl
		[@type=('journalArticle')]
		[ancestor::tei:text/@xml:id=('ISIS-06', 'ISIS-07')]
	">
	-->
	<xsl:template match="tei:bibl
		[@type=('journalArticle')]
		[tei:title/@level='j']
	">
		<xsl:copy>
			<xsl:copy-of select="@*"/>
			<xsl:variable name="last-author" select="tei:author[not(following-sibling::tei:author)]"/>
			<xsl:variable name="first-non-title" select="*[
				not(
					self::tei:author | 
					self::tei:hi[@rend='i']
				)
			][1]"/>
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
	

	
</xsl:stylesheet>
					
