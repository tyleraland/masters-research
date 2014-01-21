# This script attempts measures, for each gene's reference tree package, the 
# number of convex taxa at the phylum level and the total number of taxa in
# the tree

echo "gene,convex_taxa,total_taxa"
for gene in `cat ~/genes_coverage`; do
  TOTALTAXA=$(echo $(cat /home/kodnerr/share/refpkgs022212/$gene.refpkg/$gene.ref.tax_map.csv | wc -l) - 1 | bc)
  TAXA=$(rppr convex_taxids -c /home/kodnerr/share/refpkgs022212/$gene.refpkg/ | grep "^phylum" | wc -l)
  echo $gene,$TAXA,$TOTALTAXA
done
