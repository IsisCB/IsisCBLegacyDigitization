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
	
	<xsl:template match="tei:body/tei:div">
		<xsl:copy>
			<xsl:copy-of select="@*"/>
			<!-- handle all the citation groups -->
			<xsl:for-each-group select="node()" group-starting-with="tei:p[tei:hi[@rend='b']]">
				<xsl:choose>
					<xsl:when test="self::tei:p/tei:hi[@rend='b']">
						<div>
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
					
