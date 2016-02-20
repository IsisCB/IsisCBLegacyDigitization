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
	
	<!-- citations inside "initial-letter" divs are all parties (people and institutions) -->
	<xsl:template match="tei:body//tei:div[not(@type='initial-letter')]">
		<xsl:copy>
			<xsl:copy-of select="@*"/>
			<!-- handle all the top level subjects -->
			<!-- these headings are all in bold -->
			<!-- they start with an all uppercase word, and contain no lower case letters -->
			<xsl:for-each-group select="node()" group-starting-with="
				tei:p[
					tei:hi[@rend='b'][string(.) = string(..)] and
					matches(., '^[A-Z]+ [^a-z]+$')
				]
			">
				<xsl:choose>
					<xsl:when test="self::
						tei:p[
							tei:hi[@rend='b'][string(.) = string(..)] and
							matches(., '^[A-Z]+ [^a-z]+$')
						]
					">
						<div type="top-level-subject">
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
					
