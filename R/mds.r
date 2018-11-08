library(MASS)
library(coda)
library(ggplot2)
library(reshape2)
library(fitdistrplus)
library(MCMCpack)
library(fitdistrplus)
library(cowplot)

setwd("C:/...")  #insert working directory

CNcoins = read.csv("gammavalues-['CN'].csv")
PTcoins = read.csv("gammavalues-['PT'].csv")
PIcoins = read.csv("gammavalues-['PI'].csv")
MZcoins = read.csv("gammavalues-['MZ'].csv")
daterange <- MZcoins[,1]

CN.sub = read.csv("rmeancollected-subsampled-['CN'].csv")
PT.sub = read.csv("rmeancollected-subsampled-['PT'].csv")
PI.sub = read.csv("rmeancollected-subsampled-['PI'].csv")
MZ.sub = read.csv("rmeancollected-subsampled-['MZ'].csv")

setwd("C:/...") #insert working directory


######################
mz1 = read.csv("result-MZ1.csv", header = TRUE)
mz2 = read.csv("result-MZ2.csv", header = TRUE)
mz3 = read.csv("result-MZ3.csv", header = TRUE)
tb1 = read.csv("result-TB1.csv", header = TRUE)
tb2 = read.csv("result-TB2.csv", header = TRUE)
tb3 = read.csv("result-TB3.csv", header = TRUE)
cn1 = read.csv("result-CN1.csv", header = TRUE)
cn2 = read.csv("result-CN2.csv", header = TRUE)
pa = read.csv("result-PA.csv", header = TRUE)
pt = read.csv("result-PT.csv", header = TRUE)
sm = read.csv("result-SM.csv", header = TRUE)
pi1 = read.csv("result-PI1.csv", header = TRUE)
pi2 = read.csv("result-PI2.csv", header = TRUE)

mz1 <- as.data.frame.matrix(mz1)
mz2 <- as.data.frame.matrix(mz2)
mz3 <- as.data.frame.matrix(mz3)
tb1 <- as.data.frame.matrix(tb1)
tb2 <- as.data.frame.matrix(tb2)
tb3 <- as.data.frame.matrix(tb3)
cn1 <- as.data.frame.matrix(cn1)
cn2 <- as.data.frame.matrix(cn2)
sm <- as.data.frame.matrix(sm)
pa <- as.data.frame.matrix(pa)
pt <- as.data.frame.matrix(pt)
pi1 <- as.data.frame.matrix(pi1)
pi2 <- as.data.frame.matrix(pi2)

mz1$X	<-	NULL
mz2$X	<-	NULL
mz3$X	<-	NULL
tb1$X	<-	NULL
tb2$X	<-	NULL
tb3$X	<-	NULL
cn1$X	<-	NULL
cn2$X	<-	NULL
sm$X	<-	NULL
pa$X	<-	NULL
pt$X	<-	NULL
pi1$X	<-	NULL
pi2$X	<-	NULL

mz1$MON	<-	NULL
mz2$MON	<-	NULL
mz3$MON	<-	NULL
tb1$MON	<-	NULL
tb2$MON	<-	NULL
tb3$MON	<-	NULL
cn1$MON	<-	NULL
cn2$MON	<-	NULL
sm$MON	<-	NULL
pa$MON	<-	NULL
pt$MON	<-	NULL
pi1$MON	<-	NULL
pi2$MON	<-	NULL

mz1label <- rep("MZ1",1000)
mz2label <- rep("MZ2",1000)
mz3label <- rep("MZ3",1000)
tb1label <- rep("TB1",1000)
tb2label <- rep("TB2",1000)
tb3label <- rep("TB3",1000)
cn1label <- rep("CN1",1000)
cn2label <- rep("CN2",1000)
smlabel <- rep("SM",1000)
ptlabel <- rep("PT",1000)
palabel <- rep("PA",1000)
pi1label <- rep("PI1",1000)
pi2label <- rep("PI2",1000)

mz1$phase <- mz1label
mz2$phase <- mz2label
mz3$phase <- mz3label
tb1$phase <-tb1label
tb2$phase <-tb2label 
tb3$phase <-tb3label 
cn1$phase <-cn1label 
cn2$phase <-cn2label 
sm$phase <-smlabel 
pt$phase <-ptlabel 
pa$phase <-palabel 
pi1$phase <- pi1label
pi2$phase <- pi2label


mz1 <- melt(mz1)
mz2 <- melt(mz2)
mz3 <- melt(mz3)
cn1 <- melt(cn1)
cn2 <- melt(cn2)
tb1 <- melt(tb1)
tb2 <- melt(tb2)
tb3 <- melt(tb3)
pa <- melt(pa)
sm <- melt(sm)
pt <- melt(pt)
pi1 <- melt(pi1)
pi2 <- melt(pi2)

mz1 <- mz1[!apply(mz1 == 0, 1, FUN = any, na.rm = TRUE),]
mz1 <- mz1[!apply(mz1 == 1, 1, FUN = any, na.rm = TRUE),]
mz2 <- mz2[!apply(mz2 == 0, 1, FUN = any, na.rm = TRUE),]
mz2 <- mz2[!apply(mz2 == 1, 1, FUN = any, na.rm = TRUE),]
mz3 <- mz3[!apply(mz3 == 0, 1, FUN = any, na.rm = TRUE),]
mz3 <- mz3[!apply(mz3 == 1, 1, FUN = any, na.rm = TRUE),]
tb1 <- tb1[!apply(tb1 == 0, 1, FUN = any, na.rm = TRUE),]
tb1 <- tb1[!apply(tb1 == 1, 1, FUN = any, na.rm = TRUE),]
tb2 <- tb2[!apply(tb2 == 0, 1, FUN = any, na.rm = TRUE),]
tb2 <- tb2[!apply(tb2 == 1, 1, FUN = any, na.rm = TRUE),]
tb3 <- tb3[!apply(tb3 == 0, 1, FUN = any, na.rm = TRUE),]
tb3 <- tb3[!apply(tb3 == 1, 1, FUN = any, na.rm = TRUE),]
cn1 <- cn1[!apply(cn1 == 0, 1, FUN = any, na.rm = TRUE),]
cn1 <- cn1[!apply(cn1 == 1, 1, FUN = any, na.rm = TRUE),]
cn2 <- cn2[!apply(cn2 == 0, 1, FUN = any, na.rm = TRUE),]
cn2 <- cn2[!apply(cn2 == 1, 1, FUN = any, na.rm = TRUE),]
pt <- pt[!apply(pt == 0, 1, FUN = any, na.rm = TRUE),]
pt <- pt[!apply(pt == 1, 1, FUN = any, na.rm = TRUE),]
pa <- pa[!apply(pa == 0, 1, FUN = any, na.rm = TRUE),]
pa <- pa[!apply(pa == 1, 1, FUN = any, na.rm = TRUE),]
sm <- sm[!apply(sm == 0, 1, FUN = any, na.rm = TRUE),]
sm <- sm[!apply(sm == 1, 1, FUN = any, na.rm = TRUE),]
pi1 <- pi1[!apply(pi1 == 0, 1, FUN = any, na.rm = TRUE),]
pi1 <- pi1[!apply(pi1 == 1, 1, FUN = any, na.rm = TRUE),]
pi2 <- pi2[!apply(pi2 == 0, 1, FUN = any, na.rm = TRUE),]
pi2 <- pi2[!apply(pi2 == 1, 1, FUN = any, na.rm = TRUE),]


total <- rbind(mz1,mz2,mz3,pi1,pi2,cn1,cn2,sm,pa,pt,tb1,tb2,tb3)

###########################################################################################

#resample from the kde: n = number of samples, z = density of original data, x = original data 
#https://stats.stackexchange.com/questions/321542/how-can-i-draw-a-value-randomly-from-a-kernel-density-estimate
rdens <- function(n, density=z, data=x, kernel="gaussian") {
  width <- z$bw                              # Kernel width
  rkernel <- function(n) rnorm(n, sd=width)  # Kernel sampler
  sample(x, n, replace=TRUE) + rkernel(n)    # Here's the entire algorithm
}

sites <- list(mz1,mz2,mz3,pi1,pi2,cn1,cn2,sm,pa,pt,tb1,tb2,tb3)
sitestr <- c( "MZ1", "MZ2", "MZ3","PI1", "PI2", "CN1", "CN2", "SM", "PA", "PT", "TB1", "TB2", "TB3")
domainstr <-  c("economic" ,"agriculture" ,"livestock" ,"craft.production" ,"craft.refuse" ,"domestic" ,"personal" ,"cultural" ,"transportation" ,"real.estate" ,"exchange","MON")



domain1 <- "craft.production"
domain2 <- "exchange"
domain3 <- "economic"


#resample from kde
rsd <- function(domain,site) {
resampled <<-0
if (sum( site[ which(site$variable==domain), ]$value) > 0 ) {
	domvalues <<- site[ which(site$variable==domain), ]$value
	n <<- 1000
	z <<- density(domvalues)
	x <<- domvalues
	resampled <<- rdens(n, z, x)
}
}

#restructure data to create a df that is of a domain, with cols as sites
dom1df <- data.frame()[1:1000, ]
dom2df <- data.frame()[1:1000, ]
dom3df <- data.frame()[1:1000, ]

for (i in 1:length(sites)) {
dom1 <- rsd(domain1,sites[[i]])
dom2 <- rsd(domain2,sites[[i]])
dom3 <- rsd(domain3,sites[[i]])

sitename <- sitestr[i]
if (sum(dom1) > 0) {
dom1df[[sitename]] <- dom1
}
if (sum(dom2) > 0) {
dom2df[[sitename]] <- dom2
}
if (sum(dom3) > 0) {
dom3df[[sitename]] <- dom3
}
}

#to remove sites without coins
#dom1df$TB2 <- NULL
#dom1df$SM <- NULL
#dom1df$TB1 <- NULL
#dom1df$PT <- NULL


#generate a dataframe of mean values
means1 <- colMeans(dom1df)
means2 <- colMeans(dom2df)
means3 <- colMeans(dom3df)
means1 <- as.data.frame(means1)
means2 <- as.data.frame(means2)
means3 <- as.data.frame(means3)
colnames(means1) <- domain1
colnames(means2) <- domain2
colnames(means3) <- domain3


total2 <- dcast(total, phase ~ variable)
rownames(total2) <- total2$phase
total2$phase <- NULL
total2[] <- NA

for (i in rownames(total2)) {
for (j in colnames(total2)) {
t <- total[total$phase == i & total$variable == j, ]
x <- mean(t$value) #to check and see if not NA
if ( is.finite(x) ) {
dmax <- which.max(density(t$value)$y)
x <- density(t$value)$x[dmax] # mean(t$value)      # t[sample(nrow(t), 1), ]$value
total2[i,j] <- x
}
}
}

d <- dist(total2) 
d <- dist(total2, method = "euclidean") 

fit <- isoMDS(d, k=2) # k is the number of dim
fit # view results

# plot solution 
#x <- fit$points[,1]
#y <- fit$points[,2]
#plot(x, y, xlab="Coordinate 1", ylab="Coordinate 2", 
#  main="Nonmetric MDS", type="n")
#text(x, y, labels = row.names(total2), cex=.7)

mdsdata <- as.data.frame(fit$points)
mdsdata$site <- rownames(mdsdata)
mdsdata$site <- factor(mdsdata$site, levels = c("PI1", "PI2", "CN1", "CN2", "SM", "PA", "PT", "MZ1", "MZ2", "MZ3", "TB1", "TB2", "TB3")) 
mdsdata$phase <- c("rjc","la","rjc","rjc","la","rjc","rjc","la","rjc","rjc","rjc","rjc","la")
mdsdata[mdsdata == "rjc"] <- "Rep./Jul.-Claudian"
mdsdata[mdsdata == "la"] <- "Late Antique"
mdsdata$phase <- factor(mdsdata$phase, levels =  c("Rep./Jul.-Claudian","Late Antique"))

means1$site <- rownames(means1)
means2$site <- rownames(means2)
means3$site <- rownames(means3)


mdsdata1 <- merge(mdsdata,means1,by="site",all = TRUE)
mdsdata2 <- merge(mdsdata,means2,by="site",all = TRUE)
mdsdata3 <- merge(mdsdata,means3,by="site",all = TRUE)


p.mds.cprod <- ggplot(data=mdsdata1, aes(x=V1, y=V2, color = craft.production)) + 
geom_point(size = 5, alpha = 0.5) +
scale_color_gradient(low = "blue", high = "red") +
#scale_color_gradient2(midpoint= median(mdsdata2$craft.production), low="blue", mid="white",
#                     high="red", space ="Lab" ) +
geom_text(aes(label = site), size = 5, hjust=-0.25) +
  scale_x_continuous("coordinate 1") + #, limits = c(-1,2)) + 
  scale_y_continuous("coordinate 2") + #ggtitle(expression(paste("Non-Metric MDS of RPP Sites Using Modes of Indices (argmax ", hat(X),")"))) + 
theme_classic()


p.mds.exchange <- ggplot(data=mdsdata2, aes(x=V1, y=V2, color = exchange)) + 
geom_point(size = 5, alpha = 0.5) +
scale_color_gradient(low = "blue", high = "red") +
#scale_color_gradient2(midpoint= median(mdsdata2$exchange), low="blue", mid="white",
#                     high="red", space ="Lab" ) +
geom_text(aes(label = site), size = 5, hjust=-0.25) +
  scale_x_continuous("coordinate 1") + #, limits = c(-1,2)) + 
  scale_y_continuous("coordinate 2") + #ggtitle(expression(paste("Non-Metric MDS of RPP Sites with Mode of Resampled Estimates (", hat(X),")"))) + 
theme_classic()


p.mds.economic <- ggplot(data=mdsdata3, aes(x=V1, y=V2, color = economic)) + 
geom_point(size = 5, alpha = 0.5) +
scale_color_gradient(low = "blue", high = "red") +
#scale_color_gradient2(midpoint= median(mdsdata2$exchange), low="blue", mid="white",
#                     high="red", space ="Lab" ) +
geom_text(aes(label = site), size = 5, hjust=-0.25) +
  scale_x_continuous("coordinate 1") + #, limits = c(-1,2)) + 
  scale_y_continuous("coordinate 2") + #ggtitle(expression(paste("Non-Metric MDS of RPP Sites with Mode of Resampled Estimates (", hat(X),")"))) + 
theme_classic()




p.mds <- ggplot(data=mdsdata, aes(x=V1, y=V2, color = phase)) + 
geom_point(size = 5, alpha = 0.5) +
#scale_color_gradient(low = "orange", high = "black") +
#scale_color_gradient2(midpoint= median(mdsdata2$craft.production), low="blue", mid="white",
#                     high="red", space ="Lab" ) +
geom_text(aes(label = site), size = 5, hjust=-0.25, show.legend = FALSE) +
  scale_x_continuous("coordinate 1") + #, limits = c(-1,2)) + 
  scale_y_continuous("coordinate 2") + #ggtitle(expression(paste("Non-Metric MDS of RPP Sites with Mode of Resampled Estimates (", hat(X),")"))) +
theme_classic()

title <- ggdraw() + 
  draw_label(expression(paste("Non-Metric MDS of RPP Sites Using Index Modes (argmax ", hat(X),")")),
             fontface = 'bold')


p <- plot_grid(p.mds, p.mds.economic, p.mds.cprod, p.mds.exchange, ncol=2)
plot_grid(title, p, ncol = 1, rel_heights = c(0.1, 1.5)) # rel_heights values control title margins

