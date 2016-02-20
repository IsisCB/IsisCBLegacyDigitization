<xsl:stylesheet version="2.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 	
	xmlns:tei="http://www.tei-c.org/ns/1.0" 
	xmlns="http://www.tei-c.org/ns/1.0" 
	xmlns:tite="http://www.tei-c.org/ns/tite/1.0" 
	exclude-result-prefixes="tei tite">
	
	<!-- assigns a unique id to each citation -->
	<xsl:template match="*">
		<xsl:copy>
			<xsl:copy-of select="@*"/>
			<xsl:apply-templates/>
		</xsl:copy>
	</xsl:template>
	
	<xsl:template match="tei:text//tei:bibl">
		<xsl:copy>
			<xsl:copy-of select="@*"/>
			<xsl:attribute name="xml:id">
				<xsl:variable name="page" select="preceding::tei:pb[1]"/>
				<xsl:value-of select="
					concat(
						'p',
						$page/@n, '-', 
						string(1 + count(
							(preceding::tei:bibl | ancestor::tei:bibl)[. >> $page]
						))
					)
				"/>
			</xsl:attribute>
			<xsl:apply-templates/>
		</xsl:copy>
	</xsl:template>
	
</xsl:stylesheet>
					
