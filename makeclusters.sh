#!/bin/sh
#$ -S /bin/sh
# Submit via qsub
# Usage: ./makeclusters.sh ITERS GENE

#$ -cwd
#$ -N clustering
cd /home/landt/Code/research
PATH=$SGE_O_PATH:$PATH

GENE=$1
ITERS=$2
#TEMPDIR="$HOME/outfiles"
TEMPDIR="/state/partition1/landt"
OUTDIR="/home/landt/outfiles"

if [ ! -d $TEMPDIR ]; then
    mkdir $TEMPDIR
fi
if [ ! -d $TEMPDIR/$GENE ]; then
    mkdir $TEMPDIR/$GENE
fi
if [ ! -d $OUTDIR/$GENE ]; then
    mkdir $OUTDIR/$GENE
fi

rm -r $TEMPDIR/$GENE/*

echo "PERTURBING"
# Produce perturbed .jplace files for GENE
# Output files named i_SAMPLE.jplace, i=0..ITERS
# 0_ files are the original unperturbed data
python perturb.py $ITERS $GENE $TEMPDIR/$GENE/ $RANDOM

echo "UNPERTURBED PCA"
# Unperturbed data files live in $HOME/COGs/$GENE
guppy pca --out-dir $TEMPDIR/$GENE --prefix 0\_$GENE $HOME/COGs/$GENE/*.jplace # Projects unperturbed data into PCA space, produces .trans file
# Save .trans file
cp $TEMPDIR/$GENE/0\_$GENE.trans $OUTDIR/$GENE/

echo "UNPERTURBED SQUASH"
guppy squash --out-dir $TEMPDIR/$GENE --prefix 0\_$GENE $HOME/COGs/$GENE/*.jplace > /dev/null # Output is 0_cluster.tre
# Save .tre file
cp $TEMPDIR/$GENE/0\_"$GENE"cluster.tre $OUTDIR/$GENE/

echo "PERTURBED PCA/SQUASH"
# Each batch of perturbed SAMPLE_i.jplace have PCA, squash applied
# Perturbed data files live in $HOME/$TEMPDIR/$GENE/ thanks to perturb.py
# (Useful) Outputs: TEMPDIR/GENE/i_.{trans, cluster.tre}
for ((i=1; i<=$ITERS; i++)); do
    guppy pca --out-dir $TEMPDIR/$GENE --prefix $i\_$GENE $TEMPDIR/$GENE/*\_$i.jplace # Projects perturbed data into PCA space, produces .trans
    guppy squash --out-dir $TEMPDIR/$GENE --prefix $i\_$GENE $TEMPDIR/$GENE/*\_$i.jplace  > /dev/null # Output is i_GENEcluster.tre
done

rm $TEMPDIR/$GENE/*.jplace
echo "CUTTING CLUSTERING"
# Takes hierarchical clustering (tree) from above, cuts it using cutree
# Produces a clustering vector for each method for each iteration
# Vectors are saved to file in TEMPDIR/GENE/GENE_clusters
# data structure has ITERS*(6 methods) vectors of length |samples|
Rscript clusters.R $TEMPDIR $OUTDIR $GENE $ITERS

#cp $TEMPDIR/$GENE/0\_$GENE\_clusters /home/landt/gene_clusters2
#cp $TEMPDIR/$GENE/statfile /home/landt/gene_clusters2/$GENE\_statfile
cp $TEMPDIR/$GENE/statfile $OUTDIR/$GENE/statfile
