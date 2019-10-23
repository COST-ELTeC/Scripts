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
webRoot='/home/lou/Public/WG1/distantreading.github.io/ELTeC/'
reporter='/home/lou/Public/Scripts/reporter.xsl'
reportBalance='/home/lou/Public/Scripts/mosaic.R'
outputFile='index.html'

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
    FILES=glob.glob('level?/*.xml')
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
    


