<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xpath-default-namespace="http://www.tei-c.org/ns/1.0" 
    
    xmlns:e="http://distantreading.net/eltec/ns" exclude-result-prefixes="xs e"
    version="2.0">
    <xsl:param name="verbose"/>
    <!-- iff true, witter on -->
    <xsl:variable name="today">
        <xsl:value-of
            select="format-date(current-date(), '[Y0001]-[M01]-[D01]')"/>
    </xsl:variable>
    <xsl:variable name="textId">
        <xsl:value-of select="TEI/@xml:id"/>
    </xsl:variable>
    <xsl:variable name="textLang">
        <xsl:value-of select="TEI/@xml:lang"/>
    </xsl:variable>
    
    <!-- Script to check texts for common errors
       - check divs and fix @type where possible
       - remove empty front or back
       - remove ref with invalid target
-->
    <!-- IdentityTransform -->
    <xsl:template match="/ | @* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>

   
   <!-- look at untyped divs -->
    <xsl:template match="body/div[not(@type)]">
        <xsl:message>Untyped div found...</xsl:message>
       <xsl:choose> <xsl:when test="p and not(child::div)">
            <xsl:message>contains p but not div so marking as chapter</xsl:message>
            <div type="chapter" xmlns="http://www.tei-c.org/ns/1.0">
                <xsl:apply-templates/>
            </div>
        </xsl:when><xsl:when test="div">
            <xsl:message>contains div so marking as group</xsl:message>
            <div type="group" xmlns="http://www.tei-c.org/ns/1.0">
                <xsl:apply-templates/>
            </div> </xsl:when></xsl:choose>
    </xsl:template>
    <!-- check divs in front -->
    <xsl:template match="front/div[@type]">      
                <xsl:if test="not(@type ='titlepage' or @type='liminal')">
          <xsl:message>*** Unrecognized divtype  <xsl:value-of select="@type"/></xsl:message>
              <xsl:choose>
                  <xsl:when test="contains(@type,'title')">
                      <xsl:message> ... assuming titlepage</xsl:message>
                      <div type="titlepage" xmlns="http://www.tei-c.org/ns/1.0">
                          <xsl:apply-templates/>
                      </div>    
                  </xsl:when>
            
                  <xsl:otherwise>  <xsl:message> ... assuming liminal</xsl:message>
              <div type="liminal" xmlns="http://www.tei-c.org/ns/1.0">
                  <xsl:apply-templates/>
              </div> </xsl:otherwise>
              </xsl:choose>
                </xsl:if>
    </xsl:template>
    <xsl:template match="front/div[not(@type)]">  
        <xsl:message>*** Unmarked divtype  <xsl:value-of select="@type"/>  ... assuming liminal</xsl:message>
        <div type="liminal" xmlns="http://www.tei-c.org/ns/1.0">
            <xsl:apply-templates/>
        </div>
    </xsl:template>  
        
    <xsl:template match="back/div[not(@type)]">  
        <xsl:message>*** Unmarked divtype  <xsl:value-of select="@type"/>  ... assuming liminal</xsl:message>
        <div type="liminal" xmlns="http://www.tei-c.org/ns/1.0">
            <xsl:apply-templates/>
        </div>
    </xsl:template>  
    
    <!-- following templates added to clean up norwegian texts -->
    
    <!-- remove <ref> with content inside <head> -->
<!--   <xsl:template match="head/ref">
        <xsl:apply-templates/>
<xsl:message>Untagged ref in head</xsl:message>
    </xsl:template>
-->
    
    <!-- remove <note> elements inside the body-->
    <xsl:template match="body//note">
<xsl:message>note inside body removed</xsl:message>
    </xsl:template>
    
    <!-- remove empty front or back and vacuous ref -->

    <xsl:template match="front[not(div)]">
<xsl:message>Empty front removed</xsl:message></xsl:template>
    <xsl:template match="back[not(div)]">
<xsl:message>Empty back removed</xsl:message></xsl:template>
    
    <!-- remove invalidly targetted refs -->
    <xsl:template match="ref[not(starts-with(@target,'http')) and not(starts-with(@target,'#'))]">
<xsl:choose>
<xsl:when test='parent::head'>
<xsl:apply-templates/>
<xsl:message>ref in head de-tagged</xsl:message>
</xsl:when>
<xsl:otherwise>
<xsl:message>invalid ref removed</xsl:message>
</xsl:otherwise>    
</xsl:choose></xsl:template></xsl:stylesheet>
