library(coda)
library(ggplot2)
library(reshape2)
library(fitdistrplus)
library(MCMCpack)
library(fitdistrplus)
library(devtools)
library(cowplot)

setwd("E:/Research/2018 Stats/Generalized MC Resampling/") 

CNcoins = read.csv("gammavalues-['CN'].csv")
PTcoins = read.csv("gammavalues-['PT'].csv")
PIcoins = read.csv("gammavalues-['PI'].csv")
MZcoins = read.csv("gammavalues-['MZ'].csv")
daterange <- MZcoins[,1]

CN.sub = read.csv("rmeancollected-subsampled-['CN'].csv")
PT.sub = read.csv("rmeancollected-subsampled-['PT'].csv")
PI.sub = read.csv("rmeancollected-subsampled-['PI'].csv")
MZ.sub = read.csv("rmeancollected-subsampled-['MZ'].csv")

setwd("E:/Research/2018 Small Finds/2017 JMA Revision/scripts") 

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

#mz1$exchange	<-	NULL
#mz2$exchange	<-	NULL
#mz3$exchange	<-	NULL
#tb1$exchange	<-	NULL
#tb2$exchange	<-	NULL
#tb3$exchange	<-	NULL
#cn1$exchange	<-	NULL
#cn2$exchange	<-	NULL
#sm$exchange	<-	NULL
#pa$exchange	<-	NULL
#pt$exchange	<-	NULL
#pi1$exchange	<-	NULL
#pi2$exchange	<-	NULL

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



custom_plot <- function(.data, .title,
  colours = c("economic" = "#9e0142","agriculture" = "#d53e4f","livestock" = "#f46d43","craft.production" = "#fdae61","craft.refuse" = "#fee08b","exchange" = "#878787",  "domestic" = "#e6f598","personal" = "#abdda4","cultural" = "#66c2a5","transportation" = "#3288bd","real.estate" = "#5e4fa2")
) {
  ggplot(.data, aes(variable,value)) +
geom_jitter(size=1, alpha = I(1 / 10), aes(color = variable)) +
scale_color_manual(values = colours)+
scale_x_discrete(limits=c("economic","agriculture","livestock","craft.production","craft.refuse","domestic","personal","cultural","transportation","real.estate","exchange")) +
theme_classic() + theme(axis.text.x = element_text(angle = 270, hjust = 0)) + theme(legend.position="none")  + 
      labs(x="", y="") + ggtitle(.title)
}




p.pi1 <- custom_plot(pi1, "PI1")
p.pi2 <- custom_plot(pi2, "PI2")
p.sm <- custom_plot(sm, "SM")
p.cn1 <- custom_plot(cn1, "CN1")
p.cn2 <- custom_plot(cn2, "CN2")
p.pa <- custom_plot(pa, "PA")
p.pt <- custom_plot(pt, "PT")
p.mz1 <- custom_plot(mz1, "MZ1")
p.mz2 <- custom_plot(mz2, "MZ2")
p.mz3 <- custom_plot(mz3, "MZ3")
p.tb1 <- custom_plot(tb1, "TB1")
p.tb2 <- custom_plot(tb2, "TB2")
p.tb3 <- custom_plot(tb3, "TB3")

plot_grid(p.pi1, p.pi2, p.sm, p.cn1, p.cn2, p.pa, p.pt, p.mz1, p.mz2, p.mz3, p.tb1, p.tb2, p.tb3, ncol=7)






