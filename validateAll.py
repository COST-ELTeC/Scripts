import glob
import subprocess
import os

repoRoot='/home/lou/Public/ELTeC-'
webRoot='/home/lou/Public/WG1/distantreading.github.io/ELTeC/'
schemaFile='/home/lou/Public/Schemas/eltec-repo.rng'

LANGS=('cze', 'deu', 'eng', 'fra', 'gre', 'gsw','hrv','hun', 'ita', 'lav','nor', 'pol', 'por', 'rom', 'slv', 'spa', 'srp','swe','ukr')


for LANG in LANGS:
    repoName=repoRoot+LANG
    print("Validating repo "+repoName)
    command="jing " + schemaFile + " " + repoName + "/driver.tei " 
    subprocess.check_output(command,shell=True)
