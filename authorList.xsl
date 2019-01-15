<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    
    exclude-result-prefixes="xs t"
    xmlns:t="http://www.tei-c.org/ns/1.0"
    version="2.0">
  
<xsl:template match="/">
<list>
    <xsl:for-each select="t:teiCorpus/t:TEI/t:teiHeader/t:fileDesc/t:titleStmt">
<xsl:sort select="t:author[1]"/>
<author>
    <xsl:choose><xsl:when test="t:author/@ref">
        <xsl:copy select="t:author[1]/@ref"/>    
    </xsl:when>
    <xsl:otherwise><xsl:attribute name="ref">viaf:000000</xsl:attribute></xsl:otherwise>
</xsl:choose>    
    <xsl:attribute name="n"><xsl:value-of select="ancestor::t:TEI/@xml:id"/></xsl:attribute>
     <xsl:value-of select="normalize-space(t:author[1])"/></author><xsl:text>
</xsl:text>    </xsl:for-each>
</list>
</xsl:template>  
</xsl:stylesheet>