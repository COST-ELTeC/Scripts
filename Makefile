ECHO=
LOCAL=/home/lou/Public
LANG=cze
REPO=ELTeC-$(LANG)
PREFIX=cze
SCHEMA1=$(LOCAL)/WG1/distantreading.github.io/Schema/eltec-1.rng
CORPUS=$(LOCAL)/$(REPO)
CORPUS1=$(LOCAL)/$(REPO)/level1
SCHEMA0=$(LOCAL)/WG1/distantreading.github.io/Schema/eltec-0.rng
CORPUS0=$(LOCAL)/$(REPO)/level0
REPORTER=$(LOCAL)/Scripts/reporter.xsl
EXPOSE=$(LOCAL)/Scripts/expose.xsl
EXPOSEDIR=$(LOCAL)/WG1/distantreading.github.io/ELTeC/$(LANG)
CURRENT=`pwd`

validate:
	cd $(CORPUS)
	for f in  level1/$(PREFIX)*; do \
		echo $$f; \
		jing  $(SCHEMA1) $$f ; done; cd $(CURRENT);
	for f in  level0/$(PREFIX)*; do \
		echo $$f; \
		jing  $(SCHEMA0) $$f ; done; cd $(CURRENT);
driver:
	echo rebuild driver file
	echo '<teiCorpus xmlns="http://www.tei-c.org/ns/1.0" xmlns:xi="http://www.w3.org/2001/XInclude"><teiHeader><fileDesc> <titleStmt> <title>TEI Corpus testharness</title></titleStmt> <publicationStmt><p>Unpublished test file</p></publicationStmt><sourceDesc><p>No source driver file</p> </sourceDesc> </fileDesc> </teiHeader>' >  $(CORPUS)/driver.tei;\
	for f in  level?/$(PREFIX)*; do \
	echo "<xi:include href='$$f'/>" >> $(CORPUS)/driver.tei; \
	done;\
	 echo "</teiCorpus>" >> $(CORPUS)/driver.tei

report:	
	saxon -xi $(CORPUS)/driver.tei $(REPORTER) corpus=$(LANG) >$(CORPUS)/index.html
expose:
	cd $(CORPUS);
	for f in  level?/$(PREFIX)*; do \
	g=`echo $$f  | cut -d_ -f1`;\
	id=`basename  $$g .xml`;\
	echo $$id; \
	saxon fileName=$$f lang=$(LANG) $$f $(EXPOSE) > $(EXPOSEDIR)/$$id.html; \
	cp $(CORPUS)/index.html $(EXPOSEDIR);  done
