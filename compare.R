library(mclust)

h <- read.csv("~/Human-Microbiome-Metadata.csv", header=T)
# h <- h[order(h[,"mgrast_id"]),] 

asgn <- function(country){
  if (country == 'Venezuela' | country == 'Malawi') {
    return(1)
  }else if (country == 'United-States-of-America') {
    return(2)
  }else{
    return(simpleError("Not a valid country"))
  }
}
papercluster <- sapply(h[,5], asgn)

big_aris <- function(){
  h <- h[,"country"]
  meths = c("squash", "single", "ave", "complete", "centroid", "ward")
  for (file in list.files(path="~/gene_clusters/", pattern="*clusters")){
      load(file=paste("~/gene_clusters/", file, sep="")) # loads clusts
      if (111 == dim(clusts)[3]){
          for (m in 1:6){
              com <- adjustedRandIndex(h, clusts[1,m,])
              if (com > .2){
                  print(paste(file, "..", meths[m], ": ", as.character(com), sep=""))
              }
          }
      }
  }
}
