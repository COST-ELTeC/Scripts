<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
 xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:t="http://www.tei-c.org/ns/1.0"
 xmlns:e="http://distantreading.net/eltec/ns" exclude-result-prefixes="xs t e" version="2.0">
 <xsl:output method="html"/>

 <xsl:param name="corpus">XXX</xsl:param>
 <xsl:param name="catalog">yes</xsl:param>

 <xsl:template match="/">

  <xsl:variable name="textCount">
   <xsl:value-of select="count(//t:text)"/>
  </xsl:variable>

  <xsl:variable name="textScore">
   <xsl:choose>
    <xsl:when test="$textCount &lt; 20">1</xsl:when>
    <xsl:when test="$textCount &lt; 40">3</xsl:when>
    <xsl:when test="$textCount &lt; 60">5</xsl:when>
    <xsl:when test="$textCount &lt; 80">7</xsl:when>
    <xsl:when test="$textCount &lt; 96">9</xsl:when>
    <xsl:when test="$textCount &gt; 95">10</xsl:when>
   </xsl:choose>
  </xsl:variable>

  <xsl:variable name="femaleCount">
   <xsl:value-of select="count(//e:authorGender[@key = 'F'])"/>
  </xsl:variable>

  <xsl:variable name="femaleScore">
   <xsl:choose>
    <xsl:when test="$femaleCount &lt; 10">
     <xsl:value-of select="$femaleCount"/>
    </xsl:when>
    <xsl:when test="$femaleCount &lt; 40">10</xsl:when>
    <xsl:when test="$femaleCount &lt; 60">11</xsl:when>
    <xsl:when test="$femaleCount &lt; 71">8</xsl:when>
    <xsl:when test="$femaleCount &lt; 85">5</xsl:when>
    <xsl:when test="$femaleCount &lt; 100">2</xsl:when>
    <xsl:otherwise>0</xsl:otherwise>
   </xsl:choose>
  </xsl:variable>

  <xsl:variable name="reprintCount">
   <xsl:value-of
    select="count(//e:canonicity[@key = 'low']) + count(//e:reprintCount[@key = 'low'])"/>
  </xsl:variable>

  <xsl:variable name="reprintScore">
   <xsl:choose>
    <xsl:when test="$reprintCount &lt; 5">0</xsl:when>
    <xsl:when test="$reprintCount &lt; 10">1</xsl:when>
    <xsl:when test="$reprintCount &lt; 20">4</xsl:when>
    <xsl:when test="$reprintCount &lt; 30">6</xsl:when>
    <xsl:when test="$reprintCount &lt; 40">10</xsl:when>
    <xsl:when test="$reprintCount &lt; 60">11</xsl:when>
    <xsl:when test="$reprintCount &lt; 70">10</xsl:when>
    <xsl:when test="$reprintCount &lt; 100">5</xsl:when>
    <xsl:otherwise>0</xsl:otherwise>
   </xsl:choose>
  </xsl:variable>

  <xsl:variable name="shortCount">
   <xsl:value-of select="count(//e:size[@key = 'short'])"/>
  </xsl:variable>

  <xsl:variable name="shortScore">
   <xsl:choose>
    <xsl:when test="$shortCount &lt; 6">2</xsl:when>
    <xsl:when test="$shortCount &lt; 11">5</xsl:when>
    <xsl:when test="$shortCount &lt; 20">8</xsl:when>
    <xsl:when test="$shortCount &lt; 25">10</xsl:when>
    <xsl:when test="$shortCount &lt; 36">11</xsl:when>
    <xsl:when test="$shortCount &lt; 41">10</xsl:when>
    <xsl:when test="$shortCount &lt; 50">9</xsl:when>
    <xsl:when test="$shortCount &lt; 60">8</xsl:when>
    <xsl:when test="$shortCount &lt; 80">6</xsl:when>
    <xsl:when test="$shortCount &lt; 90">4</xsl:when>
    <xsl:when test="$shortCount &lt; 101">2</xsl:when>
    <xsl:otherwise>0</xsl:otherwise>
   </xsl:choose>
  </xsl:variable>

  <xsl:variable name="longCount">
   <xsl:value-of select="count(//e:size[@key = 'long'])"/>
  </xsl:variable>

  <xsl:variable name="longScore">
   <xsl:choose>
    <xsl:when test="$longCount &lt; 6">2</xsl:when>
    <xsl:when test="$longCount &lt; 11">5</xsl:when>
    <xsl:when test="$longCount &lt; 20">8</xsl:when>
    <xsl:when test="$longCount &lt; 25">10</xsl:when>
    <xsl:when test="$longCount &lt; 36">11</xsl:when>
    <xsl:when test="$longCount &lt; 41">10</xsl:when>
    <xsl:when test="$longCount &lt; 50">9</xsl:when>
    <xsl:when test="$longCount &lt; 60">8</xsl:when>
    <xsl:when test="$longCount &lt; 80">6</xsl:when>
    <xsl:when test="$longCount &lt; 90">4</xsl:when>
    <xsl:when test="$longCount &lt; 101">2</xsl:when>
    <xsl:otherwise>0</xsl:otherwise>
   </xsl:choose>
  </xsl:variable>

  <xsl:variable name="wordCount">
   <xsl:value-of select="xs:integer(sum(//t:measure[@unit = 'words']))"/>
  </xsl:variable>

  <xsl:variable name="authCounts">
   <xsl:for-each-group select="//t:titleStmt/t:author" group-by="normalize-space(.)">
    <xsl:sort select="count(current-group())"/>
    <xsl:value-of select="count(current-group())"/>
   </xsl:for-each-group>
  </xsl:variable>

  <xsl:variable name="tripleCount">
   <xsl:value-of select="count(tokenize($authCounts, '3')) - 1"/>
  </xsl:variable>
  <xsl:variable name="tripleScore">
   <xsl:choose>
    <xsl:when test="$tripleCount &lt; 4">2</xsl:when>
    <xsl:when test="$tripleCount &lt; 6">4</xsl:when>
    <xsl:when test="$tripleCount &lt; 9">8</xsl:when>
    <xsl:when test="$tripleCount &lt; 12">10</xsl:when>
    <xsl:when test="$tripleCount &lt; 15">8</xsl:when>
    <xsl:when test="$tripleCount &lt; 20">4</xsl:when>
    <xsl:when test="$tripleCount &lt; 34">2</xsl:when>
    <xsl:otherwise>0</xsl:otherwise>
   </xsl:choose>
  </xsl:variable>

  <xsl:variable name="singleCount">
   <xsl:value-of select="count(tokenize($authCounts, '1')) - 1"/>
  </xsl:variable>
  <xsl:variable name="singleScore">
   <xsl:choose>
    <xsl:when test="$singleCount &lt; 10">1</xsl:when>
    <xsl:when test="$singleCount &lt; 21">2</xsl:when>
    <xsl:when test="$singleCount &lt; 41">5</xsl:when>
    <xsl:when test="$singleCount &lt; 67">8</xsl:when>
    <xsl:when test="$singleCount &lt; 74">10</xsl:when>
    <xsl:when test="$singleCount &lt; 81">5</xsl:when>
    <xsl:when test="$singleCount &lt; 101">2</xsl:when>
    <xsl:otherwise>0</xsl:otherwise>
   </xsl:choose>
  </xsl:variable>
   <xsl:variable name="rangeString"> 
   <xsl:value-of select="count(//e:timeSlot[@key = 'T1'])"/><xsl:text>,</xsl:text>
   <xsl:value-of select="count(//e:timeSlot[@key = 'T2'])"/><xsl:text>,</xsl:text>
   <xsl:value-of select="count(//e:timeSlot[@key = 'T3'])"/><xsl:text>,</xsl:text>
   <xsl:value-of select="count(//e:timeSlot[@key = 'T4'])"/>
 </xsl:variable>

<xsl:variable name="rangeSeq" select="tokenize($rangeString,',')"/>
  
<xsl:variable name="rangeMax">
 <xsl:value-of select="max($rangeSeq)"/>
</xsl:variable>
  <xsl:variable name="rangeMin">
   <xsl:value-of select="min($rangeSeq)"/>
  </xsl:variable>
 <xsl:variable name="rangeCount">
  <xsl:value-of select="$rangeMax - $rangeMin"/>
</xsl:variable>
<!--<xsl:message>
Vals:<xsl:value-of select="$rangeString"/>
 <xsl:text>max: </xsl:text><xsl:value-of select="max($rangeSeq)"/>
 <xsl:text>min: </xsl:text><xsl:value-of select="min($rangeSeq)"/>
 <xsl:text>range: </xsl:text><xsl:value-of select="$rangeCount"/>
</xsl:message>-->
  <!-- (D9>80,2,D9>50,4,D9>40,6,D9>30,8,D9>10,9,D9>5,10,D9>0,10,D9=0,10)-->
  
  <xsl:variable name="rangeScore">
   <xsl:choose>
    <xsl:when test="$rangeCount &gt; 80">2</xsl:when>
    <xsl:when test="$rangeCount &gt; 50">4</xsl:when>
    <xsl:when test="$rangeCount &gt; 40">6</xsl:when>
    <xsl:when test="$rangeCount &gt; 30">8</xsl:when>
    <xsl:when test="$rangeCount &gt; 10">9</xsl:when>
    <xsl:when test="$rangeCount &gt; 5">10</xsl:when>
    <xsl:when test="$rangeCount &gt; 0">10</xsl:when>    
    <xsl:otherwise>0</xsl:otherwise>
   </xsl:choose>
  </xsl:variable>
    <tr>
   <td class="lang">
    <a>
     <xsl:attribute name="href">
      <xsl:value-of select="concat($corpus, '/index.html')"/>
     </xsl:attribute>
     <xsl:value-of select="$corpus"/>
    </a>
   </td>
   <td>
    <xsl:value-of select="$textCount"/>
    <xsl:text> [</xsl:text>
    <xsl:value-of select="$textScore"/>
    <xsl:text>]</xsl:text>
   </td>
   <td>
    <xsl:value-of select="$wordCount"/>
   </td>
   <td class="sep">
    <xsl:value-of select="count(//e:authorGender[@key = 'M'])"/>
   </td>
   <td>

    <xsl:value-of select="count(//e:authorGender[@key = 'F'])"/>
    <xsl:text> [</xsl:text>
    <xsl:value-of select="$textScore"/>
    <xsl:text>]</xsl:text>

   </td>
   <td>
    <xsl:value-of select="$singleCount"/>
    <xsl:text> [</xsl:text>
    <xsl:value-of select="$singleScore"/>
    <xsl:text>]</xsl:text>
   </td>
   <td>
    <xsl:value-of select="$tripleCount"/>
    <xsl:text> [</xsl:text>
    <xsl:value-of select="$tripleScore"/>
    <xsl:text>]</xsl:text>
   </td>

   <td class="sep">
    <xsl:value-of select="$shortCount"/>
    <xsl:text> [</xsl:text>
    <xsl:value-of select="$shortScore"/>
    <xsl:text>]</xsl:text>
   </td>
   <td>
    <xsl:value-of select="count(//e:size[@key = 'medium'])"/>
   </td>
   <td>
    <xsl:value-of select="$longCount"/>
    <xsl:text> [</xsl:text>
    <xsl:value-of select="$longScore"/>
    <xsl:text>]</xsl:text>
   </td>

   <td class="sep">
    <xsl:value-of select="count(//e:timeSlot[@key = 'T1'])"/>
   </td>
   <td>
    <xsl:value-of select="count(//e:timeSlot[@key = 'T2'])"/>
   </td>
   <td>
    <xsl:value-of select="count(//e:timeSlot[@key = 'T3'])"/>
   </td>
   <td>
    <xsl:value-of select="count(//e:timeSlot[@key = 'T4'])"/>
    <xsl:text> [</xsl:text>
    <xsl:value-of select="$rangeScore"/>
    <xsl:text>]</xsl:text>
   </td>
   <td class="sep">
    <xsl:value-of
     select="count(//e:canonicity[@key = 'high']) + count(//e:reprintCount[@key = 'high'])"/>
   </td>
   <td>
    <xsl:value-of select="$reprintCount"/>
    <xsl:text> [</xsl:text>
    <xsl:value-of select="$reprintScore"/>
    <xsl:text>]</xsl:text>
   </td>
   <td class="sep">
    <!--=SUM((E6*3),(E7*2),(E8*2),(E9*2),(E10*1),(E11*1),(E12*1),(E13*1))/13*10-->
    <xsl:value-of
     select="format-number(($textScore*3 + $femaleScore*2 + $singleScore + $tripleScore + 
            $shortScore + $longScore + $rangeScore*2 + $reprintScore*2) div 13*10, '#.00')"
    />
   </td>
  </tr>
 </xsl:template>

 <!--
  <xsl:function name="e:perc" as="xs:integer">
  <xsl:param name="val" as="xs:integer" />
  <xsl:param name="max" as="xs:integer"/>
  <xsl:sequence select="($val div $max)*100"/>
 </xsl:function>
 -->
</xsl:stylesheet>
