<xsl:stylesheet version="2.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 	
	xmlns:tei="http://www.tei-c.org/ns/1.0" 
	xmlns="http://www.w3.org/1999/xhtml" 
	exclude-result-prefixes="tei">
	
	<!-- visualize the div structure of a TEI document -->
	<xsl:template match="/">
		<html>
			<head>
				<style type="text/css">
					h2 {text-indent: 15px;}
					h3 {text-indent: 30px;}
					h4 {text-indent: 45px;}
					h5 {text-indent: 60px;}
					h6 {text-indent: 75px;}
				</style>
				<title>Structure of '<xsl:value-of select="tei:TEI/tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:title[@type='header']"/>'</title>
			</head>
			<body>
				<xsl:apply-templates select="tei:TEI/tei:text/tei:body/tei:div"/>
			</body>
		</html>
	</xsl:template>
	
	<xsl:template match="tei:div">
		<div>
			<xsl:apply-templates select="tei:head | tei:div"/>
		</div>
	</xsl:template>

	<xsl:template match="tei:head">
		<xsl:element name="h{count(ancestor::tei:div)}"><xsl:value-of select="."/></xsl:element>
		<xsl:apply-templates select="tei:div"/>
	</xsl:template>
	
</xsl:stylesheet>
					
