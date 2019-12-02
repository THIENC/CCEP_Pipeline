rm(list = ls())

library(ggplot2)

# load the data
BC = read.csv(file.choose(),header = FALSE)

BC$V2 = as.factor(BC$V2)

# Change color by groups
dp <- ggplot(BC, aes(x=V2, y=V1, fill=V2)) + 
  geom_violin(trim=TRUE)+
  geom_boxplot(width=0.1, fill="white", outlier.shape = NA)+
  labs(title="BC by group",x="Group", y = "BC")
dp + theme_classic() + scale_fill_brewer(palette="RdBu")

res.aov <- aov(V1 ~ V2, data = BC)
summary(res.aov)
TukeyHSD(res.aov)


# load the data zscored
rm(list = ls())
BC = read.csv(file.choose(),header = FALSE)

BC$V2 = as.factor(BC$V2)


# Change color by groups
dp <- ggplot(BC, aes(x=V2, y=V1, fill=V2)) + 
  geom_violin(trim=TRUE)+
  geom_boxplot(width=0.1, fill="white", outlier.shape = NA)+
  labs(title="BC by group",x="Group", y = "BC")
dp + theme_classic() + scale_fill_brewer(palette="RdBu")

res.aov <- aov(V1 ~ V2, data = BC)
summary(res.aov)
postHoc = TukeyHSD(res.aov)
postHoc

# Prognostic analysis
rm(list = ls())

library(ggplot2)

BC = read.csv(file.choose(),header = FALSE)

BC$V2 = as.factor(BC$V2)

# Change color by groups
dp <- ggplot(BC, aes(x=V2, y=V1, color=V2)) + 
  geom_boxplot(width=0.4, fill="white", outlier.shape = NA)+
  labs(title="Seizure free or not",x="free or not", y = "Z-score") +
  geom_jitter(position=position_jitter(0.15),color="black",cex=0.8) +
  scale_x_discrete(limits=c("1", "0")) + 
  scale_color_brewer(palette="Dark2",direction = -1)
dp + theme_classic()

# EZ2EZ and EZ2PZ
dp <- ggplot(BC, aes(x=V2, y=V1, color=V2)) + 
  geom_boxplot(width=0.4, fill="white", outlier.shape = NA)+
  labs(title="Seizure free or not",x="free or not", y = "Z-score") +
  geom_jitter(position=position_jitter(0.15),color="black",cex=0.8) +
  scale_x_discrete(limits=c("1", "0")) + 
  scale_y_continuous(breaks=c(0,1,2),labels=c("0.0", "1.0", "2.0")) + 
  scale_color_brewer(palette="Dark2",direction = -1)
dp + theme_classic()

wilcox.test(BC$V1[BC$V2 == 0],BC$V1[BC$V2 == 1],paired = FALSE,alternative = c("two.sided"))

# ANCOVA of the zscored data 
rm(list = ls())

library(jmv)

# load the data

Zscored = read.csv(file.choose(),header = FALSE)

Zscored$V2 = as.factor(Zscored$V2)

Model1 = ancova(data = Zscored, dep = V1, factors = V2, covs = V3,postHoc = ~V2,postHocCorr = list("tukey"))
Model1$main
Model1$postHoc

















