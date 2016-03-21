<xsl:stylesheet version="2.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 	
	xmlns:tei="http://www.tei-c.org/ns/1.0" 
	xmlns="http://www.tei-c.org/ns/1.0" 
	xmlns:tite="http://www.tei-c.org/ns/tite/1.0" 
	exclude-result-prefixes="tei tite">
	<!-- promotes bold paragraphs containing initial letters A, B, C, etc to being the headings of new top-level divs -->
	
	<xsl:template match="*">
		<xsl:copy>
			<xsl:copy-of select="@*"/>
			<xsl:apply-templates/>
		</xsl:copy>
	</xsl:template>
	
	<!-- match a div containing at least one body para which is all in bold and one character long -->
	<!-- and which represents an initial letter heading ("A", "B", "C", etc) of a major section which will contain
	further subsections headed up with headings starting with this letter -->
	<xsl:template match="
		tei:body/tei:div[
			tei:p[
				string(.) = string(tei:hi[@rend='b'][1]) and
				string-length(.) = 1
			]
		]">
		<xsl:copy>
			<xsl:copy-of select="@*"/>
			<xsl:for-each-group select="node()" group-starting-with="
				tei:p[
					string(.) = string(tei:hi[@rend='b'][1]) and
					string-length(.) = 1
				]
			">
				<xsl:choose>
					<xsl:when test="
						self::tei:p[
							string(.) = string(tei:hi[@rend='b'][1]) and
							string-length(.) = 1
						]
					">
						<div type="initial-letter">
							<head><xsl:apply-templates select="tei:hi[@rend='b']/node()"/></head>
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
					
