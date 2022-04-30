import glob
import subprocess
import os
import time 
import shutil

repoRoot='/home/lou/Public/ELTeC-'
webRoot='/home/lou/Public/distantreading.github.io/ELTeC/'
scriptRoot='/home/lou/Public/Scripts/'
summarizer=scriptRoot+'summarize.xsl'

dateLine='<p>Summary produced: '+time.strftime("%Y-%m-%d")+'</p>'

summaryTail="</table>"+dateLine+"</body></html>"


LANGS=('cze', 'deu', 'eng', 'fra', 'gre', 'gsw', 'hrv', 'hun', 'ita', 'lav', 'nor', 'pol', 'por', 'rom', 'slv', 'spa', 'srp', 'swe', 'ukr')


shutil.copyfile(scriptRoot+'summary-head.html', webRoot+'index.html')

for LANG in LANGS:
    repoName=repoRoot+LANG
    os.chdir(repoName)
    lastUpdate = str(subprocess.check_output(['git', 'log', '-1', '--date=short', '--format=format:%cd']),encoding='UTF8')

    print("Summarizing repo "+repoName+ " on "+lastUpdate)
    command="saxon -xi -s:" + repoName + "/driver.tei -xsl:" + summarizer + ' corpus='+LANG + ' lastUpdate='+ lastUpdate + '>>'+webRoot+'index.html'
    subprocess.check_output(command,shell=True)

with open(webRoot+'index.html', 'a') as file:
    file.write(summaryTail)
