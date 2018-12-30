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

Output: The script writes three files to the output folder "Metadata":
- A CSV file called "metadata.csv" with some basic metadata about the texts included in the collection
- A file called "report_corpus.txt" with a simple JSON-style string with information
about the corpus composition criteria for ELTeC collections.
- A file called "report_full.txt" with a simple JSON-style string that has some more,
maybe less universally useful information about the files.

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


# === Parameters ===

workingDir = join("..", "..", "ELTeC-fra")

teiFolder = join(workingDir, "level1", "*.xml")
metadataFolder = join(workingDir, "Metadata")
reportFile = join(workingDir, "report.md")

xpaths = {"xmlid" : "//tei:TEI/@xml:id", 
          "title" : "//tei:titleStmt/tei:title/text()",
          "title-ids" : "//tei:titleStmt/tei:title/@ref",
          "au-ids" : "//tei:titleStmt/tei:author/@ref",
          "numwords" : "//tei:extent/tei:measure[@unit='words']/text()",
          "au-gender" : "//tei:textDesc/eltec:authorGender/@key",
          "sizeCat" : "//tei:textDesc/eltec:size/@key",
          "canonicity" : "//tei:textDesc/eltec:canonicity/@key",
          "time-slot" : "//tei:textDesc/eltec:timeSlot/@key",
          "copytext-yr" : "//tei:bibl[@type='copyText']/tei:date/text()",
          "firsted-yr" : "//tei:bibl[@type='firstEdition']/tei:date/text()",
          "language" : "//tei:langUsage/tei:language/@ident"}

ordering = ["filename", "xmlid", "au-name", "title", "au-birth", "au-death",
            "au-gender", "au-ids", "copytext-yr", "firsted-yr", "title-ids",
            "sizeCat", "canonicity", "time-slot", "numwords", "language"]


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
        name = re.search("(.*?) \(", authordata).group(1)
        birth = re.search("\((\d\d\d\d)", authordata).group(1)
        death = re.search("(\d\d\d\d)\)", authordata).group(1)
    except: 
        name = "NA"
        birth = "NA"
        death = "NA"        
    return name,birth,death



def save_metadata(metadata, metadataFolder, ordering): 
    """
    Save all metadata to a CSV file. 
    The ordering of the columns follows the list defined above.
    """
    metadata = pd.DataFrame(metadata)
    metadata = metadata[ordering]
    with open(join(metadataFolder, "metadata.csv"), "w", encoding="utf8") as outfile: 
        metadata.to_csv(outfile)


def build_balancereport(allmetadata): 
    """
    Based on the metadata extracted in the previous steps, 
    calculate some basic corpus composition indicators. 
    """
    allmetadata = pd.DataFrame(allmetadata)
    allmetadata = allmetadata[ordering]
    # Number of novels
    num_novels = len(set(list(allmetadata.loc[:,"xmlid"])))
    # Number of texts per time period
    time_slots = dict(Counter(list(allmetadata.loc[:,"time-slot"])))
    # Number of texts per size category
    size_cats = dict(Counter(list(allmetadata.loc[:,"sizeCat"])))
    # Number of texts per canon level
    canon_levels = dict(Counter(list(allmetadata.loc[:,"canonicity"])))
    # Number of texts per author gender
    author_genders = dict(Counter(list(allmetadata.loc[:,"au-gender"])))
    report = {"num_novels" : num_novels, 
              "timeSlots" : time_slots,
              "sizeCats" : size_cats,
              "canonicity" : canon_levels,
              "au-gender" : author_genders}
    import pprint
    pp = pprint.PrettyPrinter(indent=0, width=30, compact=True) 
    pp.pprint(report)
    return report


def save_report(report, filename): 
    with open(filename, "w", encoding="utf8") as outfile:
        outfile.write(str(report))
    

def build_fullreport(allmetadata): 
    """
    Based on the metadata extracted in the previous steps, 
    calculate some basic corpus composition indicators. 
    """
    from collections import Counter
    allmetadata = pd.DataFrame(allmetadata)
    allmetadata = allmetadata[ordering]
    # Number of novels
    num_novels = len(set(list(allmetadata.loc[:,"xmlid"])))
    # Number of authors
    num_authors = len(set(list(allmetadata.loc[:,"au-name"])))
    # Number of texts per time period
    time_slots = dict(Counter(list(allmetadata.loc[:,"time-slot"])))
    # Number of texts per size category
    size_cats = dict(Counter(list(allmetadata.loc[:,"sizeCat"])))
    # Number of texts per size category
    canon_levels = dict(Counter(list(allmetadata.loc[:,"canonicity"])))
    # Number of texts per author gender
    author_genders = dict(Counter(list(allmetadata.loc[:,"au-gender"])))
    # Number of texts per author
    texts_per_author = dict(Counter(list(allmetadata.loc[:,"au-name"])))
    # Number of authors per text-count 
    authors_per_textcount = Counter(list(texts_per_author.values()))
    # Text lengths
    text_lengths = list(allmetadata.loc[:,"numwords"])
    report = {"num_novels" : num_novels, 
              "num_authors": num_authors, 
              "timeSlots" : time_slots,
              "sizeCats" : size_cats,
              "canonicity" : canon_levels,
              "au-gender" : author_genders,
              "texts-per-au" : texts_per_author,
              "aus-per-textcount" : authors_per_textcount,
              "text_lengths" : text_lengths}
    import pprint
    pp = pprint.PrettyPrinter(indent=0, width=30, compact=True) 
    pp.pprint(report)
    return report


def make_buildmd(allmetadata, fullreport, reportFile, metadataFolder):
    """
    Creates several plots from some metadata 
    and a report.md markdown file embedding the plots.
    """
    allmetadata = pd.DataFrame(allmetadata)
    import pygal
    from pygal.style import CleanStyle
    from pygal.style import Style   
    mystyle = CleanStyle(font_family="sans-serif")
    # Pygal chart configuration
    from pygal import Config
    config = Config()
    config.legend_at_bottom=True
    config.legend_at_bottom_columns=3
    config.print_values=True
    config.style=mystyle
    #config.width=500
    #config.height=300
    config.font_family="Arial"
    # Donut chart for author genders
    genders = dict(Counter(allmetadata.loc[:,"au-gender"]))
    chart = pygal.Pie(config,
    title ="Number of novels per author gender",
    inner_radius=.60,
    font_family="sans-serif")
    chart.add("male", genders["M"])
    chart.add("female", genders["F"])
    chart.add("other", 0)
    chart.render_to_file(join(metadataFolder, "au-genders.svg"))
    # Bar chart for time periods
    timeslots = dict(Counter(allmetadata.loc[:,"time-slot"]))
    chart = pygal.Bar(config, range=(0,30),
    title ="Number of novels per 20-year period",
    font_family="sans-serif",
    legend_at_bottom_columns=4)
    chart.add("1840-1859", timeslots["T1"])
    chart.add("1860-1879", timeslots["T2"])
    chart.add("1880-1899", timeslots["T3"])
    chart.add("1900-1919", timeslots["T4"])
    chart.render_to_file(join(metadataFolder, "timeslots.svg"))
    # Save report.md with embedded charts
    reportmd = "## Corpus composition for ELTeC-fra\n\n<img src=\"/Metadata/au-genders.svg\">\n<img src=\"/Metadata/timeslots.svg\">"
    with open(reportFile, "w", encoding="utf8") as outfile: 
        outfile.write(reportmd)
    
    


# === Coordinating function ===

def main(teiFolder, metadataFolder, xpaths, ordering, reportFile):
    """
    From a collection of ELTeC XML-TEI files,
    create a CSV file with some metadata about each file.
    """
    if not os.path.exists(metadataFolder):
        os.makedirs(metadataFolder)
    allmetadata = []
    for teiFile in glob.glob(teiFolder): 
        filename,ext = basename(teiFile).split(".")
        #print(filename)
        if "schemas" not in filename:
            keys = []
            metadata = []
            keys.append("filename")
            metadata.append(filename)
            xml = open_file(teiFile)
            name,birth,death = get_authordata(xml)
            keys.extend(["au-name", "au-birth", "au-death"])
            metadata.extend([name, birth, death])
            for key,xpath in xpaths.items(): 
                metadatum = get_metadatum(xml, xpath)
                keys.append(key)
                metadata.append(metadatum)
            allmetadata.append(dict(zip(keys, metadata)))
        save_metadata(allmetadata, metadataFolder, ordering)
    balancereport = build_balancereport(allmetadata)
    save_report(balancereport, join(metadataFolder, "report_composition.txt"))
    fullreport = build_fullreport(allmetadata)
    save_report(fullreport, join(metadataFolder, "report_full.txt"))
    make_buildmd(allmetadata, fullreport, reportFile, metadataFolder)
    
main(teiFolder, metadataFolder, xpaths, ordering, reportFile)
