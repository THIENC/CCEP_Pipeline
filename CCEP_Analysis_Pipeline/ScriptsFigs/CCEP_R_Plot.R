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
dp <- ggplot(BC, aes(x=V2, y=V1, fill=V2)) + 
  
  geom_boxplot(width=0.1, fill="white", outlier.shape = NA)+
  labs(title="BC by group",x="Group", y = "BC")
dp + theme_classic() + scale_fill_brewer(palette="RdBu")

res.aov <- aov(V1 ~ V2, data = BC)
summary(res.aov)
TukeyHSD(res.aov)

