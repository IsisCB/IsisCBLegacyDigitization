<xsl:stylesheet version="2.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 	
	xmlns:tei="http://www.tei-c.org/ns/1.0" 
	xmlns="http://www.tei-c.org/ns/1.0" 
	xmlns:tite="http://www.tei-c.org/ns/tite/1.0" 
	exclude-result-prefixes="tei tite">
	
	<!-- recognises the presence of a journal title in a bibl (they are italicised) -->
	<xsl:template match="*">
		<xsl:copy>
			<xsl:copy-of select="@*"/>
			<xsl:apply-templates/>
		</xsl:copy>
	</xsl:template>
	
	<!-- italicised phrase is a journal title -->
	<!-- unless it's only numeric with optional trailing colon (in which case it's a journal volume number -->
	<xsl:template match="tei:bibl[@type='journalArticle' or @type='review']/tei:hi[@rend='i'][not(matches(., '^[0-9]+:?$'))]">
		<xsl:element name="title">
			<xsl:attribute name="level">j</xsl:attribute>
			<xsl:element name="abbr"><xsl:apply-templates/></xsl:element>
			<xsl:variable name="abbreviation" select="
				normalize-space(
					translate(
						replace(
							normalize-unicode(., 'NFD'), 
							'\p{IsCombiningDiacriticalMarks}', 
							''
						), 
						',.', 
						' '
					)
				)
			"/>
			<xsl:variable name="term"  select="/tei:TEI/tei:teiHeader/tei:fileDesc/tei:notesStmt//tei:term[
				normalize-space(
					translate(
						replace(
							normalize-unicode(., 'NFD'), 
							'\p{IsCombiningDiacriticalMarks}', 
							''
						), 
						',.', 
						' '
					)
				)
				=$abbreviation
			]"/>
			<xsl:variable name="term-id-reference" select="concat('#', $term[1]/@xml:id)"/>
			<xsl:variable name="gloss" select="/tei:TEI/tei:teiHeader/tei:fileDesc/tei:notesStmt//tei:gloss[@target=$term-id-reference]"/>
			<!-- TODO choose the shortest gloss? -->
			<xsl:element name="expan"><xsl:value-of select="$gloss[1]"/></xsl:element>
		</xsl:element>
	</xsl:template>
	

	<!-- text sandwiched between an author and an italicised phrase is a title -->
	<xsl:template match="tei:bibl[@type='journalArticle']/text()
		[normalize-space()]
		[following-sibling::*[1]/self::tei:hi/@rend='i']
		[preceding-sibling::*[1]/self::tei:author]
	">
		<xsl:element name="title">
			<xsl:value-of select="."/>
		</xsl:element>
	</xsl:template>	
	
</xsl:stylesheet>
					
