<xsl:stylesheet version="2.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 	
	xmlns:tei="http://www.tei-c.org/ns/1.0" 
	xmlns="http://www.tei-c.org/ns/1.0" 
	xmlns:tite="http://www.tei-c.org/ns/tite/1.0" 
	exclude-result-prefixes="tei tite">
	
	<!-- split bibl elements which contain milestones into multiple bibl elements, divided by the milestones -->
	<xsl:template match="*">
		<xsl:copy>
			<xsl:copy-of select="@*"/>
			<xsl:apply-templates/>
		</xsl:copy>
	</xsl:template>
	
	<xsl:template match="tei:bibl[tei:milestone]">
		<xsl:variable name="bibl" select="."/>
		<xsl:for-each-group select="node()" group-ending-with="tei:milestone">
			<xsl:element name="bibl">
				<xsl:copy-of select="$bibl/@*"/>
				<xsl:copy-of select="current-group()[not(self::tei:milestone)]"/>
			</xsl:element>
		</xsl:for-each-group>
	</xsl:template>
	
</xsl:stylesheet>
					
