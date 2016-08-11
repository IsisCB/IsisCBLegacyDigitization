<xsl:stylesheet version="2.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 	
	xmlns:tei="http://www.tei-c.org/ns/1.0" 
	xmlns="http://www.tei-c.org/ns/1.0" 
	exclude-result-prefixes="tei">
	
	<xsl:template match="/tei:TEI">
		<table>
			<row role="label">
				<cell>ID</cell>
				<cell>Correction</cell>
				<cell>Title</cell>
				<cell>Type</cell>
				<cell>Heading</cell>
				<cell>SeePreferredHeading</cell>
				<cell>Description</cell>
				<cell>AdditionalTitles</cell>
				<cell>Authors</cell>
				<cell>Editors</cell>
				<cell>Contributors</cell>
				<cell>UnrecognizedMaterial</cell>
				<cell>PlacePublished</cell>
				<cell>Publisher</cell>
				<cell>YearPublished</cell>
				<cell>BookSeriesTitle</cell>
				<!--<cell>JournalTitleAbbreviation</cell>-->
				<cell>JournalTitle</cell>
				<cell>VolumeFullText</cell>
				<cell>IssueFullText</cell>
				<cell>PagesFullText</cell>
				<cell>PagesBegin</cell>
				<cell>PagesEnd</cell>
				<cell>ExtentFullText</cell>
				<cell>Extent</cell>
				<cell>SourceBookTitle</cell>
				<cell>SourceBookResponsibility</cell>
				<cell>SourceBookPublicationDetails</cell>
				<cell>SourceBookLink</cell>
				<cell>ClassificationTerm</cell>
				<cell>LocationInBibliography</cell>
				<cell>FullCitation</cell>
			</row>
			<!-- for each citation or cross reference -->
			<xsl:for-each select="
				tei:text/tei:body//tei:bibl |
				tei:text/tei:body//tei:p[string(tei:ref) = normalize-space(.)]
			">
				<!-- if current bibl is a review, the source-book is the item reviewed -->
				<xsl:variable name="source-book" select="ancestor::tei:bibl[1]"/>
				<row>
					<cell n="ID"><xsl:if test="self::tei:bibl">
						<xsl:value-of select="concat(ancestor::tei:text/@xml:id, '-', @xml:id)"/>
					</xsl:if></cell>
					<cell n="Correction"><xsl:value-of select="(@subtype='correction')"/></cell>
					<cell n="Title"><xsl:if test="self::tei:bibl"><xsl:value-of select="
						(
							tei:title[not(@level='j')],
							if ($source-book/tei:title[not(@level='j')]) then
								concat('Review of ', ancestor::tei:bibl/tei:title[not(@level='j')])
							else
								''
						)[1]
					"/></xsl:if></cell>
					<cell n="Type"><xsl:value-of select="@type"/></cell>
					<cell n="Heading"><xsl:value-of select="
						string-join(
							for $div in (ancestor::tei:div) return $div/tei:head[1],
							' / '
						)
					"/></cell>
					<cell n="SeePreferredHeading"><xsl:value-of select="self::tei:p/tei:ref"/></cell>
					<cell n="Description"><xsl:apply-templates mode="plain-text" select="tei:note"/></cell>
					<cell n="AdditionalTitles">(not parsed)</cell>
					<cell n="Authors"><xsl:value-of select="string-join(tei:author, ', ')"/></cell>
					<cell n="Editors">(not parsed)</cell>
					<cell n="Contributors">(not parsed)</cell>
					<cell n="UnrecognizedMaterial"><xsl:for-each select="text()[normalize-space()]">
						<xsl:value-of select="concat('[', ., ']')"/>
					</xsl:for-each></cell>
					<cell n="PlacePublished"><xsl:value-of select="tei:pubPlace"/></cell>
					<cell n="Publisher"><xsl:value-of select="tei:publisher"/></cell>
					<cell n="YearPublished"><xsl:value-of select="tei:date"/></cell>
					<cell n="BookSeriesTitle">(unparsed)</cell>
					<!--
					<cell n="JournalTitleAbbreviation"><xsl:value-of select="tei:title[@level='j']/tei:abbr"/></cell>
					-->
					<cell n="JournalTitle"><xsl:value-of select="tei:title[@level='j']/tei:expan"/></cell>
					<cell n="VolumeFullText"><xsl:value-of select="tei:biblScope[@unit='volume']"/></cell>
					<cell n="IssueFullText"><xsl:value-of select="tei:biblScope[@unit='issue']"/></cell>
					<xsl:variable name="page-range" select="tei:biblScope[@unit='page'][1]"/>
					<cell n="PagesFullText"><xsl:value-of select="$page-range"/></cell>
					<cell n="PagesBegin"><xsl:value-of select="$page-range/@from"/></cell>
					<cell n="PagesEnd"><xsl:value-of select="$page-range/@to"/></cell>
					<cell n="ExtentFullText"><xsl:value-of select="
						normalize-space(
							string-join(
								for $m in tei:extent/tei:measure return 
									string-join(
										($m/@quantity, $m/@commodity),
										' '
									),
								', '
							)
						)
					"/></cell>
					<cell n="Extent"><xsl:value-of select="string(
						number((tei:extent/tei:measure[@commodity='prefatory pages']/@quantity, '0')[1]) +
						number((tei:extent/tei:measure[@commodity='pages']/@quantity, '0')[1])
					)"/></cell>
					<cell n="SourceBookTitle"><xsl:value-of select="$source-book/tei:title[not(@level='j')]"/></cell>
					<cell n="SourceBookResponsibility"><xsl:value-of select="
						string-join(
							$source-book/tei:author,
							'; '
						)
					"/></cell>
					<cell n="SourceBookPublicationDetails"><xsl:value-of select="
						string-join(
							(
								$source-book/tei:pubPlace,
								$source-book/tei:publisher,
								$source-book/tei:date
							),
							' '
						)
					"/></cell>
					<cell n="SourceBookLink"><xsl:if test="$source-book">
						<xsl:value-of select="concat(ancestor::tei:text/@xml:id, '-', $source-book/@xml:id)"/>
					</xsl:if></cell>
					<cell n="ClassificationTerm"><xsl:value-of select="
						substring-before(
							concat(ancestor::tei:div[1][not(@type='party')]/tei:head[1], ' '),
							' '
						)
					"/></cell>
					<cell n="LocationInBibliography"><!--<xsl:value-of select="	
						concat(
							'Volume ', 
							ancestor::tei:text/@xml:id, ', page ',  
							preceding::tei:pb[1]/@n, ', citation ', 
							string(1 + count(
								(preceding::tei:bibl | ancestor::tei:bibl)[. >> preceding::tei:pb[1]]
							))
						)
					"/>--><!-- "Just provide the page number here. We can do the rest from the ID." --><xsl:value-of select="preceding::tei:pb[1]/@n"/></cell>
					<cell n="FullCitation"><xsl:apply-templates mode="plain-text" select="."/></cell>
				</row>
			</xsl:for-each>
		</table>
	</xsl:template>
	
	<xsl:variable name="quote" select="codepoints-to-string(34)"/> 	
     
	<xsl:template match="*" mode="plain-text">
		<xsl:apply-templates/>
	</xsl:template>
	<!-- do not render expansions in FullCitation mode -->
	<xsl:template match="tei:expan" mode="plain-text"/>
     
</xsl:stylesheet>
					
