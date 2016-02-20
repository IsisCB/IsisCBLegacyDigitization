<xsl:stylesheet version="2.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 	
	xmlns:tei="http://www.tei-c.org/ns/1.0" 
	xmlns="http://www.tei-c.org/ns/1.0" 
	exclude-result-prefixes="tei">
	
	<xsl:template match="/tei:TEI">
		<table>
			<row role="label">
				<cell>ID</cell>
				<cell>Title</cell>
				<cell>Type</cell>
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
			<xsl:for-each select="tei:text/tei:body//tei:bibl">
				<row>
					<cell n="ID"><xsl:value-of select="concat(ancestor::tei:text/@xml:id, '-', @xml:id)"/></cell>
					<cell n="Title"><xsl:value-of select="
						(
							tei:title[not(@level='j')],
							if (ancestor::tei:bibl/tei:title[not(@level='j')]) then
								concat('Review of ', ancestor::tei:bibl/tei:title[not(@level='j')])
							else
								''
						)[1]
					"/></cell>
					<cell n="Type"><xsl:value-of select="@type"/></cell>
					<cell n="Description"><xsl:value-of select="tei:note"/></cell>
					<cell n="AdditionalTitles">(not parsed)</cell>
					<cell n="Authors"><xsl:value-of select="string-join(tei:author, ', ')"/></cell>
					<cell n="Editors">(not parsed)</cell>
					<cell n="Contributors">(not parsed)</cell>
					<cell n="UnrecognizedMaterial"><xsl:value-of select="
						normalize-space(
							translate(
								string-join(text(), ' '),
								'.,:()[]',
								''
							)
						)
					"/></cell>
					<cell n="PlacePublished"><xsl:value-of select="tei:pubPlace"/></cell>
					<cell n="Publisher"><xsl:value-of select="tei:publisher"/></cell>
					<cell n="YearPublished"><xsl:value-of select="tei:date"/></cell>
					<cell n="BookSeriesTitle">(unparsed)</cell>
					<cell n="JournalTitle"><xsl:value-of select="tei:title[@level='j']"/></cell>
					<cell n="VolumeFullText"><xsl:value-of select="tei:biblScope[@unit='volume']"/></cell>
					<cell n="IssueFullText"><xsl:value-of select="tei:biblScope[@unit='issue']"/></cell>
					<xsl:variable name="page-range" select="tei:biblScope[@unit='pp'][1]"/>
					<cell n="PagesFullText"><xsl:value-of select="$page-range"/></cell>
					<xsl:variable name="dash" select="normalize-space(translate($page-range, '0123456789', ''))"/>
					<cell n="PagesBegin"><xsl:value-of select="substring-before($page-range, $dash)"/></cell>
					<cell n="PagesEnd"><xsl:value-of select="substring-after($page-range, $dash)"/></cell>
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
					<cell n="SourceBookTitle"><xsl:value-of select="ancestor::tei:bibl/tei:title[not(@level='j')]"/></cell>
					<cell n="SourceBookResponsibility"><xsl:value-of select="
						string-join(
							ancestor::tei:bibl/tei:author,
							'; '
						)
					"/></cell>
					<cell n="SourceBookPublicationDetails"><xsl:value-of select="
						string-join(
							(
								ancestor::tei:bibl/tei:pubPlace,
								ancestor::tei:bibl/tei:publisher,
								ancestor::tei:bibl/tei:date
							),
							' '
						)
					"/></cell>
					<cell n="SourceBookLink"><xsl:value-of select="
						concat(ancestor::tei:text/@xml:id, '-', ancestor::tei:bibl[1]/@xml:id)
					"/></cell>
					<cell n="ClassificationTerm"><xsl:value-of select="
						substring-before(
							concat(ancestor::tei:div[1][not(@type='party')]/tei:head[1], ' '),
							' '
						)
					"/></cell>
					<cell n="LocationInBibliography"><xsl:value-of select="	
						concat(
							'Volume ', 
							ancestor::tei:text/@xml:id, ', page ',  
							preceding::tei:pb[1]/@n, ', citation ', 
							string(1 + count(
								(preceding::tei:bibl | ancestor::tei:bibl)[. >> preceding::tei:pb[1]]
							))
						)
					"/></cell>
					<cell n="FullCitation"><xsl:value-of select="."/></cell>
				</row>
			</xsl:for-each>
		</table>
	</xsl:template>
	
     <xsl:variable name="quote" select="codepoints-to-string(34)"/> 	
     
</xsl:stylesheet>
					
