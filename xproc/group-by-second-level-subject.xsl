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
	
	<!-- 
		"Second-level" subject headings appear within "top-level" subject sections,
		which are either explicitly tagged as such by a previous step in the pipeline,
		or (if they were transcribed as <head> elements) which match the pattern of
		a top-level subject heading: an upper-case alphabetic token, followed by a space,
		followed by text which does not include lower case characters.
		e.g. "A SCIENCE", "AC NATURAL MAGIC; PSEUDO-SCIENCES"
	-->
	<xsl:template match="tei:body//tei:div
		[
			@type='top-level-subject' or
			matches(tei:head[1], '^[A-Z]+ [^a-z]+$')
		]">
		<xsl:copy>
			<xsl:copy-of select="@*"/>
			<!-- handle all the second level subjects -->
			<!-- these headings are all in bold, and start with an alphabetic token whose initial letter(s) are uppercase but whose ending is in lower case -->
			<xsl:for-each-group select="node()" group-starting-with="
				tei:p[
					string(.) = string(tei:hi[@rend='b']) and
					matches(., '^[A-Z]+[a-z]+ .+$')
				]
			">
				<xsl:choose>
					<xsl:when test="self::
						tei:p[
							string(.) = string(tei:hi[@rend='b']) and
							matches(., '^[A-Z]+[a-z]+ .+$')
						]
					">
						<div type="second-level-subject">
							<head><xsl:apply-templates/></head>
							<xsl:apply-templates select="current-group()[position() &gt; 1]"/>
						</div>
					</xsl:when>
					<xsl:otherwise>
						<xsl:apply-templates select="current-group()"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:for-each-group>
		</xsl:copy>
	</xsl:template>
	
	
</xsl:stylesheet>
					
