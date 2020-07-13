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
    <xsl:when test="$textCount &lt; 10">0</xsl:when>
    <xsl:when test="$textCount &lt; 20">1</xsl:when>
    <xsl:when test="$textCount &lt; 30">2</xsl:when>   
    <xsl:when test="$textCount &lt; 40">3</xsl:when>
    <xsl:when test="$textCount &lt; 50">4</xsl:when>   
    <xsl:when test="$textCount &lt; 60">5</xsl:when>
    <xsl:when test="$textCount &lt; 70">6</xsl:when>
    
    <xsl:when test="$textCount &lt; 80">7</xsl:when>
    <xsl:when test="$textCount &lt; 90">8</xsl:when>
    <xsl:when test="$textCount &lt; 100">9</xsl:when>
    <xsl:when test="$textCount = 100">10</xsl:when>
   </xsl:choose>
   <!-- $textcount div 10 -->
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
    <xsl:when test="$femalePerc &lt; 80">6</xsl:when>
    <xsl:when test="$femalePerc &lt; 90">3</xsl:when>
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
    <xsl:when test="$reprintPerc = 0">0</xsl:when>    
    <xsl:when test="$reprintPerc &lt; 5">1</xsl:when>
    <xsl:when test="$reprintPerc &lt; 9">2</xsl:when>
    <xsl:when test="$reprintPerc &lt; 12">3</xsl:when>
    <xsl:when test="$reprintPerc &lt; 15">4</xsl:when>
    <xsl:when test="$reprintPerc &lt; 18">5</xsl:when>
    <xsl:when test="$reprintPerc &lt; 21">6</xsl:when>
    <xsl:when test="$reprintPerc &lt; 24">7</xsl:when>
    <xsl:when test="$reprintPerc &lt; 27">8</xsl:when>
    <xsl:when test="$reprintPerc &lt; 30">9</xsl:when>
    <xsl:when test="$reprintPerc &lt; 40">10</xsl:when>
    <xsl:when test="$reprintPerc &lt; 60">11</xsl:when>
    <xsl:when test="$reprintPerc &lt; 71">10</xsl:when>
    
    <xsl:when test="$reprintPerc &lt; 81">6</xsl:when>
    <xsl:when test="$reprintPerc &lt; 91">3</xsl:when>
     <xsl:otherwise>0</xsl:otherwise>
   </xsl:choose>
  </xsl:variable>

  <xsl:variable name="shortPerc">
   <xsl:value-of select="count(//e:size[@key = 'short']) div $textCount * 100"/>
  </xsl:variable>

  <xsl:variable name="shortScore">
   <xsl:choose>
    <xsl:when test="$shortPerc = 0">0</xsl:when>    
    <xsl:when test="$shortPerc &lt; 4">1</xsl:when>    
    <xsl:when test="$shortPerc &lt; 6">2</xsl:when>
    <xsl:when test="$shortPerc &lt; 8">3</xsl:when>
    <xsl:when test="$shortPerc &lt; 10">4</xsl:when>
    <xsl:when test="$shortPerc &lt; 12">5</xsl:when>
    <xsl:when test="$shortPerc &lt; 14">6</xsl:when>
    <xsl:when test="$shortPerc &lt; 16">7</xsl:when>
    <xsl:when test="$shortPerc &lt; 18">8</xsl:when>
    <xsl:when test="$shortPerc &lt; 20">9</xsl:when>
    <xsl:when test="$shortPerc &lt; 30">10</xsl:when>
    <xsl:when test="$shortPerc &lt; 37">11</xsl:when>
    <xsl:when test="$shortPerc &lt; 61">10</xsl:when>
    <xsl:when test="$shortPerc &lt; 71">9</xsl:when>
    <xsl:when test="$shortPerc &lt; 81">8</xsl:when>
    <xsl:when test="$shortPerc &lt; 91">5</xsl:when>  
    <xsl:otherwise>2</xsl:otherwise>
   </xsl:choose>
  </xsl:variable>

  <xsl:variable name="longPerc">
   <xsl:value-of select="count(//e:size[@key = 'long']) div $textCount * 100"/>
  </xsl:variable>

  <xsl:variable name="longScore">
   <xsl:choose>
    <xsl:when test="$longPerc = 0">0</xsl:when>    
    <xsl:when test="$longPerc &lt; 4">1</xsl:when>    
    <xsl:when test="$longPerc &lt; 6">2</xsl:when>
    <xsl:when test="$longPerc &lt; 8">3</xsl:when>
    <xsl:when test="$longPerc &lt; 10">4</xsl:when>
    <xsl:when test="$longPerc &lt; 12">5</xsl:when>
    <xsl:when test="$longPerc &lt; 14">6</xsl:when>
    <xsl:when test="$longPerc &lt; 16">7</xsl:when>
    <xsl:when test="$longPerc &lt; 18">8</xsl:when>
    <xsl:when test="$longPerc &lt; 20">9</xsl:when>
    <xsl:when test="$longPerc &lt; 30">10</xsl:when>
    <xsl:when test="$longPerc &lt; 37">11</xsl:when>
    <xsl:when test="$longPerc &lt; 61">10</xsl:when>
    <xsl:when test="$longPerc &lt; 71">9</xsl:when>
    <xsl:when test="$longPerc &lt; 81">8</xsl:when>
    <xsl:when test="$longPerc &lt; 91">5</xsl:when>  
    <xsl:otherwise>2</xsl:otherwise>
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
  <xsl:variable name="triplePerc">
   <xsl:value-of select="$tripleCount div $textCount * 100"/>
  </xsl:variable>
  
  <xsl:variable name="tripleScore">
   <xsl:choose>
    <xsl:when test="$triplePerc &lt; 3">0</xsl:when>    
    <xsl:when test="$triplePerc &lt; 6">2</xsl:when> 
    <xsl:when test="$triplePerc &lt; 9">3</xsl:when> 
    <xsl:when test="$triplePerc &lt; 12">4</xsl:when> 
    <xsl:when test="$triplePerc &lt; 15">5</xsl:when> 
    <xsl:when test="$triplePerc &lt; 18">6</xsl:when> 
    <xsl:when test="$triplePerc &lt; 21">7</xsl:when>
    <xsl:when test="$triplePerc &lt; 24">8</xsl:when>
    <xsl:when test="$triplePerc &lt; 27">9</xsl:when>
    <xsl:when test="$triplePerc &lt; 34">10</xsl:when>
    <xsl:when test="$triplePerc &lt; 37">9</xsl:when>
    <xsl:when test="$triplePerc &lt; 40">8</xsl:when>
    <xsl:when test="$triplePerc &lt; 55">7</xsl:when>
    <xsl:when test="$triplePerc &lt; 70">6</xsl:when>
    <xsl:when test="$triplePerc &lt; 85">3</xsl:when>  
       <xsl:otherwise>0</xsl:otherwise>
   </xsl:choose>
  </xsl:variable>

  <xsl:variable name="singleCount">
   <xsl:value-of select="count(tokenize($authCounts, '1')) - 1"/>
  </xsl:variable>
  <xsl:variable name="singlePerc">
   <xsl:value-of select="$singleCount div $textCount * 100"/>
  </xsl:variable>
  
  <xsl:variable name="singleScore">
   <xsl:choose>
    <xsl:when test="$singlePerc &lt; 10">0</xsl:when>
    <xsl:when test="$singlePerc &lt; 20">1</xsl:when>
    <xsl:when test="$singlePerc &lt; 30">2</xsl:when>
    <xsl:when test="$singlePerc &lt; 35">3</xsl:when>
    <xsl:when test="$singlePerc &lt; 40">4</xsl:when>
    <xsl:when test="$singlePerc &lt; 45">5</xsl:when>
    <xsl:when test="$singlePerc &lt; 50">6</xsl:when>
    <xsl:when test="$singlePerc &lt; 55">7</xsl:when>
    <xsl:when test="$singlePerc &lt; 60">8</xsl:when>
    <xsl:when test="$singlePerc &lt; 67">9</xsl:when>
    <xsl:when test="$singlePerc &lt; 74">10</xsl:when>
    <xsl:when test="$singlePerc &lt; 77">9</xsl:when>
    <xsl:when test="$singlePerc &lt; 80">8</xsl:when>
    <xsl:when test="$singlePerc &lt; 85">7</xsl:when>   
    <xsl:when test="$singlePerc &lt; 90">6</xsl:when>
    <xsl:when test="$singlePerc &lt; 95">3</xsl:when>   
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
   <xsl:variable name="rangeScore">
   <xsl:choose>
    <xsl:when test="$rangeCount &lt; 10">10</xsl:when>
    <xsl:when test="$rangeCount &lt; 15">9</xsl:when>  
    <xsl:when test="$rangeCount &lt; 20">8</xsl:when> 
    <xsl:when test="$rangeCount &lt; 25">7</xsl:when>
    <xsl:when test="$rangeCount &lt; 30">6</xsl:when>
    <xsl:when test="$rangeCount &lt; 40">5</xsl:when>
    <xsl:when test="$rangeCount &lt; 50">4</xsl:when>
    <xsl:when test="$rangeCount &lt; 60">3</xsl:when>
    <xsl:when test="$rangeCount &lt; 70">2</xsl:when>
    <xsl:when test="$rangeCount &lt; 80">1</xsl:when>    
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
     <xsl:with-param name="score"><xsl:value-of select="$tripleScore"/></xsl:with-param>
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
