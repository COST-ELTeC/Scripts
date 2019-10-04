<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xpath-default-namespace="http://www.tei-c.org/ns/1.0"
    xmlns:e="http://distantreading.net/eltec/ns" exclude-result-prefixes="xs e"
    version="2.0">
    <xsl:param name="publish">10.5281/zenodo.3462435</xsl:param>
    <!-- iff true, update publicationStmt -->
    <xsl:param name="verbose"/>
    <!-- iff true, witter on -->
    <xsl:variable name="today">
        <xsl:value-of
            select="format-date(current-date(), '[Y0001]-[M01]-[D01]')"/>
    </xsl:variable>
    <xsl:variable name="textId">
        <xsl:value-of select="TEI/@xml:id"/>
    </xsl:variable>
    <xsl:variable name="textLang">
        <xsl:value-of select="TEI/@xml:lang"/>
    </xsl:variable>
    <xsl:variable name="editionWord">
        <xsl:choose>
            <xsl:when test="$textLang eq 'cs'">vydání ELTeC</xsl:when>
            <xsl:when test="$textLang eq 'de'">ELTeC ausgabe</xsl:when>
            <xsl:when test="$textLang eq 'en'">ELTeC edition</xsl:when>
            <xsl:when test="$textLang eq 'fr'">édition ELTeC</xsl:when>
            <xsl:when test="$textLang eq 'hu'">ELTeC kiadás</xsl:when>
            <xsl:when test="$textLang eq 'it'">edizione ELTeC</xsl:when>
            <xsl:when test="$textLang eq 'lv'">ELTeC izdevums</xsl:when>
            <xsl:when test="$textLang eq 'no'">ELTeC-utgave</xsl:when>
            <xsl:when test="$textLang eq 'po'">edycja ELTeC</xsl:when>
            <xsl:when test="$textLang eq 'pt'">edição para o ELTeC</xsl:when>
            <xsl:when test="$textLang eq 'ro'">ediție ELTeC</xsl:when>
            <xsl:when test="$textLang eq 'sl'">Izdaja ELTeC</xsl:when>
            <xsl:when test="$textLang eq 'sp'">edición ELTeC</xsl:when>
            <xsl:when test="$textLang eq 'sr'">ELTeC издање</xsl:when>
            <xsl:otherwise>ELTeC edition</xsl:otherwise>
        </xsl:choose>
    </xsl:variable>
    <!--   <xsl:variable name="respWord">
        <xsl:choose>
            <xsl:when test="$textLang eq 'cs'">vydání ELTeC</xsl:when>
            <xsl:when test="$textLang eq 'de'">ELTeC ausgabe</xsl:when>
            <xsl:when test="$textLang eq 'en'">ELTeC encoding</xsl:when>    
            <xsl:when test="$textLang eq 'fr'">édition ELTeC</xsl:when>
            <xsl:when test="$textLang eq 'hu'">ELTeC kiadás</xsl:when>
            <xsl:when test="$textLang eq 'it'">edizione ELTeC</xsl:when>
            <xsl:when test="$textLang eq 'lv'">ELTeC izdevums</xsl:when>
            <xsl:when test="$textLang eq 'no'">ELTeC-utgave</xsl:when>
            <xsl:when test="$textLang eq 'po'">edycja ELTeC</xsl:when>
            <xsl:when test="$textLang eq 'pt'">codificação segundo as normas do ELTeC</xsl:when>
            <xsl:when test="$textLang eq 'ro'">ediție ELTeC</xsl:when>
            <xsl:when test="$textLang eq 'sl'">Izdaja ELTeC</xsl:when>
            <xsl:when test="$textLang eq 'sp'">edición ELTeC</xsl:when>
            <xsl:when test="$textLang eq 'sr'">ELTeC издање</xsl:when>
            <xsl:otherwise>ELTeC edition</xsl:otherwise>
        </xsl:choose></xsl:variable>  
-->
    <!-- Script to tidy up headers
        - check titleSmt/title and titleStmt author and warn if they are unconformant
        - check sourceDesc/bibl/@type for valid values and change if necessary
            - change null value to "unspecified"
        - remove relatedItem tag
        - if titleStmt/author has a VIAF idno, move it to an attribute value
        - correct invalid pointer value # to #unspecified 
        - change canonicity@key medium to unspecified
        - add a change element to revisionDesc
        - check that name is correctly used in header
        - change key=medium to key=unspecified on canonicity
        - add publicationStmt with zenodo key
        
-->
    <!-- IdentityTransform -->
    <xsl:template match="/ | @* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="TEI">
        <xsl:message>
            <xsl:value-of select="teiHeader/fileDesc/titleStmt/title[1]"/>
        </xsl:message>
        <xsl:if test="not(matches($textId, '[A-Z]+[0-9]+'))">
            <xsl:message>Weird xml_id : <xsl:value-of select="$textId"
                /></xsl:message>
        </xsl:if>
        <xsl:copy>
            <xsl:apply-templates select="@*"/>
            <xsl:apply-templates/>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="titleStmt/title[1]">
        <xsl:copy>
            <xsl:apply-templates select="@*"/>
            <xsl:apply-templates/>
            <xsl:if test="not(contains(., 'ELTeC'))">
                <xsl:text> : </xsl:text>
                <xsl:value-of select="$editionWord"/>
            </xsl:if>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="titleStmt/author">
        <xsl:variable select="normalize-space(.)" name="theString"/>
        <xsl:variable select="substring-before($theString, '(')"
            name="theAuthor"/>
        <xsl:variable
            select="substring-before(substring-after($theString, '('), ')')"
            name="theDates"/>
        <xsl:choose>
            <xsl:when test="string-length($theAuthor) &lt; 1">
                <xsl:message>*<xsl:value-of select="$theString"/>
<xsl:text>* has no dates!</xsl:text></xsl:message>
            </xsl:when>
            <xsl:otherwise>
                <xsl:if test="not(matches($theAuthor, '\[?[\p{L} \-]+,'))">
                    <xsl:message>*<xsl:value-of select="$theAuthor"/>
<xsl:text>* strange author: no comma?</xsl:text></xsl:message>
                </xsl:if>
                <xsl:if
                    test="not(matches($theDates, '(1[789]\d\d)|\?\s*\-\s*(1[89]\d\d)|\?'))">
                    <xsl:message>*<xsl:value-of select="$theString"/>
                        <xsl:text>implausible author dates (</xsl:text><xsl:value-of
                            select="$theDates"/>)! </xsl:message>
                </xsl:if>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:choose>
            <xsl:when test="idno[@type = 'viaf']">
                <xsl:element name="author" xmlns="http://www.tei-c.org/ns/1.0">
                    <xsl:attribute name="ref">
                        <xsl:value-of
                            select="concat('viaf:', idno[@type = 'viaf'])"/>
                    </xsl:attribute>
                    <xsl:value-of
                        select="concat($theAuthor, ' (', $theDates, ')')"/>
                </xsl:element>
            </xsl:when>
            <xsl:otherwise>
                <xsl:copy>
                    <xsl:apply-templates select="@*"/>
                    <xsl:apply-templates/>
                </xsl:copy>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="titleStmt/author/idno"/>
    <!-- deal with sourceDesc -->
    <xsl:template match="sourceDesc">
        <xsl:copy>
            <xsl:apply-templates select="bibl"/>
            <xsl:apply-templates select="bibl/relatedItem/bibl"/>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="bibl/relatedItem"/>
    <xsl:template match="relatedItem">
        <xsl:if test="$verbose">
            <xsl:message>relatedItem tag suppressed</xsl:message>
        </xsl:if>
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="bibl[not(@type) and ancestor::sourceDesc]">
        <xsl:if test="$verbose">
            <xsl:message>Untyped bibl : changed to 'unspecified'</xsl:message>
        </xsl:if>
        <xsl:copy>
            <xsl:attribute name="type">
                <xsl:choose>
                    <xsl:when
                        test="parent::relatedItem[@type = 'sourceEdition']">
                        <xsl:text>firstEdition</xsl:text>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:text>unspecified</xsl:text>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:attribute>
            <xsl:apply-templates/>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="div//bibl">
        <xsl:message>Misplaced bibl changed to label</xsl:message>
        <label xmlns="http://www.tei-c.org/ns/1.0">
            <xsl:apply-templates/>
        </label>
    </xsl:template>
    <xsl:template match="bibl/@type">
        <xsl:attribute name="type">
            <xsl:choose>
                <xsl:when test=". eq 'copyText'">
                    <xsl:if test="$verbose">
                        <xsl:message>Wrongly typed bibl : changed 'copyText' to
                            'printSource'</xsl:message>
                    </xsl:if>
                    <xsl:text>printSource</xsl:text>
                </xsl:when>
                <xsl:when test=". eq 'encodedFrom'">
                    <xsl:if test="$verbose">
                        <xsl:message>Wrongly typed bibl : changed 'encodedFrom'
                            to 'digitalSource'</xsl:message>
                    </xsl:if>
                    <xsl:text>digitalSource</xsl:text>
                </xsl:when>
                <xsl:when test=". eq 'source'">
                    <xsl:if test="$verbose">
                        <xsl:message>Wrongly typed bibl : changed 'source' to
                            'digitalSource'</xsl:message>
                    </xsl:if>
                    <xsl:text>digitalSource</xsl:text>
                </xsl:when>
                <xsl:when test=". eq 'digital-source'">
                    <xsl:if test="$verbose">
                        <xsl:message>Wrongly typed bibl : changed
                            'digital-source' to 'digitalSource'</xsl:message>
                    </xsl:if>
                    <xsl:text>digitalSource</xsl:text>
                </xsl:when>
                <xsl:when test=". eq 'print-source'">
                    <xsl:if test="$verbose">
                        <xsl:message>Wrongly typed bibl : changed 'print-source'
                            to 'printSource'</xsl:message>
                    </xsl:if>
                    <xsl:text>printSource</xsl:text>
                </xsl:when>
                <xsl:when test=". eq 'printEdition'">
                    <xsl:if test="$verbose">
                        <xsl:message>Wrongly typed bibl : changed 'printEdition'
                            to 'printSource'</xsl:message>
                    </xsl:if>
                    <xsl:text>printSource</xsl:text>
                </xsl:when>
                <xsl:when test=". eq 'CopyText'">
                    <xsl:if test="$verbose">
                        <xsl:message>Wrongly typed bibl : changed 'CopyText' to
                            'printSource'</xsl:message>
                    </xsl:if>
                    <xsl:text>printSource</xsl:text>
                </xsl:when>
                <xsl:when test=". eq 'firstedition'">
                    <xsl:if test="$verbose">
                        <xsl:message>Wrongly typed bibl : changed 'firstedition'
                            to 'firstEdition'</xsl:message>
                    </xsl:if>
                    <xsl:text>firstEdition</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="."/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>
    </xsl:template>
    <xsl:template match="publicationStmt">
        <publicationStmt xmlns="http://www.tei-c.org/ns/1.0">
            <xsl:choose>
                <xsl:when test="$publish">
                    <distributor
                        ref="https://zenodo.org/communities/distant-reading"
                        >Distant Reading for European Literary History (COST
                        Action 16204) </distributor>
                    <date when="{$today}"/>
                    <availability>
                        <licence
                            target="https://creativecommons.org/licenses/by/4.0/"
                            ><p> Licenced under CC-BY 4.0 </p></licence>
                    </availability>
                    <ref type="doi" target="{$publish}"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:apply-templates/>
                </xsl:otherwise>
            </xsl:choose>
        </publicationStmt>
    </xsl:template>
    <!-- deal with canonicity -->
    <xsl:template match="*:canonicity/@key">
        <xsl:attribute name="key">
            <xsl:choose>
                <xsl:when test=". = 'medium'">unspecified</xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="."/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>
    </xsl:template>
    <xsl:template match="revisionDesc">
        <xsl:copy>
            <change xmlns="http://www.tei-c.org/ns/1.0" when="{$today}">Header
                adjusted by headChecker script</change>
            <xsl:apply-templates/>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="name">
        <xsl:choose>
            <xsl:when test="parent::change">
                <xsl:value-of select="."/>
            </xsl:when>
            <xsl:when test="parent::respStmt">
                <xsl:copy>
                    <xsl:apply-templates/>
                </xsl:copy>
            </xsl:when>
            <xsl:otherwise>
                <xsl:message>Unexpected name element found: ignored </xsl:message>
                <xsl:value-of select="."/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="ref[@target = '#']">
        <ref xmlns="http://www.tei-c.org/ns/1.0" target="#unspecified">
            <xsl:apply-templates/>
        </ref>
    </xsl:template>
    <xsl:template match="milestone[not(@unit)]">
        <xsl:if test="$verbose">
            <xsl:message>Milestone needs a unit</xsl:message>
        </xsl:if>
        <milestone xmlns="http://www.tei-c.org/ns/1.0" unit="unspecified"/>
    </xsl:template>
</xsl:stylesheet>
