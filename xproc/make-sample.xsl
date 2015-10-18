<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:key 
		name="elements-by-xpath"
		match="*[normalize-space()]"
		use="string-join(for $e in ancestor-or-self::* return name($e), '/')"/>

	<xsl:template match="/*" priority="100">
		<xsl:comment>
			This file contains a sample subset extracted from a sample XML file, in the absence of a tight schema.
			The document contains a single representative element for every element occurring with a particular chain of ancestors.
			Additionally, an @n attribute is added to every element, recording the number of times such an element occurs in that location in the source document.
			It doesn't deal very well with mixed content, but it does give a general idea.
		</xsl:comment>
		<xsl:copy>
			<xsl:copy-of select="@*"/>
			<xsl:apply-templates/>
		</xsl:copy>
	</xsl:template>
	<xsl:template match="*[normalize-space()]">
		<xsl:variable name="xpath" select="string-join(for $e in ancestor-or-self::* return name($e), '/')"/>
		<xsl:variable name="peers" select="key('elements-by-xpath', $xpath)"/>
		<xsl:if test=". is $peers[1]">
			<xsl:copy>
				<xsl:copy-of select="@*"/>
				<xsl:attribute name="n"><xsl:value-of select="count($peers)"/></xsl:attribute>
				<xsl:copy-of select="text()[normalize-space()]"/>
				<xsl:apply-templates select="$peers/*"/>
			</xsl:copy>
		</xsl:if>
	</xsl:template>
	
</xsl:stylesheet>
					
