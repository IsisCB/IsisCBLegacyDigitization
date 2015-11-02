<schema xmlns="http://purl.oclc.org/dsdl/schematron">
	<title>A Schematron Schema for IsisCB TEI Tite</title>
	<ns prefix="tei" uri="http://www.tei-c.org/ns/1.0"/>
	<ns prefix="tite" uri="http://www.tei-c.org/ns/tite/1.0"/>
	
	<pattern name="bibliography-content">
		<rule context="tei:body//tei:div1/* | tei:body//tei:div2/* | tei:body//tei:div3/*">
			<assert diagnostics="element-name element-content" test="
				self::tei:div2 | 
				self::tei:div3 | 
				self::tei:head | 
				self::tei:p | 
				self::tei:pb">Bibliography section should contain only div{n}, head, p and pb elements.</assert>
		</rule>
	</pattern>
	
	<pattern name="classification-schemes">
		<rule context="*[contains(tei:head, 'Classification') and not(contains(tei:head, 'Outline') or contains(tei:head, 'Extract'))]">
			<assert diagnostics="element-name element-head" test="descendant::tei:list">
				Classification scheme sections should contain a list.
			</assert>
		</rule>
	</pattern>
	
	<pattern name="classification-scheme-lists">
		<rule context="
			*[contains(tei:head, 'Classification') and not(contains(tei:head, 'Outline') or contains(tei:head, 'Extract'))]
			//tei:list
		">
			<assert diagnostics="element-name element-content" test="count(tei:item) != count(tei:label)">
				Classification lists should have an equal number of items and labels.
			</assert>
		</rule>
	</pattern>
	
	<pattern name="index">
		<rule context="tei:back//*[contains(tei:head, 'Index')]">
			<assert diagnostics="element-name element-head" test="descendant::tei:list">Index sections must contain a list of items</assert>
		</rule>
		<rule context="tei:back//*[contains(tei:head, 'Index')]//tei:list/tei:item">
			<assert diagnostics="element-name element-content" test="not(*[not(self::tite:i)])">Index items contain only plain or italicised text</assert>
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
			<assert diagnostics="element-name element-content" test="tite:i">
				Abbreviation paragraphs should contain an italicised abbreviation.
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
			<assert diagnostics="element-name element-content" test="self::tei:head | self::tei:pb | self::tei:p">
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
			]/tei:p/tite:i">
			<assert diagnostics="element-name element-content" test="
				not(preceding-sibling::text()) and
				following-sibling::text()[normalize-space()]
			">
				Abbreviation paragraphs contain an italicised abbreviation followed by a plain text expansion
			</assert>
		</rule>
	</pattern>	
	
	<diagnostics>
		<diagnostic id="element-name">Element name is <value-of select="local-name(.)"/></diagnostic>
		<diagnostic id="element-content">Element content is "<value-of select="string(.)"/>"</diagnostic>
		<diagnostic id="element-head">Element heading is "<value-of select="tei:head"/>"</diagnostic>
	</diagnostics>
</schema>
