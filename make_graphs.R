bucketplot(.5, 0, 4, log(stats[,8], base=10), "log(EDPL) for Gene", filenm="log-edpl-buckets.jpeg")
#bucketplot(1000, 0, 30000, stats[,7], "Reads for Gene", filenm="reads-buckets.jpeg")
bucketplot(.1, 3.0, 4.5, log(stats[,7], base=10), "Log(Reads) for Gene", filenm="log-reads-buckets.jpeg")
bucketplot(.033, -6.0, -2.5, log(stats[,12]/stats[,13]), "Log(Tree convexity) for gene", filenm="log-convexity-buckets.jpeg")

# Un-bucketed scatterplots
#df <- data.frame(reads=stats$total_reads, ave_ari=stats$ave_ari)
#ggplot(df, aes(x=reads, y=ave_ari)) + geom_point() + xlab("Reads for Gene") + ylab("Average ARI")
#ggsave(filename="reads-scatterplot.jpeg")

df <- data.frame(logreads=log(stats$total_reads, base=10), ave_ari=stats$ave_ari)
ggplot(df, aes(x=logreads, y=ave_ari)) + geom_point() + xlab("Log(Reads) for Gene") + ylab("Average ARI")
ggsave(filename="log-reads-scatterplot.jpeg")

df <- data.frame(edpl=log(stats$total_edpl, base=10), ave_ari=stats$ave_ari)
ggplot(df, aes(x=edpl, y=ave_ari)) + geom_point() + xlab("Log(EDPL) for Gene") + ylab("Average ARI")
ggsave(filename="log-edpl-scatterplot.jpeg")

df <- data.frame(conv=log(1 + stats[,12]/stats[,13]), ave_ari=stats$ave_ari)
ggplot(df, aes(x=conv, y=ave_ari)) + geom_point() + xlab("Tree Convexity for Gene") + ylab("Average ARI")
ggsave(filename="convexity-scatterplot.jpeg")

qplot(stats$ave_ari, binwidth=.1, xlab="Average ARI", ylab="Frequency")
ggsave(filename="ave-ari-hist.jpeg")
