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
	
	<!-- Each top-level (i.e. not a review article) citation begins with the author's surname, in all caps -->
	<!-- As well as regular upper case letters, names may be hyphenated, Arabic names may contain the Arabic letter Ayin transliterated as  ‘, -->
	<!-- Irish names may contain an apostrophe. -->
	<!-- Additionally, some Arabic names begin with the article "al-" in lower case, but are otherwise in all caps -->
	<!-- Further, some citations begin with an asterisk to show that they are corrections to previously published citations -->
	<xsl:variable name="surname-regex">^(\* ?)?(al-)?(Mc)?(Mac)?(['‘'-]|\p{Lu}|\p{IsCombiningDiacriticalMarks}){2,}</xsl:variable>
	
	<xsl:template match="tei:body//tei:div">
		<xsl:copy>
			<xsl:copy-of select="@*"/>
			<!-- handle all the citations -->
			<!-- each citation starts with a para whose first word is a person's name: an upper-case word
			at least 2 characters long, 
			OR an Arabic name prefixed with the definite article "al-" in lower case -->
			<xsl:for-each-group select="node()" group-starting-with="
				tei:div |
				tei:p
					[matches(., $surname-regex)]
			">
				<xsl:choose>
					<xsl:when test="self::tei:p
						[matches(., $surname-regex)]
					">
						<xsl:variable name="page" select="preceding::tei:pb[1]"/>
						<xsl:element name="bibl">
							<xsl:apply-templates select="current-group()"/>
						</xsl:element>
						<xsl:value-of select="codepoints-to-string(10)"/>
					</xsl:when>
					<xsl:otherwise><!-- page breaks and misc global elements -->
						<xsl:apply-templates select="current-group()"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:for-each-group>
		</xsl:copy>
	</xsl:template>
	
	<!-- a paragraph which begins a bibliographic citation needs to be unwrapped from its para -->
	<xsl:template priority="100" match="tei:body//tei:div/tei:p
		[matches(., $surname-regex)]">
		<xsl:apply-templates/>
	</xsl:template>
	
	<!-- the first text node of a paragraph which starts a citation, if it also starts with an asterisk -->
	<!-- These citations are corrections to previously published citations -->
	<xsl:template match="tei:body//tei:div/tei:p[matches(., $surname-regex)]/node()[1][self::text()][matches(., '^(\* ?)')]">
		<xsl:analyze-string select="." regex="^(\* ?)">
			<xsl:matching-substring>
				<xsl:attribute name="subtype">correction</xsl:attribute>
				<xsl:attribute name="rend">starred</xsl:attribute>
			</xsl:matching-substring>
			<xsl:non-matching-substring>
				<xsl:value-of select="."/>
			</xsl:non-matching-substring>
		</xsl:analyze-string>
	</xsl:template>
	
	<!-- a paragraph which follows on from a previous para in a bibliographic citation is a note -->
	<xsl:template match="tei:body//tei:div/tei:p
		[preceding-sibling::tei:p]
		[not(tei:hi[@rend='b'])]">
		<note><xsl:apply-templates/></note>
	</xsl:template>
	
</xsl:stylesheet>
					
