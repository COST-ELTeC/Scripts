"""
This file is used to adjust the settings and to run the 
extraction of plain text from XML-TEI files. 
"""

import tei2txt
from os.path import join


#=======================
# File paths (DO ADJUST)
#=======================

wdir = join("..", "..", "ELTeC-fra", "")
teipath = join(wdir, "level1", "*.xml")
txtpath = join(wdir, "plain1", "")
modsfile = join(wdir, "tei2txt_mods.csv")


#=======================
# Parameters (DO ADJUST)
#=======================

head = True # Include chapter headings?
foreign = True # Include words marked as foreign?
note = False # Include text from footnotes?
pb = False # Include page breaks?
trailer = False # Include words marked as trailer?
quote = True # Include words marked as quote?
front = False # Include front matter?
back = True # Include back matter (other than notes)?

modernize = False # Perform spelling modifications?
wordcount = True # Establish and save wordcounts?


# ======================
# Packaging (DON'T CHANGE)
# ======================

paths = {"teipath":teipath, "txtpath":txtpath, "modsfile":modsfile}
params = {"note":note, "head":head, "pb":pb, "foreign":foreign, "trailer":trailer, "front":front, "back":back, "quote":quote, "modernize":modernize, "wordcount":wordcount}


#=======================
# Run tei2txt
#=======================

tei2txt.main(paths, params)
