# Scripts
contains generic scripts for manipulating, processing, validating individual ELTeC repositories

- `refresh` : update local copies of each repo; update driver.tei in each repo
- `summarize` : update index.html summary in distantreading.github.io/ELTeC
- `report` : update index.html for each subdirectory on distantreading.github.io/ELTeC
- `expose` : update HTML links for each text in each subdirectory on distantreading.github.io/ELTeC

Don't forget to push changes from the distantreading.github.io after making them!


- `Makefile`
  - copy this into the root of your local copy of an ELTEC repo
  - edit LOCAL to point to the path for your local copy of the repo
  - edit LANG to match the language of your repo (e.g. `eng` for English)
  - edit the PREFIX to match the prefix of your text files (e.g. `ENG`)
  - run `make driver` to generate a driver file which will process all available text files
  - run `make validate` to check validity of each text file individually
  - run `make report` to generate a *balance report* using the `reporter.xsl` stylesheet



