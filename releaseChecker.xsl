<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xpath-default-namespace="http://www.tei-c.org/ns/1.0"
    xmlns:e="http://distantreading.net/eltec/ns" exclude-result-prefixes="xs e" version="2.0">
    <xsl:param name="fileName">UnknownFile</xsl:param>
    <xsl:param name="publish">https://doi.org/10.5281/zenodo.3462435</xsl:param>
    <!-- iff true, update publicationStmt -->
    <xsl:param name="verbose">true</xsl:param>
    <!-- iff true, witter on -->
    <xsl:variable name="today">
        <xsl:value-of select="format-date(current-date(), '[Y0001]-[M01]-[D01]')"/>
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
    <!-- Basically, an identity transform -->
    <xsl:template match="/ | @* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>

    <!-- but we start by throwing away any existing xmlmodel PI and putting in our own -->

    <xsl:template match="processing-instruction('xml-model')"/>

    <xsl:template match="TEI">
        <xsl:text>
    </xsl:text>
        <xsl:processing-instruction name="xml-model">
            href="../../Schemas/eltec-1.rng" type="application/xml" 
            schematypens="http://relaxng.org/ns/structure/1.0"</xsl:processing-instruction>
        <xsl:text>
    </xsl:text>
        <xsl:processing-instruction name="xml-model">
            href="../../Schemas/eltec-1.rng" type="application/xml" 
            schematypens="http://purl.oclc.org/dsdl/schematron"</xsl:processing-instruction>
        <xsl:text>
</xsl:text>
        <xsl:message> *** File <xsl:value-of select="$fileName"/> on <xsl:value-of 
            select="$today"/> (<xsl:value-of select="teiHeader/fileDesc/titleStmt/title[1]"/>) *** </xsl:message>
        <xsl:if test="not(matches($textId, '[A-Z]+[0-9]+'))">
            <xsl:message>Weird xml_id : <xsl:value-of select="$textId"/></xsl:message>
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
        <xsl:variable select="substring-before($theString, '(')" name="theAuthor"/>
        <xsl:variable select="substring-before(substring-after($theString, '('), ')')"
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
                <xsl:if test="not(matches($theDates, '(1[789]\d\d)|\?\s*\-\s*(1[89]\d\d)|\?'))">
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
                        <xsl:value-of select="concat('viaf:', idno[@type = 'viaf'])"/>
                    </xsl:attribute>
                    <xsl:value-of select="concat($theAuthor, ' (', $theDates, ')')"/>
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
            <xsl:message>Untyped bibl</xsl:message>
        </xsl:if>
        <xsl:copy>
            <xsl:attribute name="type">
                <xsl:choose>
                    <xsl:when test="parent::relatedItem[@type = 'sourceEdition']">
                        <xsl:text>firstEdition</xsl:text>
                    </xsl:when>
                    <xsl:when test="child::ref[starts-with(@target,'gut:')]">
                        <xsl:text>digitalSource</xsl:text>
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
                        <xsl:message>Wrongly typed bibl : changed 'copyText' to  'printSource'</xsl:message>
                    </xsl:if>
                    <xsl:text>printSource</xsl:text>
                </xsl:when>
                <xsl:when test=". eq 'encodedFrom'">
                    <xsl:if test="$verbose">
                        <xsl:message>Wrongly typed bibl : changed 'encodedFrom' to  'digitalSource'</xsl:message>
                    </xsl:if>
                    <xsl:text>digitalSource</xsl:text>
                </xsl:when>
                <xsl:when test=". eq 'source'">
                    <xsl:if test="$verbose">
                        <xsl:message>Wrongly typed bibl : changed 'source' to  'digitalSource'</xsl:message>
                    </xsl:if>
                    <xsl:text>digitalSource</xsl:text>
                </xsl:when>
                <xsl:when test=". eq 'digital-source'">
                    <xsl:if test="$verbose">
                        <xsl:message>Wrongly typed bibl : changed 'digital-source' to  'digitalSource'</xsl:message>
                    </xsl:if>
                    <xsl:text>digitalSource</xsl:text>
                </xsl:when>
                <xsl:when test=". eq 'print-source'">
                    <xsl:if test="$verbose">
                        <xsl:message>Wrongly typed bibl : changed 'print-source' to  'printSource'</xsl:message>
                    </xsl:if>
                    <xsl:text>printSource</xsl:text>
                </xsl:when>
                <xsl:when test=". eq 'printEdition'">
                    <xsl:if test="$verbose">
                        <xsl:message>Wrongly typed bibl : changed 'printEdition' to 'printSource'</xsl:message>
                    </xsl:if>
                    <xsl:text>printSource</xsl:text>
                </xsl:when>
                <xsl:when test=". eq 'CopyText'">
                    <xsl:if test="$verbose">
                        <xsl:message>Wrongly typed bibl : changed 'CopyText' to 'printSource'</xsl:message>
                    </xsl:if>
                    <xsl:text>printSource</xsl:text>
                </xsl:when>
                <xsl:when test=". eq 'firstedition'">
                    <xsl:if test="$verbose">
                        <xsl:message>Wrongly typed bibl : changed 'firstedition' to 'firstEdition'</xsl:message>
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
            <publisher 
ref="https://distant-reading.net">COST Action "Distant Reading for European Literary History" (CA16204)</publisher>
            <distributor
                ref="https://zenodo.org/communities/eltec/">Zenodo.org</distributor>
             <date when="{$today}"/>
            <availability>
                <licence target="https://creativecommons.org/licenses/by/4.0/"/>
            </availability>
            <ref type="doi" target="{$publish}"/>
            <xsl:if test="p">
                <xsl:comment>
<xsl:value-of select="p"/>
 </xsl:comment>
            </xsl:if>
        </publicationStmt>
    </xsl:template>
    <!-- deal with canonicity -->
    <xsl:template match="*:canonicity/@key">
        <xsl:attribute name="key">
            <xsl:choose>
                <xsl:when test=". = 'medium'">unspecified</xsl:when>
                <xsl:when test=". = 'unmarked'">unspecified</xsl:when>

                <xsl:otherwise>
                    <xsl:value-of select="."/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>
    </xsl:template>
    <xsl:template match="revisionDesc">
        <xsl:copy>
            <change xmlns="http://www.tei-c.org/ns/1.0" when="{$today}">Checked by releaseChecker script</change>
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

    <xsl:template match="milestone[not(@unit)]">
        <xsl:if test="$verbose">
            <xsl:message>Milestone unit -> unspecified</xsl:message>
        </xsl:if>
        <milestone xmlns="http://www.tei-c.org/ns/1.0" unit="unspecified"/>
    </xsl:template>

    <!-- Script to check texts for common errors
       - check divs and fix @type where possible
       - remove empty front or back
       - remove ref with invalid target
-->

    <!-- look at untyped divs -->
    <xsl:template match="body//div[not(@type)]">
        <xsl:message>Untyped div found...</xsl:message>
        <xsl:choose>
            <xsl:when test="p and not(child::div)">
                <xsl:message>contains p but not div so marking as chapter</xsl:message>
                <div type="chapter" xmlns="http://www.tei-c.org/ns/1.0">
                    <xsl:apply-templates/>
                </div>
            </xsl:when>
            <xsl:when test="div">
                <xsl:message>contains div so marking as group</xsl:message>
                <div type="group" xmlns="http://www.tei-c.org/ns/1.0">
                    <xsl:apply-templates/>
                </div>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    <!-- check divs in front -->
    <xsl:template match="front/div[@type]">
        <xsl:choose>
            <xsl:when test="@type = 'titlepage'">
                <div type="titlepage" xmlns="http://www.tei-c.org/ns/1.0">
                    <xsl:apply-templates/>
                </div>
            </xsl:when>
            <xsl:when test="@type = 'liminal'">
                <div type="liminal" xmlns="http://www.tei-c.org/ns/1.0">
                    <xsl:apply-templates/>
                </div>
            </xsl:when>
            <xsl:when test="contains(@type, 'title')">
                <xsl:message> ... assuming titlepage</xsl:message>
                <div type="titlepage" xmlns="http://www.tei-c.org/ns/1.0">
                    <xsl:apply-templates/>
                </div>
            </xsl:when>
            <xsl:otherwise>
                <xsl:message>Unrecognized divtype <xsl:value-of select="@type"/> ... assuming
                    liminal</xsl:message>
                <div type="liminal" xmlns="http://www.tei-c.org/ns/1.0">
                    <xsl:apply-templates/>
                </div>
            </xsl:otherwise>
        </xsl:choose>

    </xsl:template>
    <xsl:template match="front/div[not(@type)]">
        <xsl:message>No divtype supplied in front ... assuming liminal</xsl:message>
        <div type="liminal" xmlns="http://www.tei-c.org/ns/1.0">
            <xsl:apply-templates/>
        </div>
    </xsl:template>

    <xsl:template match="back/div[not(@type)]">
        <xsl:message>No divtype supplied in back ... assuming liminal</xsl:message>
        <div type="liminal" xmlns="http://www.tei-c.org/ns/1.0">
            <xsl:apply-templates/>
        </div>
    </xsl:template>

    <!-- following templates added to clean up norwegian texts -->

    <!-- remove <note> elements inside the body-->
    <xsl:template match="body//note">
        <xsl:message>note inside body removed</xsl:message>
    </xsl:template>

    <!-- remove empty front or back and vacuous ref -->

    <xsl:template match="front[not(div)]">
        <xsl:message>Empty front removed</xsl:message>
    </xsl:template>

    <xsl:template match="back[not(div)]">
        <xsl:message>Empty back removed</xsl:message>
    </xsl:template>

    <!-- remove invalidly targetted refs -->
    <xsl:template match="ref[@target]">
        <xsl:choose>
            <xsl:when test="parent::head">
                <xsl:apply-templates/>
                <xsl:message>ref in head de-tagged</xsl:message>
            </xsl:when>
            <xsl:when test="starts-with(@target, 'http')">
                <xsl:copy-of select="."/>
            </xsl:when>
            <xsl:when test="starts-with(@target, 'gut:')">
                <xsl:copy-of select="."/>
            </xsl:when>
            <xsl:when test="starts-with(@target, 'ia:')">
                <xsl:copy-of select="."/>
            </xsl:when>
            <xsl:when test="starts-with(@target, 'bod:')">
                <xsl:copy-of select="."/>
            </xsl:when>
            
            <xsl:when test="starts-with(@target, '#')">
                <xsl:variable name="noteId">
                    <xsl:value-of select="substring-after(@target, '#')"/>
                </xsl:variable>
                <!-- <xsl:message>Looking for note <xsl:value-of select="$noteId"/></xsl:message>
         <xsl:message><xsl:value-of select="//note[@xml:id=$noteId]"/></xsl:message>
        -->
                <xsl:choose>
                    <xsl:when test="//note[@xml:id = $noteId]"/>
                    <xsl:otherwise>
                        <xsl:message>Cannot find note with id <xsl:value-of select="$noteId"
                            /></xsl:message>
                    </xsl:otherwise>
                </xsl:choose>
                <xsl:copy-of select="."/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:message>invalid ref targetting <xsl:value-of select="@target"/> removed</xsl:message>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!--<xsl:template match="ref[@target = '#']">
        <ref xmlns="http://www.tei-c.org/ns/1.0" target="#unspecified">
            <xsl:apply-templates/>
        </ref>
    </xsl:template>-->
    <!--<xsl:template match="body//div[p]">
    <xsl:if test="div and not(@type='group')">
        <xsl:message>!!! Invalid div structure: a div cannot contain p and div !!!</xsl:message>
    </xsl:if>
    <xsl:copy><xsl:apply-templates/></xsl:copy>
</xsl:template>

-->

</xsl:stylesheet>
