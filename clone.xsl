<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:t="http://www.tei-c.org/ns/1.0"
    xpath-default-namespace="http://www.tei-c.org/ns/1.0"
    xmlns:e="http://distantreading.net/eltec/ns" exclude-result-prefixes="xs e" version="2.0">

    <xsl:template match="/ | @* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>

   <xsl:template match="choice">
    <sic><xsl:value-of select="orig"/></sic>
   </xsl:template>
 
<xsl:template match="div1">
 <div>
  <xsl:apply-templates select="@*"/>
  <xsl:apply-templates/>
 </div>
</xsl:template>
 
 <xsl:template match="figure">
  <figure style="{@rend}" n="{@xml:id}">
   <graphic url="concat('pix:',@xml:id)"/>
   <xsl:apply-templates/>
  </figure>
 </xsl:template>

</xsl:stylesheet>
