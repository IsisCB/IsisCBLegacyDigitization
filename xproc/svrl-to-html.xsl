<xsl:stylesheet version="2.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 	
	xmlns="http://www.w3.org/1999/xhtml"
	xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
	exclude-result-prefixes="svrl">
	
	
	<xsl:template match="/">
		<html>
			<head>
				<meta charset="UTF-8"/>
				<title>Schematron report</title>
			</head>
			<body>
				<xsl:apply-templates/>
			</body>
		</html>
	</xsl:template>
	
	<xsl:template match="svrl:schematron-output">
		<h1><xsl:value-of select="replace(svrl:active-pattern[1]/@document, '.*/', '')"/></h1>
		<table id="contents">
			<xsl:apply-templates mode="table-of-contents"/>
		</table>
		<xsl:apply-templates/>
	</xsl:template>
	

	<xsl:template match="svrl:failed-assert" mode="table-of-contents">
		<xsl:variable name="xpath">
			<xsl:call-template name="simplify-xpath">
				<xsl:with-param name="xpath" select="@location"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="id" select="concat('assert-', translate($xpath, '/[]', '-'))"/>
		<tr>
			<td>
				<a href="#{$id}"><xsl:value-of select="$xpath"/></a>
			</td>
			<td>
				<xsl:value-of select="svrl:text"/>
			</td>
		</tr>
	</xsl:template>
	
	<xsl:template match="svrl:failed-assert">
		<xsl:variable name="xpath">
			<xsl:call-template name="simplify-xpath">
				<xsl:with-param name="xpath" select="@location"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="id" select="concat('assert-', translate($xpath, '/[]', '-'))"/>
		<div id="{$id}">
			<h2><xsl:value-of select="$xpath"/></h2>
			<p><xsl:value-of select="svrl:text"/></p>
			<xsl:apply-templates select="svrl:diagnostic-reference"/>
		</div>
	</xsl:template>
	
	<xsl:template match="svrl:diagnostic-reference">
		<h3><xsl:value-of select="@diagnostic"/></h3>
		<pre><xsl:value-of select="."/></pre>
	</xsl:template>
	
	<xsl:template name="simplify-xpath">
		<xsl:param name="xpath"/>
		<xsl:variable name="pattern">\*\[local-name\(\)='([^']*)'\]</xsl:variable>
		<xsl:value-of select="replace($xpath, $pattern, '$1')"/>
	</xsl:template>
	
</xsl:stylesheet>
					
