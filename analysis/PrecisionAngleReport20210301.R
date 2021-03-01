dat.precision <- read.table("precision.set.report.20210301.txt", header=TRUE, 
                            sep = ";")
## the precision is measured as the angle of deviation

mod.precision.1 <- lm(Angle ~ TargetDistance + Method *Model, 
                      data = dat.precision)

summary(mod.precision.1);
anova(mod.precision.1)

library(emmeans)
emmeans(mod.precision.1, pairwise ~ Model |Method)
emmeans(mod.precision.1, pairwise ~ Method|Model)
emmeans(mod.precision.1, pairwise ~ Method)
emmeans(mod.precision.1, pairwise ~ Model)

