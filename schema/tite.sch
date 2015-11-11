<schema xmlns="http://purl.oclc.org/dsdl/schematron">
	<title>A Schematron Schema for IsisCB TEI Tite</title>
	<ns prefix="tei" uri="http://www.tei-c.org/ns/1.0"/>
	<ns prefix="tite" uri="http://www.tei-c.org/ns/tite/1.0"/>
	
	<pattern name="bibliography-content">
		<rule context="tei:body//tei:div1/* | tei:body//tei:div2/* | tei:body//tei:div3/*">
			<assert diagnostics="element-name element-content page-number facsimile-uri" test="
				self::tei:div2 | 
				self::tei:div3 | 
				self::tei:head | 
				self::tei:p | 
				self::tei:pb">Bibliography section should contain only div{n}, head, p and pb elements.</assert>
		</rule>
	</pattern>
	
	<pattern name="classification-schemes">
		<rule context="*[contains(tei:head, 'Classification') and not(contains(tei:head, 'Outline') or contains(tei:head, 'Extract'))]">
			<assert diagnostics="element-name element-head page-number facsimile-uri" test="descendant::tei:list">
				Classification scheme sections should contain a list.
			</assert>
		</rule>
	</pattern>
	
	<pattern name="classification-scheme-lists">
		<rule context="
			*[contains(tei:head, 'Classification') and not(contains(tei:head, 'Outline') or contains(tei:head, 'Extract'))]
			//tei:list
		">
			<assert diagnostics="element-name element-content page-number facsimile-uri" test="count(tei:item) = count(tei:label)">
				Classification lists should have an equal number of items and labels.
			</assert>
		</rule>
	</pattern>
	
	<pattern name="index">
		<rule context="tei:back//*[contains(tei:head, 'Index')]">
			<assert diagnostics="element-name element-head page-number facsimile-uri" test="descendant::tei:list">Index sections must contain a list of items</assert>
		</rule>
		<rule context="tei:back//*[contains(tei:head, 'Index')]//tei:list/tei:item">
			<assert diagnostics="element-name element-content page-number facsimile-uri" test="not(*[not(self::tite:i)])">Index items contain only plain or italicised text</assert>
		</rule>
	</pattern>
	
	<pattern name="abbreviations">
		<rule context="
			tei:front/tei:div1[
				contains(tei:head, 'Abbreviations') and 
				(
					contains(tei:head, 'Periodicals') or
					contains(tei:head, 'Journals') or
					contains(tei:head, 'Serials') 
				)
			]/tei:p">
			<assert diagnostics="element-name element-content page-number facsimile-uri" 
				test="
					tite:i or 
					(
						string-length(.) = 1 and 
						not(
							preceding-sibling::tei:p
								[string-length(.)=1]
								[1]
								[string-to-codepoints(.) != string-to-codepoints(current()) - 1]
						)
					)">
				Abbreviation paragraphs should contain either an italicised abbreviation, or a single letter ('A', 'B', etc) heading in sequence.
			</assert>
		</rule>
		<rule context="
			tei:front/tei:div1[
				contains(tei:head, 'Abbreviations') and 
				(
					contains(tei:head, 'Periodicals') or
					contains(tei:head, 'Journals') or
					contains(tei:head, 'Serials') 
				)
			]/*">
			<assert diagnostics="element-name element-content page-number facsimile-uri" test="self::tei:head | self::tei:pb | self::tei:p">
				Abbreviations sections should contain only headings, page breaks and paragraphs.
			</assert>
		</rule>
		
		<rule context="
			tei:front/tei:div1[
				contains(tei:head, 'Abbreviations') and 
				(
					contains(tei:head, 'Periodicals') or
					contains(tei:head, 'Journals') or
					contains(tei:head, 'Serials') 
				)
			]/tei:p/tite:i[1]">
			<assert diagnostics="element-name element-content page-number facsimile-uri" test="
				not(preceding-sibling::text()) and
				following-sibling::text()[normalize-space()]
			">
				In an abbreviation paragraph, an italicised abbreviation should precede the plain text expansion
			</assert>
		</rule>
	</pattern>	
	
	<diagnostics>
		<diagnostic id="element-name">&lt;<value-of select="local-name(.)"/>&gt;</diagnostic>
		<diagnostic id="element-content"><value-of select="string(.)"/></diagnostic>
		<diagnostic id="element-head"><value-of select="tei:head"/></diagnostic>
		 <diagnostic id="page-number"><value-of select="preceding::tei:pb[1]/@n"/></diagnostic>
		 <diagnostic id="facsimile-uri"><value-of select="preceding::tei:pb[1]/@facs"/></diagnostic>
	</diagnostics>
</schema>
