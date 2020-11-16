import glob
import subprocess
import os
import sys

repoRoot='/home/lou/Public/ELTeC-'
patchFile='/home/lou/Public/Scripts/removeRefs.xsl'
schemaFile='/home/lou/Public/Schemas/eltec-1.rng'

if (len(sys.argv) <= 1) :
	print("And which language repository would sir like to patch?")
else :
	LANG=sys.argv[1]
	repoName=repoRoot+LANG
	print("Patching repo "+repoName+" with "+patchFile)
	os.chdir(repoName)
	FILES=sorted(glob.glob('level[01]/*.xml'))
	for FILE in FILES: 
		os.rename(FILE,FILE+'.back')
                print("File="+FILE)
		command="saxon -s:" + repoName + "/" + FILE + \
         ".back -xsl:" + patchFile +  ' -o:'+FILE
		subprocess.check_output(command,shell=True)
#		command="jing "+schemaFile+" "+FILE+'.eltec'
#                print(command)
#		subprocess.check_output(command,shell=True)




