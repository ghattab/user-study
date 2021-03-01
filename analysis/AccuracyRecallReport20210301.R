dat.confidence <- read.table("confidence.set.report.20210301.txt", header=TRUE, sep = ";")
dat.confidence$Question <- as.factor(dat.confidence$Question);

library(lmerTest)
library(emmeans)


############   Accuracy in recall   ###########################


mod.accuracy.1 <- lmer(Accuracy ~ Model*Question + (1|ParticipantID), 
                       data = dat.confidence)
anova(mod.accuracy.1) 
summary(mod.accuracy.1)
emmeans(mod.accuracy.1, pairwise~ Model)
emmeans(mod.accuracy.1, pairwise~ Model|Question)

mod.accuracy.2 <- lmer(Accuracy ~ Method + Model*Question +   
                         (1|ParticipantID), data = dat.confidence)
anova(mod.accuracy.2) 
summary(mod.accuracy.2)
emmeans(mod.accuracy.2, pairwise~ Model)
emmeans(mod.accuracy.2, pairwise~ Model|Question)


############   Confidence in recall   ###########################

mod.confidence.1 <- lmer(Confidence ~ Method + Model*Question + 
                         (1|ParticipantID), data = dat.confidence)
anova(mod.confidence.1) 
summary(mod.confidence.1)
emmeans(mod.confidence.1, pairwise~ Model)
emmeans(mod.confidence.1, pairwise~ Model|Question)





