import glob
import subprocess
import os

repoRoot='/home/lou/Public/ELTeC-'
webRoot='/home/lou/Public/distantreading.github.io/ELTeC/'
LANGS=('cze', 'deu', 'eng', 'fra', 'gre', 'hun', 'ita', 'lit', 'nor', 'por', 'rom', 'slv', 'spa', 'srp')
folderRoot='https://raw.githubusercontent.com/COST-ELTeC/ELTeC-'


string1='''<!DOCTYPE html>
 <html><head>
 <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">     
  <link rel="stylesheet" href="../../css/cetei.css" media="all" title="no title" charset="utf-8"/>
  <link type="application/tei+xml" rel="alternative" href="'''

string2='''"/>
<script src="../../js/CETEI.js" charset="utf-8"></script>
 <script type="text/javascript">
    var ceteicean = new CETEI();
    ceteicean.shadowCSS = "../../css/cetei.css";
    ceteicean.getHTML5("'''

string3='''",function(data) {
  document.getElementsByTagName("body")[0].appendChild(data);});
  </script>
   <title><xsl:value-of select="Generated dummy"/></title>
    </head>
    <body>
        <a href="https://www.distant-reading.net/">
            <img src="../../media/distantreading.png" alt="logo"/>
        </a>
    </body>
</html>'''


for LANG in LANGS:
    repoName=repoRoot+LANG
    print("Exposing repo "+repoName)
    os.chdir(repoName)
    FILES=glob.glob('level[01]/*.xml')
    for FILE in FILES: 
        bf=os.path.splitext(FILE)[0] 
        f1=bf.split('/')[1]
        id=f1.split('_')[0]     
        outputFile=webRoot+LANG+"/"+id+".html"
        gitURL=folderRoot+LANG+"/master/"+FILE
        webFile=open(outputFile,'w')
        webFile.write(string1+gitURL+string2+gitURL+string3)
        webFile.close
 




 
 