<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
 xmlns:xs="http://www.w3.org/2001/XMLSchema"
 xmlns:t="http://www.tei-c.org/ns/1.0" 
 xmlns="http://www.tei-c.org/ns/1.0" 
 version="2.0">
 
 
 <xsl:template match="* | @* | processing-instruction()">
  <xsl:copy>
   <xsl:apply-templates select="* | @* | processing-instruction() | comment() | text()"/>
  </xsl:copy>
 </xsl:template>
 <xsl:template match="text()">
  <xsl:value-of select="."/>
  <!-- could normalize() here -->
 </xsl:template>
 
 <xsl:template match="//t:div/t:p[1]/t:hi[1][not(preceding-sibling::text())]">
  <xsl:message><xsl:value-of select="."/></xsl:message>
  <xsl:apply-templates/>
 </xsl:template>
 

</xsl:stylesheet>