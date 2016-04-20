<xsl:stylesheet version="2.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 	
	xmlns:tei="http://www.tei-c.org/ns/1.0" 
	xmlns="http://www.tei-c.org/ns/1.0" 
	xmlns:tite="http://www.tei-c.org/ns/tite/1.0" 
	exclude-result-prefixes="tei tite">
	
	<!-- recognises "see" cross-references, where a non-preferred term appears in a heading,
	and the content of the section is just a single paragraph referring to the preferred term, e.g.
	<hi rend="b"><hi rend="i">see</hi> ABÉLARD, Pierre</hi>
	-->
	<xsl:template match="tei:p[
		string(.) = string(tei:hi[@rend='b'][1]) and
		tei:hi[@rend='b']/tei:hi[@rend='i'] ='see'
	]">
		<!-- TODO generate @id attributes matching these @target references -->
		<xsl:copy>
			<xsl:copy-of select="@*"/>
			<xsl:element name="ref">
				<xsl:attribute name="target">
					<xsl:value-of select="
						concat(
							'#', 
							encode-for-uri(
								normalize-space(string-join(tei:hi[@rend='b']/text(), ' '))
							)
						)
					"/>
				</xsl:attribute>
				<xsl:apply-templates/>
			</xsl:element>
		</xsl:copy>
	</xsl:template>

	<xsl:template match="*">
		<xsl:copy>
			<xsl:copy-of select="@*"/>
			<xsl:apply-templates/>
		</xsl:copy>
	</xsl:template>
	
</xsl:stylesheet>
					
