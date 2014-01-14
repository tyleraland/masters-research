echo "gene,total_reads,total_edpl,branch_length" > ~/outfiles/total_edpls.csv # Blow away old file; add header
for gene in `cat ~/genes_coverage`; do
    #for jplace in ~/COGs/$gene/*.jplace; do
    #    guppy edpl $jplace | awk '{print $2}' >> ~/outfiles/$gene/edpls_all_reads
    #done;
    TOTALEDPL=`cat ~/outfiles/$gene/edpls_all_reads | awk '{edpl += $1} END {print edpl}'`
    BRANCHLEN=`Rscript branchlength.R ~/outfiles/$gene/$gene\_tree`
    NUMREADS=`cat ~/outfiles/$gene/edpls_all_reads | wc -l` 
    echo "$gene,$NUMREADS,$TOTALEDPL,$BRANCHLEN" >> ~/test_total_edpls.csv
done;

