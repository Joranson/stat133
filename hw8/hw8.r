xUnique = 1:5
trueCoeff = c(0, 1, 1)

getData = function(coefs = c(0, 1, 1), xs = 1:5, dupl = 10,
                   sd = 5, seed=2222){
  ### This function creates the artificial data
  set.seed(seed)
  x = rep(xs, each = dupl)
  y = coefs[1] + coefs[2]*x + coefs[3] * x^2 + 
      rnorm(length(x), 0, sd)
  return(data.frame(x, y))
}

### 
genBootY = function(x, y, rep = TRUE){
  ### For each unique x value, take a sample of the
  ### corresponding y values, with replacement.
  ### Return a vector of random y values the same length as y
  ### You can assume that the xs are sorted
  ### Hint use tapply here!
  unique <- unique(x)
  count <- length(unique)
  value <- c()
  for (i in 1:count){
    amount <- length(grep(unique[i],x))
    possibleY <- c()
    for (j in 1:amount){
      possibleY <- c(possibleY,y[grep(unique[i],x)])
      value[grep(unique[i],x)] <- sample(possibleY,size=amount,replace=TRUE)
    }
  }
  return(value)

}

genBootR = function(fit, err, rep = TRUE){
  ### Sample the errors 
  ### Add the errors to the fit to create a y vector
  ### Return a vector of y values the same length as fit
  ### HINT: It can be easier to sample the indices than the values
  errors = sample(err, 50, replace = FALSE)
  y = fit + errors
  return (y)
 
}

fitModel = function(x, y, degree = 1){
  ### use the lm function to fit a line of a quadratic 
  ### e.g. y ~ x or y ~ x + I(x^2)
  ### y and x are numeric vectors of the same length
  ### Return the coefficients as a vector 
  ### HINT: Take a look at the repBoot function to see how to use lm()
  if (degree == 1){
    a = lm (y ~ x)
    coeff = a$coefficients 
  } else if (degree == 2){
    a = lm (y ~ x + I(x^2))
    coeff = a$coefficients 
  } 
  return(coeff)
}

oneBoot = function(data, fit = NULL, degree = 1){
  ###  data are either your data (from call to getData)
  ###  OR fit and errors from fit of line to data
  ###  OR fit and errors from fit of quadratic to data  
  ### Use fitModel to fit a model to this bootstrap Y 
  if (is.null(fit) == TRUE) {
    new_y = genBootY(data[,1], data[,2])  
    a = fitModel(data[,1], new_y, degree = degree)
    myModel = a
  }
  else {
    new_y = genBootR(fit[,1], fit[,2])  
    a = fitModel(data[,1], new_y, degree = degree)
    myModel = a
  }
  return(myModel)
}

repBoot = function(data, B = 1000){
  
  ### Set up the inputs you need for oneBoot, i.e.,
  ### create errors and fits for line and quadratic

  ### replicate a call to oneBoot B times
  ### format the return value so that you have a list of
  ### length 4, one for each set of coefficients
  ### each element will contain a data frame with B rows
  ### and one or two columns, depending on whether the 
  ### fit is for a line or a quadratic
  ### Return this list
  
  ### Replicate a call to oneBoot B times for 
  ### each of the four conditions
  
  
  ### Format the return value so that you have a list of
  ### length 4, one for each set of coefficients
  ### each element will contain a matrix with B columns
  ### and two or three rows, depending on whether the 
  ### fit is for a line or a quadratic
  ### Return this list
  l = list()
  c1 = lm(data$y~data$x)$fitted.values
  c2 = lm(data$y~data$x)$residuals
  fit.new = cbind(c1, c2)
  l[[1]] = replicate(B, oneBoot(data, fit = NULL, degree=1))
  l[[2]] = replicate(B, oneBoot(data,fit = fit.new, degree=1))
  c3 = lm(data$y ~ data$x + I((data$x)^2))$fitted.values
  c4 = lm(data$y ~ data$x + I((data$x)^2))$residuals
  fit.new2 = cbind(c3, c4)
  l[[3]] = replicate(B, oneBoot(data,fit = NULL, degree=2))
  l[[4]] = replicate(B, oneBoot(data,fit = fit.new2, degree=2))
  return(l)
} 

bootPlot = function(x, y, coeff, trueCoeff){
  ### x and y are the original data
  ### coeff is a matrix from repBoot
  ### trueCoeff contains the true coefficients 
  ### that generated the data
  
  ### Make a scatter plot of data

  ### Add lines or curves for each row in coeff
  ### Use transparency
  ### You should use mapply to construct all 
  ### 1000 of the bootstrapped lines of best fit 
  ### Have a look at ?mapply for details.
  ### This can be done in ggplot2 or base graphics.
  
  ### Use trueCoeff to add true line/curve - 
  ###  Make the true line/curve stand out
  plot(y~x)
  if (nrow(coeff) == 2){
    mapply(abline, coeff[1,],coeff[2,],col=rgb(0,0.2,.4,0.1))
  }
  if (nrow(coeff) == 3){
    mapply(function(a,b,c){curve(a+b*x + c*(x^2),col=rgb(0,0.2,.4,0.1), add=TRUE)}, a=coeff[1,],b=coeff[2,],c=coeff[3,])
  }
  curve(trueCoeff[1]+trueCoeff[2]*x + trueCoeff[3]*(x^2),col="red",add=TRUE,lwd=3)
}

### Run your simulation by calling this function
### This function doesn't need any changing
runSim = function() {
  xUnique = 1:5
  trueCoeff = c(0, 1, 1)
  myData = getData(coefs = trueCoeff, xs = xUnique)
  expt = repBoot(data = myData)
  par(mfrow = c(2, 2))
  for (i in 1:4){
   bootPlot(myData$x, myData$y, 
            coeff = expt[[i]], trueCoeff) 
  }
  return(expt)
}
runSim()