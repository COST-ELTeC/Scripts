import glob
import subprocess
import os
import time 
import shutil

repoRoot='/home/lou/Public/ELTeC-'
webRoot='/home/lou/Public/distantreading.github.io/ELTeC/'
scriptRoot='/home/lou/Public/Scripts/'
summarizer=scriptRoot+'summarize.xsl'

dateLine='<p>Summary produced: '+time.strftime("%Y-%m-%d")+'</p>'
summaryTail="</table>"+dateLine+"</body></html>"

tabHead='''  <th colspan="4" style="text-align:center">AUTHORSHIP</th>
  <th colspan="3" style="text-align:center">LENGTH</th>
  <th colspan="5" style="text-align:center">TIME SLOT</th>
  <th colspan="2" style="text-align:center">REPRINT COUNT</th>
  <th></th></tr></thead>
<thead>
<tr>
<th>Language</th>
<th>Last update</th>
<th>Texts</th>
<th class="sep">Words</th>
<th>Male</th>
<th>Female</th>
 <th>1-title</th>
 <th>3-title</th>
<th class="sep">Short</th>
<th>Medium</th>
<th>Long</th>
<th>1840-59</th>
<th>1860-79</th>
<th>1880-99</th>
<th>1900-20</th><th>range</th>
<th class="sep">Frequent</th>
<th>Rare</th>
 <th>E5C</th>
</tr>
</thead>'''

tabTail="</table>"

LANGS=('cze', 'deu', 'eng', 'fra', 'gle', 'gre', 'gsw', 'hrv', 'hun', 'ita', 'lit', 'lav', 'nor', 'pol', 'por', 'rom', 'slv', 'spa', 'srp', 'swe', 'ukr', 'nor-ext','fra-ext1','fra-ext2','fra-ext3','eng-ext','srp-ext','por-ext')

shutil.copyfile(scriptRoot+'summary-head.html', webRoot+'index.html')
coreTab='<table><thead><tr><th colspan="4" style="text-align:left; color:red; font-style:italic">ELTeC-core</th>' + tabHead
plusTab='<table><thead><tr><th colspan="4" style="text-align:left; color:red; font-style:italic">ELTeC-plus</th>' + tabHead
extendedTab='<table><thead><tr><th colspan="4" style="text-align:left; color:red; font-style:italic">ELTeC-extension</th>' + tabHead

import sys
sys.path.append("/usr/lib/Saxon.C.API/python-saxon")
# import the Saxon/C library
import saxonc
with saxonc.PySaxonProcessor(license=False) as proc:
    print(proc.version)
    proc.set_configuration_property("xi", "on")
    xdmAtomicval = proc.make_boolean_value(False)
    xsltproc = proc.new_xslt30_processor()
    for LANG in LANGS:
      repoName=repoRoot+LANG
      os.chdir(repoName)
      lastUpdate = str(subprocess.check_output(['git', 'log', '-1', '--date=short', '--format=format:%cd']),encoding='UTF8')
      print("Summarizing repo "+repoName+ " on "+lastUpdate)
      xsltproc.set_parameter("corpus", proc.make_string_value(LANG)) 
      xsltproc.set_parameter("lastUpdate",proc.make_string_value(lastUpdate))
      result = xsltproc.transform_to_string(source_file=repoName + "/driver.tei", stylesheet_file=scriptRoot+"summarize.xsl")
#      print(result)
      if result.startswith('<tr class="core') :
        coreTab=coreTab+result
      elif result.startswith('<tr class="plus') :
        plusTab= plusTab+result
      else:
        extendedTab=extendedTab+result  
      xsltproc.clear_parameters()   
    with open(webRoot+'index.html', 'a') as file:
       file.write(coreTab+tabTail)
       file.write(plusTab+tabTail)
       file.write(extendedTab)
       file.write(summaryTail)
