<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xpath-default-namespace="http://www.tei-c.org/ns/1.0"
    xmlns:e="http://distantreading.net/eltec/ns" exclude-result-prefixes="xs e" version="2.0">

    <xsl:template match="/ | @* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>

<xsl:template match="foreign/@xml:lang">
    <xsl:attribute name="xml:lang"> 
     <xsl:choose>
      <xsl:when test="matches(.,'([A-Z][A-Z])')">
       <xsl:value-of select="lower-case(.)"/>
      </xsl:when>
      <xsl:otherwise>
       <xsl:value-of select="."/>
      </xsl:otherwise>
     </xsl:choose></xsl:attribute>
    </xsl:template>

 <xsl:template match="TEI/@xml:lang">
<xsl:attribute name="xml:lang">
  <xsl:choose>
   <xsl:when test="contains(.,'-C')">
    <xsl:value-of select="substring-before(.,'-')"/>
   </xsl:when>
   <xsl:otherwise>
    <xsl:value-of select="."/>
   </xsl:otherwise>
  </xsl:choose>
</xsl:attribute>
 </xsl:template>
 
 <xsl:template match="language/@ident">
  <xsl:attribute name="ident">
   <xsl:choose>
   <xsl:when test=". = 'sr'">sr-Cyrl</xsl:when>
   <xsl:otherwise>
    <xsl:value-of select="."/>
   </xsl:otherwise>
  </xsl:choose>
  </xsl:attribute>
 </xsl:template>
  

</xsl:stylesheet>
