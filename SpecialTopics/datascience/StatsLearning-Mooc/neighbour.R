######################################################################
# statLearning
# Graph the technique described by Trevor in Lecture 2.1

######################################################################

# Generate sample data
n <- 20

set.seed(37)
x0 <- sort(runif(n, min=0, max=10))
y0 <- 0.5 * x0 + rnorm(n, sd=0.2)

######################################################################

Estimate <- function(x, neighbourhood=2){
    # Estimates x as the average value of y within neighbourhood
    mean(y0[abs(x - x0) < neighbourhood])
}

x <- seq(0, 10, length.out=1000)
yhat <- sapply(x, Estimate)

######################################################################
png('neighbour.png')
plot(x, yhat, col='green')
points(x0, y0)
dev.off()
######################################################################
