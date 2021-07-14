<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:xi="http://www.w3.org/2001/XInclude"
    xmlns:t="http://www.tei-c.org/ns/1.0"
    xpath-default-namespace="http://www.tei-c.org/ns/1.0"
    xmlns:e="http://distantreading.net/eltec/ns" exclude-result-prefixes="xs xi e" version="2.0">
<xsl:output omit-xml-declaration="yes"/>
 
  
    <xsl:template match="/">
       <xsl:for-each select="/teiCorpus/xi:include">
       <xsl:value-of select="@href"/><xsl:text>,</xsl:text>
      </xsl:for-each>
    </xsl:template>
</xsl:stylesheet>