#import git
import glob
import subprocess
import os

def gitPull(repoDir):
    cmd = ['git', 'pull']
    p = subprocess.Popen(cmd, cwd=repoDir)
    p.wait()

root='/home/lou/Public/ELTeC-'

LANGS=('cze', 'deu', 'eng', 'fra', 'gre', 'hun', 'ita','lit', 'nor', 'por', 'rom', 'slv', 'spa', 'srp')

#LPS=['cze/CS', 'deu/deu', 'eng/ENG', 'fra/ hun',/ 'ita/IT', 'nor/ELTEC', 'por/POR', 'rom/', 'slv/SL' 'spa/SPA', 'srp/SRP']

for lang in LANGS:
    print(lang)
    repoName=root+lang
    print(repoName)
    gitPull(repoName)
    os.chdir(repoName)
    f=open("driver.tei","w")
    f.write('<teiCorpus xmlns="http://www.tei-c.org/ns/1.0" xmlns:xi="http://www.w3.org/2001/XInclude"><teiHeader><fileDesc> <titleStmt> <title>TEI Corpus testharness</title></titleStmt> <publicationStmt><p>Unpublished test file</p></publicationStmt><sourceDesc><p>No source driver file</p> </sourceDesc> </fileDesc> </teiHeader>')
    FILES=glob.glob('level?/*.xml')
    for FILE in FILES:
            f.write("<xi:include href='"+FILE+"'/>")
    f.write("</teiCorpus>")


