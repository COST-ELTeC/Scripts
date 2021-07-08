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

FILE='tei-test.xml'
SCRIPT='getTxt.xsl'
TEMP="tei-test.tmp.xml"



with saxonc.PySaxonProcessor(license=False) as proc:
    print(proc.version)
    xsltproc = proc.new_xslt30_processor()
    xsltproc.set_result_as_raw_value(True)
    xsltproc.set_initial_match_selection(file_name=FILE)
    # apply first stylesheet to extract just the text 
    content = xsltproc.apply_templates_returning_string(stylesheet_file=SCRIPT)
#    print(content)
    # do POS tagging appending results to a temp file              

    output=open(TEMP,'a')
    
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
    print(str(tup[0]))
