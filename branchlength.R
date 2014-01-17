# This function takes a phylogenetic tree in Newick format and, using ape's
# read.tree function, computes the sum of the lengths of all branches in
# the tree.  This is used as a heuristic for measuring the size of a tree
library(ape)

treefile <- commandArgs(trailingOnly=TRUE)[1]
t <- read.tree(treefile)
cat(sum(t$edge.length))
