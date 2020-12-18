#!sh

# join broken description lines
perl -0pe "s{([^>])\n}{$1}g" "GS1 Combined Published  as at 01062020 EN.xml" > gpc.xml

# convert to TSV;
# split out to: thesaurus hierarchy (catalog 4062), attribute values (catalog 4063), attribute types (useless as items, and too many for WD props)

perl convert.pl gpc.xml > gpc.tsv
grep -vP "(attType|attValue)" gpc.tsv > gpc-hier.tsv
grep  -P "attType"  gpc.tsv |sort | uniq > gpc-attType.tsv
grep  -P "attValue" gpc.tsv |sort | uniq -c | sort -rn > gpc-attValue.tsv
