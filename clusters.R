# Assume: Data is perturbed, PCA performed and PERT.trans produced
# Assume: Perturbed/Unperturbed data has been squashed, [UN]PERTcluster.tree produced

library('mclust')
library('ape')
source("~/Code/research/cuttable.R")

ppcafile <- paste("PERT", ".trans", sep="")
upcafile <- paste("UNPERT", ".trans", sep="")
ppca <- read.csv(paste("~/Code/research/outfiles/", ppcafile, sep=""), header=FALSE)
upca <- read.csv(paste("~/Code/research/outfiles/", upcafile, sep=""), header=FALSE)

colnames(ppca) <- c('sample', sprintf("pc%d", 1:(ncol(ppca)-1)))
colnames(upca) <- c('sample', sprintf("pc%d", 1:(ncol(upca)-1)))

phs <- hclust(dist(ppca[2:6]), method="single")
pha <- hclust(dist(ppca[2:6]), method="ave")
phco <- hclust(dist(ppca[2:6]), method="complete")
phce <- hclust(dist(ppca[2:6]), method="centroid")
phw <- hclust(dist(ppca[2:6]), method="ward")

uhs <- hclust(dist(upca[2:6]), method="single")
uha <- hclust(dist(upca[2:6]), method="ave")
uhco <- hclust(dist(upca[2:6]), method="complete")
uhce <- hclust(dist(upca[2:6]), method="centroid")
uhw <- hclust(dist(upca[2:6]), method="ward")
# Appends clustering 

ppca <- cbind( ppca, "single" = as.character(cutree(phs,k=4)) )
ppca <- cbind( ppca, "ave" = as.character(cutree(pha,k=4)) ) 
ppca <- cbind( ppca, "complete" = as.character(cutree(phco,k=4)) )
ppca <- cbind( ppca, "centroid" = as.character(cutree(phce,k=4)) )
ppca <- cbind( ppca, "ward" = as.character(cutree(phw,k=4)) )

upca <- cbind( upca, "single" = as.character(cutree(uhs,k=4)) )
upca <- cbind( upca, "ave" = as.character(cutree(uha,k=4)) ) 
upca <- cbind( upca, "complete" = as.character(cutree(uhco,k=4)) )
upca <- cbind( upca, "centroid" = as.character(cutree(uhce,k=4)) )
upca <- cbind( upca, "ward" = as.character(cutree(uhw,k=4)) )

# Sorts rows by sample name
ppca <- ppca[order(ppca[,1]),] 
upca <- upca[order(upca[,1]),] 
#ppcaav <- ppca[order(ppca[,1]),8]
#ppcaco <- ppca[order(ppca[,1]),9]
#ppcace <- ppca[order(ppca[,1]),10]
#ppcawa <- ppca[order(ppca[,1]),11]
#upcasi <- ppca[order(ppca[,1]),7] 
#upcaav <- ppca[order(ppca[,1]),8]
#upcaco <- ppca[order(ppca[,1]),9]
#upcace <- ppca[order(ppca[,1]),10]
#upcawa <- ppca[order(ppca[,1]),11]

psq <- read.tree("~/Code/research/outfiles/PERTcluster.tre") # Reads tree in Newick format to 'phylo' object
usq <- read.tree("~/Code/research/outfiles/UNPERTcluster.tre")

psq <- cutree(cuttable(psq), k=4) # Converts 'phylo' to a 'cuttable' hclust-like object, produces clustering
usq <- cutree(cuttable(usq), k=4)

psq <- as.vector(psq[order(names(psq))]) # Sorts cluster-assignments by sample name
usq <- as.vector(usq[order(names(usq))])


cat(paste("ARI of unperturbed squash and unperturbed pca with single  :", as.character(adjustedRandIndex(usq,upca[,7])),"\n"))
cat(paste("ARI of unperturbed squash and unperturbed pca with average :", as.character(adjustedRandIndex(usq,upca[,8])),"\n"))
cat(paste("ARI of unperturbed squash and unperturbed pca with complete:", as.character(adjustedRandIndex(usq,upca[,9])),"\n"))
cat(paste("ARI of unperturbed squash and unperturbed pca with centroid:", as.character(adjustedRandIndex(usq,upca[,10])),"\n"))
cat(paste("ARI of unperturbed squash and unperturbed pca with ward's  :", as.character(adjustedRandIndex(usq,upca[,11])),"\n"))

cat(paste("ARI of unperturbed and perturbed squash:", as.character(adjustedRandIndex(psq,usq)),"\n"))
cat(paste("ARI of unperturbed and perturbed PCA clustered with single  :", as.character(adjustedRandIndex(ppca[,7],upca[,7])),"\n"))
cat(paste("ARI of unperturbed and perturbed PCA clustered with average :", as.character(adjustedRandIndex(ppca[,8],upca[,8])),"\n"))
cat(paste("ARI of unperturbed and perturbed PCA clustered with complete:", as.character(adjustedRandIndex(ppca[,9],upca[,9])),"\n"))
cat(paste("ARI of unperturbed and perturbed PCA clustered with centroid:", as.character(adjustedRandIndex(ppca[,10],upca[,10])),"\n"))
cat(paste("ARI of unperturbed and perturbed PCA clustered with ward's  :", as.character(adjustedRandIndex(ppca[,11],upca[,11])),"\n"))

cat(paste("ARI of perturbed squash and perturbed pca with single  :", as.character(adjustedRandIndex(psq,ppca[,7])),"\n"))
cat(paste("ARI of perturbed squash and perturbed pca with average :", as.character(adjustedRandIndex(psq,ppca[,8])),"\n"))
cat(paste("ARI of perturbed squash and perturbed pca with complete:", as.character(adjustedRandIndex(psq,ppca[,9])),"\n"))
cat(paste("ARI of perturbed squash and perturbed pca with centroid:", as.character(adjustedRandIndex(psq,ppca[,10])),"\n"))
cat(paste("ARI of perturbed squash and perturbed pca with ward's  :", as.character(adjustedRandIndex(psq,ppca[,11])),"\n"))
