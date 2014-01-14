for gene in `cat ~/genes_coverage`; do
  TOTALTAXA=$(echo $(cat /home/kodnerr/share/refpkgs022212/$gene.refpkg/$gene.ref.tax_map.csv | wc -l) - 1 | bc)
  TAXA=$(rppr convex_taxids -c /home/kodnerr/share/refpkgs022212/$gene.refpkg/ | grep "^phylum" | wc -l)
  echo $gene,$TAXA,$TOTALTAXA
done
