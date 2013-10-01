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
#OUTDIR="$HOME/outfiles"
OUTDIR="/state/partition1/landt"

if [ ! -d $OUTDIR ]; then
    mkdir $OUTDIR
fi
if [ ! -d $OUTDIR/$GENE ]; then
    mkdir $OUTDIR/$GENE
fi

echo "PERTURBING"
# Produce perturbed .jplace files for GENE
# Output files named i_SAMPLE.jplace, i=0..ITERS
# 0_ files are the original unperturbed data
python perturb.py $ITERS $GENE $OUTDIR/$GENE/ $RANDOM

echo "UNPERTURBED PCA"
# Unperturbed data files live in $HOME/COGs/$GENE
#ls $OUTDIR/$GENE
#echo "..."
#ls $HOME/COGs/$GENE/*.jplace
guppy pca --out-dir $OUTDIR/$GENE --prefix 0\_ $HOME/COGs/$GENE/*.jplace # Projects unperturbed data into PCA space, produces .trans file
echo "UNPERTURBED SQUASH"
guppy squash --out-dir $OUTDIR/$GENE --prefix 0\_ $HOME/COGs/$GENE/*.jplace > /dev/null # Output is PERT_i_cluster.tre

echo "PCA/SQUASH, PERTURBED"
# Each batch of perturbed SAMPLE_i.jplace have PCA, squash applied
# Perturbed data files live in $HOME/$OUTDIR/$GENE/ thanks to perturb.py
# (Useful) Outputs: OUTDIR/GENE/i_.{trans, cluster.tre}
for ((i=1; i<=$ITERS; i++)); do
    guppy pca --out-dir $OUTDIR/$GENE --prefix $i\_ $OUTDIR/$GENE/*\_$i.jplace # Projects perturbed data into PCA space, produces .trans
    guppy squash --out-dir $OUTDIR/$GENE --prefix $i\_ $OUTDIR/$GENE/*\_$i.jplace  > /dev/null # Output is PERT_i_cluster.tre
done

rm $OUTDIR/$GENE/*.jplace
echo "CUTTING CLUSTERING"
# Takes hierarchical clustering (tree) from above, cuts it using cutree
# Produces a clustering vector for each method for each iteration
# Vectors are saved to file in OUTDIR/GENE/GENE_clusters
# data structure has ITERS*(6 methods) vectors of length |samples|
Rscript clusters.R $OUTDIR $GENE $ITERS

cp $OUTDIR/$GENE/$GENE\_clusters /home/landt/gene_clusters
cp $OUTDIR/$GENE/statfile /home/landt/gene_clusters/$GENE\_statfile
#cp $OUTDIR/$GENE/$GENE\_clusters /home/landt/
#echo "STATS"
# cat edpl/$(basename $i).edpl | awk '{moved += $2; total += $3} END {print moved, total}'

#MOVED=$(cat statfile | awk -F',' '{moved += $2} END {print moved}')
#TOTAL=$(cat statfile | awk -F',' '{total += $3} END {print total}')
#echo "Placements moved: $MOVED"
#echo "Total placements: $TOTAL"
#echo "Placements_moved:Total_placements: $(echo "scale=4; $MOVED / $TOTAL" | bc)"
# echo "Total placements for all samples: $(

#TOTALEDPL=0
#for i in genefiles/$1.aligned.*; do
#    guppy edpl $i | awk '{print $2}' > edpl/$(basename $i).edpl;
#    #echo "EDPL: $(cat edpl/$(basename $i).edpl | awk '{edpl += $1} END {print edpl}')"
#    TOTALEDPL=$(echo $(cat edpl/$(basename $i).edpl | awk '{edpl += $1} END {print edpl}') + $TOTALEDPL | bc)
#done
#echo "Total EDPL, all samples: $TOTALEDPL"
#BRANCHES=$(Rscript branchlength.R $1_tree)
#rm $1_tree
#echo "Total Branch Length: $BRANCHES"
#
##NORMALIZED=$(echo "scale=10; $TOTALEDPL / $BRANCHES / $TOTAL" | bc)
#NORMALIZED=$(echo "scale=10; $TOTALEDPL / $BRANCHES" | bc)
#echo "Score: $NORMALIZED"

# Also: number of reads AND Percent of reads moved?
