for gene in `cat ~/genes_coverage`; do
    if [ -e ~/outfiles/$gene/dibs ]; then
        cp /state/partition1/landt/$gene/*
