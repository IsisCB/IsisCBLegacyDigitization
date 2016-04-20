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
	
	<!-- assign id to top-level bibls (not contained in another bibl) -->
	<xsl:template match="tei:text//tei:bibl[not(ancestor::tei:bibl)]">
		<xsl:copy>
			<xsl:copy-of select="@*"/>
			<xsl:attribute name="xml:id">
				<xsl:variable name="page" select="preceding::tei:pb[1]"/>
				<!-- compute the position of this top-level bibl in the sequence of top-level bibls on this page -->
				<xsl:variable name="top-level-bibl-count" select="
					string(
						1 + count(
							(preceding::tei:bibl[ not(ancestor::tei:bibl)] ) [. >> $page]
						)
					)
				"/>
				<xsl:value-of select="
					concat(
						'p',
						$page/@n, '-', 
						$top-level-bibl-count
					)
				"/>
			</xsl:attribute>
			<xsl:apply-templates/>
		</xsl:copy>
	</xsl:template>
	
	<xsl:template match="tei:text//tei:bibl//tei:bibl">
		<xsl:copy>
			<xsl:copy-of select="@*"/>
			<xsl:attribute name="xml:id">
				<xsl:variable name="page" select="preceding::tei:pb[1]"/>
				<xsl:variable name="top-level-bibl" select="ancestor::tei:bibl[1]"/>
				<!-- compute the position of this top-level bibl in the sequence of top-level bibls on this page -->
				<xsl:variable name="top-level-bibl-count" select="
					string(
						1 + count(
							($top-level-bibl/preceding::tei:bibl[ not(.//tei:bibl)] ) [. >> $page]
						)
					)
				"/>
				<!-- compute the position of this second-level bibl in the sequence of descendants of the same top-level bibl -->
				<xsl:variable name="second-level-bibl-count" select="
					format-number(
						1 + count(preceding::tei:bibl [. >> $top-level-bibl]),
						'00'
					)
				"/>
				<xsl:value-of select="
					concat(
						'p',
						$page/@n, '-', 
						$top-level-bibl-count,
						'.',
						$second-level-bibl-count
					)
				"/>
			</xsl:attribute>
			<xsl:apply-templates/>
		</xsl:copy>
	</xsl:template>
	
</xsl:stylesheet>
					
