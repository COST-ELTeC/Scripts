# Scripts
contains generic scripts for manipulating, processing, validating individual ELTeC repositories

 - REFRESH
  Updates your local copy of each repo by doing "git pull"; write a new version of the file driver.tei.  Run `python3 Scripts/refresh.py` (or bash script `refresh`)

 - SUMMARIZE
  Processes the driver.tei file made by REFRESH to create a new summary of the whole collection as an index.html file stored in your local copy of the distantreading.github.io repository. Run `python3 Scripts/summarize.py` (or bash script `summarize`)

 - REPORT
  Processes the driver.tei file made by REFRESH to create a new index.html file listing titles etc. for each repository, stored in your local copy of the distantreading.github.io repository. Run `python3 Scripts/report.py` (or bash script `report`)

 - EXPOSE
  Processes the driver.tei file made by REFRESH to create HTML link files for each title in each repository, stored in your local copy of the distantreading.github.io repository. These link files transform and display the source XML files direct from the main repository, using CSS and Javascript files stored in the distantreading.github.io repository.
  Run `python3 Scripts/expose.py` 

* N extremely B * if you run any of these except the first, don't forget to commit and push the changes if you want them to be visible at http://distantreading.,github.io/ELTeC !!


- `Makefile`
  - copy this into the root of your local copy of an ELTEC repo
  - edit LOCAL to point to the path for your local copy of the repo
  - edit LANG to match the language of your repo (e.g. `eng` for English)
  - edit the PREFIX to match the prefix of your text files (e.g. `ENG`)
  - run `make driver` to generate a driver file which will process all available text files
  - run `make validate` to check validity of each text file individually
  - run `make report` to generate a *balance report* using the `reporter.xsl` stylesheet



