# This script was used to answer the question: "Can any COG gene produce a
# similar clustering result as the result produced by the authors of the
# original paper [Human Microbiome viewed across Age and Geography]?"
# The adjusted Rand Indices between that clustering result and (1) clusterings
# produced by projecting a COG's phylogenetic tree into PCA space and
# clustering the first principal components  as well as (2) clusterings
# produced by squash clustering the a COG's phylogenetic tree ... are all quite
# low, the highest of which are < .5; we have concluded that there is no COG
# can suitably reproduce the same result as the original authors produced using
# 16S analysis with UniFrac.

library(mclust)

h <- read.csv("~/Human-Microbiome-Metadata.csv", header=T)
h <- h[order(h["mgrast_id"]),]

meths = c("squash", "single", "ave", "complete", "centroid", "ward")

asgn <- function(country){
  if (country == 'Venezuela') {
    return(1)
  }else if (country == 'United-States-of-America') {
    return(2)
  }else if (country == 'Malawi') {
    return(3)
  }else{
    return(simpleError("Not a valid country"))
  }
}
papercluster <- sapply(h[,5], asgn)

big_aris <- function(){
  for (gene in list.files(path="~/outfiles/")){
      genefile <- paste("~/outfiles/", gene, "/cut3_pert0", sep="")
      if (file.exists(genefile)){
        clusts <- read.csv(genefile, header=T, sep=" ")
        if (dim(clusts)[2] == 111){
            print(gene)
        }
      }
  }
}

big_aris()
