<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" 
    exclude-result-prefixes="xs h"
    xmlns:h="http://www.w3.org/1999/xhtml" 
    xmlns:t="http://www.tei-c.org/ns/1.0"    
    xmlns="http://www.tei-c.org/ns/1.0" 
    version="2.0">
  
  <xsl:template match="/">
      <xsl:message><xsl:value-of select="count(//t:text)"/><xsl:text> texts </xsl:text>
   <xsl:value-of select="count(//t:text[t:front])"/><xsl:text> fronts  </xsl:text>
   <xsl:value-of select="count(//t:text[t:front/t:div[@type='titlepage']])"/><xsl:text> titlepages </xsl:text>
</xsl:message>
  <!-- <xsl:result-document href=""></xsl:result-document>
-->   <xsl:apply-templates select="//t:front"/>
  </xsl:template>
 
  <xsl:template match="t:front">
 <xsl:if test="t:div[@type='titlepage']">
    <xsl:value-of select="ancestor::t:TEI/@xml:id"/>
    <xsl:text> : </xsl:text>
    <xsl:apply-templates select="t:div[@type='titlepage']"/>
   <xsl:text>
</xsl:text></xsl:if>
  </xsl:template>
 
 <xsl:template match="t:p">
  <xsl:value-of select="normalize-space(.)"/>
  <xsl:text>|</xsl:text>
 </xsl:template>
 
    <!--<xsl:template match="* | @* | processing-instruction()">
        <xsl:copy>
            <xsl:apply-templates select="* | @* | processing-instruction() | comment() | text()"/>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="text()">
        <xsl:value-of select="."/>
        <!-\- could normalize() here -\->
    </xsl:template>-->
 
 <xsl:template match="text()"/>
  
</xsl:stylesheet>