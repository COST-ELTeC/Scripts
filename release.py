import glob
import subprocess
import os
import sys

repoRoot='/home/lou/Public/ELTeC-'
headfix='/home/lou/Public/Scripts/headChecker.xsl'
bodyfix='/home/lou/Public/Scripts/textChecker.xsl'
schemaFile='/home/lou/Public/Schemas/eltec-1.rng'

LANGS=('cze', 'deu', 'eng', 'fra', 'hun', 'ita', 'nor', 'por', 'rom', 'slv', 'spa', 'srp')

if (len(sys.argv) <= 1) :
	print("And which language repository would sir like to release?")
else :
	LANG=sys.argv[1]
	repoName=repoRoot+LANG
	print("Preparing repo "+repoName+ " for release")
	os.chdir(repoName)
	FILES=glob.glob('level[01]/*.xml')
	for FILE in FILES: 
		bf=os.path.splitext(FILE)[0] 
		f1=bf.split('/')[1]
		id=f1.split('_')[0]     
		print("File="+FILE+" id="+id)
		command="saxon -s:" + repoName + "/" + FILE + \
         " -xsl:" + headfix + ' lang='+LANG + ' fileName=' + FILE + \
         ' -o:'+FILE+'.eltec'
#        print(command)
		subprocess.check_output(command,shell=True)
		command="saxon -s:" + repoName + "/" + FILE + \
         ".eltec -xsl:" + bodyfix + ' lang='+LANG + ' fileName=' + FILE + \
         '.eltec' + ' -o:'+FILE+'.eltec.xml'
#		print(command)
		subprocess.check_output(command,shell=True)
		command="jing "+schemaFile+" "+FILE+'.eltec.xml'
		subprocess.check_output(command,shell=True)



