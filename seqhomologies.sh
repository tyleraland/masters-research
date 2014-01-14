for gene in `cat ~/genes_coverage`; do
    echo $gene,$(python ~/Code/research/seqhomology.py /home/kodnerr/share/refpkgs022212/$gene\.refpkg/$gene\.ref\.fasta)
done
