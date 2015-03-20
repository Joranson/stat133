# Homework 6
# Stat 133, Lec 2, Spring 2015
# Due : Friday March 20th by 5 pm

# Review the slides on simulations for this assignment.

# Consider the following model on use of a new drug:
# We have a population of doctors, population size : <n.doctors>
# Every doctor has either adopted the use of a new drug, or not (0/1 status)
# Now write a function that runs a simulation for a period of :
# <n.days> where
# - every day exactly two _random_ doctors meet
# - if one has adopted but the other one has not then the
#   holdout adopts the use of the drug with probability p
# Return a matrix that shows for each day which doctors have adopted
# the use of the drug.

# Input varibles are
# <n.days> : the number of days the simulation should be run for
# <n.doctors> : total number of doctors 
# <initial.doctors> : a 0/1 vector of length <n.doctors>, 1 for adopters
# <p> : the probability that the non-adopter adopts the drug.

# Ouput variable
# <has_adopted> : matrix with <n.doctors> rows and <n.days> columns
#                 i.e. one row for each doctor
#                 the entries are 0 for days where the doctor is a
#                 non-adopter, else 1 (so once a row turns to 1 it stays as 1).

sim.doctors <- function(initial.doctors, n.doctors, n.days, p){  
  has_adopted <- matrix(data=initial.doctors,nrow=n.doctors,ncol=n.days)
  for (j in 2:ncol(has_adopted)) {
    row.position <- sample(c(1:n.doctors),size=2)
    my.doctors <- has_adopted[row.position,j-1]
    if (my.doctors[1]==1 | my.doctors[2]==1) {
      if (runif(1)<p) {
        has_adopted[row.position,j:ncol(has_adopted)] <- 1
      }
    }
  }
  return(has_adopted)
}

# When you test your function you have to generate <initial.doctors> and
# pick values for the other input parameters.

set.seed(42)
# Generate a value for <initial.doctors> that has 10% 1s and 90% 0s.
# Run your function for at least 5 different values of <p> and plot
# on x-axis: days,
# on y-axis : the number of doctors that have already adopted the drug, on that day
# Put all 5 lines in one figure (e.g. use first plot() then lines() for the subsequent lines)

p <- c(0.1,0.3,0.5,0.7,0.9)
newMatrix <- matrix(ncol=5,nrow=1000)
for (i in 1:5) {
  adopted <- sim.doctors(initial.doctors=sample(c(0,1),size=100,replace=T,prob=c(.9,.1)),n.doctors=100,n.days=1000,p[i])
  line <- colSums(adopted)
  newMatrix[,i] <- line
}

plot(newMatrix[,1],type="l",col="green",xlab="days",ylab="doctors adopting drug",main="Number of Doctors Adopting Drugs by Day",ylim=c(0,100))
lines(newMatrix[,2],col="blue")
lines(newMatrix[,3],col="red")
lines(newMatrix[,4],col="orange")
lines(newMatrix[,5],col="purple")
text(x=800,y=45,"p=0.1", cex=0.7)
text(x=600,y=80,"p=0.3", cex=0.7)
text(x=400,y=80,"p=0.5", cex=0.7)
text(x=300,y=70,"p=0.7", cex=0.7)
text(x=200,y=80,"p=0.9", cex=0.7)
