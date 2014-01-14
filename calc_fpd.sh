echo "gene,ave_phylo_diversity" > ~/outfiles/all_ave_phylo_diversity.csv
for gene in `cat ~/genes_coverage`; do
  AVE=`guppy fpd --csv ~/COGs/$gene/*.jplace | awk -F',' 'NR>1 {SUM += $4; ROWS += 1} END {print SUM/ROWS}'`
  echo $gene,$AVE >> ~/outfiles/all_ave_phylo_diversity.csv
done
