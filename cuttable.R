# Because the Squash clustering algorithm produces a non-ultrametric tree, and
# the 'cutree' algorithm requires a merge ordering, we reconstruct that
# ordering here.  Once applied, we can use cutree to partition the tree into
# a clustering.

cuttable <- function(x)
{
    n <- length(x$tip.label)
    x$node.label <- NULL
    bt <- sort(branching.times(x))
    inode <- as.numeric(names(bt))
    N <- n - 1L
    nm <- numeric(N + n)
    nm[inode] <- 1:N
    merge <- matrix(NA, N, 2)
    for (i in 1:N) {
        ind <- which(x$edge[, 1] == inode[i])
        for (k in 1:2) {
            tmp <- x$edge[ind[k], 2]
            merge[i, k] <- if (tmp <= n)
                -tmp
            else nm[tmp]
        }
    }
    names(bt) <- NULL
    obj <- list(merge = merge, height = bt, order = 1:n, labels = x$tip.label,
            call = match.call(), method = "unknown")
    class(obj) <- "hclust"
    obj
}

