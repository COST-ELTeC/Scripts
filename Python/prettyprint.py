import lxml
from lxml import etree
import xml.dom.minidom
from os.path import join
import re
from bs4 import BeautifulSoup

xmlfile = join("..", "..", "ELTeC-fra", "level1", "FRA00101_Adam_test.xml")


def prettify(xmlfile): 
    with open(xmlfile, "r", encoding="utf8") as xmldata:
        prettyxml = BeautifulSoup(xmldata, "xml").prettify()
        print(prettyxml)
        return prettyxml
    #tree = lxml.etree.parse(xmlfile)
    #prettyxml = lxml.etree.tostring(tree, encoding="unicode", #pretty_print=True)
    #print(prettyxml[1000:2000])

#pretty = lxml.etree.tostring(tree, encoding="unicode", pretty_print=True)
#        xmldata = xml.dom.minidom.parseString(xmldata.read())
#        prettyxml = xmldata.toprettyxml()
#        prettyxml = re.sub("\n{2,10}", "\n", prettyxml, re.DOTALL)
#        return prettyxml


def save_prettyxml(prettyxml, xmlfile): 
    with open(xmlfile, "w", encoding="utf8") as outfile: 
        outfile.write(prettyxml)




def main(xmlfile): 
    prettyxml = prettify(xmlfile)
    save_prettyxml(prettyxml, xmlfile)


main(xmlfile)

