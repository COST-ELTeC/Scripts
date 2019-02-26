import glob
import subprocess
import os

repoRoot='/home/lou/Public/ELTeC-'
webRoot='/home/lou/Public/WG1/distantreading.github.io/ELTeC/'
reporter='/home/lou/Public/Scripts/reporter.xsl'

LANGS=('cze', 'deu', 'eng', 'fra', 'hun', 'ita', 'nor', 'por', 'rom', 'slv', 'spa', 'srp')

for LANG in LANGS:
    repoName=repoRoot+LANG
    print("Reporting on repo "+repoName)
    command="saxon -xi -s:" + repoName + "/driver.tei -xsl:" + reporter + ' corpus='+LANG + ' >'+webRoot+LANG+'/index.html'
#    print(command)
    subprocess.check_output(command,shell=True)
    

