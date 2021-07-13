<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:t="http://www.tei-c.org/ns/1.0"
    xpath-default-namespace="http://www.tei-c.org/ns/1.0"
    xmlns:e="http://distantreading.net/eltec/ns" exclude-result-prefixes="xs e" version="2.0">
<xsl:output omit-xml-declaration="yes"/>
 
  <!-- just output text content in xml with no whitespace 
        dirtyhack: replace ampersand by plus sign so as not to confuse tt -->  

    <xsl:template match="/">
    <xsl:apply-templates select="//t:text"/>
    </xsl:template>

 <xsl:template match=" @* | node()">
  <xsl:copy>
   <xsl:apply-templates select="@* | node()"/>
  </xsl:copy>
 </xsl:template>
 
 <xsl:template match="text()" priority="1">
   <xsl:value-of select="normalize-space(replace(.,'&amp;','+'))"/>  
  </xsl:template>
</xsl:stylesheet>
