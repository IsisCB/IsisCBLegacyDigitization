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
			<xsl:for-each-group group-ending-with="text()[contains(., '; by ')]" select="node()">
				<xsl:element name="bibl">
					<xsl:attribute name="type">review</xsl:attribute>
					<!-- previous text is the last text node preceding this citation; from '; by ' onwards it belongs to this citation -->
					<xsl:variable name="previous-text" select="preceding-sibling::node()[1]/self::text()[contains(., '; by ')]"/>
					<xsl:if test="$previous-text">
						<xsl:value-of select="concat('by ', substring-after($previous-text, '; by '))"/>
					</xsl:if>
					<!-- include the rest of the group (except the final text node -->
					<xsl:apply-templates select="current-group()[not(self::text()[contains(., '; by ')])]"/>
					<!-- the first part of the final text node belongs here -->
					<xsl:for-each select="current-group()[self::text()[contains(., '; by ')]]">
						<xsl:value-of select="concat(substring-before(., '; by '), '; ')"/>
					</xsl:for-each>
				</xsl:element>
			</xsl:for-each-group>
			<!-- wrap the contents of the note in another bibl -->
			<!--
			<xsl:element name="bibl">
				<xsl:apply-templates/>
			</xsl:element>
			-->
		</xsl:copy>
	</xsl:template>
	
</xsl:stylesheet>
					
