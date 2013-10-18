#if [ -e ~/outfiles/total_edpls.csv ]; then
#        rm ~/outfiles/total_edpls.csv
#fi;
echo "gene,total_edpl" > ~/outfiles/total_edpls.csv 
for gene in `cat ~/genes_coverage`; do
        TOTALEDPL=$(cat ~/outfiles/$gene/edpls_all_reads | awk '{edpl += $1} END {print edpl}')
    echo "$gene,$TOTALEDPL" >> ~/outfiles/total_edpls.csv
done;
