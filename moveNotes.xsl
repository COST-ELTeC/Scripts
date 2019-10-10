<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xpath-default-namespace="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="xs"
    version="2.0">
   
    <xsl:variable name="textId">
        <xsl:value-of select="TEI/@xml:id"/>
    </xsl:variable>
    
   <xsl:template match="note">
       <ref xmlns="http://www.tei-c.org/ns/1.0" target="{concat('#',$textId,'_N',position())}"/>
   </xsl:template>
    
    <xsl:template match="text[not(back)]">
        <text xmlns="http://www.tei-c.org/ns/1.0"> 
            <xsl:apply-templates/>
        <back xmlns="http://www.tei-c.org/ns/1.0">
            <div type="notes">
                <xsl:for-each select="body//note">
                    <note>
                        <xsl:attribute name="xml:id">
                            <xsl:value-of select="concat($textId,'_N',position())"/>
                        </xsl:attribute>
                        <xsl:value-of select="."/>
                    </note><xsl:text>
</xsl:text>
                </xsl:for-each>          
            </div>
        </back></text>
    </xsl:template>
    
    <xsl:template match="back">
        <xsl:apply-templates/>
        <div type="notes">
            <xsl:for-each select="body//note">
                <note>
                    <xsl:attribute name="xml:id">
                        <xsl:value-of select="concat($textId,'_N',position())"/>
                    </xsl:attribute>
                    <xsl:value-of select="."/>
                </note>
            </xsl:for-each>          
        </div>
    </xsl:template>
    
    <!-- Basically, an identity transform -->
    <xsl:template match="/ | @* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>
    
    
</xsl:stylesheet>