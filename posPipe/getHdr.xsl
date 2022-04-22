<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:t="http://www.tei-c.org/ns/1.0"
    xpath-default-namespace="http://www.tei-c.org/ns/1.0"
    xmlns:e="http://distantreading.net/eltec/ns" exclude-result-prefixes="xs t e" version="2.0">
<xsl:output omit-xml-declaration="yes"/>
 
 <!-- extracts just the teiHeader, prefixing it with a TEI start-tag only (yik)
      To be used with care!  -->
 <xsl:variable name="today">
  <xsl:value-of select="format-date(current-date(), '[Y0001]-[M01]-[D01]')"/>
 </xsl:variable>
    <xsl:template match="t:teiHeader | @* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>

   <xsl:template match="/">
    <xsl:text disable-output-escaping="yes">&lt;TEI xmlns="http://www.tei-c.org/ns/1.0" xml:lang='</xsl:text>
    <xsl:value-of select="t:TEI/@xml:lang"/>
    <xsl:text disable-output-escaping="yes">' xml:id="</xsl:text>
    <xsl:value-of select="t:TEI/@xml:id"/>
    <xsl:text disable-output-escaping="yes">">
</xsl:text>
    <xsl:apply-templates select="t:TEI/t:teiHeader"/>
   </xsl:template>
    
    <xsl:template match="t:revisionDesc">
        <revisionDesc xmlns="http://www.tei-c.org/ns/1.0">
        <change when="{$today}">Re-apply POS tagging</change>
        <xsl:apply-templates/>
        </revisionDesc>
    </xsl:template>

<xsl:template match="t:encodingDesc">
 <encodingDesc xmlns="http://www.tei-c.org/ns/1.0">
  <xsl:attribute name="n">
   <xsl:text>eltec-2</xsl:text>
  </xsl:attribute><p/>
 </encodingDesc>
</xsl:template>
</xsl:stylesheet>
