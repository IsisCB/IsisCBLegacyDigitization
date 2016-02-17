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
	
	<xsl:template match="tei:body//tei:div">
		<xsl:copy>
			<xsl:copy-of select="@*"/>
			<!-- handle all the citations -->
			<!-- each citation starts with a para whose first word is a person's name: a word
			longer than 1 character, in upper case -->
			<xsl:for-each-group select="node()" group-starting-with="
				tei:p
					[string-length(substring-before(., ' ')) &gt; 1]
					[upper-case(substring-before(., ' ')) = substring-before(., ' ')]
			">
				<xsl:choose>
					<xsl:when test="self::tei:p
						[string-length(substring-before(., ' ')) &gt; 1]
						[upper-case(substring-before(., ' ')) = substring-before(., ' ')]
					">
						<bibl>
							<xsl:apply-templates select="current-group()"/>
						</bibl><xsl:value-of select="codepoints-to-string(10)"/>
					</xsl:when>
					<xsl:otherwise><!-- page breaks and misc global elements -->
						<xsl:apply-templates select="current-group()"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:for-each-group>
		</xsl:copy>
	</xsl:template>
	
	<!-- a paragraph which begins a bibliographic citation just needs to be unwrapped from its para -->
	<xsl:template priority="100" match="tei:body//tei:div/tei:p
		[string-length(substring-before(., ' ')) &gt; 1]
		[upper-case(substring-before(., ' ')) = substring-before(., ' ')]">
		<xsl:apply-templates/>
	</xsl:template>
	
	<!-- a paragraph which follows on from a previous para in a bibliographic citation is a note -->
	<xsl:template match="tei:body//tei:div/tei:p[preceding-sibling::tei:p]">
		<note><xsl:apply-templates/></note>
	</xsl:template>
	
	
</xsl:stylesheet>
					
