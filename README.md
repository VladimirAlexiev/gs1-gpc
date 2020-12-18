# gs1-gpc

Convert GS1 GPC codes to TSV for [import](https://mix-n-match.toolforge.org/import.php) to Wikidata Mix-n-Match.
- https://www.gs1.org/standards/gpc: source, file `GS1 Combined Published  as at 01062020 EN.xml`
- https://www.wikidata.org/wiki/Wikidata:Property_proposal/GS1_GPC_brick_code: discussion and details
- https://www.wikidata.org/wiki/Property:P8957: property

Files:
- `convert.bat`: joins broken description lines in source file, invokes perl script, dispatches output to 3 files
- `gpc.xml`: same as source, but with joined description lines
- `convert.pl`: converts XML to TSV while making various fixes
- `gpc.tsv`: code, name, description (in parentheses: GPC kind: `segment, family, class, brick, attValue, attType`)
- `gpc-hier.tsv`: hierarchical thesaurus (`segment>family>class>brick`)
  - Loaded to https://mix-n-match.toolforge.org/#/catalog/4062 (to update)
- `gpc-attValue.tsv`: attribute values
  - Loaded to https://mix-n-match.toolforge.org/#/catalog/4063 (to update)
- `gpc-attType.tsv`: attribute types: useless as WD items, too many for WD props

Dependencies:
- `cpanm Lingua::EN::PluralToSingular`

Problems and fixes:
- DONE: remove heading rows, MnM Import doesn't like them
- DONE: lowercase the names; especially big problem for Attribute Values (eg created Q104244383 AUTOMATIC PET WATER DISH), is incorrect for some cases (eg value "ROMANIA")
- DONE: cut out trailing " - UNCLASSIFIED"
- DONE: move trailing "Other", "Variety Packs" from name to descr to improve matching; and collapse such bricks that are not appropriate for WD into the parent class
- DONE: sort Attribute Values by popularity to incentivize matching
- DONE: convert names to **singular** (module `Lingua::EN::PluralToSingular`)
- TODO: list the Attribute Type(s) that pertain to a Value in order to clarify the value: HARD
- TODO: reload the catalogs while preserving the matches (about 20+15)
