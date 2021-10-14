<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:t="http://www.tei-c.org/ns/1.0"
    xpath-default-namespace="http://www.tei-c.org/ns/1.0"
    xmlns:e="http://distantreading.net/eltec/ns" 
    exclude-result-prefixes="xs e t" version="2.0">
<xsl:output omit-xml-declaration="yes"/>
 
  <!-- just output text content in xml with no extra whitespace 
       also :
          add <s> tags within <head> and <p>
          dirtyhack: replace ampersand by plus sign so as not to confuse tt 
          suppress xml comments        
  -->  

    <xsl:template match="/">
    <xsl:apply-templates select="//t:text"/>
    </xsl:template>

 <xsl:template match=" @* | node()">
  <xsl:copy>
   <xsl:apply-templates select="@* | node()"/>
  </xsl:copy>
 </xsl:template>
 
 <xsl:template match="comment()" priority="1"/>
 
 <xsl:template match="text()" priority="1">
   <xsl:value-of select="normalize-space(replace(.,'&amp;','+'))"/>  
  </xsl:template>
 
 <xsl:template match="t:head|t:p">
  <xsl:copy>
   <s xmlns="http://www.tei-c.org/ns/1.0">
    <xsl:apply-templates/>
   </s>
  </xsl:copy>
 </xsl:template>
</xsl:stylesheet>
