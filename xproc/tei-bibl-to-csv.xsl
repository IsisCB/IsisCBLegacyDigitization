<xsl:stylesheet version="2.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 	
	xmlns:tei="http://www.tei-c.org/ns/1.0" 
	exclude-result-prefixes="tei">
	
	<xsl:template match="/tei:TEI">
		<csv><xsl:value-of separator="&#xA;" select="(
			'ID, Title, Type, Description, AdditionalTitles, Authors, Editors, Contributors, EditionDetails, PhysicalDetails, PlacePublished, Publisher, YearPublished, BookSeriesTitle, JournalTitle, VolumeFullText, IssueFullText, PagesFullText, PagesBegin, PagesEnd, ExtentFullText, Extent, ISBN',
			for $b in tei:text/tei:body//tei:bibl return string-join(
				for $column in (
					concat(
						$b/ancestor::tei:text/@xml:id, '-', 
						$b/@xml:id
					),
					(
						$b/tei:title[not(@level='j')],
						if ($b/ancestor::tei:bibl/tei:title[not(@level='j')]) then
							concat('Review of ', $b/ancestor::tei:bibl/tei:title[not(@level='j')])
						else
							''
					)[1],
					$b/@type,
					'?',
					'(not parsed)',
					(
						string-join($b/tei:author, ', '),
						''
					)[1],
					'(not parsed)',
					'(not parsed)',
					'?',
					'?',
					($b/tei:pubPlace, '')[1],
					($b/tei:publisher, '')[1],
					($b/tei:date, '')[1],
					'(not parsed)',
					($b/tei:title[@level='j'], '')[1],
					'?',
					'?',
					'?',
					substring-before(($b/tei:biblScope[@unit='pp'], '-')[1], '-'),
					substring-after(($b/tei:biblScope[@unit='pp'], '-')[1], '-'),
					(
						string-join(
							for $m in $b/tei:extent/tei:measure return 
								string-join(
									($m/@quantity, $m/@commodity),
									' '
								),
							', '
						),
						''
					)[1],
					(
						string(
							number($b/tei:text/tei:measure[@commodity='prefatory pages']/@quantity) +
							number($b/tei:text/tei:measure[@commodity='pages']/@quantity)
						),
						''
					)[1],
					'(not parsed)',
					'?',
					'?',
					'?',
					'?',
					'(not parsed)',
					concat(
						'Volume ', 
						$b/ancestor::tei:text/@xml:id, ', page ',  
						$b/preceding::tei:pb[1]/@n, ', citation ', 
						string(1 + count(
							$b/preceding::tei:bibl[. >> $b/preceding::tei:pb[1]]
						))
					),
					$b
				) return 
					concat($quote, replace($column, $quote, concat($quote, $quote)), $quote),
            		',' 
			)
		)"/></csv>
	</xsl:template>
	
     <xsl:variable name="quote" select="codepoints-to-string(34)"/> 	
     
</xsl:stylesheet>
					
