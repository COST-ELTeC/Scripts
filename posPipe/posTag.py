import pprint
import treetaggerwrapper

import sys
sys.path.append("/usr/lib/Saxon.C.API/python-saxon")
# import the Saxon/C library
import saxonc

import udpMap
# module providing functions to UDPify pos codes

HOME='/home/lou/Public/'

if (len(sys.argv) <= 1) :
    print("Usage: python posTag.py [repo]")
    print("  [repo] identifies input repository, which should be located at [HOME]ELTEC-[repo]")
    exit()

REPO=sys.argv[1]
print("Looking for repo "+REPO)
REPOROOT=HOME+'ELTeC-'+REPO+"/"
DRIVERFILE=REPOROOT+"driver.tei"
SCRIPT0=HOME+'Scripts/posPipe/getFileNames.xsl'
SCRIPT1=HOME+'Scripts/posPipe/getHdr.xsl'
SCRIPT2=HOME+'Scripts/posPipe/getTxt.xsl'

LEXFILE=HOME+'Scripts/posPipe/extraLex.txt'

if (REPO == 'eng') :
  LANG='en'
  tagger=treetaggerwrapper.TreeTagger(TAGLANG='en', TAGOPT='-lex '+LEXFILE+' -token -lemma -sgml -quiet')
elif (REPO == 'fra') :
  LANG='fr'
  tagger=treetaggerwrapper.TreeTagger(TAGLANG='fr', TAGOPT=' -token -lemma -sgml -quiet')
else :
  print("repo should be eng or fra")
  exit()


with saxonc.PySaxonProcessor(license=False) as proc:
    print(proc.version)
    xsltproc = proc.new_xslt30_processor()
    xsltproc.set_result_as_raw_value(True) 
# get the list of files to process from the DRIVERFILE  using SCRIPT0
    xsltproc.set_initial_match_selection(file_name=DRIVERFILE)
    fileList= xsltproc.apply_templates_returning_string(stylesheet_file=SCRIPT0)
#    pprint.pprint(fileList)
    for FILE in fileList.split(','):
      if len(FILE) <= 1 :
         exit()
      print("Processing "+FILE)
      if (FILE.startswith('level1')) :
         OUTFILE=FILE.replace('level1','level2')
      else :
         OUTFILE=FILE.replace('level0','level2')
      OUTFILE=REPOROOT+OUTFILE
      print(" ... output to "+OUTFILE)        
      xsltproc.set_initial_match_selection(file_name=REPOROOT+FILE)
# apply stylesheet to copy header and TEI start-tag to outputfile
      result = xsltproc.apply_templates_returning_file(stylesheet_file=SCRIPT1, output_file=OUTFILE)
# apply stylesheet to extract just the text
      content = xsltproc.apply_templates_returning_string(stylesheet_file=SCRIPT2)
# reopen the output file in append mode    
      output=open(OUTFILE,'a')
# do POS tagging on the content
      result=tagger.tag_text(content)
      tags=treetaggerwrapper.make_tags(result)
# reformat tagger output (there must be an easier way of doing this)
      for tup in tags:
          if len(tup) == 3  : #it's a pos tag
             w=tup[0]
             p=tup[1]
             l=tup[2]
# map the pos code (from whatever tt produces to UDP)   
             if (LANG == 'en'):
               pu= udpMap.UDPfromC5(p) 
             elif (LANG == 'fr'):
               pu= udpMap.UDPfromFR(p)
             else:
               print("No UDPmap available for language "+LANG)
               exit()
# check for "<unknown>" lemma
             if "<" in l:
                l= w.lower()
 #check for quotes in lemma
             if "'" in l:
                ql='"'+l+'"'
             else:
                ql="'"+l+"'" 
             if (w.startswith("'")):
                 join=' join="left" '
             else:
                  join='' 
# retain TT punctuation tag using @n until we agree on @xpos
             if (pu == "PUNCT") :
                output.write("<pc pos='"+pu+"' lemma="+ql+" n='"+p+"'>"+w+"</pc>\n")
             else:
                output.write ("<w pos='"+pu+"' lemma="+ql+join+">"+w+"</w>\n")
          else : #it's not a pos tag
             t=tup[0]
             output.write(t)
      output.write("</TEI>\n")
      output.close()

    