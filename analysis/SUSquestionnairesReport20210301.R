library(lmerTest);
library(MASS);
library(emmeans)

dat.sus <- read.table("sus.questions.set.report.20210301.txt", header=TRUE, sep = ";")


#############  Calculation of the system usability score ################

mydat <- dat.sus
Task1 <- mydat[,c(1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20)]
Task2 <- mydat[,c(1,2,3,4,5,6,7,8,9,10,21,22,23,24,25,26,27,28,29,30)]

sus.score <- function(H)
{
  s <- 0 ;
  s <- sum(H[c(1,3,5,7,9)])-5 + 25 - sum(H[c(2,4,6,8,10)])
  return (2.5 * s);
}

sus1 <- NULL;  ## SUS score for Task 1
sus2 <- NULL;  ## SUS score for Task 2
for(j in 1:nrow(Task1))
{
  sus1 <- rbind(sus1, sus.score(Task1[j,11:20]));
  sus2 <- rbind(sus2, sus.score(Task2[j,11:20]));
}


Task1$SUS <- sus1;
Task2$SUS <- sus2;

summary(sus1); t.test(sus1)
summary(sus2); t.test(sus2)

## > 80.3 - excellent
## 68 - 80.3 - good
## 68 - okay
## 51 - 68 - poor
## < 51 - awful

sus1.cat <- rep(0,length(sus1));
sus1.cat[which(sus1 >= 80.3 )] <- "excellent";
sus1.cat[which((sus1 >= 68)&(sus1 < 80.3) )] <- "good"
sus1.cat[which((sus1 >= 51)&(sus1 < 68) )] <- "poor"
sus1.cat[which(sus1 < 51)] <- "awful"

sus2.cat <- rep(0,length(sus2));
sus2.cat[which(sus2 >= 80.3 )] <- "excellent";
sus2.cat[which((sus2 >= 68)&(sus2 < 80.3) )] <- "good"
sus2.cat[which((sus2 >= 51)&(sus2 < 68) )] <- "poor"
sus2.cat[which(sus2 < 51)] <- "awful"

ftable(sus1.cat)
# excellent good poor
# 34   14   9
ftable(sus2.cat)
# awful excellent good poor
# 7        17  16   17

Task1$SUScat <- as.factor(sus1.cat);
Task2$SUScat <- as.factor(sus2.cat);

mydat$SystemUsabilityScoreTask1 <- sus1;
mydat$SystemUsabilityScoreTask2 <- sus2;
mydat$SystemUsabilityScoreTask1cat <- as.factor(sus1.cat);
mydat$SystemUsabilityScoreTask2cat <- as.factor(sus2.cat);


############### Models for System Usability Score #################

mod.sus.1 <- lm(SystemUsabilityScoreTask1 ~ VR + Method*Model, data = mydat)
summary(mod.sus.1)
anova(mod.sus.1)
mod.sus.2 <- lm(SystemUsabilityScoreTask2 ~ VR + Method*Model, data = mydat)
summary(mod.sus.2)
anova(mod.sus.2)

emmeans(mod.sus.1, pairwise~ Model)
emmeans(mod.sus.1, pairwise~ Method)
emmeans(mod.sus.1, pairwise~ VR)
emmeans(mod.sus.1, pairwise~ Method|Model)


emmeans(mod.sus.2, pairwise~ Model)
emmeans(mod.sus.2, pairwise~ Method)
emmeans(mod.sus.2, pairwise~ VR)
emmeans(mod.sus.2, pairwise~ Method|Model)



myT1 <- ftable(mydat$SystemUsabilityScoreTask1cat ~mydat$Model+ mydat$Method)
ftable(mydat$SystemUsabilityScoreTask1cat)  ## exc = 34, good = 14, poor = 8
prop.test(34,56, alternative = "greater")  ## 61% found excellent

myT2 <- ftable(mydat$SystemUsabilityScoreTask2cat ~mydat$Model+ mydat$Method)
ftable(mydat$SystemUsabilityScoreTask2cat)
sum(myT2)

## awful excellent good poor
## 7        17   16   16
prop.test(33,56, alternative = "greater")




mod.sus.2.1 <- lm(SystemUsabilityScoreTask2 ~ Method * Model, data = mydat)
summary(mod.sus.2.1)
anova(mod.sus.2.1)

emmeans(mod.sus.2.1, pairwise ~ Model)
emmeans(mod.sus.2.1, pairwise ~ Method)


mod.sus.1.1 <- lm(SystemUsabilityScoreTask1 ~ Method *Model, data = mydat)
summary(mod.sus.1.1)
anova(mod.sus.1.1)

emmeans(mod.sus.1.1, pairwise ~ Model)
emmeans(mod.sus.1.1, pairwise ~ Method)









