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


def parse_tei(teifile): 
    with open(teifile, "r", encoding="utf8") as infile:
        teiparsed = etree.parse(infile)
        return teiparsed
    #parser = etree.XMLParser(recover=True)
    #teiparsed = etree.parse(teifile, parser)
    #return teiparsed


def validate_xml(teiparsed, filename, rngfile):
    rngparsed = etree.parse(rngfile)
    rngvalidator = etree.RelaxNG(rngparsed)
    validation = rngvalidator.validate(teiparsed)
    log = rngvalidator.error_log
    if validation == True: 
        print("\n" + filename + "\n- OK, file valid.")
    else:
        print(filename, "\n- SORRY, file not valid!")
        print(log)
        #print(log.last_error)
        #print(log.last_error.domain_name)
        #print(log.last_error.type_name)


def check_ids(teifile, teiparsed): 
        idno_file = os.path.basename(teifile).split(".")[0].split("_")[0]
        namespaces = {'tei':'http://www.tei-c.org/ns/1.0',
                      'eltec':'http://distantreading.net/eltec/ns'}       
        try: 
            idno_text = teiparsed.xpath("//tei:TEI/@xml:id", namespaces=namespaces)[0]    
            if idno_file == idno_text: 
                print("- OK, xml:id fine!")
            if idno_file != idno_text:  
                print("- SORRY, xml:id is faulty!", idno_file, idno_text)
        except: 
            print("- SORRY, can't find the ID")
            


# === Main ===

def main(teipath, rngfile): 
    for teifile in glob.glob(teipath):
        filename,ext = os.path.basename(teifile).split(".")
        teiparsed = parse_tei(teifile)
        validate_xml(teiparsed, filename, rngfile)
        check_ids(teifile, teiparsed)

main(teipath, rngfile)
