import glob
import subprocess
import os
import time 
import shutil

repoRoot='/home/lou/Public/ELTeC-'
webRoot='/home/lou/Public/distantreading.github.io/ELTeC/'
scriptRoot='/home/lou/Public/Scripts/'
summarizer=scriptRoot+'summarize.xsl'

dateLine='<p>Last updated: '+time.strftime("%Y-%m-%d")+'</p>'

summaryTail="</table>"+dateLine+"</body></html>"

LANGS=('cze', 'deu', 'eng', 'fra', 'gre', 'hun', 'ita', 'lit', 'nor', 'por', 'rom', 'slv', 'spa', 'srp')

shutil.copyfile(scriptRoot+'summary-head.html', webRoot+'index.html')

for LANG in LANGS:
    repoName=repoRoot+LANG
    print("Summarizing repo "+repoName)
    command="saxon -xi -s:" + repoName + "/driver.tei -xsl:" + summarizer + ' corpus='+LANG + '>>'+webRoot+'/index.html'
    subprocess.check_output(command,shell=True)

with open(webRoot+'index.html', 'a') as file:
    file.write(summaryTail)
