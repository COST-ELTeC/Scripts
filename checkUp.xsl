<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xpath-default-namespace="http://www.tei-c.org/ns/1.0" xmlns:e="http://distantreading.net/eltec/ns" exclude-result-prefixes="xs e" version="2.0">

 <!-- 
       - check author and title syntax in titleStmt
       - remove empty front or back
       - check syntax for @target values on ref
       - rewrite any existing publicationStmt to provide zenodo info
       - check for wrongly nested divs; turn divs into milestones if necessary
       - add a change element to revisionDesc
       - remove any note elements not in div type note
       and  a few more things...
-->
 
 <xsl:param name="fileName">UnknownFile</xsl:param>
 <xsl:param name="publish">https://doi.org/10.5281/zenodo.3462435</xsl:param>
 <xsl:param name="ERNfile">../ELTeC/listERN.xml</xsl:param>
 
 <xsl:param name="verbose"/>
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

 <!-- Basically, an identity transform -->
 <xsl:template match="/ | @* | node()">
  <xsl:copy>
   <xsl:apply-templates select="@* | node()"/>
  </xsl:copy>
 </xsl:template>

 <!-- start by throwing away any existing xmlmodel PI and putting in our own -->

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
  <xsl:message>
   <xsl:text>*** File </xsl:text>
   <xsl:value-of select="$fileName"/>
   <xsl:text> on </xsl:text>
   <xsl:value-of select="$today"/>
   <xsl:text> (</xsl:text>
   <xsl:value-of select="teiHeader/fileDesc/titleStmt/title[1]"/>
   <xsl:text>) *** 
</xsl:text>
  </xsl:message>

  <!-- test the xml:id -->

  <xsl:if test="not(matches($textId, '[A-Z]+[0-9]+'))">
   <xsl:message>Weird xml_id : <xsl:value-of select="$textId"/></xsl:message>
  </xsl:if>

  <xsl:if test="not(starts-with($fileName, $textId))">
   <xsl:message>xml_id <xsl:value-of select="$textId"/> disagrees with filename <xsl:value-of select="$fileName"/></xsl:message>
  </xsl:if>

  <xsl:copy>
   <xsl:apply-templates select="@*"/>
   <xsl:apply-templates/>
  </xsl:copy>


  <xsl:value-of select="e:warning(count(text//div[not(@type)]), 'untyped divs found')"/>
  <!-- missing @type is permitted by schema but if @type is supplied, its values are constrained -->
 </xsl:template>

 <!-- now some specific checks on ... titleStmt -->

 <xsl:template match="titleStmt/title[1]">
  <xsl:copy>
   <xsl:apply-templates select="./@*"/>
   <xsl:value-of select="."/>
   <xsl:if test="not(contains(., 'ELTeC'))">
    <xsl:text> : </xsl:text>
    <xsl:value-of select="$editionWord"/>
   </xsl:if>
  </xsl:copy>
 </xsl:template>

 <xsl:template match="titleStmt/author/@xml:id"/>
 <xsl:template match="titleStmt/author">
  <xsl:copy>
   <xsl:if test="@xml:id">
    <xsl:attribute name="n">
     <xsl:value-of select="@xml:id"/>
    </xsl:attribute>
    <xsl:message>WARNING: @xml:id on author changed to @n</xsl:message>
   </xsl:if>
   <xsl:variable select="normalize-space(.)" name="theString"/>
   <xsl:variable select="substring-before($theString, '(')" name="theAuthor"/>
   <xsl:variable select="substring-before(substring-after($theString, '('), ')')" name="theDates"/>
   <xsl:choose>
    <xsl:when test="string-length($theAuthor) &lt; 1">
     <xsl:message>WARNING: <xsl:value-of select="$theString"/>
      <xsl:text> has no dates</xsl:text></xsl:message>
    </xsl:when>
    <xsl:otherwise>
     <xsl:if test="not(matches($theAuthor, '\[?[\p{L} \-]+,'))">
      <xsl:message>ERROR: <xsl:value-of select="$theAuthor"/>
       <xsl:text> has no comma </xsl:text></xsl:message>
     </xsl:if>
     <xsl:if test="not(matches($theDates, '(1[789]\d\d)|\?\s*\-\s*(1[89]\d\d)|\?'))">
      <xsl:message>ERROR <xsl:value-of select="$theString"/>
       <xsl:text>implausible author dates (</xsl:text><xsl:value-of select="$theDates"/>)! </xsl:message>
     </xsl:if>
    </xsl:otherwise>
   </xsl:choose>
   <xsl:apply-templates select="@*"/>
   <xsl:apply-templates/>
  </xsl:copy>
 </xsl:template>

 <!-- deal with sourceDesc : note that bibl/@type is now handled by schema -->

 <xsl:template match="sourceDesc">
  <xsl:copy>
   <xsl:apply-templates select="bibl"/>
   </xsl:copy>
 </xsl:template>
 
  <xsl:template match="respStmt[not(resp)]">
  <xsl:message>ERROR : respStmt missing resp : de-tagged</xsl:message>
  <xsl:apply-templates/>
 </xsl:template>
 
 <xsl:template match="bibl//editor">
  <xsl:message>ERROR: Editor tag not allowed: converting to respStmt</xsl:message>
  <respStmt xmlns="http://www.tei-c.org/ns/1.0">
   <resp>editor</resp>
   <name>
    <xsl:apply-templates/>
   </name>
  </respStmt>
 </xsl:template>

 <xsl:template match="div//bibl">
  <xsl:message>Misplaced bibl changed to label</xsl:message>
  <label xmlns="http://www.tei-c.org/ns/1.0">
   <xsl:apply-templates/>
  </label>
 </xsl:template>
 
 <!-- deal with publicationStmt 
 <publicationStmt>
  <publisher ref="https://distant-reading.net">COST Action
   "Distant Reading for European Literary History" (CA16204)</publisher>
  <distributor
   ref="https://zenodo.org/communities/eltec/">Zenodo.org</distributor>
  <date when="{listERN/date[1]}" />
  <availability>
   <licence target="https://creativecommons.org/licenses/by/4.0/" />
  </availability>
  <ref type="doi" target="https://doi.org/10.5281/zenodo.{listERN/@zid}">
   ELTeC</ref>
  <ref type="doi" target="https://doi.org/10.5281/zenodo.{listERN/ern[@xml:id=$lang]/@cZid}">ELTeC-$lang</ref>
  <ref type="doi" target="https://doi.org/10.5281/zenodo.{listERN/ern[@xml:id=$lang]/@rZid}">
   ELTeC-$lang release listERN/ern[@xml:id=$lang]/@n}
  </ref>
 </publicationStmt>-->
 
 <xsl:template match="publicationStmt">
  <xsl:variable name="zPrefix">https://doi.org/10.5281/zenodo.</xsl:variable>
  <xsl:variable name="zLink" select="concat($zPrefix, document($ERNfile)//e:listERN/@zid)"/>

  <xsl:variable name="cZidLink" select="concat($zPrefix,document($ERNfile)//e:listERN/e:ern[@xml:id=$textLang]/@cZid)"/>
  <xsl:variable name="rZidLink" select="concat($zPrefix,document($ERNfile)//e:listERN/e:ern[@xml:id=$textLang]/@rZid)"/>
  <xsl:variable name="release" select="document($ERNfile)//e:listERN/e:ern[@xml:id=$textLang]/@n"/>
  <publicationStmt xmlns="http://www.tei-c.org/ns/1.0">
   <publisher ref="https://distant-reading.net">COST Action "Distant Reading for European Literary History" (CA16204)</publisher>
   <distributor ref="https://zenodo.org/communities/eltec/">Zenodo.org</distributor>
   <date when="{$today}"/>
   <availability>
    <licence target="https://creativecommons.org/licenses/by/4.0/"/>
   </availability>
   <ref type="doi" target="{$zLink}">ELTeC</ref>
   <ref type="doi" target="{$cZidLink}"><xsl:value-of select="concat('ELTeC-',$textLang)"/></ref>
   <ref type="doi" target="{$rZidLink}"><xsl:value-of select="concat('ELTeC-',$textLang, ' release ', $release)"/></ref> 
   <xsl:if test="p">
    <xsl:comment>
<xsl:value-of select="p"/>
 </xsl:comment>
   </xsl:if>
  </publicationStmt>
 </xsl:template>
 <!-- deal with canonicity -->
 <xsl:template match="*:canonicity">
  <reprintCount xmlns="http://distantreading.net/eltec/ns">
   <xsl:attribute name="key">
    <xsl:choose>
     <xsl:when test="@key = 'medium'">unspecified</xsl:when>
     <xsl:when test="@key = 'unmarked'">unspecified</xsl:when>
     <xsl:otherwise>
      <xsl:value-of select="@key"/>
     </xsl:otherwise>
    </xsl:choose>
   </xsl:attribute>
  </reprintCount>
 </xsl:template>
 
 <xsl:template match="revisionDesc">
  <xsl:copy>
   <change xmlns="http://www.tei-c.org/ns/1.0" when="{$today}">Checked by checkup script</change>
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
    <xsl:message>Unexpected name tag found: suppressed </xsl:message>
    <xsl:value-of select="."/>
   </xsl:otherwise>
  </xsl:choose>
 </xsl:template>

 <xsl:template match="milestone[not(@unit)]">
  <xsl:message>WARNING: Milestone unit unspecified</xsl:message>
  <milestone xmlns="http://www.tei-c.org/ns/1.0" unit="unspecified"/>
 </xsl:template>

 <!-- look at untyped divs (which are still permitted by schema) -->
 
 <xsl:template match="body//div[not(@type)]">
  <xsl:choose>
   <xsl:when test="parent::div[@type = 'chapter']">
    <xsl:message>ERROR : div not permitted within chapter: replaced with milestone</xsl:message>
    <milestone xmlns="http://www.tei-c.org/ns/1.0" unit="unspecified"/>
    <xsl:apply-templates/>
   </xsl:when>
   <xsl:when test="p and not(child::div)">
    <xsl:if test="$verbose">
     <xsl:message>WARNING: untyped div containing p but not div: marking as chapter</xsl:message>
    </xsl:if>
    <div type="chapter" xmlns="http://www.tei-c.org/ns/1.0">
     <xsl:apply-templates select="@*"/>
     <xsl:apply-templates/>
    </div>
   </xsl:when>
   <xsl:when test="div">
    <xsl:if test="$verbose">
     <xsl:message>WARNING: untyped div containing div : marking as group</xsl:message>
    </xsl:if>
    <div type="group" xmlns="http://www.tei-c.org/ns/1.0">
     <xsl:apply-templates/>
    </div>
   </xsl:when>
  </xsl:choose>
 </xsl:template>

 <!-- check typed divs -->

 <xsl:template match="body//div[@type]">
<xsl:choose>
  <xsl:when test="parent::div[@type = 'chapter']">
    <xsl:message>ERROR : div not permitted within chapter: replaced with milestone</xsl:message>
    <milestone xmlns="http://www.tei-c.org/ns/1.0" unit="{@type}"/>
    <xsl:apply-templates/>
   </xsl:when>
 <xsl:otherwise>
 <xsl:copy> 
  <xsl:apply-templates select="@*"/>
  <xsl:apply-templates/>
</xsl:copy> </xsl:otherwise>
</xsl:choose>
 </xsl:template>

 <!-- check titlepage div is in front -->
 <xsl:template match="//div[@type='titlepage']">
  <xsl:if test="ancestor::body">
   <xsl:message>WARNING: title page found in body : shouldnt it be in front or back?</xsl:message>
  </xsl:if>
  <xsl:copy>   <xsl:apply-templates select="@*"/>
   <xsl:apply-templates/>
</xsl:copy>   </xsl:template>
 
 <xsl:template match="front/div[not(@type)]">
  <xsl:if test="$verbose">
   <xsl:message>Untyped div found in front ... assuming liminal</xsl:message>
  </xsl:if>
  <div type="liminal" xmlns="http://www.tei-c.org/ns/1.0">
   <xsl:apply-templates/>
  </div>
 </xsl:template>

 <xsl:template match="back/div[not(@type)]">
  <xsl:if test="$verbose">
   <xsl:message>Untyped div found in front ... assuming liminal</xsl:message>
  </xsl:if>
  <div type="liminal" xmlns="http://www.tei-c.org/ns/1.0">
   <xsl:apply-templates/>
  </div></xsl:template>

 <xsl:template match="back/div[@type]">
  <xsl:choose>

   <xsl:when test="@type = 'liminal' or @type = 'notes'">
    <div xmlns="http://www.tei-c.org/ns/1.0" type="{@type}">
     <xsl:apply-templates/>
    </div>
   </xsl:when>
     <xsl:otherwise>
    <xsl:message>
     <xsl:text>WARNING : unanticipated div/@type (</xsl:text>
     <xsl:value-of select="@type"/>
     <xsl:text>) in back : changed to liminal</xsl:text>
    </xsl:message>
    <div type="liminal" xmlns="http://www.tei-c.org/ns/1.0">
     <xsl:apply-templates/>
    </div>
   </xsl:otherwise>
  </xsl:choose>
 </xsl:template>

 <!-- remove <note> elements inside the body-->
 <xsl:template match="body//note">
  <xsl:message>ERROR : note inside body removed</xsl:message>
 </xsl:template>

 <!-- remove empty front or back and vacuous ref -->

 <xsl:template match="front[not(div)]">
  <xsl:message>Empty front removed</xsl:message>
 </xsl:template>

 <xsl:template match="back[not(div)]">
  <xsl:message>Empty back removed</xsl:message>
 </xsl:template>

 <!-- special tweaks for romanian -->
 <xsl:template match="div[@type = 'chapter']/div/head">
  <p xmlns="http://www.tei-c.org/ns/1.0">
   <label>
    <xsl:value-of select="."/>
   </label>
  </p>
 </xsl:template>

 <!-- kill some strange milestones -->
 <xsl:template match="milestone[@unit = 'header']"/>
 <xsl:template match="milestone[@unit = 'end']"/>
 <xsl:template match="milestone[@unit = 'middle']">
  <milestone xmlns="http://www.tei-c.org/ns/1.0" rend="dots" unit="subchapter"/>
 </xsl:template>
 <xsl:template match="milestone[@unit = 'absent']">
  <milestone xmlns="http://www.tei-c.org/ns/1.0" rend="space" unit="subchapter"/>
 </xsl:template>

 <!-- remove invalidly targetted refs from body-->
 <xsl:template match="text//ref[@target[string-length(.) gt 1]]">
  <xsl:choose>
   <xsl:when test="parent::head">
    <xsl:apply-templates/>
    <xsl:message>WARNING: ref in head removed</xsl:message>
   </xsl:when>
   <xsl:when test="starts-with(@target, 'http')">
    <xsl:copy-of select="."/>
   </xsl:when>
  <!-- <xsl:when test="starts-with(@target, 'gut:')">
    <xsl:copy-of select="."/>
   </xsl:when>
   <xsl:when test="starts-with(@target, 'ia:')">
    <xsl:copy-of select="."/>
   </xsl:when>
   <xsl:when test="starts-with(@target, 'bod:')">
    <xsl:copy-of select="."/>
   </xsl:when>
   <xsl:when test="starts-with(@target, 'textgrid:')">
    <xsl:copy-of select="."/>
   </xsl:when>
-->
   
   <xsl:when test="starts-with(@target, '#')">
    <xsl:variable name="noteId">
     <xsl:value-of select="substring-after(@target, '#')"/>
    </xsl:variable>  
    <xsl:choose>
     <xsl:when test="//note[@xml:id = $noteId]">
      <xsl:copy-of select="."/>
     </xsl:when>
     <xsl:otherwise>
      <xsl:message>ERROR: ref to nonexistent note with id <xsl:value-of select="$noteId"/> removed</xsl:message>
     </xsl:otherwise>
    </xsl:choose>
    <xsl:copy-of select="."/>
   </xsl:when>
   <xsl:otherwise>
    <xsl:message>WARNING: invalid ref targetting <xsl:value-of select="@target"/> removed</xsl:message>
   </xsl:otherwise>
  </xsl:choose>
 </xsl:template>

 <xsl:template match="ref[@target = '#']">
  <xsl:message>Suppressed vapid ref</xsl:message>
 </xsl:template>

 <xsl:template match="measure[@unit = 'pages' and . = '0']">
  <xsl:message>Suppressed zero page count</xsl:message>
 </xsl:template>

 <xsl:template match="bibl[not(matches(., '[\w]+'))]">
  <xsl:message>Suppressed vapid bibl</xsl:message>
 </xsl:template>

 <xsl:function name="e:warning">
  <xsl:param name="count" as="xs:integer"/>
  <xsl:param name="msg"/>
  <xsl:if test="$count > 0">
   <xsl:message>
    <xsl:text>WARNING : </xsl:text>
    <xsl:value-of select="$count"/>
    <xsl:text> </xsl:text>
    <xsl:value-of select="$msg"/>
   </xsl:message>

  </xsl:if>
 </xsl:function>

</xsl:stylesheet>
