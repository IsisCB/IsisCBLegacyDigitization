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
	
	<xsl:template match="tei:body//tei:div[@type='second-level-subject']">
		<xsl:copy>
			<xsl:copy-of select="@*"/>
			<!-- handle all the second level subjects -->
			<!-- these headings are all in bold, and start with an alphabetic token whose initial letter(s) are uppercase but whose ending is in lower case, followed by a hyphen and more lower case,
			optionally followed by a space and more text-->
			<xsl:for-each-group select="node()" group-starting-with="
				tei:p[
					tei:hi[@rend='b'][string(.) = string(..)] and
					matches(., '^[A-Z]+[a-z]+-[a-z]+( .+)?$')
				]
			">
				<xsl:choose>
					<xsl:when test="self::
						tei:p[
							tei:hi[@rend='b'][string(.) = string(..)] and
							matches(., '^[A-Z]+[a-z]+-[a-z]+( .+)?$')
						]
					">
						<div type="third-level-subject">
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
					
