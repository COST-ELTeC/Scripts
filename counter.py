import glob
import subprocess
import os

repoRoot='/home/lou/Public/ELTeC-'
webRoot='/home/lou/Public/WG1/distantreading.github.io/ELTeC/'
counter='/home/lou/Public/Scripts/counter.xsl'
counter2='/home/lou/Public/Scripts/counter2.xsl'

LANGS=('cze', 'deu', 'eng', 'fra', 'gre', 'hun', 'ita', 'nor', 'por', 'rom', 'slv', 'spa', 'srp')

f=open("tagCounts.xml","w")
f.write('<tagCounts>')
f.close()

for LANG in LANGS:
    repoName=repoRoot+LANG
    print("Reporting on repo "+repoName)
    command="saxon -xi -s:" + repoName + "/driver.tei -xsl:" + counter + ' corpus='+LANG + ' >>tagCounts.xml'

    subprocess.check_output(command,shell=True)

f=open("tagCounts.xml","a")
f.write('</tagCounts>')
f.close()


command="saxon -s:tagCounts.xml -xsl:" + counter2 + '>' + webRoot + 'tagCounts.html'
subprocess.check_output(command,shell=True)



