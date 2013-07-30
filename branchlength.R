library(ape)

treefile <- commandArgs(trailingOnly=TRUE)[1]
t <- read.tree(treefile)
cat(sum(t$edge.length))
