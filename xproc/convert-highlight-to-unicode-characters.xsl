<xsl:stylesheet version="2.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 	
	xmlns:tei="http://www.tei-c.org/ns/1.0" 
	xmlns="http://www.tei-c.org/ns/1.0" 
	xmlns:tite="http://www.tei-c.org/ns/tite/1.0" 
	exclude-result-prefixes="tei tite">
	
	<!-- uses superscript unicode chars where possible in preference to using TEI markup to indicate superscript -->
	<xsl:template match="*">
		<xsl:copy>
			<xsl:copy-of select="@*"/>
			<xsl:apply-templates/>
		</xsl:copy>
	</xsl:template>
	
	<!-- NB there is no superscript q! -->
	<xsl:variable name="superscriptable">abcdefghijklmnoprstuvwxyz</xsl:variable>
	<xsl:variable name="superscript">ᵃᵇᶜᵈᵉᶠᵍʰⁱʲᵏˡᵐⁿᵒᵖʳˢᵗᵘᵛʷˣʸᶻ</xsl:variable>
	<xsl:template match="tei:hi[@rend='sup']">
		<xsl:variable name="text" select="string(.)"/>
		<xsl:variable name="unsuperscriptable-text" select="translate($text, $superscriptable, '')"/>
		<xsl:choose>
			<xsl:when test="$unsuperscriptable-text"><!-- not all of the characters could be converted to a superscripted form -->
				<xsl:copy-of select="."/><!-- give up and copy the tei:hi element as is -->
			</xsl:when>
			<xsl:otherwise>
				<xsl:variable name="superscripted-text" select="translate($text, $superscriptable, $superscript)"/>
				<xsl:value-of select="$superscripted-text"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
</xsl:stylesheet>
					
