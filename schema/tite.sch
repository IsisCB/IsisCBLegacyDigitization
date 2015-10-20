<schema xmlns="http://purl.oclc.org/dsdl/schematron">
	<title>A Schematron Schema for IsisCB TEI Tite</title>
	<ns prefix="tei" uri="http://www.tei-c.org/ns/1.0"/>
	<ns prefix="tite" uri="http://www.tei-c.org/ns/tite/1.0"/>
	
	<pattern name="bibliographies">
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
			<assert diagnostics="element-name element-content" test="not(.//tei:list[count(tei:item) != count(tei:label)])">
				Classification lists should have an equal number of items and labels.
			</assert>
		</rule>
	</pattern>
	
	<pattern name="abbreviations">
		<rule context="*[contains(tei:head, 'Abbreviations') and contains(tei:head, 'Periodicals')]/*">
			<assert diagnostics="element-name element-content" test="self::tei:head | self::tei:pb | self::tei:p">
				Abbreviations sections should contain only headings, page breaks and paragraphs.
			</assert>
		</rule>
		<rule context="*[contains(tei:head, 'Abbreviations') and contains(tei:head, 'Periodicals')]/tei:p">
			<assert diagnostics="element-name element-content" test="node()[1]/self::tite:i">
				Abbreviation paragraphs should start with an italicised abbreviation.
			</assert>
			<assert diagnostics="element-name element-content" test="node()[2]/self::text()">
				Abbreviation paragraphs should end with an un-italicised expansion.
			</assert>
		</rule>
	</pattern>	
	
	<diagnostics>
		<diagnostic id="element-name">Element name is <value-of select="local-name(.)"/></diagnostic>
		<diagnostic id="element-content">Element content is "<value-of select="string(.)"/>"</diagnostic>
		<diagnostic id="element-head">Element heading is "<value-of select="tei:head"/>"</diagnostic>
	</diagnostics>
</schema>
