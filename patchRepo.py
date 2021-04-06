import glob
import subprocess
import os
import sys

repoRoot='/home/lou/Public/ELTeC-'
patchDir='/home/lou/Public/Scripts/'
schemaFile='/home/lou/Public/Schemas/eltec-1.rng'

print("This is the name of the program:", sys.argv[0])
  
print("Argument List:", str(sys.argv))



if (len(sys.argv) <= 2) :
        print("Please specify language repository and patch file\n e.g pythonRepo.py xxx wibble\n runs Scripts/wibble.xsl against each file in ELTeC-xxx")
else:
        LANG=sys.argv[1]
        PATCH=sys.argv[2]
        patchFile=patchDir+PATCH+'.xsl'
        repoName=repoRoot+LANG
        print("Patching repo "+repoName+" with "+patchFile)
        os.chdir(repoName)
        FILES=sorted(glob.glob('level[01]/*.xml'))
        for FILE in FILES: 
                os.rename(FILE,FILE+'.back')
                print("File="+FILE)
                command="saxon -s:" + repoName + "/" + FILE + ".back -xsl:" + patchFile +  ' -o:'+FILE
                subprocess.check_output(command,shell=True)

