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
	
	<xsl:template match="tei:body//tei:div[@type='second-level-period']">
		<xsl:copy>
			<xsl:copy-of select="@*"/>
			<!-- handle all the third level periods -->
			<!-- these headings are all in bold, and start with a number, 
			followed by a token whose initial letter(s) are uppercase but whose ending is in lower case, 
			optionally followed by a space and more text-->
			<xsl:for-each-group select="node()" group-starting-with="
				tei:p[
					string(tei:hi[@rend='b']) = string(.) and
					matches(., '^[0-9]+( )?[A-Z]+[a-z]+( .+)?$')
				]
			">
				<xsl:choose>
					<xsl:when test="self::
						tei:p[
							string(tei:hi[@rend='b']) = string(.) and
							matches(., '^[0-9]+( )?[A-Z]+[a-z]+( .+)?$')
						]
					">
						<div type="third-level-period">
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
					
