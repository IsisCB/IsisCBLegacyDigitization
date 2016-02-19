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
		"Second-level" period headings (subjects, within a period) appear within "top-level" period sections,
		which are transcribed as <head> elements which match the pattern of
		a number, followed by a space, followed by text.
		e.g. "1 PREHISTORY AND PRIMITIVE<lb/>SOCIETIES IN GENERAL<lb/>(including Europe)"
	-->
	<xsl:template match="tei:body//tei:div[matches(tei:head[1], '^[0-9]+ .+$')]">
		<xsl:copy>
			<xsl:copy-of select="@*"/>
			<!-- handle all the second level periods (i.e. subjects within period) -->
			<!-- these headings are all in bold, and start with a number,
			optionally followed by a space, followed by 
			an alphabetic token whose letters are all uppercase, 
			followed optionally by a space and more text -->
			<xsl:for-each-group select="node()" group-starting-with="
				tei:p[
					string(.) = string(tei:hi[@rend='b']) and
					matches(., '^[0-9]+ ?[A-Z]+( .+)?$')
				]
			">
				<xsl:choose>
					<xsl:when test="self::
						tei:p[
							string(.) = string(tei:hi[@rend='b']) and
							matches(., '^[0-9]+ ?[A-Z]+( .+)?$')
						]
					">
						<div type="second-level-period">
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
					
