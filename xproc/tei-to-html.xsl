<xsl:stylesheet version="2.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 	
	xmlns:tei="http://www.tei-c.org/ns/1.0" 
	xmlns="http://www.w3.org/1999/xhtml"
	exclude-result-prefixes="tei">
	
	<xsl:template match="tei:TEI">
		<html>
			<xsl:apply-templates/>
		</html>
	</xsl:template>
	
	<xsl:template match="tei:teiHeader">
		<head>
			<title><xsl:value-of select="tei:fileDesc/tei:titleStmt/tei:title[@type='volume']"/></title>
			<link rel="stylesheet" type="text/css" href="proofing.css"/>
			 <meta http-equiv="Content-Type" content="text/html;charset=UTF-8"/> 
		</head>
	</xsl:template>
	
	<xsl:template match="tei:text">
		<body>
			<xsl:call-template name="statistics"/>
			<xsl:apply-templates/>
		</body>
	</xsl:template>
	
	<!-- tables -->
	<xsl:template match="tei:table"><table><xsl:apply-templates/></table></xsl:template>
	
	<xsl:template match="tei:row"><tr><xsl:apply-templates/></tr></xsl:template>
	
	<xsl:template match="tei:cell"><td><xsl:apply-templates/></td></xsl:template>
	
	
	<!-- notes -->
	<xsl:template match="tei:note" priority="100">
		<div class="{local-name()}"><xsl:call-template name="attributes-as-title"/><xsl:if test="@n">
			<xsl:value-of select="concat(@n, ' ')"/>
		</xsl:if><xsl:apply-templates/></div>
	</xsl:template>
	
	<xsl:template match=" tei:bibl" priority="100">
		<div class="{local-name()}">
			<xsl:call-template name="attributes-as-title"/>
			<xsl:for-each select="@xml:id">
				<xsl:attribute name="id"><xsl:copy-of select="."/></xsl:attribute>
				<a class="permalink" href="#{.}" title="{.}">¶</a>
			</xsl:for-each>
			<span class="bibl-type">[<xsl:value-of select="@type"/>]</span>
			<xsl:apply-templates/>
		</div>
	</xsl:template>

	<!-- paragraphs and similar -->
	<xsl:template match="tei:p | tei:docTitle | tei:docAuthor | tei:docImprint">
		<p class="{local-name()}"><xsl:call-template name="attributes-as-title"/><xsl:apply-templates/></p>
	</xsl:template>
	
	<!-- divs -->
	<xsl:template match="tei:div | tei:front | tei:body | tei:back | tei:titlePage">
		<div class="{local-name()}">
			<xsl:call-template name="attributes-as-title"/><xsl:apply-templates/>
		</div>
	</xsl:template>
	
	<!-- page breaks -->
	<xsl:template match="tei:pb">
		<xsl:variable name="label" select="if (@n) then @n else 'page break'"/>
		<xsl:choose>
			<xsl:when test="@facs">
				<a class="pb" href="images/{@facs}">[<xsl:value-of select="$label"/>]</a>
			</xsl:when>
			<xsl:otherwise>
				<span class="pb">[<xsl:value-of select="$label"/>]</span>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="tei:lb"><br/></xsl:template>
	
	<!-- headings -->
	<xsl:template match="tei:head">
		<xsl:variable name="level" select="count(ancestor-or-self::tei:div)"/>
		<xsl:element name="h{$level}"><xsl:call-template name="attributes-as-title"/><xsl:apply-templates/></xsl:element>
	</xsl:template>
	
	<!-- semantic phrase-level elements within citations, etc -->
	<xsl:template match="tei:bibl//* | tei:titlePart"><span class="{local-name()}"><xsl:call-template name="attributes-as-title"/><xsl:apply-templates/></span></xsl:template>
	
	<!-- semantic elements with html equivalents -->
	<xsl:template match="tei:title"><cite><xsl:call-template name="attributes-as-title"/><xsl:apply-templates/></cite></xsl:template>
	
	<!-- highlighting -->
	<xsl:template match="tei:hi[@rend='sup']" priority="100"><sup><xsl:apply-templates/></sup></xsl:template>
	<xsl:template match="tei:hi[@rend='sub']" priority="100"><sub><xsl:apply-templates/></sub></xsl:template>
	<xsl:template match="tei:hi" priority="50"><span class="{@rend}"><xsl:apply-templates/></span></xsl:template>
	
	<!-- abbreviations and expansions -->
	<xsl:template match="tei:abbr" priority="100">
		<xsl:element name="abbr">
			<xsl:for-each select="following-sibling::*[1]/self::tei:expan">
				<xsl:attribute name="title"><xsl:value-of select="."/></xsl:attribute>
			</xsl:for-each>
			<xsl:apply-templates/>
		</xsl:element>
	</xsl:template>
	<xsl:template match="tei:expan" priority="100">
		<xsl:if test="not(preceding-sibling::*[1]/self::tei:abbr)">
			<span><xsl:call-template name="attributes-as-title"/><xsl:apply-templates/></span>
		</xsl:if>
	</xsl:template>
	
	<!-- lists -->
	<xsl:template match="tei:list[tei:label]">
		<table>
			<xsl:for-each-group select="*" group-starting-with="tei:label">
				<tr>
					<td><xsl:call-template name="attributes-as-title"/><xsl:apply-templates/></td>
					<td><xsl:apply-templates select="current-group() except ."/></td>
				</tr>
			</xsl:for-each-group>
		</table>
	</xsl:template>
	<xsl:template match="tei:list">
		<ul>
			<xsl:call-template name="attributes-as-title"/>
			<xsl:for-each-group select="*" group-starting-with="tei:item">
				<li><xsl:apply-templates/><xsl:apply-templates select="current-group() except ."/></li>
			</xsl:for-each-group>
		</ul>
	</xsl:template>	
	<xsl:template match="tei:label | tei:item">
		<span class="{local-name()}"><xsl:call-template name="render-indents"/><xsl:call-template name="attributes-as-title"/><xsl:apply-templates/></span> 
	</xsl:template>
	<xsl:template name="render-indents">
		<xsl:if test="@rend">
			<xsl:analyze-string select="@rend" regex="indent\((\d)\)">
				<xsl:matching-substring>
					<xsl:attribute name="style">padding-left: <xsl:value-of select="concat(number(regex-group(1)) * 8, 'em')"/></xsl:attribute>
				</xsl:matching-substring>
			</xsl:analyze-string>
		</xsl:if>
	</xsl:template>

	
	
	<xsl:template name="attributes-as-title">
		<xsl:variable name="quote" select="codepoints-to-string(34)"/>
		<xsl:attribute name="title"><!-- &#xA; -->
			<xsl:value-of select="
				concat(
					'&lt;', 
					string-join(
						(
							local-name(), 
							for $a in (@*) return concat(local-name($a), '=', $quote, $a, $quote)
						),
						' '
					),
					'&gt;'
				)
			"/>
		</xsl:attribute>
	</xsl:template>
	
	<xsl:template name="statistics">
		<div class="statistics">
			<h1>Statistics</h1>
			<table>
				<tr>
					<th rowspan="2">Citation Type</th>
					<th rowspan="2">Number</th>
					<th colspan="4">Characters</th>
				</tr>
				<tr>
					<th>Total</th>
					<th>Parsed</th>
					<th>Unparsed</th>
					<th>% Parsed</th>
				</tr>
				<xsl:for-each-group select="//tei:bibl" group-by="@type">
					<xsl:call-template name="statistics-row">
						<xsl:with-param name="type" select="@type"/>
						<xsl:with-param name="bibl-list" select="current-group()"/>
					</xsl:call-template>
				</xsl:for-each-group>
				<xsl:call-template name="statistics-row">
					<xsl:with-param name="type" select=" 'total' "/>
					<xsl:with-param name="bibl-list" select="//tei:bibl"/>
				</xsl:call-template>
			</table>
		</div>
	</xsl:template>
	
	<xsl:template name="statistics-row">
		<xsl:param name="bibl-list"/>
		<xsl:param name="type"/>
		<xsl:variable name="content" select="$bibl-list/node()"/>
		<xsl:variable name="parsed-content" select="$content[not(self::tei:note)]"/>
		<xsl:variable name="unparsed-content" select="$content[self::text()] | $content[self::tei:hi]"/>
		<xsl:variable name="content-length" select="sum(for $c in $content return string-length($c))"/>
		<xsl:variable name="parsed-content-length" select="sum(for $p in $parsed-content return string-length($p))"/>
		<xsl:variable name="unparsed-content-length" select="sum(for $u in $unparsed-content return string-length($u))"/>
		<tr>
			<td class="text"><xsl:value-of select="$type"/></td>
			<td><xsl:value-of select="count($bibl-list)"/></td>
			<td><xsl:value-of select="$content-length"/></td>
			<td><xsl:value-of select="$parsed-content-length"/></td>
			<td><xsl:value-of select="$unparsed-content-length"/></td>
			<td><xsl:value-of select="format-number(1 - ($unparsed-content-length div $content-length), '#%')" /></td>
		</tr>		
	</xsl:template>
	
</xsl:stylesheet>
					
