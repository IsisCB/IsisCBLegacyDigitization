<xsl:stylesheet version="2.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 	
	xmlns:tei="http://www.tei-c.org/ns/1.0" 
	xmlns="http://www.tei-c.org/ns/1.0" 
	xmlns:tite="http://www.tei-c.org/ns/tite/1.0" 
	exclude-result-prefixes="tei tite">
	
	<!-- recognises the presence of an author within a bibl -->
	<xsl:template match="*">
		<xsl:copy>
			<xsl:copy-of select="@*"/>
			<xsl:apply-templates/>
		</xsl:copy>
	</xsl:template>
	
	<!-- Citations (except for citations of reviews) begin with an author's upper-case name, terminated with ". " -->
	<!-- In some cases, the author's name can include a disambiguity suffix (such as "4th baron. ") which may
	also be in italics -->
	<xsl:template match="tei:bibl[not(@type='review')]">
		<xsl:copy>
			<xsl:copy-of select="@*"/>
			<xsl:choose>
				<xsl:when test="(count(tei:hi[@rend='i']) &gt; 1) and not(contains(text()[1], '. '))">
					<!-- more than 1 italicised phrase and first text node doesn't contain a full stop and space
					implies first italicised phrase is a terminal author name-part -->
					<!-- e.g.
					<p>RAYLEIGH, Robert John Strutt, <hi rend="i">4th baron.</hi> Vision in nature and vision aided by science; science and warfare. <hi rend="i">Science,</hi> 1938, 88: 175–81, 204–8.</p>
					-->
					<xsl:variable name="italicised-author-name-suffix" select="tei:hi[@rend='i'][1]"/>
					<xsl:element name="author">
						<!-- author name consists of anything before the italicised suffix, and the suffix itself -->
						<xsl:copy-of select="($italicised-author-name-suffix/preceding-sibling::node())"/>
						<xsl:copy-of select="$italicised-author-name-suffix"/>
					</xsl:element>
					<!-- remainder of citation ... -->
					<xsl:copy-of select="$italicised-author-name-suffix/following-sibling::node()"/>
				</xsl:when>
				<xsl:otherwise>
					<!-- Author name is the part of the first text element up to the full stop and space -->
					<xsl:element name="author">
						<xsl:value-of select="concat(substring-before(text()[1], '. '), '. ')"/>
					</xsl:element>
					<xsl:value-of select="substring-after(text()[1], '. ')"/>
					<xsl:copy-of select="text()[1]/following-sibling::node()"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:copy>
	</xsl:template>
	
</xsl:stylesheet>
					