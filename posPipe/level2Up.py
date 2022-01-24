import pprint
import treetaggerwrapper

import sys
sys.path.append("/usr/lib/Saxon.C.API/python-saxon")
# import the Saxon/C library
import saxonc

HOME='/home/lou/Public/'

if (len(sys.argv) <= 1) :
    print("Usage: python level2Up.py [repo]")
    print("  [repo] identifies input repository, which should be located at [HOME]ELTEC-[repo]")
    exit()

REPO=sys.argv[1]
print("Looking for repo "+REPO)
REPOROOT=HOME+'ELTeC-'+REPO+"/"
DRIVERFILE=REPOROOT+"driver-2.tei"
SCRIPT0=HOME+'Scripts/posPipe/getFileNames.xsl'
SCRIPT1=HOME+'Scripts/posPipe/add_RS.xsl'
SCRIPT2=HOME+'Scripts/posPipe/add_S.xsl'

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
      OUTFILE=FILE.replace('level2','level3')
      OUTFILE1=REPOROOT+OUTFILE+'.tmp'
      OUTFILE=REPOROOT+OUTFILE
      print(" ... first pass output to "+OUTFILE1)        
      xsltproc.set_initial_match_selection(file_name=REPOROOT+FILE)
# apply stylesheet to add RS
      result = xsltproc.apply_templates_returning_file(stylesheet_file=SCRIPT1, output_file=OUTFILE1)
# close()
      print(" ... second pass output to "+OUTFILE)
      xsltproc.set_initial_match_selection(file_name=OUTFILE1)
# apply stylesheet to add S
      result = xsltproc.apply_templates_returning_file(stylesheet_file=SCRIPT2, output_file=OUTFILE)
#      close()

    