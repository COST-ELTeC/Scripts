# Scripts
This folder contains generic scripts for manipulating, processing, validating individual ELTeC repositories

## python scripts

 - REFRESH
  Updates your local copy of each repo by doing "git pull"; writes a new version of the file driver.tei which is used by subsequent processes.  Run `python3 Scripts/refresh.py` (or bash script `refresh`)

 - SUMMARIZE
  Processes the driver.tei file made by REFRESH to create a new summary of the whole collection of repos as an index.html file stored in your local copy of the distantreading.github.io repository. Run `python3 Scripts/summarize.py` (or bash script `summarize`)

 - REPORT
  Processes the driver.tei file made by REFRESH to create a new index.html file listing titles etc. for each repository, stored in your local copy of the distantreading.github.io repository. Run `python3 Scripts/report.py` (or bash script `report`)

 - EXPOSE
  Processes the driver.tei file made by REFRESH to create HTML link files for each title in each repository, stored in your local copy of the distantreading.github.io repository. These link files transform and display the source XML files direct from the main repository, using CSS and Javascript files stored in the distantreading.github.io repository.
  Run `python3 Scripts/expose.py` 
  
 - REFRESHREPO
  Does the equivalent of REFRESH, REPORT, EXPOSE for a single repository only. Run `python3 Scripts/refreshRepo.py xxx` to update repository for language code xxx. Note that the index page produced by SUMMARIZE is *not* updated by this script.

*N extremely B* if you run any of these except the first, don't forget to commit and push the changes if you want them to be visible at the website https://distantreading.github.io/ELTeC !!

These scripts assume you can run `saxon` from the command line, and that you have a local installation of `Rscript`.

You will need to edit these scripts:
 - to specify path names for your local installation
 - if you add a new language repository
 
## doing a release on zenodo

The Python script `release.py` checks for some common problems in the way ELTeC texts are encoded, applying fixes wherever possible, and producing a new version of the text with a modified publicationStmt (inter alia) ready for Zenodo. It can be run against a single file for testing purposes,  but it's meant to be used on a whole repository. To run it on the zzz language repository, use a command line like this `python Scripts/release.py zzz 2>zzzLog.txt` This will save the output from the script (it's quite chatty) in a file called zzzLog.txt for you to scan through looking for surprises. In general, any line with exclamation marks on it indicates a need for attention. Note also that this script only validates against the RELAXNG schema; the additional schematron checks defined by our ODD are only implemented when a text is opened in oXygen.  

 
 # shell scripts (not updated for a while)

- `Makefile`
  - copy this into the root of your local copy of an ELTEC repo
  - edit LOCAL to point to the path for your local copy of the repo
  - edit LANG to match the language of your repo (e.g. `eng` for English)
  - edit the PREFIX to match the prefix of your text files (e.g. `ENG`)
  - run `make driver` to generate a driver file which will process all available text files
  - run `make validate` to check validity of each text file individually
  - run `make report` to generate a *balance report* using the `reporter.xsl` stylesheet


## updating the eltec

To issue a complete new update run the scripts in the order shown above, i.e.

python refresh.py
python report.py
python summarize.py
python expose.py

These scripts will update your local copy of the distantreading.github.io pages. You still need to push them to the repo to see changes on the web.

If you've added any new texts since the last time, you will also need to add the new files to the distantreading.github.io/ELTeC/xxx language repo.
