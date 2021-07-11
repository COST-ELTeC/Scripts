import pprint
import treetaggerwrapper
# create tagger
tagger=treetaggerwrapper.TreeTagger(TAGLANG='en')
# or    
#  if text has extra lexical items e.g. smart quotes, include lexicon file 
#tagger=treetaggerwrapper.TreeTagger(TAGLANG='en', TAGOPT='-lex extraLex.txt -token -lemma -sgml -quiet')
import sys
sys.path.append("/usr/lib/Saxon.C.API/python-saxon")
# import the Saxon/C library
import saxonc

import udpMap
# module providing functions to UDPify pos codes

FILE='/home/lou/Public/ELTeC-eng/level1/ENG18920_Grossmith.xml'
OUTFILE='/home/lou/Public/ELTeC-eng/level2/ENG18920_Grossmith.xml'
SCRIPT1='getHdr.xsl'
SCRIPT2='getTxt.xsl'
TEMP="tei-test.tmp.xml"



with saxonc.PySaxonProcessor(license=False) as proc:
    print(proc.version)
    xsltproc = proc.new_xslt30_processor()
    xsltproc.set_result_as_raw_value(True)
    xsltproc.set_initial_match_selection(file_name=FILE)
    # apply stylesheet to extract just the header 
    result = xsltproc.apply_templates_returning_file(stylesheet_file=SCRIPT1, output_file=OUTFILE)
#    print(content)
  # apply stylesheet to extract just the test

    content = xsltproc.apply_templates_returning_string(stylesheet_file=SCRIPT2)
    # do POS tagging appending results to a temp file              

    output=open(OUTFILE,'a')
    
result=tagger.tag_text(content)
tags=treetaggerwrapper.make_tags(result)
#pprint.pprint(tags)
for tup in tags:
  if len(tup) == 3  : #it's a tag
    w=tup[0]
    p=tup[1]
    l=tup[2]
# map the pos code    
    pu= udpMap.UDPfromC5(p) 
# check for quotes in lemma
    if "'" in l:
       ql='"'+l+'"'
    else:
       ql="'"+l+"'" 
# treat punctuation differently
    if (pu == "PUNCT") :
      print("<pc pos='"+pu+"' lemma='"+p+"'>"+w+"</pc>")
    else:
      print ("<w pos='"+pu+"' lemma="+ql+">"+w+"</w>")
  else : #it's not a pos tag
    t=tup[0]
    print(t)
    