<xsl:stylesheet version="2.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:tite="http://www.tei-c.org/ns/tite/1.0"
	xmlns:tei="http://www.tei-c.org/ns/1.0"
	exclude-result-prefixes="tei">
	
	<xsl:template match="/*">
		<xsl:copy>
			<xsl:apply-templates select="@*"/>
			<xsl:apply-templates/>
		</xsl:copy>
	</xsl:template>
	
	<xsl:template match="*">
		<xsl:copy>
			<xsl:namespace name="tite" select="'http://www.tei-c.org/ns/tite/1.0'"/>
			<xsl:apply-templates select="@*"/>
			<xsl:apply-templates/>
		</xsl:copy>
	</xsl:template>

	<xsl:template match="tite:*">
		<xsl:element name="{concat('tite:', local-name())}">
			<xsl:copy-of select="@*"/>
			<xsl:apply-templates/>
		</xsl:element>
	</xsl:template>
	
	<xsl:template match="@*">
		<xsl:copy/>
	</xsl:template>
	
	<!-- remove DTD-supplied default attribute values -->
	<xsl:template match="@part[.='N']"/>
	<xsl:template match="tei:row/@role[.='data']"/>
	<xsl:template match="tei:row/@rows[.='1']"/>
	<xsl:template match="tei:row/@cols[.='1']"/>
	<xsl:template match="tei:cell/@role[.='data']"/>
	<xsl:template match="tei:cell/@rows[.='1']"/>
	<xsl:template match="tei:cell/@cols[.='1']"/>
	
</xsl:stylesheet>
					
