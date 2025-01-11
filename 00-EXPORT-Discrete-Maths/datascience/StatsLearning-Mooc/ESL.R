######################################################################
##               Chapter 4: Linear Methods for Classification
######################################################################

Methods with linear decision boundaries.

Use discriminant functions delta.i, the i in K that gives the biggest
value is the class we guess.
One choice is to approx P(G = k | X = x)

Generate point cloud somewhat similar to ones in fig 4.1

numpts <- 300
x1 <- rnorm(numpts)
y1 <- rnorm(numpts)
x2 <- rnorm(numpts, 1,1.5)
y2 <- rnorm(numpts,-4,0.7)
x3 <- rnorm(numpts, 4, 0.3)
y3 <- rnorm(numpts, 0, 2)

x.all <- c(x1,x2,x3)
y.all <- c(y1,y2,y3)
xlim <- c(min(x.all), max(x.all))
ylim <- c(min(y.all), max(y.all))

plot(x,y,xlim=xlim, ylim=ylim)
points(x2,y2,col="green")
points(x3,y3,col="red")


############### Linear Regression with an Indicator Matrix ############

Doing the linear regression with an indicator matrix; working
to see the phenomenon of crowding out.  In different runs of the
below code it becomes clear that (1) the classification of the
middle class certainly is unstable, (2) crowding out completely
is not that common.


numpts <- 300
a1 <- rnorm(numpts)
b1 <- rnorm(numpts)
a2 <- rnorm(numpts, 4)
b2 <- rnorm(numpts, 4)
a3 <- rnorm(numpts, 8)
b3 <- rnorm(numpts, 8)

a.all <- c(a1,a2,a3)
b.all <- c(b1,b2,b3)
alim <- c(min(a.all), max(a.all))
blim <- c(min(b.all), max(b.all))

## point clouds like in fig 4.2

par(mfrow=c(1,3))
plot(a1,b1,xlim=alim, ylim=blim,
          main="separate classes 1 and 2")
points(a2,b2,col="green")
points(a3,b3,col="red")

## have three classes, so Y should be #obs x 3 here

Y1 <- t(matrix(c(1,0,0), nrow=3, ncol=numpts))
Y2 <- t(matrix(c(0,1,0), nrow=3, ncol=numpts))
Y3 <- t(matrix(c(0,0,1), nrow=3, ncol=numpts))
Y <- rbind(Y1,Y2,Y3)
Y12 <- rbind(Y1,Y2)

X1 <- cbind(a1,b1)
X2 <- cbind(a2,b2)
X3 <- cbind(a3,b3)
X <- cbind("const"=rep(1,3*numpts),rbind(X1,X2,X3))
X12 <- cbind("const"=rep(1,2*numpts), rbind("a"=X1,"b"=X2))
head(X12)

B <- solve(t(X12) %*% X12) %*% t(X12) %*% Y12

lm(Y12 ~ X12[,2:3])

pred1 <- function(x,y) {
    prediction <- c(1,x,y) %*% B
      return(prediction[1] - prediction[2])   # if positive predict 1, o/w predict 2
  }

pred1(1,1)
pred1(2,2)
pred1(4,4)
pred1(5,5)

xx <- seq(from=-2,to=8,length.out=200)
yy <- xx
zz <- matrix(0,nrow=200,ncol=200)
for (xidx in 1:200) {
    for (yidx in 1:200) {
          zz[xidx,yidx] = pred1(xx[xidx], yy[yidx])
        }
  }
contour(xx,yy,zz,drawlabels=FALSE,col="red",add=TRUE,levels=c(0))

B <- solve(t(X) %*% X) %*% t(X) %*% Y
predict <- function(x,y) {
    prediction <- c(1,x,y) %*% B
      if (prediction[1] > prediction[2] && prediction[1] > prediction[3]) {
            return(1)
          } else if (prediction[2] > prediction[1] && prediction[2] > prediction[3]) {
                return(2)
              } else {
                    return(3)
                  }
  }

xx <- seq(from=-2,to=10,length.out=200)
yy <- xx
zz <- matrix(0,nrow=200,ncol=200)
for (xidx in 1:200) {
    for (yidx in 1:200) {
          zz[xidx,yidx] = predict(xx[xidx], yy[yidx])
        }
  }
plot(a1,b1,xlim=alim, ylim=blim,
          main="separate all three")
points(a2,b2,col="green")
points(a3,b3,col="red")
contour(xx,yy,zz,drawlabels=FALSE,col="red",add=TRUE,levels=c(1,2,3))

## this only mostly masked the middle class, make a little more
## extreme to try and completely mask

numpts <- 1000
a1 <- rnorm(numpts,0,3)
b1 <- rnorm(numpts,0,3)
a2 <- rnorm(numpts, 4)
b2 <- rnorm(numpts, 4)
a3 <- rnorm(numpts, 8,3)
b3 <- rnorm(numpts, 8,3)

a.all <- c(a1,a2,a3)
b.all <- c(b1,b2,b3)
alim <- c(min(a.all), max(a.all))
blim <- c(min(b.all), max(b.all))

## have three classes, so Y should be #obs x 3 here

Y1 <- t(matrix(c(1,0,0), nrow=3, ncol=numpts))
Y2 <- t(matrix(c(0,1,0), nrow=3, ncol=numpts))
Y3 <- t(matrix(c(0,0,1), nrow=3, ncol=numpts))
Y <- rbind(Y1,Y2,Y3)

X1 <- cbind(a1,b1)
X2 <- cbind(a2,b2)
X3 <- cbind(a3,b3)
X <- cbind("const"=rep(1,3*numpts),rbind(X1,X2,X3))

B <- solve(t(X) %*% X) %*% t(X) %*% Y
predict <- function(x,y) {
    prediction <- c(1,x,y) %*% B
      if (prediction[1] > prediction[2] && prediction[1] > prediction[3]) {
            return(1)
          } else if (prediction[2] > prediction[1] && prediction[2] > prediction[3]) {
                return(2)
              } else {
                    return(3)
                  }
  }

xx <- seq(from=-2,to=10,length.out=200)
yy <- xx
zz <- matrix(0,nrow=200,ncol=200)
for (xidx in 1:200) {
    for (yidx in 1:200) {
          zz[xidx,yidx] = predict(xx[xidx], yy[yidx])
        }
  }
plot(a1,b1,xlim=alim, ylim=blim,
     main="trying to crowd out the middle class")
points(a2,b2,col="green")
points(a3,b3,col="red")
contour(xx,yy,zz,drawlabels=FALSE,col="red",add=TRUE,levels=c(1,2,3))


############### Linear Discriminant Analysis ####################
