<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:t="http://www.tei-c.org/ns/1.0"
    xmlns:e="http://distantreading.net/eltec/ns" exclude-result-prefixes="xs t e" version="2.0">
    <xsl:output method="text"/>

    <!--
       cligs-id,author-name,book-title,subgenre,year,year-cat,canon-cat,gender-cat,length,length-cat,counter
rd0301,Aimard,BanditsArizona,blanche,1881,T3,tbc,male,72114,medium,1

-->

    <xsl:template match="/">
        <xsl:param name="corpus"/>
        <xsl:variable name="today">
            <xsl:value-of
                select="
                    format-date(current-date(),
                    '[Y0001]-[M01]-[D01]')"
            />
        </xsl:variable>
        <xsl:variable name="textCount">
            <xsl:value-of select="count(//t:text)"/>
        </xsl:variable>
        <xsl:variable name="wordCount">
            <xsl:value-of select="xs:integer(sum(//t:measure[@unit = 'words']))"/>
        </xsl:variable>

        <xsl:variable name="status">
            <xsl:text>On </xsl:text>
            <xsl:value-of select="$today"/>
            <xsl:text> </xsl:text>
            <xsl:value-of select="$corpus"/>
            <xsl:text> has </xsl:text>
            <xsl:value-of select="$textCount"/>
            <xsl:text> texts containing </xsl:text>
            <xsl:value-of select="$wordCount"/>
            <xsl:text> words</xsl:text>
        </xsl:variable>
	
	<xsl:result-document href="metadata.csv">
	  
<xsl:text>id,author-name,book-title,subgenre,year,year-cat,canon-cat,gender-cat,length,length-cat,counter
</xsl:text>
        <xsl:for-each select="t:teiCorpus/t:TEI/t:teiHeader">
            <xsl:sort select="ancestor::t:TEI/@xml:id"/>

            <xsl:variable name="wc">
                <xsl:choose>
                    <xsl:when test="t:fileDesc/t:extent/t:measure[@unit = 'words']">
                        <xsl:value-of select="t:fileDesc/t:extent/t:measure[@unit = 'words']"/>
                    </xsl:when>
                    <xsl:otherwise>0</xsl:otherwise>
                </xsl:choose>

            </xsl:variable>
           
            <xsl:variable name="authorName">
                <xsl:value-of
                    select="substring-before(t:fileDesc/t:titleStmt/t:author[1]/text(), ',')"/>
            </xsl:variable>
            <xsl:variable name="titleName">
                <xsl:value-of select="replace(substring-before(t:fileDesc/t:titleStmt/t:title[1],':'),'[\s,]','')"/>
                     </xsl:variable>
            
            <xsl:variable name="date">
               <xsl:choose>
                   <xsl:when test="t:fileDesc/t:sourceDesc//t:bibl[@type = 'copyText']">
                       <xsl:value-of
                           select="t:fileDesc/t:sourceDesc//t:bibl[@type = 'copyText']/t:date"
                       />
                   </xsl:when>
                   <xsl:when test="t:fileDesc/t:sourceDesc/t:bibl/t:relatedItem[@type = 'copyText']">
                       <xsl:value-of
                           select="t:fileDesc/t:sourceDesc/t:bibl/t:relatedItem[@type = 'copyText']/t:bibl/t:date"
                       />
                   </xsl:when>
                    <xsl:when test="t:fileDesc/t:sourceDesc/t:bibl[@type = 'edition-first']">
                        <xsl:value-of
                            select="t:fileDesc/t:sourceDesc/t:bibl[@type = 'edition-first']/t:date"
                        />
                    </xsl:when>
                    <xsl:when test="t:fileDesc/t:sourceDesc//t:bibl[@type = 'firstEdition']">
                        <xsl:value-of
                            select="t:fileDesc/t:sourceDesc//t:bibl[@type = 'firstEdition']/t:date"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:text>????</xsl:text>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            
            <xsl:value-of select="ancestor::t:TEI/@xml:id"/>
            <xsl:text>,</xsl:text>
            <xsl:value-of select="$authorName"/>
            <xsl:text>,</xsl:text>
            <xsl:value-of select="$titleName"/>
            <xsl:text>,foo,</xsl:text>
            <xsl:value-of select="$date"/>
            <xsl:text>,</xsl:text>
            <xsl:value-of select="t:profileDesc/t:textDesc/e:timeSlot/@key"/>
            <xsl:text>,</xsl:text>
            <xsl:value-of select="t:profileDesc/t:textDesc/e:canonicity/@key"/>
            <xsl:text>,</xsl:text>
            <xsl:value-of select="t:profileDesc/t:textDesc/e:authorGender/@key"/>
            <xsl:text>,</xsl:text>
            <xsl:value-of select="$wc"/>
            <xsl:text>,</xsl:text>
            <xsl:value-of select="t:profileDesc/t:textDesc/e:size/@key"/>
            <xsl:text>,1
</xsl:text>
        </xsl:for-each>
</xsl:result-document>
    </xsl:template>
   
</xsl:stylesheet>
