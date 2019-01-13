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

                <xsl:variable name="status">
                    <xsl:value-of select="$textCount"/>
                    <xsl:text> texts containing </xsl:text>
                    <xsl:value-of select="$wordCount"/>
                    <xsl:text> words</xsl:text>
                </xsl:variable>

                <xsl:if test="$catalog = 'yes'">
<h4><xsl:value-of select="$status"/></h4>                    
<p>Click on a column heading to sort by that data.</p>
                    <table class="catalogue" id="theTable">
                        <tr class="label">
                            <th onclick="sortTable(0)">Identifier</th>
                            <th onclick="sortTable(1)">Encoding</th>
                            <th onclick="sortTable(2)">Page count</th>
                            <th onclick="sortTable(3)">Word count (Size)</th>
                            <th onclick="sortTable(4)">Date (Slot)</th>
                            <th onclick="sortTable(5)">Title</th>
                            <th onclick="sortTable(6)">Author</th>
                            <th onclick="sortTable(7)">Sex</th>
                            <th onclick="sortTable(8)">Reprints</th>
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
                                            test="t:fileDesc/t:sourceDesc//t:bibl[@type = 'copyText']">
                                            <xsl:value-of
                                                select="t:fileDesc/t:sourceDesc//t:bibl[@type =
                                                'copyText'][1]/t:date"
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
                
                <script>
                    function sortTable(n) {
                    var table, rows, switching, i, x, y, shouldSwitch, dir, switchcount = 0;
                    table = document.getElementById("theTable");
                    switching = true;
                    //Set the sorting direction to ascending:
                    dir = "asc"; 
                    /*Make a loop that will continue until
                    no switching has been done:*/
                    while (switching) {
                    //start by saying: no switching is done:
                    switching = false;
                    rows = table.rows;
                    /*Loop through all table rows (except the
                    first, which contains table headers):*/
                    for (i = 1; i &lt; (rows.length - 1); i++) {
                    //start by saying there should be no switching:
                    shouldSwitch = false;
                    /*Get the two elements you want to compare,
                    one from current row and one from the next:*/
                    x = rows[i].getElementsByTagName("td")[n];
                    y = rows[i + 1].getElementsByTagName("td")[n];
                    /*check if the two rows should switch place,
                    based on the direction, asc or desc:*/
                    if (dir == "asc") {
                    if (x.innerHTML.toLowerCase() > y.innerHTML.toLowerCase()) {
                    //if so, mark as a switch and break the loop:
                    shouldSwitch= true;
                    break;
                    }
                    } else if (dir == "desc") {
                    if (x.innerHTML.toLowerCase() &lt; y.innerHTML.toLowerCase()) {
                    //if so, mark as a switch and break the loop:
                    shouldSwitch = true;
                    break;
                    }
                    }
                    }
                    if (shouldSwitch) {
                    /*If a switch has been marked, make the switch
                    and mark that a switch has been done:*/
                    rows[i].parentNode.insertBefore(rows[i + 1], rows[i]);
                    switching = true;
                    //Each time a switch is done, increase this count by 1:
                    switchcount ++;      
                    } else {
                    /*If no switching has been done AND the direction is "asc",
                    set the direction to "desc" and run the while loop again.*/
                    if (switchcount == 0 &amp;&amp; dir == "asc") {
                    dir = "desc";
                    switching = true;
                    }
                    }
                    }
                    }
                </script>
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
