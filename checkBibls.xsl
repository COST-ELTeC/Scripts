<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:t="http://www.tei-c.org/ns/1.0" xmlns="http://www.tei-c.org/ns/1.0" exclude-result-prefixes="xs" version="2.0">
 
 <xsl:output method="text"/>
 
 
 <xsl:template match="/">
  
  <xsl:message>
   <xsl:value-of select="t:TEI/@xml:lang"/>
   <xsl:text> </xsl:text>
   <xsl:value-of select="count(//t:text)"/>
   <xsl:text> texts of which </xsl:text>
   <xsl:value-of select="count(//t:sourceDesc/t:bibl[@type='digitalSource'])"/>
   <xsl:text> digitally-sourced and </xsl:text>
   <xsl:value-of select="count(//t:sourceDesc/t:bibl[@type='printSource'])"/>
   <xsl:text> print-sourced and </xsl:text>
   <xsl:value-of select="count(//t:sourceDesc/t:bibl[@type='firstEdition'])"/>
   <xsl:text> have first ed info </xsl:text>
  </xsl:message>
  
  
<xsl:text>id, digital, print, first, firstDate
</xsl:text>  
  <xsl:for-each select="//t:TEI/t:teiHeader/t:fileDesc/t:sourceDesc">
   <xsl:value-of select="ancestor::t:TEI/@xml:id"/>
   <xsl:text>,</xsl:text>
   <xsl:value-of select="count(t:bibl[@type='digitalSource'])"/>
   <xsl:text>,</xsl:text>
   <xsl:value-of select="count(t:bibl[@type='printSource'])"/>
   <xsl:text>,</xsl:text>
   <xsl:value-of select="count(t:bibl[@type='firstEdition'])"/>
   <xsl:text>,</xsl:text>  
   <xsl:value-of select="t:bibl[@type='firstEdition']/t:date"/>
   <xsl:text>
</xsl:text>

  </xsl:for-each>
 </xsl:template>

</xsl:stylesheet>
