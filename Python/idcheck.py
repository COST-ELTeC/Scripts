import glob
import os
from os.path import join
import re

wdir = join("/", "media", "christof", "mydata", "repos", "cost", "")
filepath = join(wdir, "ELTeC-fra", "level1", "*.xml")

def check_ids(filepath): 
    for filename in glob.glob(filepath): 
        # retrieve the idno from the filename
        idno_file = os.path.basename(filename).split(".")[0].split("_")[0]
        #print(idno_file)
        # retrieve the idno from the xml:id attribute
        with open(filename, "r", encoding="utf8") as infile: 
            text = infile.read()
            try: 
                idno_text = re.findall("FRA\d+", text)[0]
                #if len(idno_text) > 1: 
                #    print(idno_text)
                if idno_file == idno_text: 
                    print(idno_file, idno_text, "OK")
                if idno_file != idno_text:  
                    print(idno_file, idno_text, "ERROR")
            except: 
                print("Error finding the ID")
                
        
        
check_ids(filepath)

