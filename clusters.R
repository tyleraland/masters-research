# Assume: Data is perturbed, PCA performed and PERT.trans produced
# Assume: Perturbed/Unperturbed data has been squashed, [UN]PERTcluster.tree produced
# Dependencies: cuttable.R, [PCA].trans, [PCA]cluster.tre
# Usage: Rscript clusters.R outdirec gene perts

library('mclust')
library('ape')
source("~/Code/research/cuttable.R")

indirec <- commandArgs(trailingOnly=T)[1]
outdirec <- commandArgs(trailingOnly=T)[2]
gene <- commandArgs(trailingOnly=T)[3]
perts <- as.integer(commandArgs(trailingOnly=T)[4])

indirec = file.path(indirec, gene) # /state/partition1/landt/COG0001
outdirc = file.path(outdirec, gene) # ~/outfiles/COG0001

# samples * methods * iters
methods = 6 # Number of clustering methods to try
nsamples = length(readLines(file.path(indirec, paste("0_", gene, ".trans", sep=""))))
c = 3 # number of clusters to cut at

# Index this like:
# clusts[i,j,] where i=perturbation+1, j=method
# Note: i=0 is the unperturbed data
clusts = array(rep(0,nsamples), dim=c(methods,nsamples))

for (i in 0:perts){
    sq <- read.tree(paste(indirec, "/", as.character(i), "_", gene, "cluster.tre",sep=""))
    sq <- cutree(cuttable(sq), k=c)
    clusts[1,] <- as.vector(sq[order(names(sq))])

    pca <- read.csv(paste(indirec, "/", as.character(i), "_", gene, ".trans",sep=""), header=FALSE)
    clusts[2,] <- as.character(cutree(hclust(dist(pca[2:6]), method="single"), k=c))
    clusts[3,] <- as.character(cutree(hclust(dist(pca[2:6]), method="ave"), k=c))
    clusts[4,] <- as.character(cutree(hclust(dist(pca[2:6]), method="complete"), k=c))
    clusts[5,] <- as.character(cutree(hclust(dist(pca[2:6]), method="centroid"), k=c))
    clusts[6,] <- as.character(cutree(hclust(dist(pca[2:6]), method="ward"), k=c))
    write.table(clusts, file=paste(outdirec, "/", gene, "/cut", as.character(c), "_pert", as.character(i), sep=""))
}
