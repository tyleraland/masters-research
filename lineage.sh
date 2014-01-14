for gene in COG0253 COG1052 COG0516 COG1472 COG4585 COG0190 COG1120 COG5000 COG1454; do
  a=`grep -c $gene /home/kodnerr/share/COG_test/lineage/Tyler_Confindent_scores.csv`
  echo "$gene confident: $a"
  b=`grep -c "$gene" /home/kodnerr/share/COG_test/lineage/Tyler_junk.csv`
  echo "$gene junk: $b"
  c=`grep -c "$gene" /home/kodnerr/share/COG_test/lineage/Tyler_unknown.csv`
  echo "$gene unknown: $c"
  t=`echo $a + $b + $c | bc`
  echo "$gene total: $t"
  echo $gene %-confident: $(echo "scale=3; $a / $t" | bc)
  echo $gene %-junk:      $(echo "scale=3; $b / $t" | bc)
  echo $gene %-unknown:   $(echo "scale=3; $c / $t" | bc)
  echo ""
done
