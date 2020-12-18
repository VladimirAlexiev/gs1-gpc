#!perl -wn
# Converts GS1 GPC XML file to TSV.

use Lingua::EN::PluralToSingular qw(to_singular); # https://metacpan.org/pod/distribution/Lingua-EN-PluralToSingular/lib/Lingua/EN/PluralToSingular.pod

BEGIN {
  binmode STDOUT, ":utf8"; # because we convert Unicode escapes to UTF
  # print "0code\tname\tdef (kind)\n"; # MnM import doesn't want a header line
}

# Option -n causes the following to be iterated for each line

next if m{^<[/?]}; # skip header and footer lines, as well as closing tags

# Convert XML and Unicode escapes to real chars
s{&lt;}{<}g;
s{&gt;}{>}g;
s{&amp;}{&}g;
s{&apos;}{'}g;
s{&quot;}{"}g;
s{&#160;}{ }g;
s{\t}{ }g;
s{&#(\d+);}{chr$1}ge;

# Output tab-delimited line
($kind,$code,$name,$def) = m{<(\w+) code="(.*?)" text="(.*?)" definition="(.*?)"/?>}
  or die "can't match $_";
$name =~ s{ - UNCLASSIFIED}{}g; # eg "ROMANIA - UNCLASSIFIED"
$name =~ m{ (Other|Variety Packs)$} and $def .= " $1" and $name =~ s{}{}; # alternatively, kill such lines since for every "X Other", there's also "X"
$name = lc($name);
($name1,$name2) = $name =~ m{^(.*?)( \(.*\))?$}; # split out parenthesized qualifier
$name = to_singular($name1);
$name .= $name2 if $name2; # add back qualifier
print "$code\t$name\t$def (GPC $kind)\n";
