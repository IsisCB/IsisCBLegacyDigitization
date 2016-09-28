<xsl:stylesheet version="2.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 	
	xmlns:tei="http://www.tei-c.org/ns/1.0" 
	xmlns="http://www.tei-c.org/ns/1.0" 
	xmlns:tite="http://www.tei-c.org/ns/tite/1.0" 
	exclude-result-prefixes="tei tite">
	
	<!-- recognises the presence of "extent" information (page count, volume count) in a book citation-->
	<xsl:template match="*">
		<xsl:copy>
			<xsl:copy-of select="@*"/>
			<xsl:apply-templates/>
		</xsl:copy>
	</xsl:template>
	
	<!-- book extents: number of pages of front matter and body -->
	<!-- e.g. " xxvi, 230 p.", " 100 p." -->
	<!-- also "1 pl." (one plate), "fig. " (contains figures), "front." (frontispiece) -->
	<!-- xxxi, 335 p., front., 1 pl.  -->
	<!-- 97 p., front., 17 pl. -->
	<!-- x, 359 p., 1 pl., 61 fig.  -->
	<!--  ix, 361 p., pl., portr., bibliogr. -->
	<!-- 258 pp., illus., bibl., index.  -->
	<!-- xxviii, 406 p., 12 pl., 7 maps. -->
	<!-- x + 413 pp., port., illus., index. -->
	<!-- Also journal extents:  -->
	<!-- e.g. "8 fig." -->
	<!-- div with type = articles or books is for recognising citations in the test document citation-test.xml -->
	<xsl:template match="tei:bibl[@type='journalArticle']/text() | tei:div[contains(@type, 'articles')]//tei:p/text()">
		<xsl:analyze-string select="." regex="(, (\d* )?pl\.)|(, (\d* )?fig\.)|(, (\d* )?ill\.)|(, (\d* )?portr\.)|(, (\d* )?bibliogr\.)|(, (\d* )?illus\.)|(, (\d* )?bibl\.)|(, (\d* )?maps)">
			<xsl:matching-substring>
				<xsl:if test="regex-group(1)"><!-- plates -->
					<xsl:text>, </xsl:text>
					<xsl:element name="extent">
						<xsl:element name="measure">
							<xsl:attribute name="commodity">plates</xsl:attribute>
							<xsl:if test="regex-group(2)">
								<xsl:attribute name="quantity">
									<xsl:value-of select="regex-group(2)"/><!-- just " pl. " means some unspecified number of plates? -->
								</xsl:attribute>
								<xsl:value-of select="regex-group(2)"/>
							</xsl:if>
							<xsl:text>pl.</xsl:text>
						</xsl:element>
					</xsl:element>
				</xsl:if>
				<xsl:if test="regex-group(3)"><!-- figures -->
					<xsl:text>, </xsl:text>
					<xsl:element name="extent">
						<xsl:element name="measure">
							<xsl:attribute name="commodity">figures</xsl:attribute>
							<xsl:if test="regex-group(4)">
								<xsl:attribute name="quantity">
									<xsl:value-of select="regex-group(4)"/>
								</xsl:attribute>
								<xsl:value-of select="regex-group(4)"/>
							</xsl:if>
							<xsl:text>fig.</xsl:text>
						</xsl:element>
					</xsl:element>
				</xsl:if>
				<xsl:if test="regex-group(5)"><!-- illustrations -->
					<xsl:text>, </xsl:text>
					<xsl:element name="extent">
						<xsl:element name="measure">
							<xsl:attribute name="commodity">illustrations</xsl:attribute>
							<xsl:if test="regex-group(6)">
								<xsl:attribute name="quantity">
									<xsl:value-of select="regex-group(6)"/>
								</xsl:attribute>
								<xsl:value-of select="regex-group(6)"/>
							</xsl:if>
							<xsl:text>ill.</xsl:text>
						</xsl:element>
					</xsl:element>
				</xsl:if>
				<xsl:if test="regex-group(7)"><!-- portraits -->
					<xsl:text>, </xsl:text>
					<xsl:element name="extent">
						<xsl:element name="measure">
							<xsl:attribute name="commodity">portraits</xsl:attribute>
							<xsl:if test="regex-group(8)">
								<xsl:attribute name="quantity">
									<xsl:value-of select="regex-group(8)"/>
								</xsl:attribute>
								<xsl:value-of select="regex-group(8)"/>
							</xsl:if>
							<xsl:text>portr.</xsl:text>
						</xsl:element>
					</xsl:element>
				</xsl:if>
				<xsl:if test="regex-group(9)"><!-- bibliography -->
					<xsl:text>, </xsl:text>
					<xsl:element name="extent">
						<xsl:element name="measure">
							<xsl:attribute name="commodity">bibliography</xsl:attribute>
							<xsl:if test="regex-group(10)">
								<xsl:attribute name="quantity">
									<xsl:value-of select="regex-group(10)"/>
								</xsl:attribute>
								<xsl:value-of select="regex-group(10)"/>
							</xsl:if>
							<xsl:text>bibliogr.</xsl:text>
						</xsl:element>
					</xsl:element>
				</xsl:if>
				<xsl:if test="regex-group(11)"><!-- illus. -->
					<xsl:text>, </xsl:text>
					<xsl:element name="extent">
						<xsl:element name="measure">
							<xsl:attribute name="commodity">illustrations</xsl:attribute>
							<xsl:if test="regex-group(12)">
								<xsl:attribute name="quantity">
									<xsl:value-of select="regex-group(12)"/>
								</xsl:attribute>
								<xsl:value-of select="regex-group(12)"/>
							</xsl:if>
							<xsl:text>illus.</xsl:text>
						</xsl:element>
					</xsl:element>
				</xsl:if>
				<xsl:if test="regex-group(13)"><!-- bibliography -->
					<xsl:text>, </xsl:text>
					<xsl:element name="extent">
						<xsl:element name="measure">
							<xsl:attribute name="commodity">bibliography</xsl:attribute>
							<xsl:if test="regex-group(14)">
								<xsl:attribute name="quantity">
									<xsl:value-of select="regex-group(14)"/>
								</xsl:attribute>
								<xsl:value-of select="regex-group(14)"/>
							</xsl:if>
							<xsl:text>bibl.</xsl:text>
						</xsl:element>
					</xsl:element>
				</xsl:if>
				<xsl:if test="regex-group(15)"><!-- maps -->
					<xsl:text>, </xsl:text>
					<xsl:element name="extent">
						<xsl:element name="measure">
							<xsl:attribute name="commodity">maps</xsl:attribute>
							<xsl:if test="regex-group(16)">
								<xsl:attribute name="quantity">
									<xsl:value-of select="regex-group(16)"/>
								</xsl:attribute>
								<xsl:value-of select="regex-group(16)"/>
							</xsl:if>
							<xsl:text>maps.</xsl:text>
						</xsl:element>
					</xsl:element>
				</xsl:if>
			</xsl:matching-substring>
			<xsl:non-matching-substring>
				<xsl:value-of select="."/>
			</xsl:non-matching-substring>
		</xsl:analyze-string>
	</xsl:template>
	
	<xsl:template match="tei:bibl[@type='book']/text() | tei:div[contains(@type, 'books')]//tei:p/text()">
		<xsl:analyze-string select="." regex="( ({$roman-number-regex})(,| \+))?( (\d+) pp?\.)(, front\.)?(, (\d* )?pl\.)?(, (\d* )?fig\.)?(, (\d* )?ill\.)?(, (\d* )?illus\.)?(, (\d* )?portr\.)?(, (\d* )?bibliogr\.)?(, (\d* )?bibl\.)?(, (\d* )?index\.)?">
			<xsl:matching-substring>
				<xsl:if test="regex-group(1)"><!-- roman number of prefatory pages, followed by comma or + -->
					<xsl:element name="extent">
						<xsl:element name="measure">
							<xsl:attribute name="commodity">prefatory pages</xsl:attribute>
							<xsl:attribute name="quantity">
								<xsl:call-template name="parse-roman-number">
									<xsl:with-param name="roman-number" select="regex-group(2)"/><!-- the roman number -->
								</xsl:call-template>
							</xsl:attribute>
							<xsl:value-of select="regex-group(1)"/>
						</xsl:element>
					</xsl:element>
				</xsl:if>
				<xsl:if test="regex-group(16)"><!-- arabic page number count -->
					<xsl:element name="extent">
						<xsl:element name="measure">
							<xsl:attribute name="commodity">pages</xsl:attribute>
							<xsl:attribute name="quantity">
								<xsl:value-of select="regex-group(17)"/><!-- the arabic number -->
							</xsl:attribute>
							<xsl:value-of select="regex-group(16)"/>
						</xsl:element>
					</xsl:element>
				</xsl:if>
				<xsl:if test="regex-group(18)"><!-- frontispiece -->
					<xsl:text>, </xsl:text>
					<xsl:element name="extent">
						<xsl:element name="measure">
							<xsl:attribute name="commodity">frontispiece</xsl:attribute>
							<xsl:attribute name="quantity">1</xsl:attribute>
							<xsl:text>front.</xsl:text>
						</xsl:element>
					</xsl:element>
				</xsl:if>
				<xsl:if test="regex-group(19)"><!-- plates -->
					<xsl:text>, </xsl:text>
					<xsl:element name="extent">
						<xsl:element name="measure">
							<xsl:attribute name="commodity">plates</xsl:attribute>
							<xsl:if test="regex-group(20)">
								<xsl:attribute name="quantity">
									<xsl:value-of select="regex-group(20)"/><!-- just " pl. " means some unspecified number of plates? -->
								</xsl:attribute>
								<xsl:value-of select="regex-group(20)"/>
							</xsl:if>
							<xsl:text>pl.</xsl:text>
						</xsl:element>
					</xsl:element>
				</xsl:if>
				<xsl:if test="regex-group(21)"><!-- figures -->
					<xsl:text>, </xsl:text>
					<xsl:element name="extent">
						<xsl:element name="measure">
							<xsl:attribute name="commodity">figures</xsl:attribute>
							<xsl:if test="regex-group(22)">
								<xsl:attribute name="quantity">
									<xsl:value-of select="regex-group(22)"/>
								</xsl:attribute>
								<xsl:value-of select="regex-group(22)"/>
							</xsl:if>
							<xsl:text>fig.</xsl:text>
						</xsl:element>
					</xsl:element>
				</xsl:if>
				<xsl:if test="regex-group(23)"><!-- illustrations -->
					<xsl:text>, </xsl:text>
					<xsl:element name="extent">
						<xsl:element name="measure">
							<xsl:attribute name="commodity">illustrations</xsl:attribute>
							<xsl:if test="regex-group(24)">
								<xsl:attribute name="quantity">
									<xsl:value-of select="regex-group(24)"/>
								</xsl:attribute>
								<xsl:value-of select="regex-group(24)"/>
							</xsl:if>
							<xsl:text>ill.</xsl:text>
						</xsl:element>
					</xsl:element>
				</xsl:if>
				<xsl:if test="regex-group(25)"><!-- illustrations -->
					<xsl:text>, </xsl:text>
					<xsl:element name="extent">
						<xsl:element name="measure">
							<xsl:attribute name="commodity">illustrations</xsl:attribute>
							<xsl:if test="regex-group(26)">
								<xsl:attribute name="quantity">
									<xsl:value-of select="regex-group(26)"/>
								</xsl:attribute>
								<xsl:value-of select="regex-group(26)"/>
							</xsl:if>
							<xsl:text>illus.</xsl:text>
						</xsl:element>
					</xsl:element>
				</xsl:if>
				<xsl:if test="regex-group(27)"><!-- portraits -->
					<xsl:text>, </xsl:text>
					<xsl:element name="extent">
						<xsl:element name="measure">
							<xsl:attribute name="commodity">portraits</xsl:attribute>
							<xsl:if test="regex-group(28)">
								<xsl:attribute name="quantity">
									<xsl:value-of select="regex-group(28)"/>
								</xsl:attribute>
								<xsl:value-of select="regex-group(28)"/>
							</xsl:if>
							<xsl:text>portr.</xsl:text>
						</xsl:element>
					</xsl:element>
				</xsl:if>
				<xsl:if test="regex-group(29)"><!-- bibliography -->
					<xsl:text>, </xsl:text>
					<xsl:element name="extent">
						<xsl:element name="measure">
							<xsl:attribute name="commodity">bibliography</xsl:attribute>
							<xsl:if test="regex-group(30)">
								<xsl:attribute name="quantity">
									<xsl:value-of select="regex-group(30)"/>
								</xsl:attribute>
								<xsl:value-of select="regex-group(30)"/>
							</xsl:if>
							<xsl:text>bibliogr.</xsl:text>
						</xsl:element>
					</xsl:element>
				</xsl:if>
				<xsl:if test="regex-group(31)"><!-- bibliography -->
					<xsl:text>, </xsl:text>
					<xsl:element name="extent">
						<xsl:element name="measure">
							<xsl:attribute name="commodity">bibliography</xsl:attribute>
							<xsl:if test="regex-group(32)">
								<xsl:attribute name="quantity">
									<xsl:value-of select="regex-group(32)"/>
								</xsl:attribute>
								<xsl:value-of select="regex-group(32)"/>
							</xsl:if>
							<xsl:text>bibl.</xsl:text>
						</xsl:element>
					</xsl:element>
				</xsl:if>
				<xsl:if test="regex-group(33)"><!-- index -->
					<xsl:text>, </xsl:text>
					<xsl:element name="extent">
						<xsl:element name="measure">
							<xsl:attribute name="commodity">index</xsl:attribute>
							<xsl:if test="regex-group(34)">
								<xsl:attribute name="quantity">
									<xsl:value-of select="regex-group(34)"/>
								</xsl:attribute>
								<xsl:value-of select="regex-group(34)"/>
							</xsl:if>
							<xsl:text>index.</xsl:text>
						</xsl:element>
					</xsl:element>
				</xsl:if>
			</xsl:matching-substring>
			<xsl:non-matching-substring>
				<xsl:value-of select="."/>
			</xsl:non-matching-substring>
		</xsl:analyze-string>
	</xsl:template>	
	
	<!-- recognise roman numbers from 1 to 399 (d, m, etc not supported) -->
	<xsl:variable name="roman-number-regex">(c{0,3})((xc)|(xl)|(l?)(x{0,3}))(ix)?((iv)|((v)?(i{0,3})))</xsl:variable>
	
	<xsl:template name="parse-roman-number">
		<xsl:param name="roman-number"/>
		<!-- Terminal "Z" added to avoid XSLT 2's restriction that regex should not match a zero length string -->
		<xsl:analyze-string select="concat($roman-number, 'Z')" regex="{$roman-number-regex}Z">
			<xsl:matching-substring>
				<xsl:if test="regex-group(0)">
				<xsl:variable name="c" select="regex-group(1)"/>
				<xsl:variable name="xc" select="regex-group(3)"/>
				<xsl:variable name="xl" select="regex-group(4)"/>
				<xsl:variable name="l" select="regex-group(5)"/>
				<xsl:variable name="x" select="regex-group(6)"/>
				<xsl:variable name="ix" select="regex-group(7)"/>
				<xsl:variable name="iv" select="regex-group(9)"/>
				<xsl:variable name="v" select="regex-group(11)"/>
				<xsl:variable name="i" select="regex-group(12)"/>
				<xsl:value-of select="
					100 * string-length($c) +
					(if ($xc) then 90 else 0) +
					(if ($l) then 50 else 0) +
					(if ($xl) then 40 else 0) +
					10 * string-length($x) +
					(if ($ix) then 9 else 0) +
					(if ($v) then 5 else 0) +
					(if ($iv) then 4 else 0) +
					string-length($i)
				"/>
				<!-- debugging -->
				<!--
				<xsl:value-of select="concat(
					' (',
					'c = ', $c,
					', xc = ', $xc,
					', l = ', $l,
					', xl = ', $xl,
					', x = ', $x,
					', ix= ', $ix,
					', v = ', $v,
					', iv = ', $iv,
					', i = ', $i,
					')'
				)"/>
				-->
					<!--<xsl:value-of select="concat(' (', $roman-number, ')')"/>-->
				</xsl:if>
			</xsl:matching-substring>
		</xsl:analyze-string>
	</xsl:template>
	
	<xsl:template match="roman">
		<xsl:copy>
			<xsl:for-each select="n">
				<xsl:copy>
					<xsl:attribute name="arabic">
						<xsl:call-template name="parse-roman-number"/>
					</xsl:attribute>
					<xsl:apply-templates/>
				</xsl:copy>
			</xsl:for-each>
		</xsl:copy>
	</xsl:template>
	
</xsl:stylesheet>
					
