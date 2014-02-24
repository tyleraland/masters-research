echo "gene,ave_phylo_diversity" > all_ave_phylo_diversity.csv
#echo "gene,phylo_diversity" > all_PD.csv
#echo "gene,abundance_weighted_PD" > all_AW_PD.csv
for gene in `cat ~/genes_coverage`; do
  AVE=`guppy fpd --csv ~/COGs/$gene/*.jplace | awk -F',' 'NR>1 {SUM += $4; ROWS += 1} END {print SUM/ROWS}'`
  AVEAW=`guppy fpd --csv ~/COGs/$gene/*.jplace | awk -F',' 'NR>1 {SUM += $6; ROWS += 1} END {print SUM/ROWS}'`
  #PD=`guppy fpd --csv ~/analysis/$gene/*.jplace | awk -F',' 'NR>1 {print $4}'`
  #AWPD=`guppy fpd --csv ~/analysis/$gene/*.jplace | awk -F',' 'NR>1 {print $6}'`
  #echo $gene,$PD >> all_PD.csv
  #echo $gene,$AWPD >> all_AW_PD.csv
  echo $gene,$AVE >> all_ave_phylo_diversity.csv
  echo $gene,$AVEAW >> all_ave_AW_phylo_diversity.csv
done
