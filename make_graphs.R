source("ave_buckets.R")
library(gridExtra)
stats <- read.csv("statsfile.csv", header=T)

# Un-bucketed scatterplots
#df <- data.frame(reads=stats$total_reads, ave_ari=stats$ave_ari)
#ggplot(df, aes(x=reads, y=ave_ari)) + geom_point() + xlab("Reads for Gene") + ylab("Average ARI")
#ggsave(filename="reads-scatterplot.png")

df <- data.frame(logreads=log(stats$total_reads, base=10), ave_ari=stats$ave_ari)
s1 <- ggplot(df, aes(x=logreads, y=ave_ari)) + geom_point() + xlab("log(Reads) per Gene") + ylab("Average ARI") + xlim(2.9, 4.5) + annotate("text", 2.9, 1.0, label="1a")
#ggsave(filename="log-reads-scatterplot.png")

df <- data.frame(edpl=log(stats$total_edpl, base=10), ave_ari=stats$ave_ari)
s2 <- ggplot(df, aes(x=edpl, y=ave_ari)) + geom_point() + xlab("log(EDPL) per Gene") + ylab("Average ARI") + xlim(1.0, 4.0) + annotate("text", 1.0, 1.0, label="2a")
#ggsave(filename="log-edpl-scatterplot.png")

df <- data.frame(conv=log(stats[,12]/stats[,13]), ave_ari=stats$ave_ari)
s3 <- ggplot(df, aes(x=conv, y=ave_ari)) + geom_point() + xlab("log(Convexity) per Gene") + ylab("Average ARI") + xlim(-6.5, -2.5) + annotate("text", -6.5, 1.0, label="3a")
#ggsave(filename="log-convexity-scatterplot.png")

# Bucketed plots
b1 <- bucketplot(.1, 2.9, 4.5, log(stats[,7], base=10), "Bucketed log(Reads) per Gene")
b1 <- b1 + annotate("text", 2.9, 1.0, label="1b")
b2 <- bucketplot(.5, 1.0, 4, log(stats[,8], base=10), "Bucketed log(EDPL) per Gene")
b2 <- b2 + annotate("text", 1.0, 1.0, label="2b")
b3 <- bucketplot(.033, -6.5, -2.5, log(stats[,12]/stats[,13]), "Bucketed log(convexity) per gene")
b3 <- b3 + annotate("text", -6.5, 1.0, label="3b")

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
