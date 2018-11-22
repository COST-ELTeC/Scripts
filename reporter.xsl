<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:t="http://www.tei-c.org/ns/1.0"
    xmlns:e="http://distantreading.net/eltec/ns" exclude-result-prefixes="xs t e" version="2.0">
    <xsl:output method="html"/>
    
    <xsl:param name="corpus">XXX</xsl:param>
    <xsl:param name='catalog'>yes</xsl:param>
    
    <xsl:template match="/">
        <html>
            <head>
                <meta http-equiv="Content-Type" content="text/html"/>
                <title>ELTeC reporter</title>
            </head>
            <body>
                <xsl:variable name="textCount">
                    <xsl:value-of select="count(//t:text)"/>
                </xsl:variable>
                <xsl:variable name="wordCount">
                    <xsl:value-of select="xs:integer(sum(//t:measure[@unit='words']))"/>
                </xsl:variable>
                 
                <xsl:message><xsl:value-of select="$textCount"/><xsl:text> texts found containing </xsl:text>
                    <xsl:value-of select="$wordCount"/> 
                    <xsl:text> words</xsl:text></xsl:message>

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
                    <xsl:for-each select="t:teiCorpus/t:TEI/t:text">
                        <tr>
                            <xsl:variable name="wc">
                                <xsl:value-of select="../t:teiHeader/t:fileDesc/t:extent/t:measure[@unit='words']"/>
                            </xsl:variable>
                            <xsl:variable name="pc">
                                <xsl:value-of select="../t:teiHeader/t:fileDesc/t:extent/t:measure[@unit='pages']"/>
                            </xsl:variable>
                            
                            <xsl:variable name="date">
                                
                                <xsl:choose>
                                      
                                    <xsl:when test="../t:teiHeader//t:relatedItem[@type='copyText']">
                                        <xsl:value-of select="../t:teiHeader//t:sourceDesc/t:bibl/t:relatedItem[@type='copyText']/t:bibl/t:date"/>
                                    </xsl:when><xsl:when test="../t:teiHeader//t:sourceDesc/t:bibl[@type='copyText']"> 
                                        <xsl:value-of select="../t:teiHeader//t:sourceDesc/t:bibl[@type='copyText']/t:date"/> </xsl:when>
                                    <xsl:when test="../t:teiHeader//t:sourceDesc/t:bibl[@type='edition-first']"> 
                                        <xsl:value-of select="../t:teiHeader//t:sourceDesc/t:bibl[@type='edition-first']/t:date"/> </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:text>???? </xsl:text>
                                    </xsl:otherwise>
                                </xsl:choose>
                              
                          </xsl:variable>
                     
                            <td>
                                <xsl:value-of select="ancestor::t:TEI/@xml:id"/>
                            </td>
                            <td>
                                <xsl:value-of select="../t:teiHeader/t:encodingDesc/@n"/>
                            </td>
                            <td>
                                <xsl:value-of select="$pc"/> 
                            </td><td>
                                <xsl:value-of select="$wc"/> (<xsl:value-of
                                    select="../t:teiHeader/t:profileDesc/t:textDesc/e:size/@key"
                                />)
                            </td>
                            <td>
                                <xsl:value-of select="$date"/> ( <xsl:value-of
                                    select="../t:teiHeader/t:profileDesc/t:textDesc/e:timeSlot/@key"
                                />)
                            </td>
                            
                            <td>
                                <xsl:value-of
                                    select="../t:teiHeader/t:fileDesc/t:titleStmt/t:title[1]"/>
                            </td>
                            <td>
                                <xsl:value-of
                                    select="../t:teiHeader/t:fileDesc/t:titleStmt/t:author[1]/text()"
                                />
                            </td>
                            <td>
                                <xsl:value-of
                                    select="../t:teiHeader/t:profileDesc/t:textDesc/e:authorGender/@key"
                                />
                            </td>
                                     <td>
                                <xsl:value-of
                                    select="../t:teiHeader/t:profileDesc/t:textDesc/e:canonicity/@key"
                                />
                            </td>
                          
                        </tr>
                    </xsl:for-each>
                </table>
</xsl:if>
                
                <table class="balance">
                    <thead><xsl:value-of select="$corpus"/> Balance counts for <xsl:value-of 
                        select="$textCount"/> texts (<xsl:value-of 
                            select="$wordCount"/> words) </thead>
                    
                    <tr>
                        <td>authorSex</td>
                        <xsl:variable name="authorG" select="//e:authorGender"/>
                       <td> 
                        <xsl:value-of select="e:showBalance($authorG,$textCount,'M,F,U')"/>
                       </td> 
                    </tr>
                    <tr>
                        <td>novelSize</td>
                        <xsl:variable name="size" select="//e:size"/>
                        <td> 
                            <xsl:value-of select="e:showBalance($size,$textCount,'short,medium,long')"/>
                        </td> 
                    </tr>
                    <tr>
                        <td>canonicity</td>
                        <xsl:variable name="canonicity" select="//e:canonicity"/>
                        <td> 
                            <xsl:value-of select="e:showBalance($canonicity,$textCount,'low,medium,high')"/>
                        </td> 
                    </tr> <tr>
                        <td>period</td>
                        <xsl:variable name="timeSlot" select="//e:timeSlot"/>
                        <td> 
                            <xsl:value-of select="e:showBalance($timeSlot,$textCount,'T1,T2,T3,T4')"/>
                        </td> 
                    </tr>
                </table>
            </body>
        </html>

    </xsl:template>

    <xsl:function name="e:showBalance" as="item()*">
        <xsl:param name="nodes"></xsl:param>
         <xsl:param name="totalVal" as="xs:integer"/>
        <xsl:param name="values" as="xs:string"/> 
        
        <xsl:variable name="target" select="$totalVal div count(tokenize($values,','))"/>
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
     -->       <xsl:choose> 
                <xsl:when test="$target &gt; $count">
                     <xsl:value-of select="concat($val, ':', $count, '! ')"/>
            </xsl:when>
                <xsl:otherwise >
                          <xsl:value-of select="concat($val,':',$count,' ')"/>
                </xsl:otherwise>
                
            </xsl:choose>    
        </xsl:for-each>
   </xsl:function>
</xsl:stylesheet>
