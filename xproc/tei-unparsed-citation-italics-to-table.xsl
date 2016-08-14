<!-- list all the uninterpreted italicised text in citations (for review) -->
<xsl:stylesheet version="2.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 	
	xmlns:tei="http://www.tei-c.org/ns/1.0" 
	xmlns="http://www.tei-c.org/ns/1.0" 
	exclude-result-prefixes="tei">
	
	<xsl:template match="/tei:TEI">
		<table>
			<row role="label">
				<cell>ID</cell>
				<cell>Unrecognized Italics</cell>
			</row>
			<!-- for each bit of italics remaining in a citation without any semantics -->
			<xsl:for-each-group group-by="." select="tei:text/tei:body//tei:bibl/tei:hi[@rend='i']">
				<!-- sort by the italicised fragment of text itself -->
				<xsl:sort select="."/>
				<row>
					<!-- corpus-wide uid for the citation -->
					<cell n="ID"><xsl:value-of select="concat(ancestor::tei:text/@xml:id, '-', parent::tei:bibl/@xml:id)"/></cell>
					<!-- the italicised text -->
					<cell n="Unrecognised Italics"><xsl:value-of select="."/></cell>
				</row>
			</xsl:for-each-group>
		</table>
	</xsl:template>
     
</xsl:stylesheet>
					
