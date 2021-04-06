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
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <meta http-equiv="X-UA-Compatible" content="ie=edge"/>
  <link rel="stylesheet" href="../../css/cetei.css" media="all" />
  <script src="../../js/CETEI.js"></script>
  <script>
   let c = new CETEI(); 
   let behaviors = {
    "namespaces": {
     "el": "http://distantreading.net/eltec/ns"
    },
    "tei": {
     "teiHeader": null,
     "distributor":[[ "[ref]",[ "<a href='$rw@ref' target='_blank'>", "</a>"]]],
     "author":[[ "[ref]",[ "<a href='$rw@ref' target='_blank'>", "</a>"]]],
     "pb":[ "<p class='break'>[page $@n]</p>"],
     "ref": ["<a href='$rw@target'> online "," </a>"],
    },
  };
  c.addBehaviors(behaviors);
  c.getHTML5("'''

string2='''",function(data) {
  document.getElementsByTagName("body")[0].appendChild(data);});
  </script>
     </head>
    <body>
        <a href="https://www.distant-reading.net/">
            <img src="../../media/distantreading.png" alt="logo"/>
        </a>
    </body>
</html>'''

from datetime import date
today = str(date.today())

if (len(sys.argv) <= 1) :
	print("And which language repository would sir like to refresh?")
else :
    LANG=sys.argv[1]
    repoName=repoRoot+LANG
    print("Refreshing repo "+repoName)
    gitPull(repoName)
    os.chdir(repoName)
    f=open("driver.tei","w")
    f2=open("fileNames.xml","w")
    FILES=sorted(glob.glob('level[01]/*.xml'))
    print(str(len(FILES))+' files found in repo')
    print("Rewriting driver files")
    f.write('<teiCorpus xmlns="http://www.tei-c.org/ns/1.0" xmlns:xi="http://www.w3.org/2001/XInclude" xml:lang="'+LANG+'"><teiHeader><fileDesc> <titleStmt> <title>ELTeC '+LANG+' repository</title></titleStmt><extent><measure unit="files">'+str(len(FILES))+'</measure></extent> <publicationStmt><p>Unpublished test file</p></publicationStmt><sourceDesc><p>Automatically generated source driver file</p> </sourceDesc> </fileDesc>  <xi:include href="../Scripts/encodingDesc.xml"/> <revisionDesc><change when="'+today+'">refreshRepo script run</change></revisionDesc></teiHeader>')
   
    f2.write('<fileNames>')
    for FILE in FILES:
        f.write("<xi:include href='"+FILE+"'/>")
        f2.write("<file>"+FILE+"</file>")
    f.write("</teiCorpus>")
    f2.write("</fileNames>")
    f.close()
    f2.close()
    print("Exposing repo "+repoName)
    for FILE in FILES: 
        bf=os.path.splitext(FILE)[0] 
        f1=bf.split('/')[1]
        id=f1.split('_')[0]     
        webFileName=webRoot+LANG+"/"+id+".html"
        gitURL=folderRoot+LANG+"/master/"+FILE
        webFile=open(webFileName,'w')
        webFile.write(string1+gitURL+string2)
        webFile.close
    print("Reporting on repo "+repoName)
    command="saxon -xi -s:" + repoName + "/driver.tei -xsl:" + reporter + ' corpus='+LANG + ' >'+webRoot+LANG+'/'+outputFile
#    print(command)
    subprocess.check_output(command,shell=True)
    command="Rscript "+reportBalance+" --args "+webRoot+LANG
    subprocess.check_output(command,shell=True)
# could run summarize.py here
