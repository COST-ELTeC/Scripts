<?xml version="1.0"?>
<xsl:stylesheet xmlns:edate="http://exslt.org/dates-and-times"
   xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:txm="http://textometrie.org/1.0"
   exclude-result-prefixes="tei edate" version="2.0">
  
<!-- Copyright © 2019 ENS de Lyon, CNRS, University of Franche-Comté
Licensed under the terms of the GNU General Public License (http://www.gnu.org/licenses)
@author Alexei Lavrentiev  -->
  
<!-- This stylesheet converts TEI-TXM files to the format compatible with 
    XML TEI Zero (XTZ) and XML/w import modules.
    All annotations encoded as txm:ana elements are converted to attributes of
    w elements. Customize the annotationsToKeep parameter to select the annotations 
    to keep.  -->
<!-- Ranka Stanković, September 2021, Addaptation for Serbian ELTeC level-2 collection -->
 
   <xsl:output method="xml" encoding="UTF-8" omit-xml-declaration="no" indent="yes"/>
   
   <xsl:strip-space elements="*"/>
      
   <!-- provide the names of annotations to keep in the form of a regular expression, e.g. pos|lemma -->
   <!--xsl:param name="annotationsToKeep">.*</xsl:param -->
   <xsl:param name="annotationsToKeep">srlatpos|srlatlemma|srpos|srlemma</xsl:param>
   
   <xsl:variable name="filename">
      <xsl:analyze-string select="document-uri(.)" regex="/([^/.]+)\.[^/.]*$">
         <xsl:matching-substring>
            <xsl:value-of select="regex-group(1)"/>
         </xsl:matching-substring>
      </xsl:analyze-string>
   </xsl:variable>
                  
<!--   <xsl:variable name="filedir">
      <xsl:analyze-string select="document-uri(.)" regex="^(.*)/([^/]+)$">
         <xsl:matching-substring>
            <xsl:value-of select="regex-group(1)"/>
         </xsl:matching-substring>
      </xsl:analyze-string>
   </xsl:variable>-->
   
   <xsl:template match="*">
      <xsl:choose>
         <xsl:when test="namespace-uri()=''">
            <xsl:element namespace="http://www.tei-c.org/ns/1.0" name="{local-name(.)}">
               <xsl:apply-templates select="*|@*|processing-instruction()|comment()|text()"/>
            </xsl:element>
         </xsl:when>
         <xsl:otherwise>
            <xsl:copy>
               <xsl:apply-templates select="*|@*|processing-instruction()|comment()|text()"/>
            </xsl:copy>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   
   <xsl:template match="@*|processing-instruction()|comment()">
      <xsl:copy/>
   </xsl:template>
   
   <xsl:template match="text()">
      <xsl:value-of select="normalize-space(.)"/>
   </xsl:template>
   

	<xsl:template match="tei:w">
      <xsl:element name="w" namespace="http://www.tei-c.org/ns/1.0">
         <xsl:for-each select="descendant::txm:ana[matches(@type,concat('^#(',$annotationsToKeep,')$'))]">
   <!-- Ranka:  this must be adapted to the language for TXM tagging
            <xsl:attribute name="{replace(substring(@type,2),'srlat','')}">
                <xsl:value-of select="normalize-space(.)"/>
            </xsl:attribute> -->
			<xsl:attribute name="{replace(substring(@type,2),'sr','')}">
            <xsl:value-of select="normalize-space(.)"/>
            </xsl:attribute>
         </xsl:for-each>
         <xsl:attribute name="xml:id">
            <xsl:value-of select="@*[local-name()='id'][1]"/>
         </xsl:attribute>
         <!-- decomment the line below to keep the attributes of words from XML-TEI TXM file -->
         <!--<xsl:copy-of select="@*"/>-->
          <xsl:apply-templates select="txm:form"/>        
      </xsl:element>
   </xsl:template>
   
    <!-- this template is applied to NER by Ranka -->
    <xsl:template match="tei:PERS|tei:LOC|tei:ORG|tei:DEMO|tei:ROLE|tei:WORK|tei:EVENT">
        <!-- produce a refering string element -->
        <xsl:element name="rs" namespace="http://www.tei-c.org/ns/1.0">
		 <xsl:attribute name="type"><xsl:value-of select="local-name()"/>   </xsl:attribute>
		 <xsl:apply-templates select="tei:w"/>
		<!--  -->
		<xsl:apply-templates select="tei:foreign"/> 
	 </xsl:element>
    </xsl:template>
   
   <xsl:template match="txm:form">
      <xsl:apply-templates/>
   </xsl:template>
   
   <!--   count paragraphs  -->
	  
   <xsl:template match="tei:p">
     <xsl:element name="p" namespace="http://www.tei-c.org/ns/1.0">
     <xsl:attribute name="xml:id">     
     <xsl:value-of select="local-name()"/>
	 <xsl:value-of select="count(preceding::tei:p)+1"/>
	 </xsl:attribute>
	 <xsl:apply-templates select="*"/>
 	   
   </xsl:element>
   </xsl:template>

   <!--   count sentences  -->
	  
   <xsl:template match="tei:s">
     <xsl:element name="s" namespace="http://www.tei-c.org/ns/1.0">
     <xsl:attribute name="xml:id">     
     <xsl:value-of select="local-name()"/>
	 <xsl:value-of select="count(preceding::tei:s)+1"/>
	 </xsl:attribute>
	 <xsl:apply-templates select="*"/>
 	   
   </xsl:element>
   </xsl:template>   
   
   <!--  Ranka: correct namespace xml:id -->
   <xsl:template match="tei:div">
     <xsl:element name="div" namespace="http://www.tei-c.org/ns/1.0">
     <xsl:attribute name="xml:id"><xsl:value-of select="@id" />   </xsl:attribute>
	 <xsl:copy-of select="@type"/>
	 <xsl:apply-templates select="*"/> 	   
   </xsl:element>
   </xsl:template> 
 <!-- Ranka: correct namespace xml:id --> 
 <xsl:template match="tei:note">
     <xsl:element name="note" namespace="http://www.tei-c.org/ns/1.0">
     <xsl:attribute name="xml:id"><xsl:value-of select="@id" />   </xsl:attribute>
	 <xsl:apply-templates select="*"/> 	   
   </xsl:element>
   </xsl:template> 
   <!--  Ranka: correct namespace xml:lang -->
   <xsl:template match="tei:foreign">
     <xsl:element name="foreign" namespace="http://www.tei-c.org/ns/1.0">
     <xsl:attribute name="xml:lang"><xsl:value-of select="@lang" />   </xsl:attribute>
	 <xsl:apply-templates select="*"/> 	   
   </xsl:element>
   </xsl:template>
   
   <!--  Ranka: text no attributes -->
	  
   <xsl:template match="tei:text">
     <xsl:element name="text" namespace="http://www.tei-c.org/ns/1.0">
	 <xsl:apply-templates select="*"/> 	   
   </xsl:element>
   </xsl:template>
 </xsl:stylesheet>
