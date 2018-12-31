<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:t="http://www.tei-c.org/ns/1.0"
    xmlns:e="http://distantreading.net/eltec/ns" exclude-result-prefixes="xs t e" version="2.0">
    <xsl:output method="html"/>

    <xsl:param name="corpus">XXX</xsl:param>
    <xsl:param name="catalog">yes</xsl:param>

    <xsl:template match="/">
        <html>
            <head>
                <meta http-equiv="Content-Type" content="text/html"/>
                <link rel="stylesheet" type="text/css"
                    href="https://distantreading.github.io/css/eltec-styler.css"/>

                <title>ELTeC reporter</title>
            </head>
            <body>
                <xsl:variable name="textCount">
                    <xsl:value-of select="count(//t:text)"/>
                </xsl:variable>
                <xsl:variable name="wordCount">
                    <xsl:value-of select="xs:integer(sum(//t:measure[@unit = 'words']))"/>
                </xsl:variable>

                <xsl:message>
                    <xsl:value-of select="$textCount"/>
                    <xsl:text> texts found containing </xsl:text>
                    <xsl:value-of select="$wordCount"/>
                    <xsl:text> words</xsl:text>
                </xsl:message>

                <xsl:if test="$catalog = 'yes'">

                    <table class="catalogue">
                        <tr class="label">
                            <td>Identifier</td>
                            <td>Encoding</td>
                            <td>Page count</td>
                            <td>Word count (Size)</td>
                            <td>Date (Slot)</td>
                            <td>Title</td>
                            <td>Author</td>
                            <td>Sex</td>
                            <td>Reprints</td>
                        </tr>
                        <xsl:for-each select="t:teiCorpus/t:TEI/t:teiHeader">
                            <xsl:sort select="ancestor::t:TEI/@xml:id"/>
                            <tr>
                                <xsl:variable name="wc">
                                    <xsl:choose>
                                        <xsl:when
                                            test="t:fileDesc/t:extent/t:measure[@unit = 'words']">
                                            <xsl:value-of
                                                select="t:fileDesc/t:extent/t:measure[@unit = 'words']"
                                            />
                                        </xsl:when>
                                        <xsl:otherwise>0</xsl:otherwise>
                                    </xsl:choose>

                                </xsl:variable>
                                <xsl:variable name="pc">
                                    <xsl:value-of
                                        select="t:fileDesc/t:extent/t:measure[@unit = 'pages']"/>
                                </xsl:variable>

                                <xsl:variable name="date">

                                    <xsl:choose>

                                        <xsl:when
                                            test="t:fileDesc/t:sourceDesc//t:relatedItem[@type = 'copyText']">
                                            <xsl:value-of
                                                select="t:fileDesc/t:sourceDesc//t:relatedItem[@type = 'copyText']/t:bibl/t:date"
                                            />
                                        </xsl:when>
                                        <xsl:when
                                            test="t:fileDesc/t:sourceDesc/t:bibl[@type = 'copyText']">
                                            <xsl:value-of
                                                select="t:fileDesc/t:sourceDesc/t:bibl[@type = 'copyText']/t:date"
                                            />
                                        </xsl:when>
                                        <xsl:when
                                            test="t:fileDesc/t:sourceDesc/t:bibl[@type = 'edition-first']">
                                            <xsl:value-of
                                                select="t:fileDesc/t:sourceDesc/t:bibl[@type = 'edition-first']/t:date"
                                            />
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:text>???? </xsl:text>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:variable>
                                <xsl:variable name="claimedSize">
                                    <xsl:value-of select="t:profileDesc/t:textDesc/e:size/@key"/>
                                </xsl:variable>

                                <td>
                                    <xsl:value-of select="ancestor::t:TEI/@xml:id"/>
                                </td>
                                <td>
                                    <xsl:value-of select="t:encodingDesc/@n"/>
                                </td>
                                <td>
                                    <xsl:value-of select="$pc"/>
                                </td>
                                <td>
                                    <xsl:value-of select="$wc"/> (<xsl:value-of
                                        select="$claimedSize"/>) <xsl:value-of
                                        select="e:checkSize($wc, $claimedSize)"/>
                                </td>
                                <td>
                                    <xsl:value-of select="$date"/> ( <xsl:value-of
                                        select="t:profileDesc/t:textDesc/e:timeSlot/@key"/>) </td>

                                <td>
                                    <xsl:value-of select="t:fileDesc/t:titleStmt/t:title[1]"/>
                                </td>
                                <td>
                                    <xsl:value-of select="t:fileDesc/t:titleStmt/t:author[1]/text()"
                                    />
                                </td>
                                <td>
                                    <xsl:value-of
                                        select="t:profileDesc/t:textDesc/e:authorGender/@key"/>
                                </td>
                                <td>
                                    <xsl:value-of
                                        select="t:profileDesc/t:textDesc/e:canonicity/@key"/>
                                </td>

                            </tr>
                        </xsl:for-each>
                    </table>
                </xsl:if>

                <table class="balance">
                    <thead>
                        <tr>
                            <th>
                                <xsl:value-of select="$corpus"/>
                            </th>
                            <th>Balance </th><th>(<xsl:value-of select="$textCount"/> texts
                                    </th><th><xsl:value-of select="$wordCount"/> words)</th>
                        </tr>
                    </thead>

                    <tr>
                        <td class="label">authorSex</td>
                        <xsl:variable name="authorG" select="//e:authorGender"/>

                        <xsl:for-each select="e:showBalance($authorG, $textCount, 'M,F,U')">
                            <xsl:choose>
                                <xsl:when test="ends-with(., '!')">
                                    <td class="red">
                                        <xsl:value-of select="."/>
                                    </td>
                                </xsl:when>
                                <xsl:otherwise>
                                    <td>
                                        <xsl:value-of select="."/>
                                    </td>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:for-each>
                    </tr>
                    <tr>
                        <td class="label">novelSize</td>
                        <xsl:variable name="size" select="//e:size"/>

                        <xsl:for-each select="e:showBalance($size, $textCount, 'short,medium,long')">
                            <xsl:choose>
                                <xsl:when test="ends-with(., '!')">
                                    <td class="red">
                                        <xsl:value-of select="."/>
                                    </td>
                                </xsl:when>
                                <xsl:otherwise>
                                    <td>
                                        <xsl:value-of select="."/>
                                    </td>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:for-each>

                    </tr>
                    <tr>
                        <td class="label">canonicity</td>
                        <xsl:variable name="canonicity" select="//e:canonicity"/>

                        <xsl:for-each
                            select="e:showBalance($canonicity, $textCount, 'low,medium,high')">
                            <xsl:choose>
                                <xsl:when test="ends-with(., '!')">
                                    <td class="red">
                                        <xsl:value-of select="."/>
                                    </td>
                                </xsl:when>
                                <xsl:otherwise>
                                    <td>
                                        <xsl:value-of select="."/>
                                    </td>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:for-each>

                    </tr>
                    <tr>
                        <td class="label">period</td>
                        <xsl:variable name="timeSlot" select="//e:timeSlot"/>
                        <xsl:for-each select="e:showBalance($timeSlot, $textCount, 'T1,T2,T3,T4')">
                            <xsl:choose>
                                <xsl:when test="ends-with(., '!')">
                                    <td class="red">
                                        <xsl:value-of select="."/>
                                    </td>
                                </xsl:when>
                                <xsl:otherwise>
                                    <td>
                                        <xsl:value-of select="."/>
                                    </td>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:for-each>


                    </tr>
                </table>
            </body>
        </html>

    </xsl:template>
    <xsl:function name="e:checkSize">
        <xsl:param name="count" as="xs:integer"/>
        <xsl:param name="code"/>
        <xsl:variable name="actualCode">
            <xsl:choose>
                <xsl:when test="$count lt 50000">short</xsl:when>
                <xsl:when test="$count lt 100000">medium</xsl:when>
                <xsl:when test="$count gt 100000">long</xsl:when>
            </xsl:choose>
        </xsl:variable>
        <xsl:if test="$code ne $actualCode"> !!</xsl:if>
    </xsl:function>

    <xsl:function name="e:showBalance" as="item()*">
        <xsl:param name="nodes"/>
        <xsl:param name="totalVal" as="xs:integer"/>
        <xsl:param name="values" as="xs:string"/>

        <xsl:variable name="target" select="$totalVal div count(tokenize($values, ','))"/>
        <!--      <xsl:message>Target is <xsl:value-of select="$target"/></xsl:message>
  -->
        <xsl:for-each select="tokenize($values, ',')">
            <xsl:variable name="val">
                <xsl:value-of select="."/>
            </xsl:variable>
            <xsl:variable name="count">
                <xsl:value-of select="count($nodes[@key = $val])"/>
            </xsl:variable>
            <!--    <xsl:message>... count for <xsl:value-of select="$val"/> is <xsl:value-of select="$count"/></xsl:message>
     -->
            <xsl:choose>
                <xsl:when test="$target &gt; $count">
                    <xsl:value-of select="concat($val, '=', $count, '!')"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="concat($val, '=', $count)"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
    </xsl:function>
</xsl:stylesheet>
