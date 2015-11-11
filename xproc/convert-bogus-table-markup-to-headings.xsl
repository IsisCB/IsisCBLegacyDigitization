<xsl:stylesheet version="2.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:tite="http://www.tei-c.org/ns/tite/1.0"
	xmlns:tei="http://www.tei-c.org/ns/1.0"
	exclude-result-prefixes="tei">
	
	<!-- converts bogus table markup in ISIS-07.xml into bold paragraphs -->
	
	<xsl:template match="*">
		<xsl:copy>
			<xsl:copy-of select="@*"/>
			<xsl:apply-templates/>
		</xsl:copy>
	</xsl:template>
	
	<!-- the tei:body contains the bibliographic citations -->
	<!-- these two-column tables in ISIS-07.xml (only!) are bogus, and should be encoded as paragraphs containing bold text for consistency with the rest of the text -->
	<xsl:template match="tei:body//tei:table">
		<xsl:for-each select="tei:row">
			<xsl:element name="p" namespace="http://www.tei-c.org/ns/1.0">
				<xsl:element name="tite:b">
					<xsl:copy-of select="tei:cell[1]/node()"/>
					<xsl:if test="normalize-space(tei:cell[1]) and normalize-space(tei:cell[2])">
						<xsl:text>  </xsl:text>
					</xsl:if>
					<xsl:copy-of select="tei:cell[2]/node()"/>
				</xsl:element>
			</xsl:element>
			<xsl:text>&#xA;</xsl:text>
		</xsl:for-each>
	</xsl:template>
	
</xsl:stylesheet>
					
