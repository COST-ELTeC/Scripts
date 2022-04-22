import glob
import subprocess
import os

repoRoot='/home/lou/Public/ELTeC-'
webRoot='/home/lou/Public/distantreading.github.io/ELTeC/'
#reporter='/home/lou/Public/Scripts/tagCounter.xsl'
#outputFile='tagCounts.csv'
reporter='/home/lou/Public/Scripts/reporter.xsl'
reportBalance='/home/lou/Public/Scripts/mosaic.R'
outputFile='index.html'

# potential exts are lav lit

LANGS=('cze', 'deu', 'eng', 'fra', 'gre', 'gsw', 'hrv', 'hun', 'ita',  'lit-ext', 'nor', 'pol', 'por', 'rom', 'slv', 'spa', 'srp', 'swe', 'ukr')


for LANG in LANGS:
    repoName=repoRoot+LANG
    print("Reporting on repo "+repoName)
    command="saxon -xi -s:" + repoName + "/driver.tei -xsl:" + reporter + ' corpus='+LANG + ' >'+webRoot+LANG+'/'+outputFile
#    print(command)
    subprocess.check_output(command,shell=True)
    command="Rscript "+reportBalance+" --args "+webRoot+LANG
    subprocess.check_output(command,shell=True)
    

