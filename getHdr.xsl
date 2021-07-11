<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:t="http://www.tei-c.org/ns/1.0"
    xpath-default-namespace="http://www.tei-c.org/ns/1.0"
    xmlns:e="http://distantreading.net/eltec/ns" exclude-result-prefixes="xs t e" version="2.0">
<xsl:output omit-xml-declaration="yes"/>
    
    <xsl:template match="t:teiHeader | @* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>

   <xsl:template match="/">
       <teiHeader xmlns="http://www.tei-c.org/ns/1.0">
       <xsl:apply-templates select="t:TEI/t:teiHeader"/>
       </teiHeader>
   </xsl:template>
    
    <xsl:template match="t:revisionDesc">
        <revisionDesc xmlns="http://www.tei-c.org/ns/1.0">
            <change when="2021-07-17">Generated level2 tagging  </change>
        <xsl:apply-templates/>
        </revisionDesc>
    </xsl:template>

</xsl:stylesheet>
