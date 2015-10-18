<?xml version="1.0" encoding="UTF-8"?>
<xsl:transform xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0" xmlns:tei="http://www.tei-c.org/ns/1.0"
xmlns="http://www.tei-c.org/ns/1.0" xmlns:tite="http://www.tei-c.org/ns/tite/1.0" exclude-result-prefixes="tei tite">

	<xsl:variable name="title-statement-content">
		<xsl:for-each select="
			//tei:docTitle/text()[normalize-space()] |
			//tei:docTitle/tei:titlePart
		">
			<title>
				<xsl:copy-of select="@type"/>
				<xsl:apply-templates select="." mode="metadata"/>
			</title>
		</xsl:for-each>
		<xsl:for-each select="//tei:docAuthor">
			<author>
				<xsl:apply-templates select="." mode="metadata"/>
			</author>
		</xsl:for-each>
	</xsl:variable>
	
	<xsl:template mode="publication-statement" match="tei:docDate">
		<date><xsl:copy-of select="@*"/><xsl:apply-templates select="." mode="metadata"/></date>
	</xsl:template>
	
	<xsl:template mode="publication-statement" match="tei:publisher | tei:pubPlace">
		<xsl:copy>
			<xsl:apply-templates select="." mode="metadata"/>
		</xsl:copy>
	</xsl:template>

	<xsl:variable name="publication-statement-content">
		<xsl:variable name="structured-publication-statement">
			<xsl:apply-templates select="//tei:docImprint/tei:publisher" mode="publication-statement"/>
			<xsl:apply-templates select="//tei:docImprint/tei:*[not(self::tei:publisher)]" mode="publication-statement"/>
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="normalize-space($structured-publication-statement)">
				<xsl:copy-of select="$structured-publication-statement"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:element name="p">
					<xsl:for-each select="//tei:docImprint">
						<xsl:apply-templates select="." mode="metadata"/>
					</xsl:for-each>
				</xsl:element>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	
	<xsl:template match="tei:lb" mode="metadata">
		<xsl:text> </xsl:text>
	</xsl:template>
	
	<xsl:template match="tei:text">
		<TEI xmlns="http://www.tei-c.org/ns/1.0">
			<teiHeader>
				<fileDesc>
					<!-- The title statement of the electronic text -->
					<titleStmt>
						<!-- ... includes the title statement of the source text ... -->
						<xsl:copy-of select="$title-statement-content"/>
						<!-- ... and credits for the digital file -->
						<respStmt>
							<resp>Transcribed and encoded in TEI Tite</resp>
							<orgName>Apex CoVantage</orgName>
						</respStmt>
						<respStmt>
							<resp>Converted from TEI Tite to TEI P5</resp>
							<persName>Conal Tuohy</persName>
						</respStmt>
					</titleStmt>
					<!-- The publication statement of the electronic text -->
					<publicationStmt>
						<publisher>The University of Oklahoma</publisher>
						<pubPlace>Norman</pubPlace>
						<date>2015</date>
					</publicationStmt>
					<sourceDesc>
						<biblFull>
							<titleStmt>
								<xsl:copy-of select="$title-statement-content"/>
							</titleStmt>
							<xsl:if test="normalize-space($publication-statement-content)">
								<publicationStmt>
									<xsl:copy-of select="$publication-statement-content"/>
								</publicationStmt>
							</xsl:if>
						</biblFull>
					</sourceDesc>
				</fileDesc>
			</teiHeader>
			<xsl:copy>
				<xsl:apply-templates select="@*"/>
				<xsl:apply-templates/>
			</xsl:copy>
		</TEI>
	</xsl:template>
	
	<xsl:template match="tei:*">
		<xsl:copy>
			<xsl:apply-templates select="@*"/>
			<xsl:apply-templates/>
		</xsl:copy>
	</xsl:template>
	
	<xsl:template match="@*">
		<xsl:copy/>
	</xsl:template>
	
	<xsl:template match="@part[.='N']"/>
	
	<xsl:template match="tei:div1 | tei:div2 | tei:div3 | tei:div4 | tei:div5 | tei:div6 | tei:div7">
		<xsl:element name="div">
			<xsl:copy-of select="@*"/>
			<xsl:apply-templates/>
		</xsl:element>
	</xsl:template>
	
	<xsl:template match="tite:i | tite:b | tite:ul | tite:smcap | tite:sub | tite:sup">
		<xsl:element name="hi">
			<xsl:attribute name="rend">
				<xsl:value-of select="local-name()"/>
			</xsl:attribute>
			<xsl:apply-templates/>
		</xsl:element>
	</xsl:template>
	
</xsl:transform>