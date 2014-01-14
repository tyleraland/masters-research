
conv <- read.csv("all_COG_convex.csv", header=T)
genes = readLines("~/Code/research/genes_coverage")
gc <- array(dim=c(length(genes),2))
gc[,1] <- genes
for (i in 1:length(genes)){
  convexTaxa <- length(intersect( which(as.character(conv[,1]) == genes[i]),
                                  which(as.character(conv[,2]) == "phylum")))
  gc[i,2] <- convexTaxa
}
