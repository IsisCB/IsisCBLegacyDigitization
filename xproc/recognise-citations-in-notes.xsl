<xsl:stylesheet version="2.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 	
	xmlns:tei="http://www.tei-c.org/ns/1.0" 
	xmlns="http://www.tei-c.org/ns/1.0" 
	xmlns:tite="http://www.tei-c.org/ns/tite/1.0" 
	exclude-result-prefixes="tei tite">
	
	<!-- recognises the presence of another citation within a bibl's note -->
	<xsl:template match="*">
		<xsl:copy>
			<xsl:copy-of select="@*"/>
			<xsl:apply-templates/>
		</xsl:copy>
	</xsl:template>
	
	<!-- match notes which appear to contain a review -->
	<!-- e.g. "Reviewed by P.J. Richard ..." or "French edition: Le problème Martien (Paris: Elzévir, 1946) reviewed by..."-->
	<xsl:template match="tei:bibl/tei:note[contains(., 'eviewed by')]">
		<xsl:copy>
			<xsl:copy-of select="@*"/>
			<!-- wrap the contents of the note in another bibl -->
			<xsl:element name="bibl">
				<xsl:apply-templates/>
			</xsl:element>
		</xsl:copy>
	</xsl:template>
	
</xsl:stylesheet>
					
