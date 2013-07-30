#NOTE:  mbari hitcounts is WRONG.

mbari_hitcount <- read.csv("~/Code/all_MBARI_hitcounts_descriptions.txt", header=TRUE, sep="\t")
mb <- subset(mbari_hitcount, description %in% c("Photosynthesis", "Electron transport"))
mb <- subset(mb, rowSums( mb[,2:5]) > 25)
alltrans <- list.files(path="~/Code/mbari_guppy/pca/", "*.trans")
pcas <- NULL
genes <- NULL
count <- 0
for (i in mb$gene){
    filename = paste(i, ".trans", sep="")
    if (filename %in% alltrans){
        count <- count + 1
        pca <- read.csv(paste("~/Code/mbari_guppy/pca/", filename, sep=""), header=FALSE)
        colnames(pca) <- c('sample', sprintf("pc%d", 1:(ncol(pca)-1)))
        genes[[count]] <- i
        pcas[[count]] <- pca
    }
}
