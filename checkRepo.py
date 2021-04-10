import glob
import subprocess
import os
import sys

# should be split to just do release mod?

repoRoot='/home/lou/Public/ELTeC-'
release='/home/lou/Public/Scripts/checkUp.xsl'
schemaFile='/home/lou/Public/Schemas/eltec-1.rng'

# writes tidied up version of each .xml file in nominated repo 
#   to a directory called Release in same repo 
# validates the result against `schemaFile` using jing

if (len(sys.argv) <= 1) :
	print("And which language repository would sir like to release?")
else :
	LANG=sys.argv[1]
	repoName=repoRoot+LANG
	print("Releasing "+repoName)
	os.chdir(repoName)
	if not os.path.exists('Release'): os.makedirs('Release')
	FILES=sorted(glob.glob('level[01]/*.xml'))
	for FILE in FILES: 
		bf=os.path.splitext(FILE)[0] 
		f1=bf.split('/')[1]
		id=f1.split('_')[0]     
#		print("File="+FILE+" id="+id)
		command="saxon -s:" + repoName + "/" + FILE + \
         " -xsl:" + release + ' lang='+LANG + ' fileName=' + FILE + \
         ' -o:Release/'+FILE
		subprocess.check_output(command,shell=True)
		command="jing "+schemaFile+" Release/"+FILE
#                print(command)
		subprocess.check_output(command,shell=True)




