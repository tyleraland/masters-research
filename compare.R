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
      #print(gene)
      #load(file=paste("~/gene_clusters/", file, sep="")) # loads clusts
      genefile <- paste("~/outfiles/", gene, "/cut3_pert0", sep="")
      if (file.exists(genefile)){
        clusts <- read.csv(genefile, header=T, sep=" ")
        if (dim(clusts)[2] == 111){
            print(gene)
            #for (m in 1:6){
            #    com <- adjustedRandIndex(papercluster, as.numeric(clusts[m,]))
            #    if (com > .2){
            #        print(paste(gene, "..", meths[m], ": ", as.character(com), sep=""))
            #    }
            #}
        }
      }
  }
}

big_aris()
