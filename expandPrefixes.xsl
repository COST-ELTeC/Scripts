<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
 xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs h"
 xmlns:h="http://www.w3.org/1999/xhtml" xmlns:t="http://www.tei-c.org/ns/1.0"
 xmlns="http://www.tei-c.org/ns/1.0" version="2.0">

 <!-- expand prefixes on @ref attributes or ref/@targets  
      using mappings from <prefixDef> elements 
      read from the file ../encodingDesc.xml 
 -->

 <xsl:template match="@ref">
  <xsl:attribute name="ref">
   <xsl:for-each select="tokenize(., '\s+')">
    <xsl:choose>
     <xsl:when test="starts-with(., 'http')">
      <xsl:value-of select="."/>
     </xsl:when>
     <xsl:otherwise>
      <xsl:value-of select="t:expandLink(.)"/>
     </xsl:otherwise>
    </xsl:choose>
    <xsl:if test="position() != last()">
     <xsl:text> </xsl:text>
    </xsl:if>
   </xsl:for-each>
  </xsl:attribute>
 </xsl:template>


 <xsl:template match="t:ref/@target">
  <xsl:attribute name="target">
   <xsl:for-each select="tokenize(., '\s+')">
    <xsl:choose>
     <xsl:when test="starts-with(., 'http')">
      <xsl:value-of select="."/>
     </xsl:when>
     <xsl:otherwise>
      <xsl:value-of select="t:expandLink(.)"/>
     </xsl:otherwise>
    </xsl:choose>
    <xsl:if test="position() != last()">
     <xsl:text> </xsl:text>
    </xsl:if>
   </xsl:for-each>
  </xsl:attribute>
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

 <xsl:function name="t:expandLink" as="xs:string">
  <xsl:param name="target"/>
  <xsl:analyze-string select="$target" regex="(\S+):(\S+)">
   <xsl:matching-substring>
    <xsl:variable name="prefix" select="regex-group(1)"/>
    <xsl:variable name="value" select="regex-group(2)"/>
    <xsl:choose>
     <xsl:when test="document('../encodingDesc.xml')//t:prefixDef[@ident = $prefix]">
      <xsl:for-each select="document('../encodingDesc.xml')//t:prefixDef[@ident = $prefix]">
       <xsl:sequence select="replace($value, @matchPattern, @replacementPattern)"/>
      </xsl:for-each>
     </xsl:when>
     <xsl:otherwise>
      <xsl:sequence select="regex-group(0)"/>
     </xsl:otherwise>
    </xsl:choose>
   </xsl:matching-substring>
   <xsl:non-matching-substring>
    <xsl:value-of select="."/>
   </xsl:non-matching-substring>
  </xsl:analyze-string>
 </xsl:function>
</xsl:stylesheet>
