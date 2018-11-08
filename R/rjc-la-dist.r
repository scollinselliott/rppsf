#calculate distance measure between late republican and late antique phases - figure 7
#take the distances between each non null value and then obtain their mean
#make sure to have run indices.r and mds.r

rjcdist <- c()

for (b in 1:1000) {
	total2 <- dcast(total, phase ~ variable)
	rownames(total2) <- total2$phase
	total2$phase <- NULL
	total2[] <- NA

	total2 <- total2[ which(rownames(total2) %in% c("PI1", "CN1", "MZ1", "MZ2", "PA", "PT", "SM", "TB1", "TB2")), ]

	for (i in rownames(total2)) {
	for (j in colnames(total2)) {
	t <- total[total$phase == i & total$variable == j, ]
	x <- mean(t$value) #to check and see if not NA
	if ( is.finite(x) ) {
	#dmax <- which.max(density(t$value)$y)
	#x <- density(t$value)$x[dmax] # mean(t$value)      # t[sample(nrow(t), 1), ]$value
	total2[i,j] <- sample(t$value, size = 1)
	}
	}
	}

	d <- mean(dist(total2))
	rjcdist <- append(rjcdist,d)
}

ladist <- c()

for (b in 1:1000) {
	total2 <- dcast(total, phase ~ variable)
	rownames(total2) <- total2$phase
	total2$phase <- NULL
	total2[] <- NA

	total2 <- total2[ which(rownames(total2) %in% c("CN2", "MZ3", "PI2", "TB3")), ]

	for (i in rownames(total2)) {
	for (j in colnames(total2)) {
	t <- total[total$phase == i & total$variable == j, ]
	x <- mean(t$value) #to check and see if not NA
	if ( is.finite(x) ) {
	#dmax <- which.max(density(t$value)$y)
	#x <- density(t$value)$x[dmax] # mean(t$value)      # t[sample(nrow(t), 1), ]$value
	total2[i,j] <- sample(t$value, size = 1)
	}
	}
	}

	d <- mean(dist(total2))
	ladist <- append(ladist,d)
}

x <- seq(0,2,length.out = 1000)
rjcmean <- mean(rjcdist)
rjcsd <- sd(rjcdist)
lamean <- mean(ladist)
lasd <- sd(ladist)
rjcdist2 <- rnorm(x, mean = rjcmean, sd = rjcsd)

diff <- data.frame(rjcdist)
diff$ladist <- ladist


p.diff <- ggplot(diff) + geom_density(aes(rjcdist), color = "blue", label = "RJC") +
geom_density(aes(ladist), color = "red") +
labs(x="Mean Euclidean Distance between Sites", y = " ") + ggtitle("Site Differentiation Based on Behavioral Indices") + 
theme_classic()
p.diff


conf = 0.85

hpd_lower = function(x) coda::HPDinterval(as.mcmc(x), prob = conf)[1]
hpd_upper = function(x) coda::HPDinterval(as.mcmc(x), prob = conf)[2]

colnames(diff)[1] <- "Late Rep./Jul.-Claudian"
colnames(diff)[2] <- "Late Antique"

mdiff <- melt(diff)

df_hpd <- group_by(mdiff, variable) %>% summarize(x=hpd_lower(value), xend=hpd_upper(value))

colnames(diff)[1] <- "Late Rep./Jul.-Claudian"
colnames(diff)[2] <- "Late Antique"

ggplot(mdiff, aes(x=value, color = variable)) + 
  geom_density() +
#  facet_wrap(~variable) + 
  geom_segment(data = df_hpd, aes(x=x, xend=xend, y=0, yend=0), size=3) +
#  scale_colour_brewer(direction= -1) +
scale_color_manual(values = c("#00bfc4","#f8766d")) +
labs(x="Mean Euclidean Distance between Sites by Period", y = " ") + 
ggtitle("Site Differentiation Based on Behavioral Indices (85% Cred. Int.)") + 
theme_classic()
