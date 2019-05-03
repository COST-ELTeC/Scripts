<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:t="http://www.tei-c.org/ns/1.0"
    xmlns:e="http://distantreading.net/eltec/ns" exclude-result-prefixes="xs t e" version="2.0">
    <xsl:output method="html"/>

    <xsl:param name="corpus">XXX</xsl:param>
    <xsl:param name="catalog">yes</xsl:param>

    <xsl:template match="/">

        <xsl:element name="tagcount">
            <xsl:attribute name="corpus">
                <xsl:value-of select="$corpus"/>
            </xsl:attribute>
            <xsl:attribute name="words">
                <xsl:value-of select="xs:integer(sum(//t:measure[@unit = 'words']))"/>
            </xsl:attribute>
            
            <xsl:for-each-group select="//t:text//*" group-by="name()">
                <xsl:element name="node">
                    <xsl:attribute name="name">
                        <xsl:value-of select="current-grouping-key()"/>
                    </xsl:attribute>
                    <xsl:attribute name="count">
                        <xsl:value-of select="count(current-group())"/>
                    </xsl:attribute>
                </xsl:element>
                     
            </xsl:for-each-group>
        </xsl:element>

    </xsl:template>
</xsl:stylesheet>
