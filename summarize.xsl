<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:t="http://www.tei-c.org/ns/1.0"
    xmlns:e="http://distantreading.net/eltec/ns" exclude-result-prefixes="xs t e" version="2.0">
    <xsl:output method="html"/>

    <xsl:param name="corpus">XXX</xsl:param>
    <xsl:param name="catalog">yes</xsl:param>

    <xsl:template match="/">

        <xsl:variable name="textCount">
            <xsl:value-of select="count(//t:text)"/>
        </xsl:variable>
        <xsl:variable name="wordCount">
            <xsl:value-of select="xs:integer(sum(//t:measure[@unit = 'words']))"/>
        </xsl:variable>

        <tr>
            <td class="lang">
                <a>
                    <xsl:attribute name="href">
                        <xsl:value-of select="concat($corpus, '/index.html')"/>
                    </xsl:attribute>
                    <xsl:value-of select="$corpus"/>
                </a>
            </td>
            <td>
                <xsl:value-of select="$textCount"/>
            </td>
            <td>
                <xsl:value-of select="$wordCount"/>
            </td>
            <td class="sep">
                <xsl:value-of select="count(//e:authorGender[@key = 'M'])"/>
            </td>
            <td>
                <xsl:value-of select="count(//e:authorGender[@key = 'F'])"/>
            </td>
            <td class="sep">
                <xsl:value-of select="count(//e:size[@key = 'short'])"/>
            </td>
            <td>
                <xsl:value-of select="count(//e:size[@key = 'medium'])"/>
            </td>
            <td>
                <xsl:value-of select="count(//e:size[@key = 'long'])"/>
            </td>
            <td class="sep">
                <xsl:value-of select="count(//e:timeSlot[@key = 'T1'])"/>
            </td>
            <td>
                <xsl:value-of select="count(//e:timeSlot[@key = 'T2'])"/>
            </td>
            <td>
                <xsl:value-of select="count(//e:timeSlot[@key = 'T3'])"/>
            </td>
            <td>
                <xsl:value-of select="count(//e:timeSlot[@key = 'T4'])"/>
            </td>
                 <td class="sep">
                     <xsl:value-of select="count(//e:canonicity[@key = 'high']) + count(//e:reprintCount[@key = 'high'])"/>
                </td>
                <td>
                    <xsl:value-of select="count(//e:canonicity[@key = 'low']) + count(//e:reprintCount[@key = 'low'])"/>
                </td>
        </tr>
    </xsl:template>
</xsl:stylesheet>
