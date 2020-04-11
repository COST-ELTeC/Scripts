# -*- coding: utf-8 -*-

# === Import statements ===

import os
import glob
from lxml import etree
import sys
from os.path import join


# === Parameters === 

wdir = join("/", "media", "christof", "mydata", "repos", "cost", "")
teipath = join(wdir, "ELTeC-fra", "level1", "*.xml*")
rngfile = join(wdir, "Schemas", "eltec-1.rng")


# === Functions === 

def validate_xml(teifile, idno, rngfile):
    rngparsed = etree.parse(rngfile)
    rngvalidator = etree.RelaxNG(rngparsed)
    parser = etree.XMLParser(recover=True)
    teiparsed = etree.parse(teifile, parser)
    #teiparsed = etree.parse(teifile)
    validation = rngvalidator.validate(teiparsed)
    log = rngvalidator.error_log

    if validation == True: 
        print(idno, "valid!")
    else:
        print("\n", idno, "sorry, not valid!")
        print(log)
        #print(log.last_error)
        #print(log.last_error.domain_name)
        #print(log.last_error.type_name)


# === Main ===

def main(teipath, rngfile): 
    for teifile in glob.glob(teipath):
        #print(teifile)
        idno = os.path.basename(teifile)
        #print(idno)
        validate_xml(teifile, idno, rngfile)

main(teipath, rngfile)
