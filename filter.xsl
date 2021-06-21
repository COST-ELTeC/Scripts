<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
 xmlns:xs="http://www.w3.org/2001/XMLSchema"
 xmlns:t="http://www.tei-c.org/ns/1.0"
 exclude-result-prefixes="xs t"
 version="2.0">
 <xsl:output media-type="text"/>
 
 <xsl:param name="output">lemma</xsl:param>
 <xsl:param name="pos">NOUN</xsl:param>
 <xsl:template match="/">
  <xsl:apply-templates select="//t:div[@type='chapter']//t:w[@pos eq $pos]"/>
 </xsl:template> 
 
 <xsl:template match="t:w">
  <xsl:choose>
   <xsl:when test="$output eq 'lemma'">
    <xsl:value-of select="@lemma"/>
   </xsl:when>
   <xsl:when test="$output eq 'form'">
    <xsl:value-of select="."/>
   </xsl:when>
   <xsl:otherwise/>
  </xsl:choose>
  <xsl:text> </xsl:text>
 </xsl:template>
 
</xsl:stylesheet>