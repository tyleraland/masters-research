# This script calculates the sum of all reads' EDPL for each gene with good
# coverage.  It further calculates those genes' reference trees' total branch
# length and the total number of reads for that gene.

echo "gene,total_reads,total_edpl,branch_lengh" > ~/outfiles/total_edpls.csv 
for gene in `cat ~/genes_coverage`; do
        TOTALEDPL=$(cat ~/outfiles/$gene/edpls_all_reads | awk '{edpl += $1} END {print edpl}')
        BRANCHLEN=`Rscript branchlength.R ~/outfiles/$gene/$gene\_tree`
        NUMREADS=`cat ~/outfiles/$gene/edpls_all_reads | wc -l` 
    echo "$gene,$NUMREADS,$TOTALEDPL,$BRANCHLEN" >> ~/outfiles/total_edpls.csv
done;
