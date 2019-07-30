<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xpath-default-namespace="http://www.tei-c.org/ns/1.0" exclude-result-prefixes="xs" version="2.0">

    <xsl:param name="fixIt"/>
    <xsl:param name="verbose"/>
    <xsl:variable name="today">
        <xsl:value-of select="format-date(current-date(),'[Y0001]-[M01]-[D01]')"/>
    </xsl:variable>

<!-- Script to tidy up headers
        - check titleSmt/title and titleStmt author and warn if they are unconformant
        - check sourceDesc/bibl/@type  for valid values
            - change "copyText" to "printEdition"
            - change null value to "unspecified"
        - remove relatedItem tag
        - add change element to revisionDesc
-->
        
    <!-- IdentityTransform -->
    <xsl:template match="/ | @* | node()">
        
        <xsl:copy>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>

<xsl:template match="TEI">
    <xsl:message><xsl:value-of select="concat(@xml:id, '  ', teiHeader/fileDesc/titleStmt/title[1])"/>)</xsl:message>
    <xsl:copy>     <xsl:apply-templates select="@*"/><xsl:apply-templates/>
</xsl:copy></xsl:template>
    <xsl:template match="titleStmt/title[1]">
        <xsl:variable select="substring-before(., ': ELTeC')" name="theTitle"/>
        <xsl:message>
            <xsl:value-of select="$theTitle"/>
        </xsl:message>
        <xsl:if test="string-length($theTitle) &lt; 1">
            <xsl:message>
                <xsl:value-of select="concat(., ' is a defective title')"/>
            </xsl:message>
        </xsl:if>
        <xsl:copy>
            <xsl:apply-templates select="@*"/>
            <xsl:apply-templates/>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="titleStmt/author">
        <xsl:variable select="normalize-space(.)" name="theString"/>
        <xsl:variable select="substring-before($theString, '(')" name="theAuthor"/>
        <xsl:variable select="substring-after($theString, '(')" name="theDates"/>
        <xsl:choose>
            <xsl:when test="string-length($theAuthor) &lt; 1">
                <xsl:message>[<xsl:value-of select="$theString"/>] has no dates!</xsl:message>
            </xsl:when>
            <xsl:otherwise>
                <xsl:if test="not(matches($theAuthor, '[A-Z][a-z ]+,'))">
                    <xsl:message>[<xsl:value-of select="$theAuthor"/>] is a strange author: no
                        comma?</xsl:message>
                </xsl:if>
                <xsl:if test="not(matches($theDates, '1[789]\d\d\-1[89]\d\d\)'))">
                    <xsl:message>[<xsl:value-of select="$theString"/>] datestring is strange!
                    </xsl:message>
                </xsl:if>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:copy>
            <xsl:apply-templates select="@*"/>
            <xsl:apply-templates/>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="sourceDesc">
        <xsl:copy> <xsl:apply-templates select="bibl"/>
<xsl:apply-templates select="bibl/relatedItem/bibl"/>
</xsl:copy>  </xsl:template>
    
    <xsl:template match="bibl/relatedItem"/>
    
    <xsl:template match="relatedItem">
    <xsl:if test="$verbose">    <xsl:message>relatedItem tag suppressed</xsl:message>
     </xsl:if>   <xsl:apply-templates/>
    </xsl:template>

   <xsl:template match="bibl[not(@type)]">
    <xsl:if test="$verbose">    <xsl:message>Untyped bibl : changed to 'unspecified'</xsl:message>
    </xsl:if>    <xsl:copy>
            <xsl:attribute name="type">
                <xsl:text>unspecified</xsl:text>
            </xsl:attribute>
            <xsl:apply-templates/>
        </xsl:copy>
    </xsl:template>
<xsl:template match="div//bibl">
    <xsl:message>Misplaced bibl changed to label</xsl:message>
    <label xmlns="http://www.tei-c.org/ns/1.0"><xsl:apply-templates/></label>
</xsl:template>
    <xsl:template match="bibl/@type">
        <xsl:attribute name="type">
            <xsl:choose>
                
                <xsl:when test=". eq 'copyText'">
                <xsl:if test="$verbose">    <xsl:message>Wrongly typed bibl : changed 'copyText' to 'printSource'</xsl:message>             
                </xsl:if>    <xsl:text>printSource</xsl:text>
                </xsl:when>
                <xsl:when test=". eq 'encodedFrom'">
                 <xsl:if test="$verbose">   <xsl:message>Wrongly typed bibl : changed 'encodedFrom' to 'digitalSource'</xsl:message>
               </xsl:if>     <xsl:text>digitalSource</xsl:text>
                </xsl:when>
                <xsl:when test=". eq 'source'">
                    <xsl:if test="$verbose">   <xsl:message>Wrongly typed bibl : changed 'source' to 'digitalSource'</xsl:message>
                    </xsl:if>     <xsl:text>digitalSource</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="."/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>
    </xsl:template>
    
    
    <xsl:template match="milestone[not(@unit)]">
     <xsl:if test="$verbose">   <xsl:message>Milestone needs a unit</xsl:message>
    </xsl:if>    <milestone xmlns="http://www.tei-c.org/ns/1.0" unit="unspecified"/>
    </xsl:template>
    
    <xsl:template match="revisionDesc">
        <xsl:copy>
        <change xmlns="http://www.tei-c.org/ns/1.0" when="{$today}">Header fixed by headChecker script</change>
        <xsl:apply-templates/>
        </xsl:copy>
    </xsl:template>
</xsl:stylesheet>
