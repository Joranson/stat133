#################################################################################
#### Functions for BML Simulation Study


#### Initialization function.
## Input : size of grid [r and c] and density [p]
## Output : A matrix [m] with entries 0 (no cars) 1 (red cars) or 2 (blue cars)
## that stores the state of the system (i.e. location of red and blue cars)

bml.init <- function(r, c, p){
  samples <- sample(c(0, 1, 2), size = r * c, replace = T, prob = c(1 - p, p / 2, p / 2))
  m <- matrix(samples, nrow = r, ncol = c)
  return(m)
}

#### Function to move the system one step (east and north)
## Input : a matrix [m] of the same type as the output from bml.init()
## Output : TWO variables, the updated [m] and a logical variable
## [grid.new] which should be TRUE if the system changed, FALSE otherwise.

## NOTE : the function should move the red cars once and the blue cars once,
## you can write extra functions that do just a step north or just a step east.

bml.moveEast <- function(m){
  if (ncol(m)==1) {
    return(m)
  }
  blocked <- m[, c(2:ncol(m), 1)]!=0
  red_cars <- m*(m==1)
  return (m*(m!=1) + red_cars*blocked + (red_cars*!blocked)[,c(ncol(m), 1:(ncol(m)-1))])
}

bml.moveNorth <- function(m){
  if (nrow(m)==1) {
    return(m)
  }
  blocked <- m[c(nrow(m), 1:(nrow(m)-1)),]!=0
  blue_cars <- m*(m==2)
  return (m*(m!=2) + blue_cars*blocked + (blue_cars*!blocked)[c(2:nrow(m), 1), ])
}

bml.step <- function(m){
  m.new <- bml.moveNorth(bml.moveEast(m))
  grid.new <- !all(m.new == m)
  return(list(m.new, grid.new))
}

#### Function to do a simulation for a given set of input parameters
## Input : size of grid [r and c] and density [p]
## Output : *up to you* (e.g. number of steps taken, did you hit gridlock, ...)

bml.sim <- function(r, c, p){
  m = bml.init(r, c, p)
  image(t(apply(m,2,rev)), axes = F, col = c("white", "red", "blue"))
  for (i in 1:2000) {
    n = bml.step(m)
    if (n[[2]]) {
      m = n[[1]]
      image(t(apply(m,2,rev)), axes = F, col = c("white", "red", "blue"))
    } else {
      image(t(apply(m,2,rev)), axes = F, col = c("white", "red", "blue"))
      return (cat("Deadlock at ", toString(i), "th iteration", sep=""))
    }
  }
  return ("So far so good! No deadlock for 2000 iterations!")
}

