import glob
import subprocess
import os

repoRoot='/home/lou/Public/ELTeC-'
headfix='/home/lou/Public/Scripts/headChecker.xsl'
schemaFile='/home/lou/Public/Schemas/eltec-1.rnc'

LANGS=('cze', 'deu', 'eng', 'fra', 'hun', 'ita', 'nor', 'por', 'rom', 'slv', 'spa', 'srp')



for LANG in LANGS:
    repoName=repoRoot+LANG
    print("Revalidating repo "+repoName)
    os.chdir(repoName)
    FILES=glob.glob('level[01]/*.xml')
    for FILE in FILES: 
        bf=os.path.splitext(FILE)[0] 
        f1=bf.split('/')[1]
        id=f1.split('_')[0]     
        print("File="+FILE+" id="+id)
        command="saxon -s:" + repoName + "/" + FILE + \
         " -xsl:" + headfix + ' lang='+LANG + ' fileName=' + FILE + \
          ' | rnv ' + schemaFile
#        print(command)
        subprocess.check_output(command,shell=True)




