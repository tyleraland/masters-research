source("ave_buckets.R")
library(gridExtra)
stats <- read.csv("statsfile.csv", header=T)

b1 <- bucketplot(.1, 3.0, 4.5, log(stats[,7], base=10), "Bucketed log(Reads) per Gene")
b2 <- bucketplot(.5, 0, 4, log(stats[,8], base=10), "Bucketed log(EDPL) per Gene")
#bucketplot(1000, 0, 30000, stats[,7], "Reads for Gene", filenm="reads-buckets.png")
b3 <- bucketplot(.033, -6.0, -2.5, log(stats[,12]/stats[,13]), "Bucketed log(convexity) per gene")
b4 <- bucketplot(.2, 2.0, 6.5, log(pd[,2]), "phylo diversity")

# Un-bucketed scatterplots
#df <- data.frame(reads=stats$total_reads, ave_ari=stats$ave_ari)
#ggplot(df, aes(x=reads, y=ave_ari)) + geom_point() + xlab("Reads for Gene") + ylab("Average ARI")
#ggsave(filename="reads-scatterplot.png")

df <- data.frame(logreads=log(stats$total_reads, base=10), ave_ari=stats$ave_ari)
s1 <- ggplot(df, aes(x=logreads, y=ave_ari)) + geom_point() + xlab("log(Reads) per Gene") + ylab("Average ARI")
#ggsave(filename="log-reads-scatterplot.png")

df <- data.frame(edpl=log(stats$total_edpl, base=10), ave_ari=stats$ave_ari)
s2 <- ggplot(df, aes(x=edpl, y=ave_ari)) + geom_point() + xlab("log(EDPL) per Gene") + ylab("Average ARI")
#ggsave(filename="log-edpl-scatterplot.png")

df <- data.frame(conv=log(stats[,12]/stats[,13]), ave_ari=stats$ave_ari)
s3 <- ggplot(df, aes(x=conv, y=ave_ari)) + geom_point() + xlab("log(Convexity) per Gene") + ylab("Average ARI")
#ggsave(filename="log-convexity-scatterplot.png")

df <- data.frame(logpd=log(stats[,14]), ave_ari=stats$ave_ari)
s4 <- ggplot(df, aes(x=logpd, y=ave_ari)) + geom_point() + xlab("log(Phylo Diversity) per gene") + ylab("Average ARI")

qplot(stats$ave_ari, binwidth=.1, xlab="Average ARI", ylab="Frequency")
ggsave(filename="ave-ari-hist.png")

png("6plot-scatterplot-buckets.png")
grid.arrange(s1, b1, s2, b2, s3, b3, nrow=3, ncol=2)
dev.off()
#png("log-edpl.png")
#grid.arrange(s2, b2, nrow=2)
#dev.off()
#png("log-convexity.png")
#grid.arrange(s3, b3, nrow=2)
#dev.off()
