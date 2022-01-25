
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
 xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs h t e"
 xmlns:h="http://www.w3.org/1999/xhtml" xmlns:t="http://www.tei-c.org/ns/1.0"
 xmlns:e="http://distantreading.net/eltec/ns" xmlns="http://www.tei-c.org/ns/1.0" version="2.0">

 <!-- add s element for each segment ending pc@n='SENT' within a p or head or l 
     also generates identifier for same
      run this after addRS -->
 
<xsl:template match="t:p | t:head | t:l | t:quote">
  <xsl:variable name="textNum">
   <xsl:value-of
    select="ancestor::t:TEI/@xml:id"
   />
  </xsl:variable>
  <xsl:copy>
<xsl:for-each-group select="*" group-ending-with="t:pc[@n = 'SENT']">
    <s xmlns="http://www.tei-c.org/ns/1.0">
   <xsl:attribute name="xml:id">
 <!--   <xsl:value-of select="concat($textNum, '_', format-number(count(preceding::*),'000000'))"/>   
--><xsl:value-of select="concat($textNum, '_', generate-id())"/>   
  <!-- generate_id() runs about 10 tems as fast as count() -->  
     </xsl:attribute>   
   <xsl:for-each select="current-group()">
       <xsl:copy>
       <xsl:apply-templates select="@* | node()"/>
      </xsl:copy><xsl:text>
</xsl:text>
     </xsl:for-each>
    </s>
    <xsl:text>
</xsl:text>
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
