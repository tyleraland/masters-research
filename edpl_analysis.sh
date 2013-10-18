gene=$1
for jplace in ~/COGs/$gene/*.jplace; do
    guppy edpl $jplace | awk '{print $2}' >> ~/outfiles/$gene/edpls_all_reads
done;
