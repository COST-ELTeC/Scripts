import glob
import subprocess
import os
import sys

repoRoot='/home/lou/Public/ELTeC-'
script='/home/lou/Public/Scripts/filter.xsl'

if (len(sys.argv) <= 2) :
	print("Usage: python filter.py [lang] [pos]")
else :
	LANG=sys.argv[1]
	POS=sys.argv[2]
	repoName=repoRoot+LANG
	print("Filtering repo "+repoName+" for "+POS)
	os.chdir(repoName)
	FILES=sorted(glob.glob('level2/*.xml'))
	for FILE in FILES: 
		bf=os.path.splitext(FILE)[0] 
		f1=bf.split('/')[1]
		id=f1.split('_')[0]     
		print("File="+FILE+" id="+id)
		command="saxon -s:" + repoName + "/" + FILE + \
         " -xsl:" + script + ' pos='+POS  + \
         ' -o:'+FILE+'_'+POS+'.txt'
		subprocess.check_output(command,shell=True)
		
