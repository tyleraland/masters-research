library(ggplot2)

b = 5

l = 20
h = 65
ds <- stats$pairwise_percent_identity
vec <- rep(0,length(seq(l,h-b,b)))
for (i in seq(l,h-b,b)){
  ins <- ds > i & ds <= i+b
  vec[(i-l)/b+1] <- mean(stats[ins,4])
  #vec[(i-20)/b+1] <- sd(stats[ins,4])
}
df <- data.frame(seq(l,h-b,b), vec)
colnames(df) <- c("bucket","ave_ave")

ggplot(df, aes(x=bucket,y=ave_ave,group=1)) + geom_point() + xlab("Lower-bound percent identity") + ylab("Average average-ARI for bucket") + ylim(.5,1.0)
ggsave(filename="~/Code/research/graphs/Average_Average_ARI_by_percent_identity_bucket.jpeg")

b <- 2000
l <- 1000
h <- 28000
ds <- reads
vec <- rep(0,length(seq(l,h-b,b)))
for (i in seq(l,h-b,b)){
  ins <- ds > i & ds <= i+b
  vec[(i-l)/b+1] <- mean(stats[ins,4])
  #vec[(i-1000)/b+1] <- sd(stats[ins,4])
}

df <- data.frame(seq(l,h-b,b), vec)
colnames(df) <- c("bucket","ave_ave")

ggplot(df, aes(x=bucket,y=ave_ave,group=1)) + xlab("Lower-bound reads in samples") + ylab("Average average-ARI for bucket") + geom_point() + ylim(.5,1.0)
ggsave(filename="~/Code/research/graphs/Average_Average_ARI_by_reads_bucket.jpeg")

b <- .25
l <- 0.0
h <- 4.0
ds <- log(edpl,base=10)
vec <- rep(0,length(seq(l,h-b,b)))
for (i in seq(l,h-b,b)){
  ins <- ds > i & ds <= i+b
  vec[(i-l)/b+1] <- mean(stats[ins,4])
  #vec[(i-1000)/b+1] <- sd(stats[ins,4])
}

df <- data.frame(seq(l,h-b,b), vec)
colnames(df) <- c("bucket","ave_ave")

b <- .025 
l <- 0.0
h <- .60
ds <- ((conv[2]/conv[3])[,1])^(.25)
vec <- rep(0,length(seq(l,h-b,b)))
for (i in seq(l,h-b,b)){
  ins <- ds > i & ds <= i+b
  vec[(i-l)/b+1] <- mean(stats[ins,4])
}
df <- data.frame(seq(l,h-b,b), vec)
colnames(df) <- c("bucket", "ave_ave")

b <- .0005
l <- 0.0
h <- 0.025
ds <- x
vec <- rep(0,length(seq(l,h-b,b)))
for (i in seq(l,h-b,b)){
  ins <- ds > i & ds <= i+b
  vec[(i-l)/b+1] <- mean(stats[ins,4])
}
df <- data.frame(seq(l,h-b,b), vec)
colnames(df) <- c("bucket", "ave_ave")

ggplot(df, aes(x=bucket,y=ave_ave,group=1)) + xlab("Buckets by treesz") + ylab("Average average-ARI for bucket") + geom_point() + ylim(.5,1.0)
ggsave(filename="~/Code/research/graphs/Average_Average_ARI_by_log_treesz.jpeg")
