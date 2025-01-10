libary(ISLR)

attach(Defaault)
summary(Default)

# Fit a Logistic Regression Model
# glm() - Generalized Linear Model

glm(default~student+balance+income,family="binomial",data=Default)
