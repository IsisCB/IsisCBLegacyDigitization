<xsl:stylesheet version="2.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 	
	xmlns:tei="http://www.tei-c.org/ns/1.0" 
	xmlns="http://www.tei-c.org/ns/1.0" 
	xmlns:tite="http://www.tei-c.org/ns/tite/1.0" 
	exclude-result-prefixes="tei tite">
	
	<!-- recognises the presence of another citation within a bibl's note -->
	<xsl:template match="*">
		<xsl:copy>
			<xsl:copy-of select="@*"/>
			<xsl:apply-templates/>
		</xsl:copy>
	</xsl:template>
	
	<!-- match notes which appear to contain a review -->
	<!-- e.g. "Reviewed by P.J. Richard ..." or "French edition: Le problème Martien (Paris: Elzévir, 1946) reviewed by..."-->
	<xsl:template match="tei:bibl/tei:note[contains(., 'eviewed by')]">
		<xsl:copy>
			<xsl:copy-of select="@*"/>
			<xsl:for-each-group group-ending-with="text()[contains(., '; by ')]" select="node()">
				<xsl:element name="bibl">
					<xsl:attribute name="type">review</xsl:attribute>
					<!-- previous text is the last text node preceding this citation; from '; by ' onwards it belongs to this citation -->
					<xsl:variable name="previous-text" select="preceding-sibling::node()[1]/self::text()[contains(., '; by ')]"/>
					<xsl:if test="$previous-text">
						<xsl:value-of select="concat('by ', substring-after($previous-text, '; by '))"/>
					</xsl:if>
					<!-- include the rest of the group (except the final text node -->
					<xsl:apply-templates select="current-group()[not(self::text()[contains(., '; by ')])]"/>
					<!-- the first part of the final text node belongs here -->
					<xsl:for-each select="current-group()[self::text()[contains(., '; by ')]]">
						<xsl:value-of select="concat(substring-before(., '; by '), '; ')"/>
					</xsl:for-each>
				</xsl:element>
			</xsl:for-each-group>
		</xsl:copy>
	</xsl:template>
	
	<!-- in the "book review" section of volume 7, starting on page 605, all the top-level citations are of books, and a simpler format is used for review citations -->
	<xsl:template match="tei:bibl[ancestor::tei:text/@xml:id='ISIS-07' and preceding::tei:pb/@n='605']">
		<xsl:copy>
			<xsl:copy-of select="@*"/>
			<xsl:attribute name="type">book</xsl:attribute>
			<xsl:attribute name="subtype">book-review-section</xsl:attribute>
			<xsl:apply-templates mode="book-review-section"/>
		</xsl:copy>
	</xsl:template>
	<xsl:template match="*" mode="book-review-section">
		<xsl:copy>
			<xsl:copy-of select="@*"/>
			<xsl:apply-templates mode="book-review-section"/>
		</xsl:copy>
	</xsl:template>
	<xsl:template match="tei:note" mode="book-review-section">
		<xsl:copy>
			<xsl:copy-of select="@*"/>
			<!-- e.g. 
			L. Dulieu in Bibl. Renaiss., 1967, 29:289–90. J.M. Lopez Piñero in Asclepio, 1965, 17:281–2. C.H. Talbot in Isis, 1967, 58:575–6. W.D. Sharpe in Speculum, 1968, 43:119–21. E. Seidler in Sudhoffs Arch., 1967, 51:280–1.
			-->
			<xsl:element name="bibl">
				<xsl:attribute name="type">review</xsl:attribute>
				<xsl:attribute name="subtype">book-review-section</xsl:attribute>
				<xsl:apply-templates mode="book-review-section-review"/>
			</xsl:element>
		</xsl:copy>
	</xsl:template>	
	
	<xsl:template match="node()" mode="book-review-section-review">
		<xsl:copy-of select="."/>
	</xsl:template>

	<!-- text following an italicised number with optional trailing colon, in a book-review-section review may straddle the boundary between one review and another -->
	<!-- if so, a milestone is inserted to mark that boundary, and later the bibl will be split around this milestone -->
	<xsl:template match="text()[preceding-sibling::*[1]/self::tei:hi[@rend='i'][matches(., '^[0-9]+:?$')]]" mode="book-review-section-review">
		<xsl:analyze-string select="." regex="^(\([0-9]+\))?:?[0-9]+(–[0-9]+)?(, [0-9]+(–[0-9]+)?)*\. ">
			<xsl:matching-substring>
				<!-- first bibl finishes after the page number or page range -->
				<xsl:value-of select="."/>
				<xsl:element name="milestone"/>
			</xsl:matching-substring>
			<xsl:non-matching-substring>
				<xsl:value-of select="."/>
			</xsl:non-matching-substring>
		</xsl:analyze-string>
	</xsl:template>
	
</xsl:stylesheet>
					
