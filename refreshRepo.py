#import git
import glob
import subprocess
import os
import sys

def gitPull(repoDir):
    cmd = ['git', 'pull']
    p = subprocess.Popen(cmd, cwd=repoDir)
    p.wait()

repoRoot='/home/lou/Public/ELTeC-'
webRoot='/home/lou/Public/distantreading.github.io/ELTeC/'
folderRoot='https://raw.githubusercontent.com/COST-ELTeC/ELTeC-'
reporter='/home/lou/Public/Scripts/reporter.xsl'
exposer='/home/lou/Public/Scripts/expose.xsl'
reportBalance='/home/lou/Public/Scripts/mosaic.R'
outputFile='index.html'
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
   <title>ELTeC</title>
    </head>
    <body>
        <a href="https://www.distant-reading.net/">
            <img src="../../media/distantreading.png" alt="logo"/>
        </a>
    </body>
</html>'''


if (len(sys.argv) <= 1) :
	print("And which language repository would sir like to refresh?")
else :
    LANG=sys.argv[1]
    repoName=repoRoot+LANG
    print("Refreshing repo "+repoName)
    gitPull(repoName)
    os.chdir(repoName)
    f=open("driver.tei","w")
    print("Rewriting driver file")
    f.write('<teiCorpus xmlns="http://www.tei-c.org/ns/1.0" xmlns:xi="http://www.w3.org/2001/XInclude"><teiHeader><fileDesc> <titleStmt> <title>ELTeC '+LANG+' repository</title></titleStmt> <publicationStmt><p>Unpublished test file</p></publicationStmt><sourceDesc><p>Automatically generated source driver file</p> </sourceDesc> </fileDesc> </teiHeader>')
    FILES=sorted(glob.glob('level[01]/*.xml'))
    for FILE in FILES:
        f.write("<xi:include href='"+FILE+"'/>")
    f.write("</teiCorpus>")
    f.close();
    print("Reporting on repo "+repoName)
    command="saxon -xi -s:" + repoName + "/driver.tei -xsl:" + reporter + ' corpus='+LANG + ' >'+webRoot+LANG+'/'+outputFile
#    print(command)
    subprocess.check_output(command,shell=True)
    command="Rscript "+reportBalance+" --args "+webRoot+LANG
    subprocess.check_output(command,shell=True)
    print("Exposing repo "+repoName)
    for FILE in FILES: 
        bf=os.path.splitext(FILE)[0] 
        f1=bf.split('/')[1]
        id=f1.split('_')[0]     
        webFileName=webRoot+LANG+"/"+id+".html"
        gitURL=folderRoot+LANG+"/master/"+FILE
        webFile=open(webFileName,'w')
        webFile.write(string1+gitURL+string2+gitURL+string3)
        webFile.close

