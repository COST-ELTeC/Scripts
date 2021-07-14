# POSPipe

This folder contains source code for a python pipeline designed to apply POS tagging to a TEI XML file (specifically, an ELTeC text) without disturbing or removing the original TEI-XML tagging.
 
It relies on the following components, all of which need to be installed along with your favourite python processor

- treetagger (tree-tagger-linux-3.2 from 
[https://www.cis.uni-muenchen.de/~schmid/tools/TreeTagger/](https://www.cis.uni-muenchen.de/~schmid/tools/TreeTagger/))
- saxonc (libsaxon-HEC-setup64-v1.2.1, from 
[https://www.saxonica.com/html/download/download_page.html](https://www.saxonica.com/html/download/download_page.html))
- treetaggerwrapper (see 
[https://treetaggerwrapper.readthedocs.io/en/latest/](https://treetaggerwrapper.readthedocs.io/en/latest/) for detailed instructions)
- saxon-python also needs Cython, if you don't already have that installed
- and you also need UDPmap (this is a tiny module I wrote to map the POS tagset used by treetagger onto the UDP tagset)


The file `posTag.py` does all the work. It proceeds as follows:


1. Given the name of a language repository, it looks for the file `driver.tei` in its root and transforms it using the XSLT script `getFileNames.xsl`  in order to extract the names of the files to be processed. The resulting list is returned as a Python object.
1. For each filename in the list returned:

   1.  create a new output file in the folder level-2 of the target repository
   1. use the XSLT script `getHdr.xsl` to extract from each file a start-tag for the new TEI element and a modified version of the existing TEI Header; write these to the new output file and close it
   1. use the XSLT script `getTxt.xsl` to extract from each file a string containing (almost) the whole of its  `<text>` element as a Python object. Since treetagger does not cope well with XML comments I remove them at this stage; since it has problems with character entity references I pre-translate these too.
   1. Pass this string to a Python process created by treetaggerwrapper and reformat the named tuples returned by this process as TEI-ELTeC-level2-compatible `<w>` tags. Append these to the output file created in step 2a.
   1. When input is exhausted, output a closing `</TEI>` tag
            
Treetagger is by no means the only POS tagger around, of course. Its biggest selling point for me is that it knows to leave XML tags well alone, and just passes them through to the output. It comes with an impressive suite of  language models, and also has a facility to top up the existing model with items missing from its lexicon. (I make use of this to POS-tag smart quotes and ampersands correctly)

My thanks to colleagues on ELTeC WG2, and also to Laurent Pointal for responding helpfully to my idiot questions during the process of getting this all to work.

Lou Burnard
Bastille Day 2021
