<xsl:stylesheet version="2.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 	
	xmlns:tei="http://www.tei-c.org/ns/1.0" 
	xmlns="http://www.tei-c.org/ns/1.0" 
	xmlns:tite="http://www.tei-c.org/ns/tite/1.0" 
	exclude-result-prefixes="tei tite">
	
	<!-- a regex of possible name parts suitable for tagging with tei:nameLink -->
	<xsl:variable name="nameLinks" select=" 'von|van der|van|de' "/>
	
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
				<xsl:when test="(count(tei:hi[@rend='i']) &gt; 0) and not(contains(text()[1], '. '))">
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
					<xsl:apply-templates select="$italicised-author-name-suffix/following-sibling::node()"/>
				</xsl:when>
				<xsl:otherwise>
					<!-- Author name is the part of the first text element up to the full stop and space,
					except where a "nameLink" such as "von" appears after the name. (TODO) -->
					<xsl:variable name="author" select="substring-before(text()[1], '. ')"/>
					<xsl:choose>
						<xsl:when test="$author">
							<xsl:element name="author">
								<xsl:value-of select="concat($author, '. ')"/>
							</xsl:element>
							<xsl:value-of select="substring-after(text()[1], '. ')"/>
							<xsl:apply-templates select="text()[1]/following-sibling::node()"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:comment>No author!</xsl:comment>
							<xsl:apply-templates/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:copy>
	</xsl:template>
	
	<xsl:template match="tei:bibl[@type='review']">
		<xsl:copy>
			<xsl:copy-of select="@*"/>
			<!-- review citations begin with "Reviewed by" or something like "Vol. 6-7 reviewed by" or "Dutch ed. reviewed by" -->
			<!--  parse the first text node to identify the review author -->
			<xsl:variable name="first-text-node" select="text()[1]"/>
			<xsl:choose>
				<xsl:when test="$first-text-node">
					<xsl:analyze-string select="$first-text-node" regex="((^by )|(.*eviewed by ))([^,]+)(.*)">
						<xsl:matching-substring>
							<xsl:value-of select="regex-group(2)"/><!-- e.g. "by " -->
							<xsl:value-of select="regex-group(3)"/><!-- e.g. "Dutch ed. reviewed by " -->
							<xsl:element name="author">
								<xsl:value-of select="regex-group(4)"/>
							</xsl:element>
							<xsl:value-of select="regex-group(5)"/>
						</xsl:matching-substring>
						<xsl:non-matching-substring>
							<xsl:comment>No author!</xsl:comment>
							<xsl:value-of select="."/>
						</xsl:non-matching-substring>
					</xsl:analyze-string>
					<!-- reproduce the remainder of the citation -->
					<xsl:copy-of select="$first-text-node/following-sibling::node()"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:comment>No text nodes!</xsl:comment>
					<xsl:apply-templates/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:copy>
	</xsl:template>
	
</xsl:stylesheet>
					
