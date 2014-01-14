#!/bin/sh

#GENES=$(cat ~/COG_list)
#PATH=$PATH:$SGE_O_PATH
PATH=$SGE_O_PATH:$PATH
GENES="COG0001"
#GENES=$(ls /home/landt/analysis/)
for gene in $GENES; do
  #qsub makeclusters.sh $gene 20
  #qsub makeclusters.sh $gene 20
  qsub dummy.sh
done
