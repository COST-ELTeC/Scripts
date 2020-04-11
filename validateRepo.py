#import git
import glob
import subprocess
import os
import sys

def gitPull(repoDir):
    cmd = ['git', 'pull']
    p = subprocess.Popen(cmd, cwd=repoDir)
    p.wait()

repoRoot='/home/lou/Public/ELTeC-'
schemaDir='/home/lou/Public/Schemas'

if (len(sys.argv) <= 1) :
	print("And which language repository would sir like to validate?")
else :
    LANG=sys.argv[1]
    repoName=repoRoot+LANG
    print("Validating repo "+repoName)
    gitPull(repoName)
    os.chdir(repoName)
    FILES=sorted(glob.glob('level0/*.xml'))
    for FILE in FILES:
        command="jing "+schemaDir+"/eltec-0.rng "+FILE
        print(command)
        subprocess.check_output(command,shell=True)
    FILES=sorted(glob.glob('level1/*.xml'))
    for FILE in FILES:
        command="jing "+schemaDir+"/eltec-1.rng "+FILE
        print(command)
        subprocess.check_output(command,shell=True)


