<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
 xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:t="http://www.tei-c.org/ns/1.0"
  xmlns:e="http://distantreading.net/eltec/ns"
 exclude-result-prefixes="xs t e" version="2.0">
 <xsl:output method="html"/>

 <xsl:param name="corpus">XXX</xsl:param>
 <xsl:param name="verbose"></xsl:param>
 <xsl:param name="lastUpdate">[unknown]</xsl:param>

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
  <xsl:variable name="femalePerc">
   <xsl:value-of select="$femaleCount div $textCount * 100"/>
  </xsl:variable>

  <xsl:variable name="femaleScore">
   <xsl:choose>
    <xsl:when test="$femalePerc &lt; 10">
     <xsl:value-of select="$femalePerc"/>
    </xsl:when>
    <xsl:when test="$femalePerc &lt; 40">10</xsl:when>
    <xsl:when test="$femalePerc &lt; 60">11</xsl:when>
    <xsl:when test="$femalePerc &lt; 71">8</xsl:when>
    <xsl:when test="$femalePerc &lt; 85">5</xsl:when>
    <xsl:when test="$femalePerc &lt; 100">2</xsl:when>
    <xsl:otherwise>0</xsl:otherwise>
   </xsl:choose>
  </xsl:variable>
<xsl:if test="$verbose">
<xsl:message>Female count: <xsl:value-of select="$femaleCount"/>
 Female perc: <xsl:value-of select="$femalePerc"/>
 Female score: <xsl:value-of select="$femaleScore"/><xsl:text>
 </xsl:text>
</xsl:message></xsl:if>
  
  <xsl:variable name="reprintCount">
   <xsl:value-of
    select="count(//e:canonicity[@key = 'low']) + count(//e:reprintCount[@key = 'low'])"/>
  </xsl:variable>
  
  <xsl:variable name="reprintPerc">
   <xsl:value-of select="$reprintCount div $textCount * 100"/>
  </xsl:variable>
  
  <xsl:variable name="reprintScore">
   <xsl:choose>
    <xsl:when test="$reprintPerc &lt; 5">0</xsl:when>
    <xsl:when test="$reprintPerc &lt; 10">1</xsl:when>
    <xsl:when test="$reprintPerc &lt; 20">4</xsl:when>
    <xsl:when test="$reprintPerc &lt; 30">6</xsl:when>
    <xsl:when test="$reprintPerc &lt; 40">10</xsl:when>
    <xsl:when test="$reprintPerc &lt; 60">11</xsl:when>
    <xsl:when test="$reprintPerc &lt; 70">10</xsl:when>
    <xsl:when test="$reprintPerc &lt; 100">5</xsl:when>
    <xsl:otherwise>0</xsl:otherwise>
   </xsl:choose>
  </xsl:variable>

  <xsl:variable name="shortPerc">
   <xsl:value-of select="count(//e:size[@key = 'short']) div $textCount * 100"/>
  </xsl:variable>

  <xsl:variable name="shortScore">
   <xsl:choose>
    <xsl:when test="$shortPerc &lt; 6">2</xsl:when>
    <xsl:when test="$shortPerc &lt; 11">5</xsl:when>
    <xsl:when test="$shortPerc &lt; 20">8</xsl:when>
    <xsl:when test="$shortPerc &lt; 25">10</xsl:when>
    <xsl:when test="$shortPerc &lt; 36">11</xsl:when>
    <xsl:when test="$shortPerc &lt; 41">10</xsl:when>
    <xsl:when test="$shortPerc &lt; 50">9</xsl:when>
    <xsl:when test="$shortPerc &lt; 60">8</xsl:when>
    <xsl:when test="$shortPerc &lt; 80">6</xsl:when>
    <xsl:when test="$shortPerc &lt; 90">4</xsl:when>
    <xsl:when test="$shortPerc &lt; 101">2</xsl:when>
    <xsl:otherwise>0</xsl:otherwise>
   </xsl:choose>
  </xsl:variable>

  <xsl:variable name="longPerc">
   <xsl:value-of select="count(//e:size[@key = 'long']) div $textCount * 100"/>
  </xsl:variable>

  <xsl:variable name="longScore">
   <xsl:choose>
    <xsl:when test="$longPerc &lt; 6">2</xsl:when>
    <xsl:when test="$longPerc &lt; 11">5</xsl:when>
    <xsl:when test="$longPerc &lt; 20">8</xsl:when>
    <xsl:when test="$longPerc &lt; 25">10</xsl:when>
    <xsl:when test="$longPerc &lt; 36">11</xsl:when>
    <xsl:when test="$longPerc &lt; 41">10</xsl:when>
    <xsl:when test="$longPerc &lt; 50">9</xsl:when>
    <xsl:when test="$longPerc &lt; 60">8</xsl:when>
    <xsl:when test="$longPerc &lt; 80">6</xsl:when>
    <xsl:when test="$longPerc &lt; 90">4</xsl:when>
    <xsl:when test="$longPerc &lt; 101">2</xsl:when>
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
   <xsl:value-of select="count(//e:timeSlot[@key = 'T1']) div $textCount * 100"/>
   <xsl:text>,</xsl:text>
   <xsl:value-of select="count(//e:timeSlot[@key = 'T2']) div $textCount * 100"/>
   <xsl:text>,</xsl:text>
   <xsl:value-of select="count(//e:timeSlot[@key = 'T3']) div $textCount * 100"/>
   <xsl:text>,</xsl:text>
   <xsl:value-of select="count(//e:timeSlot[@key = 'T4']) div $textCount * 100"/>
  </xsl:variable>

  <xsl:variable name="rangeSeq" select="tokenize($rangeString, ',')"/>

  <xsl:variable name="rangeMax">
   <xsl:value-of select="max($rangeSeq)"/>
  </xsl:variable>
  <xsl:variable name="rangeMin">
   <xsl:value-of select="min($rangeSeq)"/>
  </xsl:variable>
  <xsl:variable name="rangeCount">
   <xsl:value-of select="$rangeMax - $rangeMin"/>
  </xsl:variable>
 <xsl:if test="$verbose">
<xsl:message>Vals:<xsl:value-of select="$rangeString"/>
 <xsl:text>max: </xsl:text><xsl:value-of select="max($rangeSeq)"/>
 <xsl:text>min: </xsl:text><xsl:value-of select="min($rangeSeq)"/>
 <xsl:text>range: </xsl:text><xsl:value-of select="$rangeCount"/></xsl:message>
 </xsl:if>
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
  
  <!-- compute the score -->
  
  <xsl:variable name="e5cScore">
   <xsl:value-of
    select="($textScore * 3 + $femaleScore * 2 + $singleScore + $tripleScore +
    $shortScore + $longScore + $rangeScore * 2 + $reprintScore * 2) div 13 * 10"/>
  </xsl:variable>
  
  <!-- now output the table row -->
  
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
    <xsl:value-of select="$lastUpdate"/>
   </td>
   <td>
    <xsl:choose>
     <xsl:when test="$textCount &lt; 50">
      <span style="color:red" title="{$textScore}">
       <xsl:value-of select="$textCount"/>
      </span>
     </xsl:when>
     <xsl:otherwise>
      <span title="{$textScore}">
       <xsl:value-of select="$textCount"/>
      </span>   
     </xsl:otherwise>
    </xsl:choose>
    
   </td>
   <td>
    <xsl:value-of select="$wordCount"/>
   </td>
   <td class="sep">
    <xsl:value-of select="count(//e:authorGender[@key = 'M'])"/>
   </td>
   <td>
    <xsl:call-template  name="showScore">
     <xsl:with-param name="count"><xsl:value-of select="count(//e:authorGender[@key = 'F'])"/></xsl:with-param>
     <xsl:with-param name="score"><xsl:value-of select="$femaleScore"/></xsl:with-param>
     <xsl:with-param name="target">5</xsl:with-param>
    </xsl:call-template>
     </td>
   <td>
    <xsl:call-template  name="showScore">
     <xsl:with-param name="count"><xsl:value-of select="$singleCount"/></xsl:with-param>
     <xsl:with-param name="score">  <xsl:value-of select="$singleScore"/></xsl:with-param>
     <xsl:with-param name="target">5</xsl:with-param>
    </xsl:call-template>
   </td>
   <td>
    <xsl:call-template  name="showScore">
     <xsl:with-param name="count"><xsl:value-of select="$tripleCount"/></xsl:with-param>
     <xsl:with-param name="score">  <xsl:value-of select="$tripleScore"/></xsl:with-param>
     <xsl:with-param name="target">5</xsl:with-param>
    </xsl:call-template>
   </td>

   <td class="sep">
    <xsl:call-template  name="showScore">
     <xsl:with-param name="count"><xsl:value-of select="count(//e:size[@key = 'short'])"/></xsl:with-param>
     <xsl:with-param name="score"><xsl:value-of select="$shortScore"/></xsl:with-param>
     <xsl:with-param name="target">5</xsl:with-param>
    </xsl:call-template>
   </td>
   <td>
    <xsl:value-of select="count(//e:size[@key = 'medium'])"/>
   </td>
   <td>
    
    <xsl:call-template  name="showScore">
     <xsl:with-param name="count"><xsl:value-of select="count(//e:size[@key = 'long'])"/></xsl:with-param>
     <xsl:with-param name="score"><xsl:value-of select="$longScore"/></xsl:with-param>
     <xsl:with-param name="target">5</xsl:with-param>
    </xsl:call-template>
   <!-- <xsl:text> [</xsl:text>
    <xsl:value-of select="$longScore"/>
    <xsl:text>]</xsl:text>-->
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
    <span title="{$reprintScore}">
    <xsl:value-of select="$reprintCount"/>
   </span>
    <!-- <xsl:text> [</xsl:text>
    <xsl:value-of select="$reprintScore"/>
    <xsl:text>]</xsl:text>-->
    
   </td>
   <td class="sep">
      <xsl:choose>
     <xsl:when test="$e5cScore &gt; 74">
      <span style="color:green"><xsl:value-of select="format-number($e5cScore,'#.00')"/></span>
     </xsl:when>
     <xsl:otherwise>
      <xsl:value-of select="format-number($e5cScore,'#.00')"/>
     </xsl:otherwise>
    </xsl:choose>
   </td>
  </tr>
 </xsl:template>
 
 <xsl:template name="showScore">
  <xsl:param name="count" />
  <xsl:param name="score" as="xs:float"/>
  <xsl:param name="target" as="xs:float"/> 
  <xsl:choose>
   <xsl:when test="$score &lt; $target">
    <span style="color:red" title="{$score}">
     <xsl:value-of select="$count"/>
    </span>
   </xsl:when>
   <xsl:otherwise>
    <span title="{$score}">
     <xsl:value-of select="$count"/>
    </span>   
   </xsl:otherwise>
  </xsl:choose>
  
 </xsl:template>

</xsl:stylesheet>
