<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:t="http://www.tei-c.org/ns/1.0"
    xmlns:e="http://distantreading.net/eltec/ns" exclude-result-prefixes="xs t e" version="2.0">
    <xsl:output method="html"/>

    <xsl:param name="corpus">XXX</xsl:param>
    <xsl:param name="catalog">yes</xsl:param>

    <xsl:template match="/">
     
   <!-- <xsl:variable name="ROOT" select="document('tagCounts.xml')"/>
 -->  
     <xsl:variable name="ROOT" select="."/>
     <xsl:variable name="corpora">cze,deu,eng,fra,gre,gsw,hrv,hun,ita,lav,nor,pol,por,rom,slv,spa,srp,swe,ukr</xsl:variable>
     <xsl:variable name="tags">back,body,corr,div,emph,foreign,front,gap,head,hi,l,label,milestone,note,p,pb,quote,ref,trailer</xsl:variable>
        
        <html>
            <link rel="stylesheet" type="text/css" href="../css/summary.css"/>
                <head><title>Tag counts per corpus</title></head>
                <body>
                    <h2>Tags used within &lt;text&gt; only</h2>
                    <table>
                    <thead>
<tr>
    <td/>
    <xsl:for-each select="tokenize($corpora,',')">
        <xsl:variable name="corpus"><xsl:value-of select="."/></xsl:variable>       
        <td><xsl:value-of select="$corpus"/><br/>
        <xsl:value-of select="$ROOT//tagcount[@corpus=$corpus]/@words"/><br/>
         <xsl:value-of select="$ROOT//tagcount[@corpus=$corpus]/@texts"/></td>
        
    </xsl:for-each>
</tr>
                    </thead> 
        
        <xsl:for-each select="tokenize($tags,',')">
            <xsl:variable name="tag"><xsl:value-of select="."/>
            </xsl:variable>
         <tr>
             <td class="label"><xsl:value-of select="$tag"/></td>
             
         <xsl:for-each select="tokenize($corpora,',')">
             <xsl:variable name="corpus"><xsl:value-of select="."/>
             </xsl:variable>
             <xsl:variable name="count">
               <xsl:value-of select="$ROOT//tagcount[@corpus=$corpus]/node[@name=$tag]/@count"/>
             </xsl:variable>
             <td>
             <xsl:choose>
                 <xsl:when test="$count gt '0'">
                     <xsl:value-of select="$count"/>
                 </xsl:when>
                 <xsl:otherwise>0</xsl:otherwise>
             </xsl:choose> 
             </td>
         </xsl:for-each>
            </tr>
     </xsl:for-each>

                    
                    </table>
                </body></html>                  
    </xsl:template>
</xsl:stylesheet>
