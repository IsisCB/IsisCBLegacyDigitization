# IsisCBLegacyDigitization

This repository contains TEI transcriptions of 7 volumes of the ISIS CB bibliography of science, and associated scripts and transformations for converting the transcriptions into structured bibliographic metadata.

The volumes were transcribed to TEI Tite by Apex CoVantage. The transcriptions capture basic textual features including some headings, paragraphs, lists, tables, and typographical variation (bold and italics).

The transformation pipeline, written in the XProc language, strings together a sequence of dozens of XSLT transformations to recognise semantic structures latent in the text and embed detailed TEI markup to model them explicitly, producing a TEI-encoded bibliography whose content is easily machine-readable. 

e.g.

Relatively unstructured text as input:
```xml
<p>STEPHANIDES, M. Fusikē &#8216;istoría tôn léxeōn. [The natural history of words. (In Greek)] 
<i>&#8216;Ēmerológion tês Megálēs &#8216;Elládos,</i> 1925, 4: 475–87.</p>
```

Structured bibliographic citation as output:
```xml
<bibl xml:id="p33-36" type="journalArticle">
  <author>STEPHANIDES, M. </author>
  <title>Fusikē ‘istoría tôn léxeōn. [The natural history of words. (In Greek)] </title>
  <title level="j">‘Ēmerológion tês Megálēs ‘Elládos,</title> 
  <date>1925</date>, 
  <biblScope unit="volume">4</biblScope>: 
  <biblScope unit="pp">475–87</biblScope>.
</bibl>
```

The final stage of the pipeline extracts these bibliographic records into a tabular form for import into a bibliographic database.
