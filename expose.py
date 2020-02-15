import glob
import subprocess
import os

repoRoot='/home/lou/Public/ELTeC-'
webRoot='/home/lou/Public/distantreading.github.io/ELTeC/'
reporter='/home/lou/Public/Scripts/expose.xsl'

LANGS=('cze', 'deu', 'eng', 'fra', 'gre', 'hun', 'ita', 'lit', 'nor', 'por', 'rom', 'slv', 'spa', 'srp')

for LANG in LANGS:
    repoName=repoRoot+LANG
    print("Exposing repo "+repoName)
    os.chdir(repoName)
    FILES=glob.glob('level[01]/*.xml')
    for FILE in FILES: 
        bf=os.path.splitext(FILE)[0] 
        f1=bf.split('/')[1]
        id=f1.split('_')[0]     
        print("File="+FILE+" id="+id)
        command="saxon -s:" + repoName + "/" + FILE + \
         " -xsl:" + reporter + ' lang='+LANG + ' fileName=' + FILE + \
          ' >'+webRoot+LANG+'/'+id+'.html'
        #print(command)
        subprocess.check_output(command,shell=True)
    

