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

   <xsl:template match="@rend">
       <xsl:choose>
           <xsl:when test=". eq 'sc'">smallcaps</xsl:when>
           <xsl:otherwise><xsl:value-of select="."/></xsl:otherwise>
       </xsl:choose>
   </xsl:template>
</xsl:stylesheet>
