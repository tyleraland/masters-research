OUTDIR="/home/landt/outfiles"
TEMPDIR="/home/landt/outfiles"
ITERS=0

for GENE in `cat ~/COG_list`; do
    echo $GENE
    Rscript clusters.R $TEMPDIR $OUTDIR $GENE $ITERS
done;
