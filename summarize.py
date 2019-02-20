import glob
import subprocess
import os
import time 
import shutil

repoRoot='/home/lou/Public/ELTeC-'
webRoot='/home/lou/Public/WG1/distantreading.github.io/ELTeC/'
scriptRoot='/home/lou/Public/Scripts/'
summarizer=scriptRoot+'summarize.xsl'

dateLine='<p>Last updated: '+time.strftime("%Y-%m-%d")+'</p>'

summaryTail="</table>"+dateLine+"</body></html>"

LANGS=('cze', 'deu', 'eng', 'fra', 'hun', 'ita', 'nor', 'por', 'rom', 'slv', 'spa', 'srp')

shutil.copyfile(scriptRoot+'summary-head.html', webRoot+'indox.html')

for LANG in LANGS:
    repoName=repoRoot+LANG
    print("Summarizing repo "+repoName)
    command="saxon -xi -s:" + repoName + "/driver.tei -xsl:" + summarizer + ' corpus='+LANG + ' >>'+webRoot+'/indox.html'
    subprocess.check_output(command,shell=True)

with open(webRoot+'indox.html', 'a') as file:
    file.write(summaryTail)
