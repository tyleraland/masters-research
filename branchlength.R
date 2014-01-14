library(ape)


read.tree <- function (file = "", text = NULL, tree.names = NULL, skip = 0, 
    comment.char = "#", keep.multi = FALSE, ...) 
{
    unname <- function(treetext) {
        nc <- nchar(treetext)
        tstart <- 1
        while (substr(treetext, tstart, tstart) != "(" && tstart <= 
            nc) tstart <- tstart + 1
        if (tstart > 1) 
            return(c(substr(treetext, 1, tstart - 1), substr(treetext, 
                tstart, nc)))
        return(c("", treetext))
    }
    if (!is.null(text)) {
        if (!is.character(text)) 
            stop("argument `text' must be of mode character")
        tree <- text
    }
    else {
        tree <- scan(file = file, what = "", sep = "\n", quiet = TRUE, 
            skip = skip, comment.char = comment.char, ...)
    }
    if (identical(tree, character(0))) {
        warning("empty character string.")
        return(NULL)
    }
    tree <- gsub("[ \t]", "", tree)
    tree <- unlist(strsplit(tree, NULL))
    y <- which(tree == ";")
    Ntree <- length(y)
    x <- c(1, y[-Ntree] + 1)
    if (is.na(y[1])) 
        return(NULL)
    STRING <- character(Ntree)
    for (i in 1:Ntree) STRING[i] <- paste(tree[x[i]:y[i]], sep = "", 
        collapse = "")
    tmp <- unlist(lapply(STRING, unname))
    tmpnames <- tmp[c(TRUE, FALSE)]
    STRING <- tmp[c(FALSE, TRUE)]
    if (is.null(tree.names) && any(nzchar(tmpnames))) 
        tree.names <- tmpnames
    colon <- grep(":", STRING)
    if (!length(colon)) {
        obj <- lapply(STRING, clado.build)
    }
    else if (length(colon) == Ntree) {
        obj <- lapply(STRING, tree.build)
    }
    else {
        obj <- vector("list", Ntree)
        obj[colon] <- lapply(STRING[colon], tree.build)
        nocolon <- (1:Ntree)[!1:Ntree %in% colon]
        obj[nocolon] <- lapply(STRING[nocolon], clado.build)
    }
    for (i in 1:Ntree) {
        ROOT <- length(obj[[i]]$tip.label) + 1
        if (sum(obj[[i]]$edge[, 1] == ROOT) == 1 && dim(obj[[i]]$edge)[1] > 
            1) 
            stop(paste("The tree has apparently singleton node(s): cannot read tree file.\n  Reading Newick file aborted at tree no.", 
                i))
    }
    if (Ntree == 1 && !keep.multi) 
        obj <- obj[[1]]
    else {
        if (!is.null(tree.names)) 
            names(obj) <- tree.names
        class(obj) <- "multiPhylo"
    }
    obj
}

treefile <- commandArgs(trailingOnly=TRUE)[1]
t <- read.tree(treefile)
cat(sum(t$edge.length))

