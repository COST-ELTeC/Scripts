<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
 xmlns:xs="http://www.w3.org/2001/XMLSchema"
 xmlns:t="http://www.tei-c.org/ns/1.0"
 exclude-result-prefixes="xs t"
 version="2.0">
 
 <xsl:output omit-xml-declaration="yes"/>
 
  <xsl:template match="/">
   <frequencies>
    <xsl:for-each-group group-by="." select="//t:w[@pos='VERB']/@lemma">
<!--  select= "for $w in tokenize(string(.), '\W+') return lower-case($w)">
-->  
     <xsl:sort select="count(current-group())" order="descending"/>
     <xsl:variable name="freq" select="count(current-group())"/>
<xsl:if test="$freq &gt; 100">
    <lemma form="{current-grouping-key()}"
      freq="{$freq}"/>
     <xsl:text>
     </xsl:text>
 </xsl:if>
    </xsl:for-each-group>
   </frequencies>
  </xsl:template>

 
</xsl:stylesheet>