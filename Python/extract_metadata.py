#!/usr/bin/env python3

"""
Script (a) for building a metadata table from ELTeC XML-TEI 
and (b) for creating some basic corpus composition statistics.

The XML-TEI files need to be valid against the ELTeC level1 schema.

Requirements: This script runs in Thonny, https://thonny.org/,
if the packages pandas and lxml are installed via the package manager.
Advanced users of Python will know how to get it to work in their preferred environment. 

Usage: The only parameter you should need to adjust is the path
encoded in the variable "workingDir" (line 47), to point it to the appropriate
language collection folder.

Assuming you cloned the Scripts repository to the same place as the language
collections repositories, you go one level up ("..") and then down
to the appropriate language collection folder (e.g. "ELTec-por"). 
Advanced users may want to change the XPath expressions to match their TEI encoding.

Output: The script writes one file:
- A TSV file called "[collection]_metadata.tsv" with some basic metadata about the texts included in the collection

Please send feedback to Christof at "schoech@uni-trier.de". 
"""




# === Import statements ===

import os
import re
import glob
from os.path import join
from os.path import basename
import pandas as pd
from lxml import etree
from collections import Counter


# === Files and folders ===

corpora = [
"ELTeC-cze",
"ELTeC-deu",
"ELTeC-eng",
"ELTeC-eng-ext",
"ELTeC-fra",
"ELTeC-fra-ext1",
"ELTeC-fra-ext2",
"ELTeC-fra-ext3",
"ELTeC-gsw",
"ELTeC-hrv",
"ELTeC-hun",
"ELTeC-ita",
"ELTeC-lav",
"ELTeC-lit",
"ELTeC-nld",
"ELTeC-nor",
"ELTeC-nor-ext",
"ELTeC-pol",
"ELTeC-por",
"ELTeC-por-ext",
"ELTeC-rom",
"ELTeC-rus",
"ELTeC-slv",
"ELTeC-spa",
"ELTeC-srp",
"ELTeC-srp-ext",
"ELTeC-swe",
"ELTeC-ukr",
    ]

#corpora = ["ELTeC-fra", "ELTeC-pol"] # for testing


level = "level1"


# === Parameters === 

xpaths = {
    "xmlid" : "//tei:TEI/@xml:id", 
    "title" : "//tei:titleStmt/tei:title/text()",
    "title-ids" : "//tei:titleStmt/tei:title/@ref",
    "author-ids" : "//tei:titleStmt/tei:author/@ref",
    "numwords" : "//tei:extent/tei:measure[@unit='words']/text()",
    "narrative-perspective" : "//tei:textClass/tei:keywords/tei:term[@type='narrative-perspective']/text()",
    "subgenre" : "//tei:textClass/tei:keywords/tei:term[@type='subgenre']/text()",
    "author-gender" : "//tei:textDesc/eltec:authorGender/@key",
    "size-category" : "//tei:textDesc/eltec:size/@key",
    "reprint-count" : "//tei:textDesc/eltec:reprintCount/@key",
    "time-slot" : "//tei:textDesc/eltec:timeSlot/@key",
    "first-edition" : "//tei:bibl[@type='firstEdition']/tei:date/text()",
    "print-edition" : "//tei:bibl[@type='printSource']/tei:date/text()",
    "digital-edition" : "//tei:bibl[@type='digitalSource']/tei:date/text()",
    "provenance" : "//tei:bibl[@type='digitalSource']/tei:publisher/text()",
    "language" : "//tei:langUsage/tei:language/@ident"}

ordering = [
    "corpus-id",
    "filename", 
    "xmlid", 
    "author-name", 
    "title", 
    "author-birth", 
    "author-death", 
    "author-gender",
    "author-ids", 
    "reference-year",
    "first-edition",
    "digital-edition",
    "print-edition", 
    "provenance", 
    "title-ids", 
    "language", 
    "numwords", 
    "subgenre", 
    "narrative-perspective",
    "size-category", 
    "reprint-count", 
    "time-slot"]

sorting = ["reference-year", True] # column, ascending?


# === Functions ===


def open_file(teiFile): 
    """
    Open and parse the XML file. 
    Returns an XML tree.
    """
    with open(teiFile, "r", encoding="utf8") as infile:
        xml = etree.parse(infile)
        return xml



def get_metadatum(xml, xpath): 
    """
    For each metadata key and XPath defined above, retrieve the 
    metadata item from the XML tree.
    Note that the individual identifers for au-ids and title-ids 
    are not split into individual columns.
    """
    try: 
        namespaces = {'tei':'http://www.tei-c.org/ns/1.0',
                      'eltec':'http://distantreading.net/eltec/ns'}       
        metadatum = xml.xpath(xpath, namespaces=namespaces)[0]
    except: 
        metadatum = "NA"
    metadatum = re.sub(": ELTeC edition", "", metadatum)
    metadatum = re.sub(" : ELTeC edition", "", metadatum)
    metadatum = re.sub(" : ELTeC Edition", "", metadatum)
    metadatum = re.sub(": ELTeC Edition", "", metadatum)
    metadatum = re.sub(" : ELTec edition", "", metadatum)
    metadatum = re.sub(" : ELTeC\n     edition", "", metadatum, re.DOTALL)
    metadatum = re.sub(" : édition ELTeC", "", metadatum)
    metadatum = re.sub(" : edition ELTeC", "", metadatum)
    metadatum = re.sub(" : vydání ELTeC", "", metadatum)
    metadatum = re.sub(" \(vydání ELTeC\)", "", metadatum)
    metadatum = re.sub(" : ELTeC ausgabe", "", metadatum) 
    metadatum = re.sub(": MiMoText edition", "", metadatum)     
    metadatum = re.sub(" : ELTeC kiadás", "", metadatum) 
    metadatum = re.sub(": edizion ELTeC", "", metadatum) 
    metadatum = re.sub(" : Edição para o ELTeC", "", metadatum) 
    metadatum = re.sub(": Edição para o ELTeC", "", metadatum) 
    metadatum = re.sub(": edição para o ELTeC", "", metadatum) 
    metadatum = re.sub(": editie ELTeC", "", metadatum) 
    metadatum = re.sub(": ediție ELTeC", "", metadatum) 
    metadatum = re.sub(": Ediție ELTeC", "", metadatum) 
    metadatum = re.sub(" : edicija ELTeC", "", metadatum) 
    metadatum = re.sub(" : edición ELTeC", "", metadatum) 
    metadatum = re.sub(" : Edición ELTeC", "", metadatum) 
    metadatum = re.sub(" : ELTeC издање", "", metadatum) 
    metadatum = re.sub(" : ELTeC видання", "", metadatum)     
    metadatum = metadatum.strip()
    metadatum = re.sub("\n", "", metadatum)
    return metadatum


def get_authordata(xml): 
    """
    Retrieve the author field and split it into constituent parts.
    Expected pattern: "name (alternatename) (birth-death)"
    where birth and death are both four-digit years. 
    The alternate name is ignored. 
    Note that the first and last names are not split into separate
    entries, as this is not always a trivial decision to make.
    """
    try: 
        namespaces = {'tei':'http://www.tei-c.org/ns/1.0'}       
        authordata = xml.xpath("//tei:titleStmt/tei:author/text()",
                               namespaces=namespaces)[0]
        authordata = authordata.strip()
        name = re.search("(.*?) \(", authordata).group(1)
    except: 
        if "nonymous" in authordata: 
            name = "Anonymous"
        else: 
            name = "NA"
    try: 
        birth = re.search("\((\d\d\d\d)", authordata).group(1)
    except: 
        birth = "NA"
    try: 
        death = re.search("(\d\d\d\d)\)", authordata).group(1)
    except: 
        death = "NA"        
    return name, birth, death


def get_reference_year(row, metadata): 
    """
    Determine a year of reference for the earliest documented year of publication, 
    or alternatively, the earliest year of known completion of the text. 
    For a closed list of texts, where it is known that publication was much later than
    production, a date is supplied here explicitly. 
    For all other cases, a heuristics is used to use the earliest documented year. 
    """
    # Texts with known year of completion but much later publication
    if row["xmlid"] == "Diderot_Neveu": 
        ref_year = "1773"
    if row["xmlid"] == "FRA20018": 
        ref_year = "1773"
    if row["xmlid"] == "DEU004": 
        ref_year = "1859"
    if row["xmlid"] == "DEU049": 
        ref_year = "1863"

    # Other novels where a useful year of publication is known
    elif row["first-edition"] != "NA": 
        ref_year = re.sub("\D", "", row["first-edition"])[-4:]
    # Other novels still, where at least a useful, early print edition was used and is known. 
    elif row["print-edition"] != "NA": 
        ref_year = row["print-edition"][-4:]
    elif row["digital-edition"] != "NA": 
        ref_year = row["digital-edition"][-4:]
    else: 
        ref_year = "NA"
        ref_year = "1880"
    return ref_year


def save_metadata(metadata, metadatafile, ordering, sorting): 
    """
    Save all metadata to a CSV file. 
    The ordering of the columns follows the list defined above.
    """
    metadata = pd.DataFrame(metadata)
    metadata["reference-year"] = metadata.apply(lambda x: get_reference_year(x, metadata), axis=1)
    metadata["language"] = metadata["language"].str.lower()
    metadata = metadata[ordering]
    #print(metadata.head())
    #print(metadata.columns)
    metadata = metadata.sort_values(by=sorting[0], ascending=sorting[1])
    #print(metadatafile)
    with open(join(metadatafile), "w", encoding="utf8") as outfile: 
        metadata.to_csv(outfile, sep="\t", index=None)


# === Coordinating function ===

def main(corpus, level, xpaths, ordering, sorting):
    """
    From a collection of ELTeC XML-TEI files,
    create a CSV file with some metadata about each file.
    """
    print(corpus, end=" ")
    try: 
        current_dir = join(os.path.realpath(os.path.dirname(__file__)))
        workingDir = join(current_dir, "..", "..", corpus)
        teiFolder = join(workingDir, level, "*.xml")
        metadatafile = join(current_dir, "..", "..", corpus, corpus+"_metadata.tsv")
        allmetadata = []
        counter = 0
        for teiFile in glob.glob(teiFolder): 
            filename,ext = basename(teiFile).split(".")
            #print(filename)
            try: 
                if "schemas" not in filename:
                    counter +=1
                    keys = []
                    metadata = []
                    keys.append("filename")
                    metadata.append(filename)
                    xml = open_file(teiFile)
                    name, birth, death = get_authordata(xml)
                    keys.extend(["corpus-id", "author-name", "author-birth", "author-death"])
                    metadata.extend([corpus, name, birth, death])
                    for key,xpath in xpaths.items(): 
                        metadatum = get_metadatum(xml, xpath)
                        keys.append(key)
                        metadata.append(metadatum)
                    allmetadata.append(dict(zip(keys, metadata)))
            except: 
                print("ERROR!!!", filename)
        print(":", counter, "files.")
        save_metadata(allmetadata, metadatafile, ordering, sorting)
    except: 
        print("ERROR :-(")

for corpus in corpora:     
    main(corpus, level, xpaths, ordering, sorting)
