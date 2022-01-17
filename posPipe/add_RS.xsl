
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
 xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs h t e"
 xmlns:h="http://www.w3.org/1999/xhtml" xmlns:t="http://www.tei-c.org/ns/1.0"
 xmlns:e="http://distantreading.net/eltec/ns" xmlns="http://www.tei-c.org/ns/1.0" version="2.0">

 <!-- add rs element for each sequence of PROPN found within a p head or l -->
 
<xsl:template match="t:p | t:head | t:l">
  <xsl:variable name="nodeNum">
   <xsl:value-of
    select="concat(ancestor::t:TEI/@xml:id, format-number(count(preceding::node()[name() eq 'p' or name() eq 'head' or name() eq 'l']), '0000'))"
   />
  </xsl:variable>
  <xsl:copy>

  <xsl:for-each-group select="*" group-adjacent="boolean(self::t:w[@pos='PROPN'])">
  <xsl:choose>
   <xsl:when test="current-grouping-key()">
   <rs>
    <xsl:for-each select="current-group()">
     <xsl:copy>
      <xsl:apply-templates select="@* | node()"/>
     </xsl:copy><xsl:text> </xsl:text>
    </xsl:for-each>
   </rs>
   </xsl:when>
   <xsl:otherwise>
    <xsl:for-each select="current-group()">
     <xsl:copy>
      <xsl:apply-templates select="@* | node()"/>
     </xsl:copy>
    </xsl:for-each>
   </xsl:otherwise>
  </xsl:choose>
  </xsl:for-each-group> 
  </xsl:copy>
 </xsl:template>


 <xsl:template match="* | @* | processing-instruction()">
  <xsl:copy>
   <xsl:apply-templates select="* | @* | processing-instruction() | comment() | text()"/>
  </xsl:copy>
 </xsl:template>

 <xsl:template match="text()">
  <xsl:value-of select="."/>
  <!-- could normalize() here -->
 </xsl:template>
</xsl:stylesheet>
