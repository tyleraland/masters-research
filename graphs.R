library(mclust)

maps_to_pert <- function(row){
    as.numeric(substr(as.character(row[[1]]), start=11, stop=13))
}

genes <- readLines("~/Code/research/genes_coverage")
stats <- data.frame( array(0, dim=c(length(genes), 6)))
colnames(stats) <- c('gene', 'min_ari', 'max_ari', 'ave_ari', 'moved:total reads', 'average_moved' )
stats[,1] <- genes
for (g in 1:(length(genes))){
    gene <- genes[g]
    # Have to correct for mislabeled columns; 'seed' is missing from header
    sf <- read.csv(paste("~/outfiles/", gene, "/statfile", sep=""), header=F, skip=1, col.names=c('sample','moved','total','seed'))
    stats[g,5] <- sum(sf[,2])/sum(sf[,3])
    moved <- array(0, dim=10)
    for (rowi in 1:(nrow(sf))){
        moved[maps_to_pert(sf[rowi,])] <- moved[maps_to_pert(sf[rowi,])] + sf[rowi,2]
    }
    stats[g,6] <- mean(moved)
    
    ### Stability analysis
    fc0 <- paste("~/outfiles/", gene, "/cut3_pert0", sep="")
    c0 <- read.csv(fc0, header=T, sep=" ")
    pert <- rep(0,10)
    for (i in 1:10){
        fci <- paste("~/outfiles/", gene, "/cut3_pert", as.character(i), sep="")
        ci <- read.csv(fci, header=T, sep=" ")
        pert[i] <- adjustedRandIndex(as.numeric(c0[1,]), as.numeric(ci[1,]))
    }    
    stats[g,2] <- min(pert)
    stats[g,3] <- max(pert)
    stats[g,4] <- mean(pert)
}
#jpeg('min_ari_cut3.jpg')
#hist(stats[,2], ylab='number of genes', xlab='minimum ARI', main="Minimum ARI among 10 perturbations for 3 clusters")
#dev.off()
#jpeg('max_ari_cut3.jpg')
#hist(stats[,3], ylab='number of genes', xlab='maximum ARI', main="Maximum ARI among 10 perturbations for 3 clusters")
#dev.off()
#jpeg('ave_ari_cut3.jpg')
#hist(stats[,4], ylab='number of genes', xlab='average ARI', main="Average ARI among 10 perturbations for 3 clusters")
#dev.off()
#jpeg('moved_to_total_reads.jpg')
#hist(stats[,5], ylab='number of genes', xlab='proportion', main="perturbation moved:total ratios")
#dev.off()
#jpeg('moved_reads_average.jpg')
#hist(stats[,5], ylab='number of genes', xlab='Moved Reads', main="Average number of moved reads by gene over 10 perturbations")
#dev.off()

stats <- cbind(stats, read.csv("~/outfiles/total_edpls.csv", header=T)[,2:4], read.csv("gene_ave_identities.csv", header=T)[,2], read.csv("gut_pairwise_identities.csv", header=T)[,2], read.csv("~/outfiles/all_ave_phylo_diversity.csv", header=T)[,2])
colnames(stats)[10] <- "ave_identity"
colnames(stats)[11] <- "pairwise_percent_identity"
colnames(stats)[12] <- "ave_phylo_div"
#hist(edpls[,2], ylab='number of genes', xlab='Total EDPL', main="Sum of EDPL among all reads in all samples, by gene")

