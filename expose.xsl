<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:t="http://www.tei-c.org/ns/1.0"
    xmlns:e="http://distantreading.net/eltec/ns" exclude-result-prefixes="xs t e" version="2.0">
    <xsl:output method="html"/>
    <xsl:param name="fileName"/>
    <xsl:param name='lang'/>
    <xsl:param name="folder">https://raw.githubusercontent.com/COST-ELTeC/ELTeC-</xsl:param>
    <xsl:variable name="gitURL">
        <xsl:value-of select="concat($folder,$lang,'/master/',$fileName)"/>
    </xsl:variable>
    
    <xsl:template match="/">
           
  <xsl:text disable-output-escaping="yes">&lt;!DOCTYPE html></xsl:text>       
      <html>  <head>
            <link rel="stylesheet" href="../../css/cetei.css" media="all" title="no title" 
                charset="utf-8"/>
            <link type="application/tei+xml" rel="alternative" 
                href="{$gitURL}"/>
            <script src="../../js/CETEI.js" charset="utf-8"></script>
            <script type="text/javascript">
               <xsl:text> var ceteicean = new CETEI();
                ceteicean.shadowCSS = "../../css/cetei.css";
                ceteicean.getHTML5(
                '</xsl:text><xsl:value-of select="$gitURL"/><xsl:text>', 
                function(data) {
                document.getElementsByTagName("body")[0].appendChild(data);
                });</xsl:text>
            </script>
            
    <title><xsl:value-of select="t:TEI/t:teiHeader/t:fileDesc/t:titleStmt/t:title[1]"/></title>
    </head>
    <body>
        <a href="https://www.distant-reading.net/">
            <img src="../../media/distantreading.png" alt="logo"/>
        </a>
        
    </body>
</html>

    </xsl:template>
    </xsl:stylesheet>
